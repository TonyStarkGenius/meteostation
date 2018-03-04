#include "convert.h"
void Convert_T(uint16_t num)
{
	uint16_t out='°C';
	int var = 0;
	int del = 1000;
	int del1 = 10;
	for (int i = 0; i < 4; i++)
	{
		var = ((num / del)%del1) + 48;
		del /= 10;
        USART_Transmit(var);
        if(i==1)
           USART_Transmit(0x2E);
	}
	USART_TransmitU16(out);
}
void Convert_P(uint32_t num)
{
	uint8_t out1='h';
	uint16_t out='Pa';
	int var = 0;
	int del = 10000;
	int del1 = 10;
	for (int i = 0; i < 5; i++)
	{
		var = ((num / del)%del1) + 48;
		del /= 10;
		USART_Transmit(var);
		if(i==2)
		USART_Transmit(0x2E);
	}
	USART_Transmit(0x20);
	USART_Transmit(out1);
	USART_TransmitU16(out);
}
void Convert_H(uint32_t num)
{
	uint8_t out='%';
	int var = 0;
	int del = 1000;
	int del1 = 10;
	num/=10;
	for (int i = 0; i < 4; i++)
	{
		var = ((num / del)%del1) + 48;
		del /= 10;
		USART_Transmit(var);
		if(i==1)
		USART_Transmit(0x2E);
	}
	USART_Transmit(out);
}