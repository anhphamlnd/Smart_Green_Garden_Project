#ifndef _UARTLIB_
#define _UARTLIB_

#include <mega328p.h>

#define FOSC 16000000UL  // T?n s? dao d?ng h? th?ng

//===========================
// H�m kh?i t?o UART
//===========================
void uart_init(unsigned int baudrate) {
    // T�nh gi� tr? UBRR cho baudrate
    unsigned int ubrr_value = FOSC / (16UL * baudrate) - 1;

    // G�n gi� tr? v�o thanh ghi UBRR
    UBRR0H = (unsigned char)(ubrr_value >> 8);
    UBRR0L = (unsigned char)ubrr_value;

    // C?u h�nh: Asynchronous, 8-bit data, 1 stop bit, no parity
    UCSR0C = 0b00000110;

    // B?t truy?n, nh?n v� ng?t nh?n
    UCSR0B = 0b10011000;

    // Cho ph�p ng?t to�n c?c
    #asm("sei")
}

//===========================
// G?i 1 k� t? qua UART
//===========================
void uart_putchar(unsigned char data) {
    while (!(UCSR0A & 0b00100000));  // Ch? cho d?n khi UDR tr?ng
    UDR0 = data;
}

//===========================
// G?i chu?i k� t?
//===========================
void uart_putstring(char *str) {
    while (*str) {
        uart_putchar(*str);
        if (*str == '\n') uart_putchar('\r');  // Chu?n h�a xu?ng d�ng
        str++;
    }
}

//===========================
// G?i s? nguy�n (d?ng th?p ph�n)
//===========================
void uart_put_int(unsigned int value) {
    unsigned char buf[6]; // d? cho gi� tr? 65535
    int index = 0;

    // T�ch t?ng ch? s?
    do {
        buf[index++] = (value % 10) + '0';
        value /= 10;
    } while (value);

    // G?i t? cu?i v? d?u
    while (index--) {
        uart_putchar(buf[index]);
    }
}

#endif
