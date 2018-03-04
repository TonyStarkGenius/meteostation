#ifndef USART_H_
#define USART_H_

#include "main.h"
void USART_Init(unsigned int speed);
void USART_Transmit(unsigned char data);
void USART_TransmitU16(uint16_t data);
void USART_Transmit32(int32_t data);

#endif /* USART_H_ */