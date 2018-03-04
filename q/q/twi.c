#include "twi.h"
void I2C_Init(void)
{
	TWBR=0x20;
	if(TWBR < 10)
	TWBR = 10;
	TWSR &= (~((1<<TWPS1)|(1<<TWPS0)));
}
void I2C_StartCondition(void)
{
	TWCR = (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);
	while(!(TWCR&(1<<TWINT)));
}
void I2C_StopCondition(void)
{
	TWCR = (1<<TWINT)|(1<<TWSTO)|(1<<TWEN);
}
void I2C_SendByte(unsigned char c)
{
	TWDR = c;
	TWCR = (1<<TWINT)|(1<<TWEN);
	while (!(TWCR & (1<<TWINT)));
}
void I2C_WriteByte(uint8_t address,uint8_t data)
{
	I2C_StartCondition();
	I2C_SendByte(0b11101100);
	I2C_SendByte(address);
	TWDR=(data);
	TWCR=(1<<TWINT)|(1<<TWEN);
	while(!(TWCR & (1<<TWINT)));
	I2C_StopCondition();
}
uint8_t I2C_ReadByte(uint8_t address)
{
	uint8_t data;
	I2C_StartCondition();
	I2C_SendByte(0b11101100);
	I2C_SendByte(address);
	I2C_StartCondition();
	I2C_SendByte(0b11101101);
	TWCR=(1<<TWINT)|(1<<TWEN);
	while(!(TWCR & (1<<TWINT)));
	data=TWDR;
	I2C_StopCondition();
	return data;
}
uint8_t I2CReadAck(void)
{
	TWCR=(1<<TWINT) | (1<<TWEN) | (1<<TWEA);
	while (!(TWCR & (1<<TWINT))){};
	return TWDR;
}

uint8_t I2CReadNak(void)
{
	TWCR=(1<<TWINT) | (1<<TWEN);
	while(!(TWCR & (1<<TWINT))){};
	return TWDR;
}
int32_t I2C_Read24(uint8_t address)
{
	int32_t data;
	I2C_StartCondition();
	I2C_SendByte(0b11101100);
	I2C_SendByte(address);            
	I2C_StopCondition();
	I2C_StartCondition(); 	                
	I2C_SendByte(0b11101101);	        
	data = I2CReadAck();
    data = (data << 8)+I2CReadAck();
    data = (data << 8)+I2CReadNak();
	I2C_StopCondition(); 	              
	return data;
}
int16_t I2C_Read16(uint8_t address)
{
	int16_t data;
	I2C_StartCondition();
	I2C_SendByte(0b11101100);
	I2C_SendByte(address);
	I2C_StopCondition();
	I2C_StartCondition();
	I2C_SendByte(0b11101101);
	data = I2CReadAck();
	data = (data << 8)+I2CReadNak();
	I2C_StopCondition();
	return data;
}