
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _TWI_Rx_Index=R3
	.DEF _TWI_Rx_Index_msb=R4
	.DEF _TWI_Tx_Index=R5
	.DEF _TWI_Tx_Index_msb=R6
	.DEF _TWI_Data_In=R7
	.DEF _TWI_Data_In_msb=R8
	.DEF _Status_Code=R10
	.DEF _i=R11
	.DEF _i_msb=R12
	.DEF _curx=R13
	.DEF _curx_msb=R14
	.DEF _dht_error=R9

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x8:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x5F,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x7,0x0
	.DB  0x0,0x0,0x7,0x0,0x0,0x0,0x14,0x0
	.DB  0x7F,0x0,0x14,0x0,0x7F,0x0,0x14,0x0
	.DB  0x24,0x0,0x2A,0x0,0x7F,0x0,0x2A,0x0
	.DB  0x12,0x0,0x23,0x0,0x13,0x0,0x8,0x0
	.DB  0x64,0x0,0x62,0x0,0x36,0x0,0x49,0x0
	.DB  0x55,0x0,0x22,0x0,0x50,0x0,0x0,0x0
	.DB  0x5,0x0,0x3,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1C,0x0,0x22,0x0,0x41,0x0
	.DB  0x0,0x0,0x0,0x0,0x41,0x0,0x22,0x0
	.DB  0x1C,0x0,0x0,0x0,0x14,0x0,0x8,0x0
	.DB  0x3E,0x0,0x8,0x0,0x14,0x0,0x8,0x0
	.DB  0x8,0x0,0x3E,0x0,0x8,0x0,0x8,0x0
	.DB  0x0,0x0,0x50,0x0,0x30,0x0,0x0,0x0
	.DB  0x0,0x0,0x8,0x0,0x8,0x0,0x8,0x0
	.DB  0x8,0x0,0x8,0x0,0x0,0x0,0x60,0x0
	.DB  0x60,0x0,0x0,0x0,0x0,0x0,0x20,0x0
	.DB  0x10,0x0,0x8,0x0,0x4,0x0,0x2,0x0
	.DB  0x3E,0x0,0x51,0x0,0x49,0x0,0x45,0x0
	.DB  0x3E,0x0,0x0,0x0,0x42,0x0,0x7F,0x0
	.DB  0x40,0x0,0x0,0x0,0x42,0x0,0x61,0x0
	.DB  0x51,0x0,0x49,0x0,0x46,0x0,0x21,0x0
	.DB  0x41,0x0,0x45,0x0,0x4B,0x0,0x31,0x0
	.DB  0x18,0x0,0x14,0x0,0x12,0x0,0x7F,0x0
	.DB  0x10,0x0,0x27,0x0,0x45,0x0,0x45,0x0
	.DB  0x45,0x0,0x39,0x0,0x3C,0x0,0x4A,0x0
	.DB  0x49,0x0,0x49,0x0,0x30,0x0,0x1,0x0
	.DB  0x71,0x0,0x9,0x0,0x5,0x0,0x3,0x0
	.DB  0x36,0x0,0x49,0x0,0x49,0x0,0x49,0x0
	.DB  0x36,0x0,0x6,0x0,0x49,0x0,0x49,0x0
	.DB  0x29,0x0,0x1E,0x0,0x0,0x0,0x36,0x0
	.DB  0x36,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x56,0x0,0x36,0x0,0x0,0x0,0x0,0x0
	.DB  0x8,0x0,0x14,0x0,0x22,0x0,0x41,0x0
	.DB  0x0,0x0,0x14,0x0,0x14,0x0,0x14,0x0
	.DB  0x14,0x0,0x14,0x0,0x0,0x0,0x41,0x0
	.DB  0x22,0x0,0x14,0x0,0x8,0x0,0x2,0x0
	.DB  0x1,0x0,0x51,0x0,0x9,0x0,0x6,0x0
	.DB  0x32,0x0,0x49,0x0,0x79,0x0,0x41,0x0
	.DB  0x3E,0x0,0x7E,0x0,0x11,0x0,0x11,0x0
	.DB  0x11,0x0,0x7E,0x0,0x7F,0x0,0x49,0x0
	.DB  0x49,0x0,0x49,0x0,0x36,0x0,0x3E,0x0
	.DB  0x41,0x0,0x41,0x0,0x41,0x0,0x22,0x0
	.DB  0x7F,0x0,0x41,0x0,0x41,0x0,0x22,0x0
	.DB  0x1C,0x0,0x7F,0x0,0x49,0x0,0x49,0x0
	.DB  0x49,0x0,0x41,0x0,0x7F,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x1,0x0,0x3E,0x0
	.DB  0x41,0x0,0x49,0x0,0x49,0x0,0x7A,0x0
	.DB  0x7F,0x0,0x8,0x0,0x8,0x0,0x8,0x0
	.DB  0x7F,0x0,0x0,0x0,0x41,0x0,0x7F,0x0
	.DB  0x41,0x0,0x0,0x0,0x20,0x0,0x40,0x0
	.DB  0x41,0x0,0x3F,0x0,0x1,0x0,0x7F,0x0
	.DB  0x8,0x0,0x14,0x0,0x22,0x0,0x41,0x0
	.DB  0x7F,0x0,0x40,0x0,0x40,0x0,0x40,0x0
	.DB  0x40,0x0,0x7F,0x0,0x2,0x0,0xC,0x0
	.DB  0x2,0x0,0x7F,0x0,0x7F,0x0,0x4,0x0
	.DB  0x8,0x0,0x10,0x0,0x7F,0x0,0x3E,0x0
	.DB  0x41,0x0,0x41,0x0,0x41,0x0,0x3E,0x0
	.DB  0x7F,0x0,0x9,0x0,0x9,0x0,0x9,0x0
	.DB  0x6,0x0,0x3E,0x0,0x41,0x0,0x51,0x0
	.DB  0x21,0x0,0x5E,0x0,0x7F,0x0,0x9,0x0
	.DB  0x19,0x0,0x29,0x0,0x46,0x0,0x46,0x0
	.DB  0x49,0x0,0x49,0x0,0x49,0x0,0x31,0x0
	.DB  0x1,0x0,0x1,0x0,0x7F,0x0,0x1,0x0
	.DB  0x1,0x0,0x3F,0x0,0x40,0x0,0x40,0x0
	.DB  0x40,0x0,0x3F,0x0,0x1F,0x0,0x20,0x0
	.DB  0x40,0x0,0x20,0x0,0x1F,0x0,0x3F,0x0
	.DB  0x40,0x0,0x38,0x0,0x40,0x0,0x3F,0x0
	.DB  0x63,0x0,0x14,0x0,0x8,0x0,0x14,0x0
	.DB  0x63,0x0,0x7,0x0,0x8,0x0,0x70,0x0
	.DB  0x8,0x0,0x7,0x0,0x61,0x0,0x51,0x0
	.DB  0x49,0x0,0x45,0x0,0x43,0x0,0x0,0x0
	.DB  0x7F,0x0,0x41,0x0,0x41,0x0,0x0,0x0
	.DB  0x2,0x0,0x4,0x0,0x8,0x0,0x10,0x0
	.DB  0x20,0x0,0x0,0x0,0x41,0x0,0x41,0x0
	.DB  0x7F,0x0,0x0,0x0,0x4,0x0,0x2,0x0
	.DB  0x1,0x0,0x2,0x0,0x4,0x0,0x40,0x0
	.DB  0x40,0x0,0x40,0x0,0x40,0x0,0x40,0x0
	.DB  0x0,0x0,0x1,0x0,0x2,0x0,0x4,0x0
	.DB  0x0,0x0,0x20,0x0,0x54,0x0,0x54,0x0
	.DB  0x54,0x0,0x78,0x0,0x7F,0x0,0x48,0x0
	.DB  0x44,0x0,0x44,0x0,0x38,0x0,0x38,0x0
	.DB  0x44,0x0,0x44,0x0,0x44,0x0,0x20,0x0
	.DB  0x38,0x0,0x44,0x0,0x44,0x0,0x48,0x0
	.DB  0x7F,0x0,0x38,0x0,0x54,0x0,0x54,0x0
	.DB  0x54,0x0,0x18,0x0,0x8,0x0,0x7E,0x0
	.DB  0x9,0x0,0x1,0x0,0x2,0x0,0xC,0x0
	.DB  0x52,0x0,0x52,0x0,0x52,0x0,0x3E,0x0
	.DB  0x7F,0x0,0x8,0x0,0x4,0x0,0x4,0x0
	.DB  0x78,0x0,0x0,0x0,0x44,0x0,0x7D,0x0
	.DB  0x40,0x0,0x0,0x0,0x20,0x0,0x40,0x0
	.DB  0x44,0x0,0x3D,0x0,0x0,0x0,0x0,0x0
	.DB  0x7F,0x0,0x10,0x0,0x28,0x0,0x44,0x0
	.DB  0x0,0x0,0x41,0x0,0x7F,0x0,0x40,0x0
	.DB  0x0,0x0,0x7C,0x0,0x4,0x0,0x18,0x0
	.DB  0x4,0x0,0x78,0x0,0x7C,0x0,0x8,0x0
	.DB  0x4,0x0,0x4,0x0,0x78,0x0,0x38,0x0
	.DB  0x44,0x0,0x44,0x0,0x44,0x0,0x38,0x0
	.DB  0x7C,0x0,0x14,0x0,0x14,0x0,0x14,0x0
	.DB  0x8,0x0,0x8,0x0,0x14,0x0,0x14,0x0
	.DB  0x18,0x0,0x7C,0x0,0x7C,0x0,0x8,0x0
	.DB  0x4,0x0,0x4,0x0,0x8,0x0,0x48,0x0
	.DB  0x54,0x0,0x54,0x0,0x54,0x0,0x20,0x0
	.DB  0x4,0x0,0x3F,0x0,0x44,0x0,0x40,0x0
	.DB  0x20,0x0,0x3C,0x0,0x40,0x0,0x40,0x0
	.DB  0x20,0x0,0x7C,0x0,0x1C,0x0,0x20,0x0
	.DB  0x40,0x0,0x20,0x0,0x1C,0x0,0x3C,0x0
	.DB  0x40,0x0,0x30,0x0,0x40,0x0,0x3C,0x0
	.DB  0x44,0x0,0x28,0x0,0x10,0x0,0x28,0x0
	.DB  0x44,0x0,0xC,0x0,0x50,0x0,0x50,0x0
	.DB  0x50,0x0,0x3C,0x0,0x44,0x0,0x64,0x0
	.DB  0x54,0x0,0x4C,0x0,0x44,0x0,0x0,0x0
	.DB  0x8,0x0,0x36,0x0,0x41,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x7F,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x41,0x0,0x36,0x0
	.DB  0x8,0x0,0x0,0x0,0x10,0x0,0x8,0x0
	.DB  0x8,0x0,0x10,0x0,0x8,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0

_0x72:
	.DB  0x1
_0x0:
	.DB  0x4F,0x77,0x6E,0x20,0x61,0x64,0x64,0x72
	.DB  0x65,0x73,0x73,0x20,0x6D,0x61,0x74,0x63
	.DB  0x68,0x20,0x2B,0x20,0x57,0x20,0xA,0x0
	.DB  0x52,0x65,0x63,0x65,0x69,0x76,0x65,0x20
	.DB  0x61,0x20,0x62,0x79,0x74,0x65,0x2C,0x20
	.DB  0x73,0x65,0x6E,0x74,0x20,0x41,0x43,0x4B
	.DB  0x20,0xA,0x0,0x55,0x6E,0x6B,0x6E,0x6F
	.DB  0x77,0x6E,0x20,0x54,0x57,0x49,0x20,0x73
	.DB  0x74,0x61,0x74,0x75,0x73,0x20,0x63,0x6F
	.DB  0x64,0x65,0xA,0x0,0x25,0x75,0x64,0x25
	.DB  0x75,0x68,0x25,0x75,0x6D,0x25,0x75,0x73
	.DB  0x0,0x25,0x75,0x64,0x25,0x75,0x6D,0x25
	.DB  0x75,0x73,0x0,0x25,0x75,0x64,0x25,0x75
	.DB  0x73,0x0,0x25,0x75,0x68,0x25,0x75,0x73
	.DB  0x0,0x53,0x6D,0x61,0x72,0x74,0x20,0x47
	.DB  0x61,0x72,0x64,0x65,0x6E,0x20,0x76,0x32
	.DB  0x2E,0x31,0x0,0x54,0x65,0x6D,0x70,0x20
	.DB  0x3A,0x20,0x25,0x64,0x2E,0x25,0x64,0x20
	.DB  0x43,0x20,0x21,0x48,0x4F,0x54,0x21,0x0
	.DB  0x54,0x65,0x6D,0x70,0x20,0x3A,0x20,0x25
	.DB  0x64,0x2E,0x25,0x64,0x20,0x43,0x0,0x48
	.DB  0x75,0x6D,0x20,0x20,0x3A,0x20,0x25,0x64
	.DB  0x2E,0x25,0x64,0x20,0x25,0x25,0x0,0x44
	.DB  0x48,0x54,0x31,0x31,0x3A,0x20,0x45,0x72
	.DB  0x72,0x6F,0x72,0x0,0x47,0x61,0x74,0x65
	.DB  0x3A,0x20,0x4F,0x50,0x45,0x4E,0x0,0x47
	.DB  0x61,0x74,0x65,0x3A,0x20,0x43,0x4C,0x4F
	.DB  0x53,0x45,0x0,0x4C,0x45,0x44,0x3A,0x20
	.DB  0x4F,0x4E,0x0,0x4C,0x45,0x44,0x3A,0x20
	.DB  0x4F,0x46,0x46,0x0,0x41,0x4C,0x45,0x52
	.DB  0x54,0x3A,0x25,0x75,0x73,0x0,0x57,0x61
	.DB  0x69,0x74,0x32,0x6E,0x64,0x0,0x43,0x3A
	.DB  0x25,0x64,0x0,0x55,0x70,0x3A,0x25,0x73
	.DB  0x0,0x55,0x70,0x3A,0x20,0x25,0x75,0x2E
	.DB  0x25,0x75,0x73,0x0,0x43,0x6E,0x74,0x3A
	.DB  0x20,0x25,0x75,0x0,0x49,0x6E,0x69,0x74
	.DB  0x69,0x61,0x6C,0x69,0x7A,0x69,0x6E,0x67
	.DB  0x2E,0x2E,0x2E,0x0,0x41,0x6E,0x68,0x20
	.DB  0x76,0x61,0x20,0x48,0x6F,0x69,0x20,0x64
	.DB  0x65,0x73,0x69,0x67,0x6E,0x0,0x53,0x79
	.DB  0x73,0x74,0x65,0x6D,0x20,0x52,0x65,0x61
	.DB  0x64,0x79,0x21,0x0,0x54,0x69,0x6D,0x65
	.DB  0x72,0x3A,0x20,0x4F,0x4B,0x0,0x54,0x69
	.DB  0x6D,0x65,0x72,0x3A,0x20,0x45,0x52,0x52
	.DB  0x4F,0x52,0x0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x18
	.DW  _0x31
	.DW  _0x0*2

	.DW  0x1B
	.DW  _0x31+24
	.DW  _0x0*2+24

	.DW  0x19
	.DW  _0x31+51
	.DW  _0x0*2+51

	.DW  0x01
	.DW  _last_sound_state
	.DW  _0x72*2

	.DW  0x12
	.DW  _0xB3
	.DW  _0x0*2+113

	.DW  0x0D
	.DW  _0xB3+18
	.DW  _0x0*2+183

	.DW  0x0B
	.DW  _0xB3+31
	.DW  _0x0*2+196

	.DW  0x0C
	.DW  _0xB3+42
	.DW  _0x0*2+207

	.DW  0x08
	.DW  _0xB3+54
	.DW  _0x0*2+219

	.DW  0x09
	.DW  _0xB3+62
	.DW  _0x0*2+227

	.DW  0x08
	.DW  _0xB3+71
	.DW  _0x0*2+246

	.DW  0x10
	.DW  _0xCA
	.DW  _0x0*2+284

	.DW  0x12
	.DW  _0xCA+16
	.DW  _0x0*2+300

	.DW  0x0E
	.DW  _0xCA+34
	.DW  _0x0*2+318

	.DW  0x0A
	.DW  _0xCA+48
	.DW  _0x0*2+332

	.DW  0x0D
	.DW  _0xCA+58
	.DW  _0x0*2+342

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x300

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
;	baudrate -> Y+2
;	ubrr_value -> R16,R17
;	data -> R17
;	*str -> R16,R17
;	value -> R18,R19
;	buf -> Y+4
;	index -> R16,R17
_TWI_Init:
; .FSTART _TWI_Init
	CALL __SAVELOCR4
	MOV  R17,R26
	LDD  R16,Y+4
	LDD  R19,Y+5
;	sla -> R19
;	gcall -> R16
;	sclock -> R17
	MOV  R30,R19
	LSL  R30
	MOV  R26,R30
	MOV  R30,R16
	ANDI R30,LOW(0x1)
	ADD  R30,R26
	STS  186,R30
	LDS  R30,185
	ANDI R30,LOW(0xFC)
	STS  185,R30
	MOV  R30,R17
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0xF42400
	CALL __DIVD21U
	__SUBD1N 16
	CALL __LSRD1
	STS  184,R30
	LDI  R30,LOW(69)
	STS  188,R30
	RJMP _0x2060007
; .FEND
_TWI_Start:
; .FSTART _TWI_Start
	LDI  R30,LOW(164)
	STS  188,R30
_0x10:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x10
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	RET
; .FEND
_TWI_Stop:
; .FSTART _TWI_Stop
	LDI  R30,LOW(148)
	STS  188,R30
	RET
; .FEND
;	add -> R16
;	rw -> R17
_TWI_Send_Byte:
; .FSTART _TWI_Send_Byte
	ST   -Y,R17
	MOV  R17,R26
;	b -> R17
	STS  187,R17
	LDI  R30,LOW(132)
	STS  188,R30
_0x16:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x16
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	RJMP _0x2060004
; .FEND
;	*arr -> R18,R19
;	length -> R16,R17
;	sla -> R21
;	*arr -> R18,R19
;	length -> R16,R17
;	sla -> R21
;	*arr -> R18,R19
;	length -> R16,R17

	.DSEG
_0x31:
	.BYTE 0x4C

	.CSEG
_SSD1306_Command:
; .FSTART _SSD1306_Command
	ST   -Y,R17
	MOV  R17,R26
;	cmd -> R17
	RCALL _TWI_Start
	LDI  R26,LOW(120)
	RCALL _TWI_Send_Byte
	LDI  R26,LOW(0)
	RCALL _TWI_Send_Byte
	MOV  R26,R17
	RCALL _TWI_Send_Byte
	RCALL _TWI_Stop
	RJMP _0x2060004
; .FEND
_ssd1306_set_cursor:
; .FSTART _ssd1306_set_cursor
	CALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
;	x -> R18,R19
;	y -> R16,R17
	__MOVEWRR 13,14,18,19
	__PUTWMRN _cury,0,16,17
	SUBI R26,-LOW(176)
	RCALL _SSD1306_Command
	MOV  R30,R18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	RCALL _SSD1306_Command
	MOVW R30,R18
	CALL __LSRW4
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _SSD1306_Command
_0x2060007:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
_ssd1306_clear:
; .FSTART _ssd1306_clear
	CALL __SAVELOCR4
;	page -> R16,R17
;	col -> R18,R19
	__GETWRN 16,17,0
_0x47:
	__CPWRN 16,17,8
	BRGE _0x48
	__GETWRN 18,19,0
_0x4A:
	__CPWRN 18,19,128
	BRGE _0x4B
	CALL SUBOPT_0x0
	LDI  R26,LOW(0)
	STD  Z+0,R26
	__ADDWRN 18,19,1
	RJMP _0x4A
_0x4B:
	__ADDWRN 16,17,1
	RJMP _0x47
_0x48:
	CLR  R13
	CLR  R14
	LDI  R30,LOW(0)
	STS  _cury,R30
	STS  _cury+1,R30
	CALL __LOADLOCR4
	RJMP _0x2060003
; .FEND
_ssd1306_write_char:
; .FSTART _ssd1306_write_char
	CALL __SAVELOCR4
	MOV  R19,R26
;	c -> R19
;	i -> R16,R17
	__GETW2R 13,14
	ADIW R26,10
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRGE _0x4C
	CPI  R19,32
	BRLO _0x4E
	CPI  R19,128
	BRLO _0x4D
_0x4E:
	LDI  R19,LOW(32)
_0x4D:
	__GETWRN 16,17,0
_0x51:
	__CPWRN 16,17,5
	BRGE _0x52
	CALL SUBOPT_0x1
	ADD  R30,R16
	ADC  R31,R17
	SUBI R30,LOW(-_ssd1306_buffer)
	SBCI R31,HIGH(-_ssd1306_buffer)
	MOVW R22,R30
	MOV  R30,R19
	LDI  R31,0
	SBIW R30,32
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	SUBI R30,LOW(-_font5x8*2)
	SBCI R31,HIGH(-_font5x8*2)
	MOVW R26,R30
	MOVW R30,R16
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R22
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x51
_0x52:
	CALL SUBOPT_0x1
	__ADDW1MN _ssd1306_buffer,5
	LDI  R26,LOW(0)
	STD  Z+0,R26
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	__ADDWRR 13,14,30,31
	RJMP _0x53
_0x4C:
	LDI  R26,LOW(_cury)
	LDI  R27,HIGH(_cury)
	CALL SUBOPT_0x2
_0x53:
	CALL __LOADLOCR4
	RJMP _0x2060003
; .FEND
_ssd1306_print:
; .FSTART _ssd1306_print
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*str -> R16,R17
_0x54:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0x56
	LD   R26,X
	RCALL _ssd1306_write_char
	MOVW R26,R16
	__ADDWRN 16,17,1
	LD   R30,X
	RJMP _0x54
_0x56:
	RJMP _0x2060002
; .FEND
;	*str -> R16,R17
_ssd1306_display:
; .FSTART _ssd1306_display
	CALL __SAVELOCR4
;	page -> R16,R17
;	col -> R18,R19
	__GETWRN 16,17,0
_0x5B:
	__CPWRN 16,17,8
	BRGE _0x5C
	CALL SUBOPT_0x3
	MOVW R26,R16
	RCALL _ssd1306_set_cursor
	RCALL _TWI_Start
	LDI  R26,LOW(120)
	RCALL _TWI_Send_Byte
	LDI  R26,LOW(64)
	RCALL _TWI_Send_Byte
	__GETWRN 18,19,0
_0x5E:
	__CPWRN 18,19,128
	BRGE _0x5F
	CALL SUBOPT_0x0
	LD   R26,Z
	RCALL _TWI_Send_Byte
	__ADDWRN 18,19,1
	RJMP _0x5E
_0x5F:
	RCALL _TWI_Stop
	__ADDWRN 16,17,1
	RJMP _0x5B
_0x5C:
	CALL __LOADLOCR4
	RJMP _0x2060003
; .FEND
;	fvalue -> Y+18
;	buf -> Y+10
;	value -> R16,R17
;	index -> R18,R19
;	i -> R20,R21
;	j -> Y+8
;	k -> Y+6
;	value -> Y+14
;	buf -> Y+6
;	index -> R16,R17
;	i -> R18,R19
;	j -> R20,R21
_SSD1306_Init:
; .FSTART _SSD1306_Init
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(160)
	RCALL _TWI_Init
	LDI  R26,LOW(174)
	RCALL _SSD1306_Command
	LDI  R26,LOW(32)
	CALL SUBOPT_0x4
	LDI  R26,LOW(176)
	RCALL _SSD1306_Command
	LDI  R26,LOW(200)
	CALL SUBOPT_0x4
	LDI  R26,LOW(16)
	RCALL _SSD1306_Command
	LDI  R26,LOW(64)
	RCALL _SSD1306_Command
	LDI  R26,LOW(129)
	RCALL _SSD1306_Command
	LDI  R26,LOW(207)
	RCALL _SSD1306_Command
	LDI  R26,LOW(161)
	RCALL _SSD1306_Command
	LDI  R26,LOW(166)
	RCALL _SSD1306_Command
	LDI  R26,LOW(168)
	RCALL _SSD1306_Command
	LDI  R26,LOW(63)
	RCALL _SSD1306_Command
	LDI  R26,LOW(164)
	RCALL _SSD1306_Command
	LDI  R26,LOW(211)
	CALL SUBOPT_0x4
	LDI  R26,LOW(213)
	RCALL _SSD1306_Command
	LDI  R26,LOW(128)
	RCALL _SSD1306_Command
	LDI  R26,LOW(217)
	RCALL _SSD1306_Command
	LDI  R26,LOW(241)
	RCALL _SSD1306_Command
	LDI  R26,LOW(218)
	RCALL _SSD1306_Command
	LDI  R26,LOW(18)
	RCALL _SSD1306_Command
	LDI  R26,LOW(219)
	RCALL _SSD1306_Command
	LDI  R26,LOW(64)
	RCALL _SSD1306_Command
	LDI  R26,LOW(141)
	RCALL _SSD1306_Command
	LDI  R26,LOW(20)
	RCALL _SSD1306_Command
	LDI  R26,LOW(175)
	RCALL _SSD1306_Command
	RCALL _ssd1306_clear
	RCALL _ssd1306_display
	RET
; .FEND
;volatile unsigned long millis_counter = 0;
;volatile unsigned char timer_overflow_count = 0;
;unsigned int I_RH, D_RH, I_Temp, D_Temp, CheckSum;
;char display_buffer[20];
;unsigned char dht_error = 0;
;unsigned char hasObstacle = 0, past_obstacle = 0;
;unsigned char led_state = 0;
;unsigned char sound_detected = 0;
;unsigned char last_sound_state = 1; // KY-037 idle = HIGH

	.DSEG
;unsigned long clap_timer = 0;
;unsigned char clap_count = 0;
;unsigned char waiting_for_second_clap = 0;
;unsigned long last_dht_read = 0;
;unsigned long last_display_update = 0;
;unsigned int debug_seconds = 0;
;unsigned long debug_last_second = 0;
;unsigned char temp_alert_active = 0;
;unsigned long temp_alert_start_time = 0;
;unsigned long temp_alert_last_toggle = 0;
;unsigned char temp_alert_buzzer_state = 0;
;void timer0_init() {
; 0000 0036 void timer0_init() {

	.CSEG
_timer0_init:
; .FSTART _timer0_init
; 0000 0037 // Clear timer registers
; 0000 0038 TCCR0A = 0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0039 TCCR0B = 0x00;
	OUT  0x25,R30
; 0000 003A TCNT0 = 0x00;
	OUT  0x26,R30
; 0000 003B 
; 0000 003C // Configure for CTC mode with proper prescaler
; 0000 003D TCCR0A = (1 << WGM01);  // CTC mode
	LDI  R30,LOW(2)
	OUT  0x24,R30
; 0000 003E TCCR0B = (1 << CS01) | (1 << CS00);  // Prescaler 64
	LDI  R30,LOW(3)
	OUT  0x25,R30
; 0000 003F 
; 0000 0040 // Set compare value for 1ms interrupt at 16MHz
; 0000 0041 // (16MHz / 64) / 1000Hz = 250
; 0000 0042 OCR0A = 249;  // 250 - 1
	LDI  R30,LOW(249)
	OUT  0x27,R30
; 0000 0043 
; 0000 0044 // Enable compare match interrupt
; 0000 0045 TIMSK0 = (1 << OCIE0A);
	LDI  R30,LOW(2)
	STS  110,R30
; 0000 0046 
; 0000 0047 // Enable global interrupts
; 0000 0048 #asm("sei");
	SEI
; 0000 0049 }
	RET
; .FEND
;interrupt [TIM0_COMPA] void timer0_compa_isr(void) {
; 0000 004C interrupt [15] void timer0_compa_isr(void) {
_timer0_compa_isr:
; .FSTART _timer0_compa_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004D millis_counter++;
	LDI  R26,LOW(_millis_counter)
	LDI  R27,HIGH(_millis_counter)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 004E timer_overflow_count++;
	LDS  R30,_timer_overflow_count
	SUBI R30,-LOW(1)
	STS  _timer_overflow_count,R30
; 0000 004F 
; 0000 0050 // Reset overflow counter every second for debug
; 0000 0051 if (timer_overflow_count >= 250) {  // 250 * 4ms = 1000ms
	LDS  R26,_timer_overflow_count
	CPI  R26,LOW(0xFA)
	BRLO _0x73
; 0000 0052 timer_overflow_count = 0;
	LDI  R30,LOW(0)
	STS  _timer_overflow_count,R30
; 0000 0053 }
; 0000 0054 }
_0x73:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;unsigned long millis() {
; 0000 0056 unsigned long millis() {
_millis:
; .FSTART _millis
; 0000 0057 unsigned long temp;
; 0000 0058 #asm("cli");
	SBIW R28,4
;	temp -> Y+0
	CLI
; 0000 0059 temp = millis_counter;
	LDS  R30,_millis_counter
	LDS  R31,_millis_counter+1
	LDS  R22,_millis_counter+2
	LDS  R23,_millis_counter+3
	CALL SUBOPT_0x5
; 0000 005A #asm("sei");
	SEI
; 0000 005B return temp;
	CALL SUBOPT_0x6
	RJMP _0x2060003
; 0000 005C }
; .FEND
;unsigned int get_uptime_seconds() {
; 0000 005F unsigned int get_uptime_seconds() {
_get_uptime_seconds:
; .FSTART _get_uptime_seconds
; 0000 0060 unsigned long current_millis = millis();
; 0000 0061 return (unsigned int)(current_millis / 1000UL);
	CALL SUBOPT_0x7
;	current_millis -> Y+0
	CALL __GETD2S0
	CALL SUBOPT_0x8
	RJMP _0x2060003
; 0000 0062 }
; .FEND
;void format_uptime(char* buffer, unsigned long total_seconds) {
; 0000 0065 void format_uptime(char* buffer, unsigned long total_seconds) {
_format_uptime:
; .FSTART _format_uptime
; 0000 0066 unsigned int days, hours, minutes, seconds;
; 0000 0067 
; 0000 0068 days = total_seconds / 86400UL;     // 86400 seconds in a day
	CALL __PUTPARD2
	SBIW R28,2
	CALL __SAVELOCR6
;	*buffer -> Y+12
;	total_seconds -> Y+8
;	days -> R16,R17
;	hours -> R18,R19
;	minutes -> R20,R21
;	seconds -> Y+6
	CALL SUBOPT_0x9
	CALL __DIVD21U
	MOVW R16,R30
; 0000 0069 total_seconds %= 86400UL;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 006A 
; 0000 006B hours = total_seconds / 3600UL;     // 3600 seconds in an hour
	__GETD1N 0xE10
	CALL __DIVD21U
	MOVW R18,R30
; 0000 006C total_seconds %= 3600UL;
	__GETD2S 8
	__GETD1N 0xE10
	CALL SUBOPT_0xA
; 0000 006D 
; 0000 006E minutes = total_seconds / 60UL;     // 60 seconds in a minute
	__GETD1N 0x3C
	CALL __DIVD21U
	MOVW R20,R30
; 0000 006F seconds = total_seconds % 60UL;
	__GETD2S 8
	__GETD1N 0x3C
	CALL __MODD21U
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0070 
; 0000 0071 // Format based on time duration
; 0000 0072 if (days > 0) {
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRSH _0x74
; 0000 0073 if (hours > 0) {
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRSH _0x75
; 0000 0074 sprintf(buffer, "%ud%uh%um%us", days, hours, minutes, seconds);
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,76
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CALL SUBOPT_0xE
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 0075 } else if (minutes > 0) {
	RJMP _0x76
_0x75:
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRSH _0x77
; 0000 0076 sprintf(buffer, "%ud%um%us", days, minutes, seconds);
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,89
	CALL SUBOPT_0xC
	MOVW R30,R20
	CALL SUBOPT_0xE
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	CALL SUBOPT_0xE
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 0077 } else {
	RJMP _0x78
_0x77:
; 0000 0078 sprintf(buffer, "%ud%us", days, seconds);
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,99
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0079 }
_0x78:
_0x76:
; 0000 007A } else if (hours > 0) {
	RJMP _0x79
_0x74:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRSH _0x7A
; 0000 007B if (minutes > 0) {
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRSH _0x7B
; 0000 007C sprintf(buffer, "%uh%um%us", hours, minutes, seconds);
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,79
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xD
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	CALL SUBOPT_0xE
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 007D } else {
	RJMP _0x7C
_0x7B:
; 0000 007E sprintf(buffer, "%uh%us", hours, seconds);
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,106
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 007F }
_0x7C:
; 0000 0080 } else if (minutes > 0) {
	RJMP _0x7D
_0x7A:
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRSH _0x7E
; 0000 0081 sprintf(buffer, "%um%us", minutes, seconds);
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,82
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 0082 } else {
	RJMP _0x7F
_0x7E:
; 0000 0083 sprintf(buffer, "%us", seconds);
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,85
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL SUBOPT_0xE
	CALL SUBOPT_0x11
; 0000 0084 }
_0x7F:
_0x7D:
_0x79:
; 0000 0085 }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; .FEND
;void servo_setup() {
; 0000 0088 void servo_setup() {
_servo_setup:
; .FSTART _servo_setup
; 0000 0089 DDRB |= (1 << 1); // PB1 output (SERVO_PIN)
	SBI  0x4,1
; 0000 008A 
; 0000 008B // Timer1 setup for 16MHz - exactly like your working code
; 0000 008C TCCR1A = 0x00;
	LDI  R30,LOW(0)
	STS  128,R30
; 0000 008D TCCR1B = 0x00;
	STS  129,R30
; 0000 008E TCCR1A |= (1 << WGM11);
	LDS  R30,128
	ORI  R30,2
	STS  128,R30
; 0000 008F TCCR1B |= (1 << WGM12) | (1 << WGM13);
	LDS  R30,129
	ORI  R30,LOW(0x18)
	STS  129,R30
; 0000 0090 TCCR1A |= (1 << COM1A1);
	LDS  R30,128
	ORI  R30,0x80
	STS  128,R30
; 0000 0091 TCCR1B |= (1 << CS11); // Prescaler 8
	LDS  R30,129
	ORI  R30,2
	STS  129,R30
; 0000 0092 
; 0000 0093 // Set ICR1 = 40000 for 20ms period (exactly like your code)
; 0000 0094 ICR1H = 0b10011100;  // 0x9C
	LDI  R30,LOW(156)
	STS  135,R30
; 0000 0095 ICR1L = 0b01000000;  // 0x40
	LDI  R30,LOW(64)
	STS  134,R30
; 0000 0096 
; 0000 0097 // Initial position (closed) - using your exact values
; 0000 0098 OCR1AH = 0b00000100;  // 0x04
	RJMP _0x2060006
; 0000 0099 OCR1AL = 0b00100100;  // 0x24
; 0000 009A }
; .FEND
;void open_gate() {
; 0000 009C void open_gate() {
_open_gate:
; .FSTART _open_gate
; 0000 009D // Your working "open" values (90 degrees)
; 0000 009E OCR1AH = 0b00001011;  // 0x0B
	LDI  R30,LOW(11)
	STS  137,R30
; 0000 009F OCR1AL = 0b01111100;  // 0x7C
	LDI  R30,LOW(124)
	RJMP _0x2060005
; 0000 00A0 }
; .FEND
;void close_gate() {
; 0000 00A2 void close_gate() {
_close_gate:
; .FSTART _close_gate
; 0000 00A3 // Your working "close" values (0 degrees)
; 0000 00A4 OCR1AH = 0b00000100;  // 0x04
_0x2060006:
	LDI  R30,LOW(4)
	STS  137,R30
; 0000 00A5 OCR1AL = 0b00100100;  // 0x24
	LDI  R30,LOW(36)
_0x2060005:
	STS  136,R30
; 0000 00A6 }
	RET
; .FEND
;void dht_request() {
; 0000 00A9 void dht_request() {
_dht_request:
; .FSTART _dht_request
; 0000 00AA DDRD |= (1 << DHT_PIN);
	SBI  0xA,6
; 0000 00AB PORTD &= ~(1 << DHT_PIN);
	CBI  0xB,6
; 0000 00AC delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 00AD PORTD |= (1 << DHT_PIN);
	SBI  0xB,6
; 0000 00AE delay_us(30);
	__DELAY_USB 160
; 0000 00AF }
	RET
; .FEND
;void dht_response() {
; 0000 00B1 void dht_response() {
_dht_response:
; .FSTART _dht_response
; 0000 00B2 DDRD &= ~(1 << DHT_PIN);
	CBI  0xA,6
; 0000 00B3 while (PIND & (1 << DHT_PIN));
_0x80:
	SBIC 0x9,6
	RJMP _0x80
; 0000 00B4 while (!(PIND & (1 << DHT_PIN)));
_0x83:
	SBIS 0x9,6
	RJMP _0x83
; 0000 00B5 while (PIND & (1 << DHT_PIN));
_0x86:
	SBIC 0x9,6
	RJMP _0x86
; 0000 00B6 }
	RET
; .FEND
;uint8_t dht_receive_data() {
; 0000 00B8 uint8_t dht_receive_data() {
_dht_receive_data:
; .FSTART _dht_receive_data
; 0000 00B9 uint8_t c = 0;
; 0000 00BA int q;
; 0000 00BB for (q = 0; q < 8; q++) {
	CALL __SAVELOCR4
;	c -> R17
;	q -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
_0x8A:
	__CPWRN 18,19,8
	BRGE _0x8B
; 0000 00BC while (!(PIND & (1 << DHT_PIN)));
_0x8C:
	SBIS 0x9,6
	RJMP _0x8C
; 0000 00BD delay_us(30);
	__DELAY_USB 160
; 0000 00BE if (PIND & (1 << DHT_PIN))
	SBIS 0x9,6
	RJMP _0x8F
; 0000 00BF c = (c << 1) | 1;
	MOV  R30,R17
	LSL  R30
	ORI  R30,1
	MOV  R17,R30
; 0000 00C0 else
	RJMP _0x90
_0x8F:
; 0000 00C1 c = (c << 1);
	LSL  R17
; 0000 00C2 while (PIND & (1 << DHT_PIN));
_0x90:
_0x91:
	SBIC 0x9,6
	RJMP _0x91
; 0000 00C3 }
	__ADDWRN 18,19,1
	RJMP _0x8A
_0x8B:
; 0000 00C4 return c;
	MOV  R30,R17
	CALL __LOADLOCR4
	RJMP _0x2060003
; 0000 00C5 }
; .FEND
;unsigned char read_dht11() {
; 0000 00C7 unsigned char read_dht11() {
_read_dht11:
; .FSTART _read_dht11
; 0000 00C8 dht_request();
	RCALL _dht_request
; 0000 00C9 dht_response();
	RCALL _dht_response
; 0000 00CA 
; 0000 00CB I_RH = dht_receive_data();
	RCALL _dht_receive_data
	LDI  R31,0
	STS  _I_RH,R30
	STS  _I_RH+1,R31
; 0000 00CC D_RH = dht_receive_data();
	RCALL _dht_receive_data
	LDI  R31,0
	STS  _D_RH,R30
	STS  _D_RH+1,R31
; 0000 00CD I_Temp = dht_receive_data();
	RCALL _dht_receive_data
	LDI  R31,0
	STS  _I_Temp,R30
	STS  _I_Temp+1,R31
; 0000 00CE D_Temp = dht_receive_data();
	RCALL _dht_receive_data
	LDI  R31,0
	STS  _D_Temp,R30
	STS  _D_Temp+1,R31
; 0000 00CF CheckSum = dht_receive_data();
	RCALL _dht_receive_data
	LDI  R31,0
	STS  _CheckSum,R30
	STS  _CheckSum+1,R31
; 0000 00D0 
; 0000 00D1 // Verify checksum
; 0000 00D2 if ((I_RH + D_RH + I_Temp + D_Temp) == CheckSum) {
	LDS  R30,_D_RH
	LDS  R31,_D_RH+1
	LDS  R26,_I_RH
	LDS  R27,_I_RH+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x12
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_D_Temp
	LDS  R27,_D_Temp+1
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_CheckSum
	LDS  R31,_CheckSum+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x94
; 0000 00D3 dht_error = 0;
	CLR  R9
; 0000 00D4 return 1; // Success
	LDI  R30,LOW(1)
	RET
; 0000 00D5 } else {
_0x94:
; 0000 00D6 dht_error = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 00D7 return 0; // Error
	LDI  R30,LOW(0)
	RET
; 0000 00D8 }
; 0000 00D9 }
	RET
; .FEND
;void check_temperature_alert() {
; 0000 00DC void check_temperature_alert() {
_check_temperature_alert:
; .FSTART _check_temperature_alert
; 0000 00DD unsigned long current_time = millis();
; 0000 00DE 
; 0000 00DF // Check if temperature is above 38°C and no error
; 0000 00E0 if (!dht_error && I_Temp >= 38) {
	CALL SUBOPT_0x7
;	current_time -> Y+0
	TST  R9
	BRNE _0x97
	CALL SUBOPT_0x12
	SBIW R26,38
	BRSH _0x98
_0x97:
	RJMP _0x96
_0x98:
; 0000 00E1 if (!temp_alert_active) {
	LDS  R30,_temp_alert_active
	CPI  R30,0
	BRNE _0x99
; 0000 00E2 // Start temperature alert
; 0000 00E3 temp_alert_active = 1;
	LDI  R30,LOW(1)
	STS  _temp_alert_active,R30
; 0000 00E4 temp_alert_start_time = current_time;
	CALL SUBOPT_0x6
	STS  _temp_alert_start_time,R30
	STS  _temp_alert_start_time+1,R31
	STS  _temp_alert_start_time+2,R22
	STS  _temp_alert_start_time+3,R23
; 0000 00E5 temp_alert_last_toggle = current_time;
	CALL SUBOPT_0x13
; 0000 00E6 temp_alert_buzzer_state = 0;
	LDI  R30,LOW(0)
	STS  _temp_alert_buzzer_state,R30
; 0000 00E7 }
; 0000 00E8 } else {
_0x99:
	RJMP _0x9A
_0x96:
; 0000 00E9 // Temperature is normal or DHT error - stop alert
; 0000 00EA temp_alert_active = 0;
	CALL SUBOPT_0x14
; 0000 00EB if (temp_alert_buzzer_state) {
	BREQ _0x9B
; 0000 00EC PORTD &= ~(1 << BUZZER_PIN);  // Turn off buzzer
	CBI  0xB,2
; 0000 00ED temp_alert_buzzer_state = 0;
	LDI  R30,LOW(0)
	STS  _temp_alert_buzzer_state,R30
; 0000 00EE }
; 0000 00EF }
_0x9B:
_0x9A:
; 0000 00F0 
; 0000 00F1 // Handle temperature alert blinking
; 0000 00F2 if (temp_alert_active) {
	LDS  R30,_temp_alert_active
	CPI  R30,0
	BREQ _0x9C
; 0000 00F3 // Check if 5 seconds have passed
; 0000 00F4 if (current_time - temp_alert_start_time >= 5000) {
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	__CPD1N 0x1388
	BRLO _0x9D
; 0000 00F5 // 5 seconds completed - stop alert
; 0000 00F6 temp_alert_active = 0;
	CALL SUBOPT_0x14
; 0000 00F7 if (temp_alert_buzzer_state) {
	BREQ _0x9E
; 0000 00F8 PORTD &= ~(1 << BUZZER_PIN);
	CBI  0xB,2
; 0000 00F9 temp_alert_buzzer_state = 0;
	LDI  R30,LOW(0)
	STS  _temp_alert_buzzer_state,R30
; 0000 00FA }
; 0000 00FB } else {
_0x9E:
	RJMP _0x9F
_0x9D:
; 0000 00FC // Blink buzzer every 200ms (5Hz frequency)
; 0000 00FD if (current_time - temp_alert_last_toggle >= 200) {
	LDS  R26,_temp_alert_last_toggle
	LDS  R27,_temp_alert_last_toggle+1
	LDS  R24,_temp_alert_last_toggle+2
	LDS  R25,_temp_alert_last_toggle+3
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	BRLO _0xA0
; 0000 00FE temp_alert_buzzer_state = !temp_alert_buzzer_state;
	LDS  R30,_temp_alert_buzzer_state
	CALL __LNEGB1
	STS  _temp_alert_buzzer_state,R30
; 0000 00FF temp_alert_last_toggle = current_time;
	CALL SUBOPT_0x13
; 0000 0100 
; 0000 0101 if (temp_alert_buzzer_state) {
	LDS  R30,_temp_alert_buzzer_state
	CPI  R30,0
	BREQ _0xA1
; 0000 0102 PORTD |= (1 << BUZZER_PIN);   // Buzzer on
	SBI  0xB,2
; 0000 0103 } else {
	RJMP _0xA2
_0xA1:
; 0000 0104 PORTD &= ~(1 << BUZZER_PIN);  // Buzzer off
	CBI  0xB,2
; 0000 0105 }
_0xA2:
; 0000 0106 }
; 0000 0107 }
_0xA0:
_0x9F:
; 0000 0108 }
; 0000 0109 }
_0x9C:
	RJMP _0x2060003
; .FEND
;void set_led(unsigned char state) {
; 0000 010C void set_led(unsigned char state) {
_set_led:
; .FSTART _set_led
; 0000 010D led_state = state;
	ST   -Y,R17
	MOV  R17,R26
;	state -> R17
	STS  _led_state,R17
; 0000 010E if (led_state) {
	LDS  R30,_led_state
	CPI  R30,0
	BREQ _0xA3
; 0000 010F PORTD |= (1 << LED_PIN);
	SBI  0xB,5
; 0000 0110 } else {
	RJMP _0xA4
_0xA3:
; 0000 0111 PORTD &= ~(1 << LED_PIN);
	CBI  0xB,5
; 0000 0112 }
_0xA4:
; 0000 0113 }
_0x2060004:
	LD   R17,Y+
	RET
; .FEND
;void handle_clap_switch() {
; 0000 0115 void handle_clap_switch() {
_handle_clap_switch:
; .FSTART _handle_clap_switch
; 0000 0116 unsigned long current_time;
; 0000 0117 unsigned char current_sound;
; 0000 0118 
; 0000 0119 current_time = millis();
	SBIW R28,4
	ST   -Y,R17
;	current_time -> Y+1
;	current_sound -> R17
	RCALL _millis
	__PUTD1S 1
; 0000 011A current_sound = (PINC & (1 << SOUND_SENSOR_PIN)) ? 1 : 0;
	SBIS 0x6,3
	RJMP _0xA5
	LDI  R30,LOW(1)
	RJMP _0xA6
_0xA5:
	LDI  R30,LOW(0)
_0xA6:
	MOV  R17,R30
; 0000 011B 
; 0000 011C // Detect falling edge (HIGH -> LOW) = sound detected
; 0000 011D if (last_sound_state == 1 && current_sound == 0) {
	LDS  R26,_last_sound_state
	CPI  R26,LOW(0x1)
	BRNE _0xA9
	CPI  R17,0
	BREQ _0xAA
_0xA9:
	RJMP _0xA8
_0xAA:
; 0000 011E if (!waiting_for_second_clap) {
	LDS  R30,_waiting_for_second_clap
	CPI  R30,0
	BRNE _0xAB
; 0000 011F // First clap
; 0000 0120 waiting_for_second_clap = 1;
	LDI  R30,LOW(1)
	STS  _waiting_for_second_clap,R30
; 0000 0121 clap_timer = current_time;
	CALL SUBOPT_0x18
	STS  _clap_timer,R30
	STS  _clap_timer+1,R31
	STS  _clap_timer+2,R22
	STS  _clap_timer+3,R23
; 0000 0122 clap_count = 1;
	LDI  R30,LOW(1)
	STS  _clap_count,R30
; 0000 0123 } else if (current_time - clap_timer > 30 && current_time - clap_timer < 200) {
	RJMP _0xAC
_0xAB:
	CALL SUBOPT_0x19
	__CPD1N 0x1F
	BRLO _0xAE
	CALL SUBOPT_0x17
	BRLO _0xAF
_0xAE:
	RJMP _0xAD
_0xAF:
; 0000 0124 // Second clap (within 30ms - 200ms) - very fast
; 0000 0125 clap_count = 2;
	LDI  R30,LOW(2)
	STS  _clap_count,R30
; 0000 0126 // Toggle LED immediately
; 0000 0127 set_led(!led_state);
	LDS  R30,_led_state
	CALL __LNEGB1
	MOV  R26,R30
	RCALL _set_led
; 0000 0128 // Reset state
; 0000 0129 waiting_for_second_clap = 0;
	CALL SUBOPT_0x1A
; 0000 012A clap_count = 0;
; 0000 012B clap_timer = 0;
; 0000 012C }
; 0000 012D }
_0xAD:
_0xAC:
; 0000 012E 
; 0000 012F // Timeout - reset if no second clap within 200ms
; 0000 0130 if (waiting_for_second_clap && (current_time - clap_timer > 200)) {
_0xA8:
	LDS  R30,_waiting_for_second_clap
	CPI  R30,0
	BREQ _0xB1
	CALL SUBOPT_0x19
	__CPD1N 0xC9
	BRSH _0xB2
_0xB1:
	RJMP _0xB0
_0xB2:
; 0000 0131 waiting_for_second_clap = 0;
	CALL SUBOPT_0x1A
; 0000 0132 clap_count = 0;
; 0000 0133 clap_timer = 0;
; 0000 0134 }
; 0000 0135 
; 0000 0136 last_sound_state = current_sound;
_0xB0:
	STS  _last_sound_state,R17
; 0000 0137 }
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
;void update_display() {
; 0000 013A void update_display() {
_update_display:
; .FSTART _update_display
; 0000 013B // Declare all variables at the beginning
; 0000 013C unsigned long current_millis;
; 0000 013D unsigned long uptime_seconds_long;
; 0000 013E unsigned int uptime_seconds;
; 0000 013F unsigned int deciseconds;
; 0000 0140 unsigned int raw_counter;
; 0000 0141 char uptime_formatted[16];
; 0000 0142 
; 0000 0143 ssd1306_clear();
	SBIW R28,24
	CALL __SAVELOCR6
;	current_millis -> Y+26
;	uptime_seconds_long -> Y+22
;	uptime_seconds -> R16,R17
;	deciseconds -> R18,R19
;	raw_counter -> R20,R21
;	uptime_formatted -> Y+6
	CALL SUBOPT_0x1B
; 0000 0144 
; 0000 0145 // Title
; 0000 0146 ssd1306_set_cursor(0, 0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _ssd1306_set_cursor
; 0000 0147 ssd1306_print("Smart Garden v2.1");
	__POINTW2MN _0xB3,0
	RCALL _ssd1306_print
; 0000 0148 
; 0000 0149 // DHT11 data with temperature alert indicator
; 0000 014A if (!dht_error) {
	TST  R9
	BREQ PC+2
	RJMP _0xB4
; 0000 014B ssd1306_set_cursor(0, 2);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1C
; 0000 014C if (temp_alert_active && I_Temp >= 38) {
	LDS  R30,_temp_alert_active
	CPI  R30,0
	BREQ _0xB6
	CALL SUBOPT_0x12
	SBIW R26,38
	BRSH _0xB7
_0xB6:
	RJMP _0xB5
_0xB7:
; 0000 014D sprintf(display_buffer, "Temp : %d.%d C !HOT!", I_Temp, D_Temp);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,131
	RJMP _0xDD
; 0000 014E } else {
_0xB5:
; 0000 014F sprintf(display_buffer, "Temp : %d.%d C", I_Temp, D_Temp);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,152
_0xDD:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_I_Temp
	LDS  R31,_I_Temp+1
	CALL SUBOPT_0xE
	LDS  R30,_D_Temp
	LDS  R31,_D_Temp+1
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
; 0000 0150 }
; 0000 0151 ssd1306_print(display_buffer);
	LDI  R26,LOW(_display_buffer)
	LDI  R27,HIGH(_display_buffer)
	CALL SUBOPT_0x1E
; 0000 0152 
; 0000 0153 ssd1306_set_cursor(0, 3);
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _ssd1306_set_cursor
; 0000 0154 sprintf(display_buffer, "Hum  : %d.%d %%", I_RH, D_RH);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,167
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_I_RH
	LDS  R31,_I_RH+1
	CALL SUBOPT_0xE
	LDS  R30,_D_RH
	LDS  R31,_D_RH+1
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
; 0000 0155 ssd1306_print(display_buffer);
	LDI  R26,LOW(_display_buffer)
	LDI  R27,HIGH(_display_buffer)
	RJMP _0xDE
; 0000 0156 } else {
_0xB4:
; 0000 0157 ssd1306_set_cursor(0, 2);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1C
; 0000 0158 ssd1306_print("DHT11: Error");
	__POINTW2MN _0xB3,18
_0xDE:
	RCALL _ssd1306_print
; 0000 0159 }
; 0000 015A 
; 0000 015B // Gate status
; 0000 015C ssd1306_set_cursor(0, 5);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x1F
; 0000 015D if (hasObstacle) {
	LDS  R30,_hasObstacle
	CPI  R30,0
	BREQ _0xBA
; 0000 015E ssd1306_print("Gate: OPEN");
	__POINTW2MN _0xB3,31
	RJMP _0xDF
; 0000 015F } else {
_0xBA:
; 0000 0160 ssd1306_print("Gate: CLOSE");
	__POINTW2MN _0xB3,42
_0xDF:
	RCALL _ssd1306_print
; 0000 0161 }
; 0000 0162 
; 0000 0163 // LED status
; 0000 0164 ssd1306_set_cursor(0, 6);
	CALL SUBOPT_0x3
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _ssd1306_set_cursor
; 0000 0165 if (led_state) {
	LDS  R30,_led_state
	CPI  R30,0
	BREQ _0xBC
; 0000 0166 ssd1306_print("LED: ON");
	__POINTW2MN _0xB3,54
	RJMP _0xE0
; 0000 0167 } else {
_0xBC:
; 0000 0168 ssd1306_print("LED: OFF");
	__POINTW2MN _0xB3,62
_0xE0:
	RCALL _ssd1306_print
; 0000 0169 }
; 0000 016A 
; 0000 016B // Temperature alert status
; 0000 016C ssd1306_set_cursor(68, 5);
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1F
; 0000 016D if (temp_alert_active) {
	LDS  R30,_temp_alert_active
	CPI  R30,0
	BREQ _0xBE
; 0000 016E unsigned long remaining = 5000 - (millis() - temp_alert_start_time);
; 0000 016F sprintf(display_buffer, "ALERT:%us", (unsigned int)(remaining/1000 + 1));
	SBIW R28,4
;	current_millis -> Y+30
;	uptime_seconds_long -> Y+26
;	uptime_formatted -> Y+10
;	remaining -> Y+0
	RCALL _millis
	CALL SUBOPT_0x15
	CALL __SUBD12
	__GETD2N 0x1388
	CALL __SWAPD12
	CALL __SUBD12
	CALL SUBOPT_0x5
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,236
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 4
	CALL SUBOPT_0x8
	__ADDD1N 1
	CLR  R22
	CLR  R23
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x20
; 0000 0170 ssd1306_print(display_buffer);
	LDI  R26,LOW(_display_buffer)
	LDI  R27,HIGH(_display_buffer)
	RCALL _ssd1306_print
; 0000 0171 }
	ADIW R28,4
; 0000 0172 
; 0000 0173 // Clap debug info (can be removed after testing)
; 0000 0174 ssd1306_set_cursor(64, 6);
_0xBE:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	LDI  R27,0
	RCALL _ssd1306_set_cursor
; 0000 0175 if (waiting_for_second_clap) {
	LDS  R30,_waiting_for_second_clap
	CPI  R30,0
	BREQ _0xBF
; 0000 0176 ssd1306_print("Wait2nd");
	__POINTW2MN _0xB3,71
	RJMP _0xE1
; 0000 0177 } else {
_0xBF:
; 0000 0178 sprintf(display_buffer, "C:%d", clap_count);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,254
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_clap_count
	CLR  R31
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x20
; 0000 0179 ssd1306_print(display_buffer);
	LDI  R26,LOW(_display_buffer)
	LDI  R27,HIGH(_display_buffer)
_0xE1:
	RCALL _ssd1306_print
; 0000 017A }
; 0000 017B 
; 0000 017C // System uptime - ENHANCED with human readable format
; 0000 017D ssd1306_set_cursor(0, 7);
	CALL SUBOPT_0x3
	LDI  R26,LOW(7)
	LDI  R27,0
	RCALL _ssd1306_set_cursor
; 0000 017E 
; 0000 017F // Get current values
; 0000 0180 current_millis = millis();
	RCALL _millis
	__PUTD1S 26
; 0000 0181 uptime_seconds = get_uptime_seconds();
	RCALL _get_uptime_seconds
	MOVW R16,R30
; 0000 0182 
; 0000 0183 if (current_millis > 0 && uptime_seconds > 0) {
	CALL SUBOPT_0x21
	BRSH _0xC2
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRLO _0xC3
_0xC2:
	RJMP _0xC1
_0xC3:
; 0000 0184 // Format uptime in human readable format
; 0000 0185 uptime_seconds_long = (unsigned long)uptime_seconds;
	MOVW R30,R16
	CLR  R22
	CLR  R23
	__PUTD1S 22
; 0000 0186 format_uptime(uptime_formatted, uptime_seconds_long);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 24
	RCALL _format_uptime
; 0000 0187 sprintf(display_buffer, "Up:%s", uptime_formatted);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,259
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	RJMP _0xE2
; 0000 0188 ssd1306_print(display_buffer);
; 0000 0189 } else if (current_millis > 0) {
_0xC1:
	CALL SUBOPT_0x21
	BRSH _0xC5
; 0000 018A // Fallback 1: Show milliseconds/100
; 0000 018B deciseconds = (unsigned int)(current_millis / 100UL);
	__GETD2S 26
	__GETD1N 0x64
	CALL __DIVD21U
	MOVW R18,R30
; 0000 018C sprintf(display_buffer, "Up: %u.%us", deciseconds/10, deciseconds%10);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,265
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	CALL SUBOPT_0xE
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
; 0000 018D ssd1306_print(display_buffer);
	RJMP _0xE3
; 0000 018E } else {
_0xC5:
; 0000 018F // Fallback 2: Show raw counter
; 0000 0190 #asm("cli");
	CLI
; 0000 0191 raw_counter = (unsigned int)(millis_counter & 0xFFFF);
	LDS  R30,_millis_counter
	LDS  R31,_millis_counter+1
	MOVW R20,R30
; 0000 0192 #asm("sei");
	SEI
; 0000 0193 sprintf(display_buffer, "Cnt: %u", raw_counter);
	CALL SUBOPT_0x1D
	__POINTW1FN _0x0,276
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
_0xE2:
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x20
; 0000 0194 ssd1306_print(display_buffer);
_0xE3:
	LDI  R26,LOW(_display_buffer)
	LDI  R27,HIGH(_display_buffer)
	RCALL _ssd1306_print
; 0000 0195 }
; 0000 0196 
; 0000 0197 ssd1306_display();
	RCALL _ssd1306_display
; 0000 0198 }
	CALL __LOADLOCR6
	ADIW R28,30
	RET
; .FEND

	.DSEG
_0xB3:
	.BYTE 0x4F
;void debug_timer() {
; 0000 019B void debug_timer() {

	.CSEG
_debug_timer:
; .FSTART _debug_timer
; 0000 019C unsigned long current_time;
; 0000 019D static unsigned char debug_led = 0;
; 0000 019E 
; 0000 019F current_time = millis();
	CALL SUBOPT_0x7
;	current_time -> Y+0
; 0000 01A0 
; 0000 01A1 // Update debug seconds counter
; 0000 01A2 if (current_time - debug_last_second >= 1000) {
	LDS  R26,_debug_last_second
	LDS  R27,_debug_last_second+1
	LDS  R24,_debug_last_second+2
	LDS  R25,_debug_last_second+3
	CALL SUBOPT_0x16
	__CPD1N 0x3E8
	BRLO _0xC7
; 0000 01A3 debug_seconds++;
	LDI  R26,LOW(_debug_seconds)
	LDI  R27,HIGH(_debug_seconds)
	CALL SUBOPT_0x2
; 0000 01A4 debug_last_second = current_time;
	CALL SUBOPT_0x6
	STS  _debug_last_second,R30
	STS  _debug_last_second+1,R31
	STS  _debug_last_second+2,R22
	STS  _debug_last_second+3,R23
; 0000 01A5 
; 0000 01A6 // Blink built-in LED every second for visual confirmation
; 0000 01A7 debug_led = !debug_led;
	LDS  R30,_debug_led_S000002A000
	CALL __LNEGB1
	STS  _debug_led_S000002A000,R30
; 0000 01A8 if (debug_led) {
	CPI  R30,0
	BREQ _0xC8
; 0000 01A9 PORTB |= (1 << 5);  // Arduino pin 13
	SBI  0x5,5
; 0000 01AA } else {
	RJMP _0xC9
_0xC8:
; 0000 01AB PORTB &= ~(1 << 5);
	CBI  0x5,5
; 0000 01AC }
_0xC9:
; 0000 01AD }
; 0000 01AE }
_0xC7:
_0x2060003:
	ADIW R28,4
	RET
; .FEND
;void system_init() {
; 0000 01B1 void system_init() {
_system_init:
; .FSTART _system_init
; 0000 01B2 int i;
; 0000 01B3 
; 0000 01B4 // Configure debug LED (pin 13)
; 0000 01B5 DDRB |= (1 << 5);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	SBI  0x4,5
; 0000 01B6 PORTB &= ~(1 << 5);
	CBI  0x5,5
; 0000 01B7 
; 0000 01B8 // Initialize OLED
; 0000 01B9 SSD1306_Init();
	RCALL _SSD1306_Init
; 0000 01BA ssd1306_clear();
	CALL SUBOPT_0x1B
; 0000 01BB 
; 0000 01BC // Show startup message
; 0000 01BD ssd1306_set_cursor(0, 2);
	CALL SUBOPT_0x1C
; 0000 01BE ssd1306_print("Initializing...");
	__POINTW2MN _0xCA,0
	CALL SUBOPT_0x1E
; 0000 01BF ssd1306_set_cursor(0, 4);
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _ssd1306_set_cursor
; 0000 01C0 ssd1306_print("Anh va Hoi design");
	__POINTW2MN _0xCA,16
	RCALL _ssd1306_print
; 0000 01C1 ssd1306_display();
	RCALL _ssd1306_display
; 0000 01C2 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 01C3 
; 0000 01C4 // Initialize timer FIRST - IMPORTANT
; 0000 01C5 timer0_init();
	RCALL _timer0_init
; 0000 01C6 
; 0000 01C7 // Initialize servo
; 0000 01C8 servo_setup();
	RCALL _servo_setup
; 0000 01C9 close_gate();
	RCALL _close_gate
; 0000 01CA 
; 0000 01CB // Configure pins
; 0000 01CC // Gate control pins
; 0000 01CD DDRC &= ~(1 << FC51_PIN);    // FC51 input
	CBI  0x7,1
; 0000 01CE PORTC |= (1 << FC51_PIN);    // Pull-up
	SBI  0x8,1
; 0000 01CF DDRD |= (1 << BUZZER_PIN);   // Buzzer output
	SBI  0xA,2
; 0000 01D0 PORTD &= ~(1 << BUZZER_PIN); // Buzzer off
	CBI  0xB,2
; 0000 01D1 
; 0000 01D2 // Clap switch pins
; 0000 01D3 DDRD |= (1 << LED_PIN);      // LED output
	SBI  0xA,5
; 0000 01D4 PORTD &= ~(1 << LED_PIN);    // LED off
	CBI  0xB,5
; 0000 01D5 DDRC &= ~(1 << SOUND_SENSOR_PIN); // Sound sensor input
	CBI  0x7,3
; 0000 01D6 PORTC |= (1 << SOUND_SENSOR_PIN); // Pull-up
	SBI  0x8,3
; 0000 01D7 
; 0000 01D8 // Startup LED sequence
; 0000 01D9 for (i = 0; i < 3; i++) {
	__GETWRN 16,17,0
_0xCC:
	__CPWRN 16,17,3
	BRGE _0xCD
; 0000 01DA PORTD |= (1 << LED_PIN);
	SBI  0xB,5
; 0000 01DB delay_ms(200);
	CALL SUBOPT_0x22
; 0000 01DC PORTD &= ~(1 << LED_PIN);
	CBI  0xB,5
; 0000 01DD delay_ms(200);
	CALL SUBOPT_0x22
; 0000 01DE }
	__ADDWRN 16,17,1
	RJMP _0xCC
_0xCD:
; 0000 01DF 
; 0000 01E0 // Initialize variables
; 0000 01E1 led_state = 0;
	LDI  R30,LOW(0)
	STS  _led_state,R30
; 0000 01E2 sound_detected = 0;
	STS  _sound_detected,R30
; 0000 01E3 last_sound_state = 1;
	LDI  R30,LOW(1)
	STS  _last_sound_state,R30
; 0000 01E4 clap_timer = 0;
	LDI  R30,LOW(0)
	STS  _clap_timer,R30
	STS  _clap_timer+1,R30
	STS  _clap_timer+2,R30
	STS  _clap_timer+3,R30
; 0000 01E5 clap_count = 0;
	STS  _clap_count,R30
; 0000 01E6 waiting_for_second_clap = 0;
	STS  _waiting_for_second_clap,R30
; 0000 01E7 hasObstacle = 0;
	STS  _hasObstacle,R30
; 0000 01E8 past_obstacle = 0;
	STS  _past_obstacle,R30
; 0000 01E9 last_dht_read = 0;
	STS  _last_dht_read,R30
	STS  _last_dht_read+1,R30
	STS  _last_dht_read+2,R30
	STS  _last_dht_read+3,R30
; 0000 01EA last_display_update = 0;
	STS  _last_display_update,R30
	STS  _last_display_update+1,R30
	STS  _last_display_update+2,R30
	STS  _last_display_update+3,R30
; 0000 01EB debug_seconds = 0;
	STS  _debug_seconds,R30
	STS  _debug_seconds+1,R30
; 0000 01EC debug_last_second = 0;
	STS  _debug_last_second,R30
	STS  _debug_last_second+1,R30
	STS  _debug_last_second+2,R30
	STS  _debug_last_second+3,R30
; 0000 01ED 
; 0000 01EE // Initialize temperature alert variables
; 0000 01EF temp_alert_active = 0;
	STS  _temp_alert_active,R30
; 0000 01F0 temp_alert_start_time = 0;
	STS  _temp_alert_start_time,R30
	STS  _temp_alert_start_time+1,R30
	STS  _temp_alert_start_time+2,R30
	STS  _temp_alert_start_time+3,R30
; 0000 01F1 temp_alert_last_toggle = 0;
	STS  _temp_alert_last_toggle,R30
	STS  _temp_alert_last_toggle+1,R30
	STS  _temp_alert_last_toggle+2,R30
	STS  _temp_alert_last_toggle+3,R30
; 0000 01F2 temp_alert_buzzer_state = 0;
	STS  _temp_alert_buzzer_state,R30
; 0000 01F3 
; 0000 01F4 // Wait for timer to start
; 0000 01F5 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 01F6 
; 0000 01F7 ssd1306_clear();
	CALL SUBOPT_0x1B
; 0000 01F8 ssd1306_set_cursor(0, 3);
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _ssd1306_set_cursor
; 0000 01F9 ssd1306_print("System Ready!");
	__POINTW2MN _0xCA,34
	CALL SUBOPT_0x1E
; 0000 01FA 
; 0000 01FB // Show timer status
; 0000 01FC ssd1306_set_cursor(0, 5);
	CALL SUBOPT_0x1F
; 0000 01FD if (millis() > 0) {
	RCALL _millis
	CALL __CPD01
	BRSH _0xCE
; 0000 01FE ssd1306_print("Timer: OK");
	__POINTW2MN _0xCA,48
	RJMP _0xE4
; 0000 01FF } else {
_0xCE:
; 0000 0200 ssd1306_print("Timer: ERROR");
	__POINTW2MN _0xCA,58
_0xE4:
	RCALL _ssd1306_print
; 0000 0201 }
; 0000 0202 
; 0000 0203 ssd1306_display();
	RCALL _ssd1306_display
; 0000 0204 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0205 }
_0x2060002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0xCA:
	.BYTE 0x47
;void main(void) {
; 0000 0208 void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 0209 unsigned long current_time;
; 0000 020A 
; 0000 020B // System initialization
; 0000 020C system_init();
	SBIW R28,4
;	current_time -> Y+0
	RCALL _system_init
; 0000 020D 
; 0000 020E while (1) {
_0xD0:
; 0000 020F current_time = millis();
	RCALL _millis
	CALL SUBOPT_0x5
; 0000 0210 
; 0000 0211 // Debug timer function
; 0000 0212 debug_timer();
	RCALL _debug_timer
; 0000 0213 
; 0000 0214 // Read DHT11 every 2 seconds
; 0000 0215 if (current_time - last_dht_read >= 2000) {
	LDS  R26,_last_dht_read
	LDS  R27,_last_dht_read+1
	LDS  R24,_last_dht_read+2
	LDS  R25,_last_dht_read+3
	CALL SUBOPT_0x16
	__CPD1N 0x7D0
	BRLO _0xD3
; 0000 0216 read_dht11();
	RCALL _read_dht11
; 0000 0217 last_dht_read = current_time;
	CALL SUBOPT_0x6
	STS  _last_dht_read,R30
	STS  _last_dht_read+1,R31
	STS  _last_dht_read+2,R22
	STS  _last_dht_read+3,R23
; 0000 0218 }
; 0000 0219 
; 0000 021A // Check temperature alert - NEW
; 0000 021B check_temperature_alert();
_0xD3:
	RCALL _check_temperature_alert
; 0000 021C 
; 0000 021D // Check obstacle sensor
; 0000 021E hasObstacle = !(PINC & (1 << FC51_PIN));
	IN   R30,0x6
	ANDI R30,LOW(0x2)
	CALL __LNEGB1
	STS  _hasObstacle,R30
; 0000 021F 
; 0000 0220 if (hasObstacle) {
	CPI  R30,0
	BREQ _0xD4
; 0000 0221 // Object detected - open gate
; 0000 0222 if (past_obstacle != hasObstacle) {
	LDS  R26,_past_obstacle
	CP   R30,R26
	BREQ _0xD5
; 0000 0223 open_gate();
	RCALL _open_gate
; 0000 0224 // Only sound obstacle buzzer if not in temperature alert mode
; 0000 0225 if (!temp_alert_active) {
	LDS  R30,_temp_alert_active
	CPI  R30,0
	BRNE _0xD6
; 0000 0226 PORTD |= (1 << BUZZER_PIN);   // Buzzer on
	SBI  0xB,2
; 0000 0227 delay_ms(200);
	CALL SUBOPT_0x22
; 0000 0228 PORTD &= ~(1 << BUZZER_PIN);  // Buzzer off
	CBI  0xB,2
; 0000 0229 }
; 0000 022A delay_ms(1000);
_0xD6:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 022B }
; 0000 022C } else {
_0xD5:
	RJMP _0xD7
_0xD4:
; 0000 022D // No object - close gate
; 0000 022E close_gate();
	RCALL _close_gate
; 0000 022F }
_0xD7:
; 0000 0230 past_obstacle = hasObstacle;
	LDS  R30,_hasObstacle
	STS  _past_obstacle,R30
; 0000 0231 
; 0000 0232 // Process clap switch - CALL ONLY 1 FUNCTION
; 0000 0233 handle_clap_switch();
	RCALL _handle_clap_switch
; 0000 0234 
; 0000 0235 // Update display every 500ms
; 0000 0236 if (current_time - last_display_update >= 500) {
	LDS  R26,_last_display_update
	LDS  R27,_last_display_update+1
	LDS  R24,_last_display_update+2
	LDS  R25,_last_display_update+3
	CALL SUBOPT_0x16
	__CPD1N 0x1F4
	BRLO _0xD8
; 0000 0237 update_display();
	RCALL _update_display
; 0000 0238 last_display_update = current_time;
	CALL SUBOPT_0x6
	STS  _last_display_update,R30
	STS  _last_display_update+1,R31
	STS  _last_display_update+2,R22
	STS  _last_display_update+3,R23
; 0000 0239 }
; 0000 023A 
; 0000 023B // No delay needed - main loop runs freely
; 0000 023C }
_0xD8:
	RJMP _0xD0
; 0000 023D }
_0xD9:
	RJMP _0xD9
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	CALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000016
	MOVW R26,R18
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000018
	__CPWRN 16,17,2
	BRLO _0x2000019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1RNS 18,4
_0x2000018:
	MOVW R26,R18
	ADIW R26,2
	CALL SUBOPT_0x2
	SBIW R30,1
	ST   Z,R21
_0x2000019:
	MOVW R26,R18
	CALL __GETW1P
	TST  R31
	BRMI _0x200001A
	CALL SUBOPT_0x2
_0x200001A:
	RJMP _0x200001B
_0x2000016:
	MOVW R26,R18
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x200001B:
	CALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x200001C:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200001E
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000022
	CPI  R18,37
	BRNE _0x2000023
	LDI  R17,LOW(1)
	RJMP _0x2000024
_0x2000023:
	CALL SUBOPT_0x23
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BRNE _0x2000025
	CPI  R18,37
	BRNE _0x2000026
	CALL SUBOPT_0x23
	RJMP _0x20000D2
_0x2000026:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000027
	LDI  R16,LOW(1)
	RJMP _0x2000021
_0x2000027:
	CPI  R18,43
	BRNE _0x2000028
	LDI  R20,LOW(43)
	RJMP _0x2000021
_0x2000028:
	CPI  R18,32
	BRNE _0x2000029
	LDI  R20,LOW(32)
	RJMP _0x2000021
_0x2000029:
	RJMP _0x200002A
_0x2000025:
	CPI  R30,LOW(0x2)
	BRNE _0x200002B
_0x200002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x200002C
	ORI  R16,LOW(128)
	RJMP _0x2000021
_0x200002C:
	RJMP _0x200002D
_0x200002B:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x2000021
_0x200002D:
	CPI  R18,48
	BRLO _0x2000030
	CPI  R18,58
	BRLO _0x2000031
_0x2000030:
	RJMP _0x200002F
_0x2000031:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000021
_0x200002F:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000035
	CALL SUBOPT_0x24
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x25
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x73)
	BRNE _0x2000038
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x70)
	BRNE _0x200003B
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000039:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x200003C
_0x200003B:
	CPI  R30,LOW(0x64)
	BREQ _0x200003F
	CPI  R30,LOW(0x69)
	BRNE _0x2000040
_0x200003F:
	ORI  R16,LOW(4)
	RJMP _0x2000041
_0x2000040:
	CPI  R30,LOW(0x75)
	BRNE _0x2000042
_0x2000041:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x2000043
_0x2000042:
	CPI  R30,LOW(0x58)
	BRNE _0x2000045
	ORI  R16,LOW(8)
	RJMP _0x2000046
_0x2000045:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000077
_0x2000046:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x2000043:
	SBRS R16,2
	RJMP _0x2000048
	CALL SUBOPT_0x24
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000049
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000049:
	CPI  R20,0
	BREQ _0x200004A
	SUBI R17,-LOW(1)
	RJMP _0x200004B
_0x200004A:
	ANDI R16,LOW(251)
_0x200004B:
	RJMP _0x200004C
_0x2000048:
	CALL SUBOPT_0x24
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x200004C:
_0x200003C:
	SBRC R16,0
	RJMP _0x200004D
_0x200004E:
	CP   R17,R21
	BRSH _0x2000050
	SBRS R16,7
	RJMP _0x2000051
	SBRS R16,2
	RJMP _0x2000052
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2000053
_0x2000052:
	LDI  R18,LOW(48)
_0x2000053:
	RJMP _0x2000054
_0x2000051:
	LDI  R18,LOW(32)
_0x2000054:
	CALL SUBOPT_0x23
	SUBI R21,LOW(1)
	RJMP _0x200004E
_0x2000050:
_0x200004D:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x2000055
_0x2000056:
	CPI  R19,0
	BREQ _0x2000058
	SBRS R16,3
	RJMP _0x2000059
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x200005A
_0x2000059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005A:
	CALL SUBOPT_0x23
	CPI  R21,0
	BREQ _0x200005B
	SUBI R21,LOW(1)
_0x200005B:
	SUBI R19,LOW(1)
	RJMP _0x2000056
_0x2000058:
	RJMP _0x200005C
_0x2000055:
_0x200005E:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000060:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2000062
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000060
_0x2000062:
	CPI  R18,58
	BRLO _0x2000063
	SBRS R16,3
	RJMP _0x2000064
	SUBI R18,-LOW(7)
	RJMP _0x2000065
_0x2000064:
	SUBI R18,-LOW(39)
_0x2000065:
_0x2000063:
	SBRC R16,4
	RJMP _0x2000067
	CPI  R18,49
	BRSH _0x2000069
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000068
_0x2000069:
	RJMP _0x20000D3
_0x2000068:
	CP   R21,R19
	BRLO _0x200006D
	SBRS R16,0
	RJMP _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x200006F
	LDI  R18,LOW(48)
_0x20000D3:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000070
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x25
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	CALL SUBOPT_0x23
	CPI  R21,0
	BREQ _0x2000072
	SUBI R21,LOW(1)
_0x2000072:
_0x200006C:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x200005F
	RJMP _0x200005E
_0x200005F:
_0x200005C:
	SBRS R16,0
	RJMP _0x2000073
_0x2000074:
	CPI  R21,0
	BREQ _0x2000076
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x25
	RJMP _0x2000074
_0x2000076:
_0x2000073:
_0x2000077:
_0x2000036:
_0x20000D2:
	LDI  R17,LOW(0)
_0x2000021:
	RJMP _0x200001C
_0x200001E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR6
	MOVW R30,R28
	CALL __ADDW1R15
	__GETWRZ 20,21,14
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2000078
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060001
_0x2000078:
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	MOVW R16,R26
	__PUTWSR 20,21,8
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2060001:
	CALL __LOADLOCR6
	ADIW R28,12
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_TWI_Rx_Buf:
	.BYTE 0x32
_TWI_Tx_Buf:
	.BYTE 0x32
_ssd1306_buffer:
	.BYTE 0x400
_cury:
	.BYTE 0x2
_millis_counter:
	.BYTE 0x4
_timer_overflow_count:
	.BYTE 0x1
_I_RH:
	.BYTE 0x2
_D_RH:
	.BYTE 0x2
_I_Temp:
	.BYTE 0x2
_D_Temp:
	.BYTE 0x2
_CheckSum:
	.BYTE 0x2
_display_buffer:
	.BYTE 0x14
_hasObstacle:
	.BYTE 0x1
_past_obstacle:
	.BYTE 0x1
_led_state:
	.BYTE 0x1
_sound_detected:
	.BYTE 0x1
_last_sound_state:
	.BYTE 0x1
_clap_timer:
	.BYTE 0x4
_clap_count:
	.BYTE 0x1
_waiting_for_second_clap:
	.BYTE 0x1
_last_dht_read:
	.BYTE 0x4
_last_display_update:
	.BYTE 0x4
_debug_seconds:
	.BYTE 0x2
_debug_last_second:
	.BYTE 0x4
_temp_alert_active:
	.BYTE 0x1
_temp_alert_start_time:
	.BYTE 0x4
_temp_alert_last_toggle:
	.BYTE 0x4
_temp_alert_buzzer_state:
	.BYTE 0x1
_debug_led_S000002A000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	MOVW R30,R16
	CALL __LSLW3
	CALL __LSLW4
	ADD  R30,R18
	ADC  R31,R19
	SUBI R30,LOW(-_ssd1306_buffer)
	SBCI R31,HIGH(-_ssd1306_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDS  R30,_cury
	LDS  R31,_cury+1
	CALL __LSLW3
	CALL __LSLW4
	ADD  R30,R13
	ADC  R31,R14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	CALL _SSD1306_Command
	LDI  R26,LOW(0)
	JMP  _SSD1306_Command

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x6:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	SBIW R28,4
	CALL _millis
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD1N 0x3E8
	CALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__GETD2S 8
	__GETD1N 0x15180
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	CALL __MODD21U
	__PUTD1S 8
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	MOVW R30,R18
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOVW R30,R20
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xE:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDS  R26,_I_Temp
	LDS  R27,_I_Temp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x6
	STS  _temp_alert_last_toggle,R30
	STS  _temp_alert_last_toggle+1,R31
	STS  _temp_alert_last_toggle+2,R22
	STS  _temp_alert_last_toggle+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _temp_alert_active,R30
	LDS  R30,_temp_alert_buzzer_state
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDS  R26,_temp_alert_start_time
	LDS  R27,_temp_alert_start_time+1
	LDS  R24,_temp_alert_start_time+2
	LDS  R25,_temp_alert_start_time+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	RCALL SUBOPT_0x6
	CALL __SUBD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	__CPD1N 0xC8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDS  R26,_clap_timer
	LDS  R27,_clap_timer+1
	LDS  R24,_clap_timer+2
	LDS  R25,_clap_timer+3
	RCALL SUBOPT_0x18
	CALL __SUBD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	STS  _waiting_for_second_clap,R30
	STS  _clap_count,R30
	STS  _clap_timer,R30
	STS  _clap_timer+1,R30
	STS  _clap_timer+2,R30
	STS  _clap_timer+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL _ssd1306_clear
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _ssd1306_set_cursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(_display_buffer)
	LDI  R31,HIGH(_display_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	CALL _ssd1306_print
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(5)
	LDI  R27,0
	JMP  _ssd1306_set_cursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL __PUTPARD1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	__GETD2S 26
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x23:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ADDW1R15:
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LSRD1:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	MOVW R20,R0
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	CPC  R0,R22
	CPC  R0,R23
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
