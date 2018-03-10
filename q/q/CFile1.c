#include "main.h"
int main(void)
{
	USART_Init (16);
	I2C_Init();
	ADC_Init();
	Registers();
	while(1)
	{
		 Calib();
		 _delay_ms(10);
         uint16_t T = readTempC();
         Convert_T(T);
         USART_Transmit(0x09);
		 int32_t P=readPress();
		 Convert_P(P);
		 USART_Transmit(0x09);
		 int32_t H=readHum();
		 Convert_H(H);
		 USART_Transmit(0x09);
		 Rain();
		 USART_Transmit(0x09);
		 _delay_ms(3000);
	}
}