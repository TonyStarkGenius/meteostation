#include "Rain.h"
void Rain(void)
{
	uint16_t val;
	val=ADC_convert();
	_delay_ms(50);
	if(val>=1022)
	USART_TransmitU16(nr);
	if(val>=950&&val<1022)
	USART_Transmit32(vlr);
	if(val>=800&&val<950)
	USART_TransmitU16(lr);
	if(val>=500&&val<800)
	USART_Transmit(r);
	if(val<500)
	USART_TransmitU16(hr);
}