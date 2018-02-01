void lcd_init(void);
   void lcd_puts(unsigned char *str);
   void lcdLoadCustomChar(void);
    void lcd_data(unsigned char data1,unsigned char type);
    void clear_lcd(void);
    
     
 void cmd(unsigned char inst);
 void data_lcd(unsigned char data1);
// void string_lcd(unsigned char *str);
// void lcd_goto(unsigned char  colm, unsigned char line);
 void lcd_goto(unsigned char line , unsigned char colm);
 void lcd_cmd(unsigned char inst);      
 void cal_ascii(unsigned int value);

//#include <lcd16x1.h> 