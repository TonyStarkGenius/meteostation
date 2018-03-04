#include "usart.h"
void USART_Init( unsigned int speed)
{
	UBRR0 = speed;
    UCSR0B=(1<<RXEN0)|( 1<<TXEN0); 
    UCSR0B |= (1<<RXCIE0);
	UCSR0A |= (1<<U2X0);
	UCSR0C = (1<<USBS0)|(1<<UCSZ01)|(1<<UCSZ00);
 }
 void USART_Transmit(unsigned char data)
 {
	while ( !(UCSR0A & (1<<UDRE0)) );
	UDR0=data;
 }
void USART_TransmitU16(uint16_t data)
{
    while ( !(UCSR0A & (1<<UDRE0)) );
    UDR0=(data>>8);
    while ( !(UCSR0A & (1<<UDRE0)) );
    UDR0 =data;
}
void USART_Transmit32(int32_t data)
{
	while ( !(UCSR0A & (1<<UDRE0)) );
	UDR0=data>>24;
	while ( !(UCSR0A & (1<<UDRE0)) );
	UDR0=data>>16;
	while ( !(UCSR0A & (1<<UDRE0)) );
	UDR0=data>>8;
	while ( !(UCSR0A & (1<<UDRE0)) );
	UDR0 =data;
}