
;CodeVisionAVR C Compiler V1.24.8d Professional
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega48
;Clock frequency        : 4.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : No
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega48
	#pragma AVRPART MEMORY PROG_FLASH 4096
	#pragma AVRPART MEMORY EEPROM 256
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU GPIOR1=0x2A
	.EQU GPIOR2=0x2B

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

	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C

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
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
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

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
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

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
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

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
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
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
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
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
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
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
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

	.CSEG
	.ORG 0

	.INCLUDE "r.vec"
	.INCLUDE "r.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x200)
	LDI  R25,HIGH(0x200)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
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

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	LDI  R30,__GPIOR1_INIT
	OUT  GPIOR1,R30
	LDI  R30,__GPIOR2_INIT
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x2FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x2FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x180)
	LDI  R29,HIGH(0x180)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x180
;       1 #include <mega48.h>
;       2 #include <string.h>
;       3 #include <delay.h>
;       4 #include <lcd16x1.h> 
;       5 #define button PIND.2
;       6 #define RXB8 1
;       7 #define TXB8 0
;       8 #define UPE 2
;       9 #define OVR 3
;      10 #define FE 4
;      11 #define UDRE 5
;      12 #define RXC 7
;      13 
;      14 #define FRAMING_ERROR (1<<FE)
;      15 #define PARITY_ERROR (1<<UPE)
;      16 #define DATA_OVERRUN (1<<OVR)
;      17 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      18 #define RX_COMPLETE (1<<RXC)
;      19 unsigned char timer_count_info1=0,timer_count_info;
;      20 #define ADC_VREF_TYPE 0x00
;      21 unsigned char attendance1=0,attendance2=0,attendance3=0,attendance4=0,display_atd,code;
;      22 
;      23  
;      24 unsigned char card[8],msg[]="WELCOME TO CDAC",msg1[]="ATTENDANCE V1.0",msg2[]="  BLUETOOTH  ",msg3[]="  ATTENDANCE  ";
_card:
	.BYTE 0x8
_msg:
	.BYTE 0x10
_msg1:
	.BYTE 0x10
_msg2:
	.BYTE 0xE
_msg3:
	.BYTE 0xF
;      25 
;      26 unsigned char r[]="Ram",a[]="Raj",b[]="Ved",c[]="Sam",d[]="Om";
_r:
	.BYTE 0x4
_a:
	.BYTE 0x4
_b:
	.BYTE 0x4
_c:
	.BYTE 0x4
_d:
	.BYTE 0x3
;      27 
;      28 
;      29 
;      30 
;      31 
;      32 // USART Receiver buffer
;      33 #define RX_BUFFER_SIZE0 8
;      34 char rx_buffer0[RX_BUFFER_SIZE0];
_rx_buffer0:
	.BYTE 0x8
;      35 
;      36 #if RX_BUFFER_SIZE0<256
;      37 unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;      38 #else
;      39 unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;      40 #endif
;      41 
;      42 // This flag is set on USART Receiver buffer overflow
;      43 bit rx_buffer_overflow0;
;      44 
;      45 // USART Receiver interrupt service routine
;      46 interrupt [USART_RXC] void usart_rx_isr(void)
;      47 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;      48 char status,data;
;      49 status=UCSR0A;
	RCALL __SAVELOCR2
;	status -> R16
;	data -> R17
	LDS  R16,192
;      50 data=UDR0;
	LDS  R17,198
;      51 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BREQ PC+2
	RJMP _0x3
;      52    {
;      53    rx_buffer0[rx_wr_index0]=data;
	MOV  R26,R10
	LDI  R27,0
	SUBI R26,LOW(-_rx_buffer0)
	SBCI R27,HIGH(-_rx_buffer0)
	ST   X,R17
;      54    if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	INC  R10
	LDI  R30,LOW(8)
	CP   R30,R10
	BREQ PC+2
	RJMP _0x4
	CLR  R10
;      55    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R12
	LDI  R30,LOW(8)
	CP   R30,R12
	BREQ PC+2
	RJMP _0x5
;      56       {
;      57       rx_counter0=0;
	CLR  R12
;      58       rx_buffer_overflow0=1;
	SBI  0x1E,0
;      59       };
_0x5:
;      60    };
_0x3:
;      61 }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;      62 
;      63 #ifndef _DEBUG_TERMINAL_IO_
;      64 // Get a character from the USART Receiver buffer
;      65 #define _ALTERNATE_GETCHAR_
;      66 #pragma used+
;      67 char getchar(void)
;      68 {
_getchar:
;      69 char data;
;      70 while (rx_counter0==0);
	ST   -Y,R16
;	data -> R16
_0x6:
	TST  R12
	BREQ PC+2
	RJMP _0x8
	RJMP _0x6
_0x8:
;      71 data=rx_buffer0[rx_rd_index0];
	MOV  R30,R11
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R16,Z
;      72 if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	INC  R11
	LDI  R30,LOW(8)
	CP   R30,R11
	BREQ PC+2
	RJMP _0x9
	CLR  R11
;      73 #asm("cli")
_0x9:
	cli
;      74 --rx_counter0;
	DEC  R12
;      75 #asm("sei")
	sei
;      76 return data;
	MOV  R30,R16
	LD   R16,Y+
	RET
;      77 }
;      78 #pragma used-
;      79 #endif
;      80 
;      81 // USART Transmitter buffer
;      82 #define TX_BUFFER_SIZE0 8
;      83 char tx_buffer0[TX_BUFFER_SIZE0];

	.DSEG
_tx_buffer0:
	.BYTE 0x8
;      84 
;      85 #if TX_BUFFER_SIZE0<256
;      86 unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
_tx_counter0:
	.BYTE 0x1
;      87 #else
;      88 unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;      89 #endif
;      90 
;      91 // USART Transmitter interrupt service routine
;      92 interrupt [USART_TXC] void usart_tx_isr(void)
;      93 {

	.CSEG
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      94 if (tx_counter0)
	RCALL SUBOPT_0x1
	CPI  R30,0
	BRNE PC+2
	RJMP _0xA
;      95    {
;      96    --tx_counter0;
	RCALL SUBOPT_0x1
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
;      97    UDR0=tx_buffer0[tx_rd_index0];
	MOV  R30,R14
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	STS  198,R30
;      98    if (++tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	INC  R14
	LDI  R30,LOW(8)
	CP   R30,R14
	BREQ PC+2
	RJMP _0xB
	CLR  R14
;      99    };
_0xB:
_0xA:
;     100 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     101 
;     102 #ifndef _DEBUG_TERMINAL_IO_
;     103 // Write a character to the USART Transmitter buffer
;     104 #define _ALTERNATE_PUTCHAR_
;     105 #pragma used+
;     106 void putchar(char c)
;     107 {
_putchar:
;     108 while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0xC:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x8)
	BREQ PC+2
	RJMP _0xE
	RJMP _0xC
_0xE:
;     109 #asm("cli")
	cli
;     110 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	RCALL SUBOPT_0x1
	CPI  R30,0
	BREQ PC+2
	RJMP _0x10
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BRNE PC+2
	RJMP _0x10
	RJMP _0xF
_0x10:
;     111    {
;     112    tx_buffer0[tx_wr_index0]=c;
	MOV  R30,R13
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
;     113    if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	INC  R13
	LDI  R30,LOW(8)
	CP   R30,R13
	BREQ PC+2
	RJMP _0x12
	CLR  R13
;     114    ++tx_counter0;
_0x12:
	RCALL SUBOPT_0x1
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
;     115    }
;     116 else
	RJMP _0x13
_0xF:
;     117    UDR0=c;
	LD   R30,Y
	STS  198,R30
;     118 #asm("sei")
_0x13:
	sei
;     119 }
	ADIW R28,1
	RET
;     120 #pragma used-
;     121 #endif
;     122 // Timer 1 overflow interrupt service routine
;     123 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     124 {
_timer1_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     125 // Reinitialize Timer 1 value
;     126 TCNT1H=0xFE;
	RCALL SUBOPT_0x2
;     127 TCNT1L=0x79;
;     128 //TIMSK1=0x00;
;     129 // Place your code here 
;     130 timer_count_info++; 
	INC  R3
;     131 timer_count_info1++; 
	INC  R2
;     132 //  putchar('a');
;     133 //  PORTD.2=1;
;     134 //    delay_ms(100);
;     135 //    PORTD.2=0;
;     136   if (timer_count_info==800)
	MOV  R30,R3
	RCALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x14
;     137   { timer_count_info=0;              
	CLR  R3
;     138    attendance1=0;
	RCALL SUBOPT_0x4
;     139    attendance2=0;
;     140    attendance3=0;
;     141    attendance4=0;
;     142    } 
;     143    
;     144    if (timer_count_info1==800)
_0x14:
	MOV  R30,R2
	RCALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x15
;     145   { timer_count_info1=0;              
	CLR  R2
;     146    attendance1=0;
	RCALL SUBOPT_0x4
;     147    attendance2=0;
;     148    attendance3=0;
;     149    attendance4=0;
;     150    }
;     151  
;     152  // TIMSK1=0x01;
;     153 }
_0x15:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     154 // Standard Input/Output functions
;     155 #include <stdio.h>
;     156 
;     157 // Declare your global variables here
;     158 
;     159 void main(void)
;     160 {
_main:
;     161 // Declare your local variables here
;     162  unsigned char present[]="PRESENT",absent[]="ABSENT ";
;     163 // Crystal Oscillator division factor: 1
;     164 #pragma optsize-
;     165 CLKPR=0x80;
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x16*2)
	LDI  R31,HIGH(_0x16*2)
	RCALL __INITLOCB
;	present -> Y+8
;	absent -> Y+0
	LDI  R30,LOW(128)
	STS  97,R30
;     166 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
;     167 #ifdef _OPTIMIZE_SIZE_
;     168 #pragma optsize+
;     169 #endif
;     170 
;     171 // Input/Output Ports initialization
;     172 // Port B initialization
;     173 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     174 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     175 PORTB=0x00;
	OUT  0x5,R30
;     176 DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x4,R30
;     177 
;     178 // Port C initialization
;     179 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     180 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     181 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
;     182 DDRC=0x00;
	OUT  0x7,R30
;     183 
;     184 // Port D initialization
;     185 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     186 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     187 PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0xB,R30
;     188 DDRD=0xf0;
	LDI  R30,LOW(240)
	OUT  0xA,R30
;     189 
;     190 // Timer/Counter 0 initialization
;     191 // Clock source: System Clock
;     192 // Clock value: Timer 0 Stopped
;     193 // Mode: Normal top=FFh
;     194 // OC0A output: Disconnected
;     195 // OC0B output: Disconnected
;     196 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;     197 TCCR0B=0x00;
	OUT  0x25,R30
;     198 TCNT0=0x00;
	OUT  0x26,R30
;     199 OCR0A=0x00;
	OUT  0x27,R30
;     200 OCR0B=0x00;
	OUT  0x28,R30
;     201 
;     202 // Timer/Counter 1 initialization
;     203 // Clock source: System Clock
;     204 // Clock value: 3.906 kHz
;     205 // Mode: Normal top=FFFFh
;     206 // OC1A output: Discon.
;     207 // OC1B output: Discon.
;     208 // Noise Canceler: Off
;     209 // Input Capture on Falling Edge
;     210 // Timer 1 Overflow Interrupt: On
;     211 // Input Capture Interrupt: Off
;     212 // Compare A Match Interrupt: Off
;     213 // Compare B Match Interrupt: Off
;     214 TCCR1A=0x00;
	STS  128,R30
;     215 TCCR1B=0x05;
	LDI  R30,LOW(5)
	STS  129,R30
;     216 TCNT1H=0xFE;
	RCALL SUBOPT_0x2
;     217 TCNT1L=0x79;
;     218 ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
;     219 ICR1L=0x00;
	STS  134,R30
;     220 OCR1AH=0x00;
	STS  137,R30
;     221 OCR1AL=0x00;
	STS  136,R30
;     222 OCR1BH=0x00;
	STS  139,R30
;     223 OCR1BL=0x00;
	STS  138,R30
;     224 
;     225 // Timer/Counter 2 initialization
;     226 // Clock source: System Clock
;     227 // Clock value: Timer 2 Stopped
;     228 // Mode: Normal top=FFh
;     229 // OC2A output: Disconnected
;     230 // OC2B output: Disconnected
;     231 ASSR=0x00;
	STS  182,R30
;     232 TCCR2A=0x00;
	STS  176,R30
;     233 TCCR2B=0x00;
	STS  177,R30
;     234 TCNT2=0x00;
	STS  178,R30
;     235 OCR2A=0x00;
	STS  179,R30
;     236 OCR2B=0x00;
	STS  180,R30
;     237 
;     238 
;     239 
;     240 // Timer/Counter 0 Interrupt(s) initialization
;     241 TIMSK0=0x00;
	STS  110,R30
;     242 // Timer/Counter 1 Interrupt(s) initialization
;     243 TIMSK1=0x00;
	RCALL SUBOPT_0x5
;     244 // Timer/Counter 2 Interrupt(s) initialization
;     245 TIMSK2=0x00;
	LDI  R30,LOW(0)
	STS  112,R30
;     246 
;     247 // USART initialization
;     248 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     249 // USART Receiver: On
;     250 // USART Transmitter: On
;     251 // USART0 Mode: Asynchronous
;     252 // USART Baud rate: 9600
;     253 UCSR0A=0x00;
	STS  192,R30
;     254 UCSR0B=0xD8;
	LDI  R30,LOW(216)
	STS  193,R30
;     255 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
;     256 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
;     257 UBRR0L=0x19;
	LDI  R30,LOW(25)
	STS  196,R30
;     258 
;     259 
;     260 
;     261 
;     262 // Global enable interrupts
;     263 #asm("sei")
	sei
;     264 lcd_init();
	RCALL _lcd_init
;     265  clear_lcd();
	RCALL SUBOPT_0x6
;     266  lcd_cmd(0x80);
;     267  lcd_puts(msg);
	LDI  R30,LOW(_msg)
	LDI  R31,HIGH(_msg)
	RCALL SUBOPT_0x7
;     268  //delay_ms(1000);
;     269  lcd_cmd(0xC0) ;
	RCALL SUBOPT_0x8
;     270  lcd_puts(msg1);
	LDI  R30,LOW(_msg1)
	LDI  R31,HIGH(_msg1)
	RCALL SUBOPT_0x7
;     271  delay_ms(3000); 
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RCALL SUBOPT_0x9
;     272   clear_lcd();
	RCALL SUBOPT_0x6
;     273    lcd_cmd(0x80) ;
;     274    
;     275 while (1)
_0x17:
;     276       {
;     277       // Place your code here
;     278        if(rx_counter0>0)
	LDI  R30,LOW(0)
	CP   R30,R12
	BRLO PC+2
	RJMP _0x1A
;     279          {
;     280          code = getchar();
	RCALL _getchar
	MOV  R9,R30
;     281          putchar(code);
	ST   -Y,R9
	RCALL _putchar
;     282       if(code=='@')
	LDI  R30,LOW(64)
	CP   R30,R9
	BREQ PC+2
	RJMP _0x1B
;     283       {  code=0;
	CLR  R9
;     284       attendance1=1;  
	LDI  R30,LOW(1)
	MOV  R4,R30
;     285       timer_count_info=0;
	CLR  R3
;     286       TCNT1H=0xFE;
	RCALL SUBOPT_0x2
;     287       TCNT1L=0x79;
;     288       TIMSK1=0x01;
	RCALL SUBOPT_0xA
;     289       } 
;     290       
;     291        if(code=='#')
_0x1B:
	LDI  R30,LOW(35)
	CP   R30,R9
	BREQ PC+2
	RJMP _0x1C
;     292       { code=0;
	CLR  R9
;     293       attendance2=1;
	LDI  R30,LOW(1)
	MOV  R5,R30
;     294       timer_count_info1=0; 
	CLR  R2
;     295       TCNT1H=0xFE;
	RCALL SUBOPT_0x2
;     296       TCNT1L=0x79;
;     297       TIMSK1=0x01;
	RCALL SUBOPT_0xA
;     298       }  
;     299        if(code=='$')
_0x1C:
	LDI  R30,LOW(36)
	CP   R30,R9
	BREQ PC+2
	RJMP _0x1D
;     300       {
;     301       attendance3=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
;     302       timer_count_info=0;
	CLR  R3
;     303        TIMSK1=0x01;
	RCALL SUBOPT_0xA
;     304        TCNT1H=0xFE;
	RCALL SUBOPT_0x2
;     305        TCNT1L=0x79;
;     306       } 
;     307       
;     308        if(code=='*')
_0x1D:
	LDI  R30,LOW(42)
	CP   R30,R9
	BREQ PC+2
	RJMP _0x1E
;     309       {
;     310       attendance4=1; 
	LDI  R30,LOW(1)
	MOV  R7,R30
;     311       timer_count_info=0;
	CLR  R3
;     312       TIMSK1=0x01;
	RCALL SUBOPT_0xA
;     313       TCNT1H=0xFE;
	RCALL SUBOPT_0x2
;     314 TCNT1L=0x79;
;     315       }
;     316                          
;     317          }
_0x1E:
;     318        
;     319 //          lcd_cmd(0x80) ;
;     320 //          lcd_puts(msg2);
;     321 //          lcd_cmd(0xC0) ;
;     322 //          lcd_puts(msg3);
;     323         // if(display_atd==1)
;     324          {
_0x1A:
;     325             display_atd=0;
	CLR  R8
;     326            if(attendance1==1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BREQ PC+2
	RJMP _0x1F
;     327            {
;     328              lcd_cmd(0x80) ;
	RCALL SUBOPT_0xB
;     329          lcd_puts(r);
;     330           lcd_data(' ',0);
	RCALL SUBOPT_0xC
;     331          lcd_data(':',0); 
	RCALL SUBOPT_0xD
;     332            lcd_data(' ',0);
;     333            lcd_puts(present);
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x7
;     334            
;     335            }
;     336            else
	RJMP _0x20
_0x1F:
;     337          {
;     338              lcd_cmd(0x80) ;
	RCALL SUBOPT_0xB
;     339          lcd_puts(r);
;     340           lcd_data(' ',0);
	RCALL SUBOPT_0xC
;     341          lcd_data(':',0); 
	RCALL SUBOPT_0xD
;     342            lcd_data(' ',0);
;     343            lcd_puts(absent);
	MOVW R30,R28
	RCALL SUBOPT_0x7
;     344            
;     345            } 
_0x20:
;     346            if(attendance2==1)
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x21
;     347            {
;     348              lcd_cmd(0xc0) ;
	RCALL SUBOPT_0x8
;     349          lcd_puts(b);
	LDI  R30,LOW(_b)
	LDI  R31,HIGH(_b)
	RCALL SUBOPT_0x7
;     350           lcd_data(' ',0);
	RCALL SUBOPT_0xC
;     351          lcd_data(':',0); 
	RCALL SUBOPT_0xD
;     352            lcd_data(' ',0);
;     353            lcd_puts(present);
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x7
;     354            
;     355            }
;     356            else
	RJMP _0x22
_0x21:
;     357          {
;     358              lcd_cmd(0xc0) ;
	RCALL SUBOPT_0x8
;     359          lcd_puts(b);
	LDI  R30,LOW(_b)
	LDI  R31,HIGH(_b)
	RCALL SUBOPT_0x7
;     360           lcd_data(' ',0);
	RCALL SUBOPT_0xC
;     361          lcd_data(':',0); 
	RCALL SUBOPT_0xD
;     362            lcd_data(' ',0);
;     363            lcd_puts(absent);
	MOVW R30,R28
	RCALL SUBOPT_0x7
;     364            
;     365            }
_0x22:
;     366           //  delay_ms(3000);
;     367          // clear_lcd();
;     368          
;     369          }
;     370          
;     371         
;     372       };
	RJMP _0x17
_0x19:
;     373 } 
	ADIW R28,16
_0x23:
	RJMP _0x23
;     374 
;     375 
;     376  #include <mega48.h>         
;     377 //#include <prototype.h> 
;     378 #include <lcd16x1.h> 
;     379 #include <stdlib.h>
;     380 #include <stdio.h>  
;     381 //#include<prototype.h>     
;     382 //#define INT0_PIN PIND.2         //int0 pin PD.2
;     383 //#define INT1_PIN PIND.3         //int1 pin PD.3
;     384 
;     385 #define RS PORTB.0
;     386 #define RW PORTB.1    //lcd defines
;     387 #define EN PORTB.2  
;     388                         
;     389 
;     390 
;     391 
;     392                
;     393 
;     394 //function to clear the lcd & start from first row first column onwards       
;     395 void clear_lcd(void)
;     396 {
_clear_lcd:
;     397        lcd_cmd(0x01);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xE
;     398        //lcd_cmd(0x80);   //clear screen n start from fist line first column
;     399        lcd_cmd(0x06);     //incremental cursor
	LDI  R30,LOW(6)
	RCALL SUBOPT_0xE
;     400 }
	RET
;     401 
;     402 //lcd initialization function for 4 datalines    
;     403  void lcd_init(void)
;     404  {
_lcd_init:
;     405         delay_ms(15);               //startup delay
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RCALL SUBOPT_0x9
;     406                   lcd_cmd(0x03);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xE
;     407         delay_ms(5);     
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x9
;     408                   lcd_cmd(0x03);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xE
;     409         delay_us(160);     
	RCALL SUBOPT_0xF
;     410                   lcd_cmd(0x03);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xE
;     411         delay_us(160);            
	RCALL SUBOPT_0xF
;     412                   lcd_cmd(0x02);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xE
;     413        delay_us(160);  
	RCALL SUBOPT_0xF
;     414                   lcd_cmd(0x28);         //4 bit data , 5*7, 2 line..   //the abouve cmds are necessary
	LDI  R30,LOW(40)
	RCALL SUBOPT_0xE
;     415        delay_ms(100);                    
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x9
;     416                   lcd_cmd(0x60);         // set CGRAM addr
	LDI  R30,LOW(96)
	RCALL SUBOPT_0xE
;     417        delay_ms(100);           
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x9
;     418          lcd_cmd(0x0C); 
	LDI  R30,LOW(12)
	RCALL SUBOPT_0xE
;     419        delay_ms(1);                          
	RCALL SUBOPT_0x10
;     420                   lcd_cmd(0x06);       //increment cursor no shift
	LDI  R30,LOW(6)
	RCALL SUBOPT_0xE
;     421        delay_ms(1);           
	RCALL SUBOPT_0x10
;     422                   lcd_cmd(0x90);       // 1st column 1st char
	LDI  R30,LOW(144)
	RCALL SUBOPT_0xE
;     423         delay_ms(1);                                        
	RCALL SUBOPT_0x10
;     424                   lcd_cmd(0x01);       //clear lcd
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xE
;     425         delay_ms(2);                              
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x9
;     426   }                                 
	RET
;     427 
;     428 //to send lcd commands
;     429 void lcd_cmd(unsigned char inst){
_lcd_cmd:
;     430 
;     431        unsigned char lsb=0,msb=0;
;     432         lsb=inst&0x0F;        //split msb n lsb nibbles
	RCALL __SAVELOCR2
;	inst -> Y+2
;	lsb -> R16
;	msb -> R17
	LDI  R16,0
	LDI  R17,0
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	MOV  R16,R30
;     433         msb=inst>>4; 
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,0xF
	MOV  R17,R30
;     434         msb&=0x0F;   
	ANDI R17,LOW(15)
;     435         lsb=lsb&0X0F;
	ANDI R16,LOW(15)
;     436         msb=msb<<4;
	SWAP R17
	ANDI R17,0xF0
;     437         lsb=lsb<<4;
	SWAP R16
	ANDI R16,0xF0
;     438         delay_us(500);            //busy check duration       500
	__DELAY_USW 500
;     439         RS=0;
	CBI  0x5,0
;     440         RW=0;    
	RCALL SUBOPT_0x11
;     441         EN=1;     
;     442         PORTD&=0x0F; 
;     443         PORTD|=msb; 
;     444         delay_us(5);         //6 nops       changed from 10u to 5u
;     445         EN=0;
;     446         delay_us(5);         //6 nops
;     447         EN=1;
;     448         PORTD&=0x0F;        //sending lsb now       
;     449         PORTD|=lsb; 
;     450         delay_us(5);         //6 nops
;     451         EN=0;
;     452      }   
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;     453                
;     454 //function to send data to lcd
;     455  void lcd_data(unsigned char data1,unsigned char type)
;     456  {      
_lcd_data:
;     457       unsigned char lsbc,msbc,temp,a; 
;     458       type=a;
	RCALL __SAVELOCR4
;	data1 -> Y+5
;	type -> Y+4
;	lsbc -> R16
;	msbc -> R17
;	temp -> R18
;	a -> R19
	STD  Y+4,R19
;     459       temp=0;lsbc=0;msbc=0;
	LDI  R18,LOW(0)
	LDI  R16,LOW(0)
	LDI  R17,LOW(0)
;     460       msbc=data1&0xF0;      //msb n lsb split
	LDD  R30,Y+5
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
;     461       lsbc=data1<<4;
	LDD  R30,Y+5
	SWAP R30
	ANDI R30,0xF0
	MOV  R16,R30
;     462       delay_us(600);            //busy check duration       prev 600
	__DELAY_USW 600
;     463       RS=1;
	SBI  0x5,0
;     464       RW=0;     
	RCALL SUBOPT_0x11
;     465       EN=1;
;     466       PORTD&=0x0F; 
;     467       PORTD|=msbc;         // this being moved to the lsbbits of port instead of msb...
;     468       delay_us(5);        
;     469       EN=0 ;                   
;     470       delay_us(5);        
;     471       EN=1;
;     472       PORTD&=0x0F;
;     473       PORTD|=lsbc;        
;     474       delay_us(5);        
;     475       EN=0;     
;     476 } 
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
;     477               
;     478 
;     479 //function to put string onto lcd     
;     480 void lcd_puts(unsigned char *str)
;     481 {
_lcd_puts:
;     482   while(*str !='\0') 
;	*str -> Y+0
_0x24:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BRNE PC+2
	RJMP _0x26
;     483          {
;     484            lcd_data(*str,1);
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_data
;     485              *str++;
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
;     486           }
	RJMP _0x24
_0x26:
;     487 }
	ADIW R28,2
	RET
;     488 


;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDS  R30,_tx_counter0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(254)
	STS  133,R30
	LDI  R30,LOW(121)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x320)
	LDI  R26,HIGH(0x320)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CLR  R4
	CLR  R5
	CLR  R6
	CLR  R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	STS  111,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL _clear_lcd
	LDI  R30,LOW(128)
	ST   -Y,R30
	RJMP _lcd_cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(192)
	ST   -Y,R30
	RJMP _lcd_cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(128)
	ST   -Y,R30
	RCALL _lcd_cmd
	LDI  R30,LOW(_r)
	LDI  R31,HIGH(_r)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _lcd_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(58)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _lcd_data
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	ST   -Y,R30
	RJMP _lcd_cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	__DELAY_USB 213
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x11:
	CBI  0x5,1
	SBI  0x5,2
	IN   R30,0xB
	ANDI R30,LOW(0xF)
	OUT  0xB,R30
	IN   R30,0xB
	OR   R30,R17
	OUT  0xB,R30
	__DELAY_USB 7
	CBI  0x5,2
	__DELAY_USB 7
	SBI  0x5,2
	IN   R30,0xB
	ANDI R30,LOW(0xF)
	OUT  0xB,R30
	IN   R30,0xB
	OR   R30,R16
	OUT  0xB,R30
	__DELAY_USB 7
	CBI  0x5,2
	RET

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x3E8
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

__INITLOCB:
__INITLOCW:
	ADD R26,R28
	ADC R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
