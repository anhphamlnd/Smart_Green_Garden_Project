#ifndef _TWILIB_
#define _TWILIB_

#include <mega328p.h>
#include <delay.h>
#include "uart.h"

#define F_CPU 16000000UL
#define BR400 12
#define BR200 32
#define BR100 72

unsigned char TWI_Rx_Buf[50];
unsigned char TWI_Tx_Buf[50];
int TWI_Rx_Index = 0, TWI_Tx_Index = 0, TWI_Data_In = 0;
unsigned char Status_Code;
int i;

//===========================================
// Initialize TWI (as Slave)
void TWI_Init(char sla, char gcall, char sclock){
    TWAR = (sla << 1) + (gcall & 0x01); // Set slave address and general call
    TWSR &= 0b11111100;                 // Prescaler = 1
    TWBR = (unsigned char)((F_CPU / sclock - 16) / 2); // Set SCL frequency
    TWCR = 0b01000101;                  // Enable TWI, ACK, Interrupt
}

// Enable TWI Interrupt
void TWI_Interupt_Enable(void){
    TWCR |= 0b01000001; // Enable TWI interrupt, ACK
}

// Disable TWI Interrupt
void TWI_Interupt_Disable(void){
    TWCR &= 0b11111110; // Disable TWI interrupt
}

// Send START condition
unsigned char TWI_Start(void){
    TWCR = 0b10100100; // Send START
    while (!(TWCR & 0x80));
    return (TWSR & 0xF8);
}

// Send STOP condition
void TWI_Stop(void){
    TWCR = 0b10010100;
}

// Send Slave Address + R/W
unsigned char TWI_SLA_RW(unsigned char add, unsigned char rw){
    TWDR = (add << 1) + (rw & 0x01); // LSB = R/W bit
    TWCR = 0b10000100;
    while (!(TWCR & 0x80));
    return (TWSR & 0xF8);
}

// Send single byte
unsigned char TWI_Send_Byte(unsigned char b){
    TWDR = b;
    TWCR = 0b10000100;
    while (!(TWCR & 0x80));
    return (TWSR & 0xF8);
}

// Send array
unsigned char TWI_Send_Array(unsigned char* arr, int length){
    for (i = 0; i < length; i++){
        if (TWI_Send_Byte(arr[i]) != 0x28) return (TWSR & 0xF8);
    }
    return (TWSR & 0xF8);
}

// Handle error
void TWI_Error(void){
    TWI_Stop();
    TWI_Interupt_Enable();
}

// Master send function
unsigned char TWI_Master_Send(unsigned char sla, unsigned char* arr, int length){
    TWI_Interupt_Disable();
    if (TWI_Start() != 0x08) return 1;
    if (TWI_SLA_RW(sla, 0) != 0x18) return 1;
    if (TWI_Send_Array(arr, length) != 0x28) return 1;
    TWI_Stop();
    TWI_Interupt_Enable();
    return 0;
}

// Master receive function
unsigned char TWI_Master_Receive(unsigned char sla, unsigned char* arr, int length){
    TWI_Interupt_Disable();
    if (TWI_Start() != 0x08) return 1;
    if (TWI_SLA_RW(sla, 1) != 0x40) return 1;

    for (i = 0; i < length - 1; i++){
        TWCR = 0b11000100; // Clear TWINT, send ACK
        while (!(TWCR & 0x80));
        if ((TWSR & 0xF8) != 0x50) return 1;
        arr[i] = TWDR;
    }

    TWCR = 0b10000100; // Clear TWINT, send NACK
    while (!(TWCR & 0x80));
    if ((TWSR & 0xF8) != 0x58) return 1;
    arr[length - 1] = TWDR;

    TWI_Stop();
    TWI_Interupt_Enable();
    return 0;
}

// Interrupt Service Routine for Slave Mode
void TWI_Slave_Int(){
    Status_Code = (TWSR & 0xF8);
    switch (Status_Code){
        //----------- Slave Receiver Mode ----------
        case 0x60: // Own SLA+W received
            uart_putstring("Own address match + W \n");
            TWI_Rx_Index = 0;
            TWCR |= 0b11000000;
            break;

        case 0x80: // Data byte received, ACK returned
            uart_putstring("Receive a byte, sent ACK \n");
            if (TWI_Rx_Index < 49){
                TWI_Rx_Buf[TWI_Rx_Index++] = TWDR;
                TWCR |= 0b11000000;
            } else {
                TWI_Rx_Buf[TWI_Rx_Index] = TWDR;
                TWCR = 0b10000101;
            }
            break;

        case 0x88: // Data byte received, NACK returned
            TWCR |= 0b11000000;
            break;

        case 0x70: // General call received
            TWI_Rx_Index = 0;
            TWCR |= 0b11000000;
            break;

        case 0x90:
            if (TWI_Rx_Index < 49){
                TWI_Rx_Buf[TWI_Rx_Index++] = TWDR;
                TWCR |= 0b11000000;
            } else {
                TWI_Rx_Buf[TWI_Rx_Index] = TWDR;
                TWCR = 0b10000101;
            }
            break;

        case 0x98:
            TWCR |= 0b11000000;
            break;

        case 0xA0: // STOP or repeated START
            TWI_Data_In = 1;
            TWCR |= 0b11000000;
            break;

        //----------- Slave Transmit Mode ----------
        case 0xA8: // Own SLA+R received
        case 0xB0: // Arbitration lost, SLA+R received
            TWI_Tx_Index = 0;
            TWDR = TWI_Tx_Buf[TWI_Tx_Index++];
            TWCR |= 0b11000000;
            break;

        case 0xB8: // Data sent, ACK received
            if (TWI_Tx_Index < 49){
                TWDR = TWI_Tx_Buf[TWI_Tx_Index++];
                TWCR |= 0b11000000;
            } else {
                TWDR = TWI_Tx_Buf[TWI_Tx_Index];
                TWCR = 0b10000101;
            }
            break;

        case 0xC0: // Data sent, NACK received
        case 0xC8: // Last byte sent, ACK received
            TWCR |= 0b11000000;
            break;

        default:
            uart_putstring("Unknown TWI status code\n");
            TWI_Error();
            break;
    }
}

#endif
