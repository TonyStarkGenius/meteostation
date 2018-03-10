#include "ADC.h"
void ADC_Init(void)
{
	ADCSRA = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
	ADMUX =(1<<REFS0);
}
uint16_t ADC_convert (void)
{
	uint8_t low,high;
	ADCSRA |= (1<<ADSC);
	while((ADCSRA & (1<<ADSC)));
	low  = ADCL;
	high = ADCH;
	return (high << 8) | low;
}