
#pragma used+
sfrb PINB=3;
sfrb DDRB=4;
sfrb PORTB=5;
sfrb PINC=6;
sfrb DDRC=7;
sfrb PORTC=8;
sfrb PIND=9;
sfrb DDRD=0xa;
sfrb PORTD=0xb;
sfrb TIFR0=0x15;
sfrb TIFR1=0x16;
sfrb TIFR2=0x17;
sfrb PCIFR=0x1b;
sfrb EIFR=0x1c;
sfrb EIMSK=0x1d;
sfrb GPIOR0=0x1e;
sfrb EECR=0x1f;
sfrb EEDR=0x20;
sfrb EEARL=0x21;
sfrb EEARH=0x22;
sfrw EEAR=0x21;   
sfrb GTCCR=0x23;
sfrb TCCR0A=0x24;
sfrb TCCR0B=0x25;
sfrb TCNT0=0x26;
sfrb OCR0A=0x27;
sfrb OCR0B=0x28;
sfrb GPIOR1=0x2a;
sfrb GPIOR2=0x2b;
sfrb SPCR=0x2c;
sfrb SPSR=0x2d;
sfrb SPDR=0x2e;
sfrb ACSR=0x30;
sfrb SMCR=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb SPMCSR=0x37;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
#endasm

#pragma used+

char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
flash char *strchrf(flash char *str,char c); 
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned char strlcpy(char *dest,char *src,unsigned char n);	
unsigned char strlcpyf(char *dest,char flash *src,unsigned char n); 
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
char *strrchr(char *str,char c);
flash char *strrchrf(flash char *str,char c); 
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
char *strtok(char *str1,char flash *str2);

unsigned int strlen(char *str);
void *memccpy(void *dest,void *src,char c,unsigned n);
void *memchr(void *buf,unsigned char c,unsigned n);
signed char memcmp(void *buf1,void *buf2,unsigned n);
signed char memcmpf(void *buf1,void flash *buf2,unsigned n);
void *memcpy(void *dest,void *src,unsigned n);
void *memcpyf(void *dest,void flash *src,unsigned n);
void *memmove(void *dest,void *src,unsigned n);
void *memset(void *buf,unsigned char c,unsigned n);
unsigned int strcspn(char *str,char *set);
unsigned int strcspnf(char *str,char flash *set);
int strpos(char *str,char c);
int strrpos(char *str,char c);
unsigned int strspn(char *str,char *set);
unsigned int strspnf(char *str,char flash *set);

#pragma used-
#pragma library string.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

void lcd_init(void);
void lcd_puts(unsigned char *str);
void lcdLoadCustomChar(void);
void lcd_data(unsigned char data1,unsigned char type);
void clear_lcd(void);

void cmd(unsigned char inst);
void data_lcd(unsigned char data1);
void lcd_goto(unsigned char line , unsigned char colm);
void lcd_cmd(unsigned char inst);      
void cal_ascii(unsigned int value);

unsigned char timer_count_info1=0,timer_count_info;
unsigned char attendance1=0,attendance2=0,attendance3=0,attendance4=0,display_atd,code;

unsigned char card[8],msg[]="WELCOME TO CDAC",msg1[]="ATTENDANCE V1.0",msg2[]="  BLUETOOTH  ",msg3[]="  ATTENDANCE  ";

unsigned char r[]="Ram",a[]="Raj",b[]="Ved",c[]="Sam",d[]="Om";

char rx_buffer0[8];

unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;

bit rx_buffer_overflow0;

interrupt [19] void usart_rx_isr(void)
{
char status,data;
status=(*(unsigned char *) 0xc0);
data=(*(unsigned char *) 0xc6);
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer0[rx_wr_index0]=data;
if (++rx_wr_index0 == 8) rx_wr_index0=0;
if (++rx_counter0 == 8)
{
rx_counter0=0;
rx_buffer_overflow0=1;
};
};
}

#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0];
if (++rx_rd_index0 == 8) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-

char tx_buffer0[8];

unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;

interrupt [21] void usart_tx_isr(void)
{
if (tx_counter0)
{
--tx_counter0;
(*(unsigned char *) 0xc6)=tx_buffer0[tx_rd_index0];
if (++tx_rd_index0 == 8) tx_rd_index0=0;
};
}

#pragma used+
void putchar(char c)
{
while (tx_counter0 == 8);
#asm("cli")
if (tx_counter0 || (((*(unsigned char *) 0xc0) & (1<<5))==0))
{
tx_buffer0[tx_wr_index0]=c;
if (++tx_wr_index0 == 8) tx_wr_index0=0;
++tx_counter0;
}
else
(*(unsigned char *) 0xc6)=c;
#asm("sei")
}
#pragma used-
interrupt [14] void timer1_ovf_isr(void)
{
(*(unsigned char *) 0x85)=0xFE;
(*(unsigned char *) 0x84)=0x79;
timer_count_info++; 
timer_count_info1++; 
if (timer_count_info==800)
{ timer_count_info=0;              
attendance1=0;
attendance2=0;
attendance3=0;
attendance4=0;
} 

if (timer_count_info1==800)
{ timer_count_info1=0;              
attendance1=0;
attendance2=0;
attendance3=0;
attendance4=0;
}

}

typedef char *va_list;

#pragma used+

char getchar(void);

void putchar(char c);

void puts(char *str);
void putsf(char flash *str);
int printf(char flash *fmtstr,...);
int sprintf(char *str, char flash *fmtstr,...);
int vprintf(char flash * fmtstr, va_list argptr);
int vsprintf(char *str, char flash * fmtstr, va_list argptr);

char *gets(char *str,unsigned int len);
int snprintf(char *str, unsigned int size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned int size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

void main(void)
{
unsigned char present[]="PRESENT",absent[]="ABSENT ";
#pragma optsize-
(*(unsigned char *) 0x61)=0x80;
(*(unsigned char *) 0x61)=0x00;
#pragma optsize+

PORTB=0x00;
DDRB=0x07;

PORTC=0x00;
DDRC=0x00;

PORTD=0x04;
DDRD=0xf0;

TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

(*(unsigned char *) 0x80)=0x00;
(*(unsigned char *) 0x81)=0x05;
(*(unsigned char *) 0x85)=0xFE;
(*(unsigned char *) 0x84)=0x79;
(*(unsigned char *) 0x87)=0x00;
(*(unsigned char *) 0x86)=0x00;
(*(unsigned char *) 0x89)=0x00;
(*(unsigned char *) 0x88)=0x00;
(*(unsigned char *) 0x8b)=0x00;
(*(unsigned char *) 0x8a)=0x00;

(*(unsigned char *) 0xb6)=0x00;
(*(unsigned char *) 0xb0)=0x00;
(*(unsigned char *) 0xb1)=0x00;
(*(unsigned char *) 0xb2)=0x00;
(*(unsigned char *) 0xb3)=0x00;
(*(unsigned char *) 0xb4)=0x00;

(*(unsigned char *) 0x6e)=0x00;
(*(unsigned char *) 0x6f)=0x00;
(*(unsigned char *) 0x70)=0x00;

(*(unsigned char *) 0xc0)=0x00;
(*(unsigned char *) 0xc1)=0xD8;
(*(unsigned char *) 0xc2)=0x06;
(*(unsigned char *) 0xc5)=0x00;
(*(unsigned char *) 0xc4)=0x19;

#asm("sei")
lcd_init();
clear_lcd();
lcd_cmd(0x80);
lcd_puts(msg);
lcd_cmd(0xC0) ;
lcd_puts(msg1);
delay_ms(3000); 
clear_lcd();
lcd_cmd(0x80) ;

while (1)
{
if(rx_counter0>0)
{
code = getchar();
putchar(code);
if(code=='@')
{  code=0;
attendance1=1;  
timer_count_info=0;
(*(unsigned char *) 0x85)=0xFE;
(*(unsigned char *) 0x84)=0x79;
(*(unsigned char *) 0x6f)=0x01;
} 

if(code=='#')
{ code=0;
attendance2=1;
timer_count_info1=0; 
(*(unsigned char *) 0x85)=0xFE;
(*(unsigned char *) 0x84)=0x79;
(*(unsigned char *) 0x6f)=0x01;
}  
if(code=='$')
{
attendance3=1;
timer_count_info=0;
(*(unsigned char *) 0x6f)=0x01;
(*(unsigned char *) 0x85)=0xFE;
(*(unsigned char *) 0x84)=0x79;
} 

if(code=='*')
{
attendance4=1; 
timer_count_info=0;
(*(unsigned char *) 0x6f)=0x01;
(*(unsigned char *) 0x85)=0xFE;
(*(unsigned char *) 0x84)=0x79;
}

}

{
display_atd=0;
if(attendance1==1)
{
lcd_cmd(0x80) ;
lcd_puts(r);
lcd_data(' ',0);
lcd_data(':',0); 
lcd_data(' ',0);
lcd_puts(present);

}
else
{
lcd_cmd(0x80) ;
lcd_puts(r);
lcd_data(' ',0);
lcd_data(':',0); 
lcd_data(' ',0);
lcd_puts(absent);

} 
if(attendance2==1)
{
lcd_cmd(0xc0) ;
lcd_puts(b);
lcd_data(' ',0);
lcd_data(':',0); 
lcd_data(' ',0);
lcd_puts(present);

}
else
{
lcd_cmd(0xc0) ;
lcd_puts(b);
lcd_data(' ',0);
lcd_data(':',0); 
lcd_data(' ',0);
lcd_puts(absent);

}

}

};
} 

