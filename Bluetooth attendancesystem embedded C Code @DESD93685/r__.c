#include <mega48.h>
#include <string.h>
#include <delay.h>
#include <lcd16x1.h> 
#define button PIND.2
#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
unsigned char timer_count_info1=0,timer_count_info;
#define ADC_VREF_TYPE 0x00
unsigned char attendance1=0,attendance2=0,attendance3=0,attendance4=0,display_atd,code;

 
unsigned char card[8],msg[]="WELCOME TO CDAC",msg1[]="ATTENDANCE V1.0",msg2[]="  BLUETOOTH  ",msg3[]="  ATTENDANCE  ";

unsigned char r[]="Ram",a[]="Raj",b[]="Ved",c[]="Sam",d[]="Om";





// USART Receiver buffer
#define RX_BUFFER_SIZE0 8
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0<256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow0;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0]=data;
   if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0];
if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE0 8
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0<256
unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
#else
unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0];
   if (++tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0]=c;
   if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}
#pragma used-
#endif
// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer 1 value
TCNT1H=0xFE;
TCNT1L=0x79;
//TIMSK1=0x00;
// Place your code here 
timer_count_info++; 
timer_count_info1++; 
//  putchar('a');
//  PORTD.2=1;
//    delay_ms(100);
//    PORTD.2=0;
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
 
 // TIMSK1=0x01;
}
// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here

void main(void)
{
// Declare your local variables here
 unsigned char present[]="PRESENT",absent[]="ABSENT ";
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x07;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x04;
DDRD=0xf0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 3.906 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x05;
TCNT1H=0xFE;
TCNT1L=0x79;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;



// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;
// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x00;
// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART0 Mode: Asynchronous
// USART Baud rate: 9600
UCSR0A=0x00;
UCSR0B=0xD8;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x19;




// Global enable interrupts
#asm("sei")
lcd_init();
 clear_lcd();
 lcd_cmd(0x80);
 lcd_puts(msg);
 //delay_ms(1000);
 lcd_cmd(0xC0) ;
 lcd_puts(msg1);
 delay_ms(3000); 
  clear_lcd();
   lcd_cmd(0x80) ;
   
while (1)
      {
      // Place your code here
       if(rx_counter0>0)
         {
         code = getchar();
         putchar(code);
      if(code=='@')
      {  code=0;
      attendance1=1;  
      timer_count_info=0;
      TCNT1H=0xFE;
      TCNT1L=0x79;
      TIMSK1=0x01;
      } 
      
       if(code=='#')
      { code=0;
      attendance2=1;
      timer_count_info1=0; 
      TCNT1H=0xFE;
      TCNT1L=0x79;
      TIMSK1=0x01;
      }  
       if(code=='$')
      {
      attendance3=1;
      timer_count_info=0;
       TIMSK1=0x01;
       TCNT1H=0xFE;
       TCNT1L=0x79;
      } 
      
       if(code=='*')
      {
      attendance4=1; 
      timer_count_info=0;
      TIMSK1=0x01;
      TCNT1H=0xFE;
TCNT1L=0x79;
      }
                         
         }
       
//          lcd_cmd(0x80) ;
//          lcd_puts(msg2);
//          lcd_cmd(0xC0) ;
//          lcd_puts(msg3);
        // if(display_atd==1)
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
          //  delay_ms(3000);
         // clear_lcd();
         
         }
         
        
      };
} 


 #include <mega48.h>         
//#include <prototype.h> 
#include <lcd16x1.h> 
#include <stdlib.h>
#include <stdio.h>  
//#include<prototype.h>     
//#define INT0_PIN PIND.2         //int0 pin PD.2
//#define INT1_PIN PIND.3         //int1 pin PD.3

#define RS PORTB.0
#define RW PORTB.1    //lcd defines
#define EN PORTB.2  
                        



               

//function to clear the lcd & start from first row first column onwards       
void clear_lcd(void)
{
       lcd_cmd(0x01);
       //lcd_cmd(0x80);   //clear screen n start from fist line first column
       lcd_cmd(0x06);     //incremental cursor
}

//lcd initialization function for 4 datalines    
 void lcd_init(void)
 {
        delay_ms(15);               //startup delay
                  lcd_cmd(0x03);
        delay_ms(5);     
                  lcd_cmd(0x03);
        delay_us(160);     
                  lcd_cmd(0x03);
        delay_us(160);            
                  lcd_cmd(0x02);
       delay_us(160);  
                  lcd_cmd(0x28);         //4 bit data , 5*7, 2 line..   //the abouve cmds are necessary
       delay_ms(100);                    
                  lcd_cmd(0x60);         // set CGRAM addr
       delay_ms(100);           
         lcd_cmd(0x0C); 
       delay_ms(1);                          
                  lcd_cmd(0x06);       //increment cursor no shift
       delay_ms(1);           
                  lcd_cmd(0x90);       // 1st column 1st char
        delay_ms(1);                                        
                  lcd_cmd(0x01);       //clear lcd
        delay_ms(2);                              
  }                                 

//to send lcd commands
void lcd_cmd(unsigned char inst){

       unsigned char lsb=0,msb=0;
        lsb=inst&0x0F;        //split msb n lsb nibbles
        msb=inst>>4; 
        msb&=0x0F;   
        lsb=lsb&0X0F;
        msb=msb<<4;
        lsb=lsb<<4;
        delay_us(500);            //busy check duration       500
        RS=0;
        RW=0;    
        EN=1;     
        PORTD&=0x0F; 
        PORTD|=msb; 
        delay_us(5);         //6 nops       changed from 10u to 5u
        EN=0;
        delay_us(5);         //6 nops
        EN=1;
        PORTD&=0x0F;        //sending lsb now       
        PORTD|=lsb; 
        delay_us(5);         //6 nops
        EN=0;
     }   
               
//function to send data to lcd
 void lcd_data(unsigned char data1,unsigned char type)
 {      
      unsigned char lsbc,msbc,temp,a; 
      type=a;
      temp=0;lsbc=0;msbc=0;
      msbc=data1&0xF0;      //msb n lsb split
      lsbc=data1<<4;
      delay_us(600);            //busy check duration       prev 600
      RS=1;
      RW=0;     
      EN=1;
      PORTD&=0x0F; 
      PORTD|=msbc;         // this being moved to the lsbbits of port instead of msb...
      delay_us(5);        
      EN=0 ;                   
      delay_us(5);        
      EN=1;
      PORTD&=0x0F;
      PORTD|=lsbc;        
      delay_us(5);        
      EN=0;     
} 
              

//function to put string onto lcd     
void lcd_puts(unsigned char *str)
{
  while(*str !='\0') 
         {
           lcd_data(*str,1);
             *str++;
          }
}

