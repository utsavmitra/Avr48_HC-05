
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

#pragma used+

unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
int atoi(char *str);
long int atol(char *str);
float atof(char *str);
void itoa(int n,char *str);
void ltoa(long int n,char *str);
void ftoa(float n,unsigned char decimals,char *str);
void ftoe(float n,unsigned char decimals,char *str);
void srand(int seed);
int rand(void);
void *malloc(unsigned int size);
void *calloc(unsigned int num, unsigned int size);
void *realloc(void *ptr, unsigned int size); 
void free(void *ptr);

#pragma used-
#pragma library stdlib.lib

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

void clear_lcd(void)
{
lcd_cmd(0x01);
lcd_cmd(0x06);     
}

void lcd_init(void)
{
delay_ms(15);               
lcd_cmd(0x03);
delay_ms(5);     
lcd_cmd(0x03);
delay_us(160);     
lcd_cmd(0x03);
delay_us(160);            
lcd_cmd(0x02);
delay_us(160);  
lcd_cmd(0x28);         
delay_ms(100);                    
lcd_cmd(0x60);         
delay_ms(100);           
lcd_cmd(0x0C); 
delay_ms(1);                          
lcd_cmd(0x06);       
delay_ms(1);           
lcd_cmd(0x90);       
delay_ms(1);                                        
lcd_cmd(0x01);       
delay_ms(2);                              
}                                 

void lcd_cmd(unsigned char inst){

unsigned char lsb=0,msb=0;
lsb=inst&0x0F;        
msb=inst>>4; 
msb&=0x0F;   
lsb=lsb&0X0F;
msb=msb<<4;
lsb=lsb<<4;
delay_us(500);            
PORTB.0=0;
PORTB.1    =0;    
PORTB.2  =1;     
PORTD&=0x0F; 
PORTD|=msb; 
delay_us(5);         
PORTB.2  =0;
delay_us(5);         
PORTB.2  =1;
PORTD&=0x0F;        
PORTD|=lsb; 
delay_us(5);         
PORTB.2  =0;
}   

void lcd_data(unsigned char data1,unsigned char type)
{      
unsigned char lsbc,msbc,temp,a; 
type=a;
temp=0;lsbc=0;msbc=0;
msbc=data1&0xF0;      
lsbc=data1<<4;
delay_us(600);            
PORTB.0=1;
PORTB.1    =0;     
PORTB.2  =1;
PORTD&=0x0F; 
PORTD|=msbc;         
delay_us(5);        
PORTB.2  =0 ;                   
delay_us(5);        
PORTB.2  =1;
PORTD&=0x0F;
PORTD|=lsbc;        
delay_us(5);        
PORTB.2  =0;     
} 

void lcd_puts(unsigned char *str)
{
while(*str !='\0') 
{
lcd_data(*str,1);
*str++;
}
}

