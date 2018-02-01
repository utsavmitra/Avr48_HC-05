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

