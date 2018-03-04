#ifndef TWI_H_
#define TWI_H_

#include "main.h"
void I2C_Init(void);
void I2C_StartCondition(void);
void I2C_StopCondition(void);
void I2C_SendByte(unsigned char c);
uint8_t I2C_ReadByte(uint8_t address);
void I2C_WriteByte(uint8_t address,uint8_t data);
uint8_t I2CReadNak(void);
uint8_t I2CReadAck(void);
int32_t I2C_Read24(uint8_t address);
int16_t I2C_Read16(uint8_t address);

#endif /* TWI_H_ */