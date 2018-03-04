#include "BME280.h"
uint16_t BME_Calibration(uint8_t address)
{
	uint8_t lsb=0;
	uint16_t data;
	I2C_StartCondition();
	I2C_SendByte(0b11101100);
	I2C_SendByte(address);           
	I2C_StopCondition();
    I2C_StartCondition(); 	               
	I2C_SendByte(0b11101101);	        
	lsb = I2CReadAck();
	data = I2CReadNak();
	I2C_StopCondition(); 	               
	data = (data << 8) + lsb;
	return data;
}
uint16_t Calib_H4(uint8_t address)
{
	uint8_t lsb=0;
	uint16_t data;
	I2C_StartCondition();
	I2C_SendByte(0b11101100);
	I2C_SendByte(address);
	I2C_StopCondition();
	I2C_StartCondition();
	I2C_SendByte(0b11101101);
	data = I2CReadAck();
	lsb = I2CReadNak();
	I2C_StopCondition();
	data = (data << 4) + (lsb&0b00001111);
	return data;
}
uint16_t Calib_H5(uint8_t address)
{
	uint8_t lsb=0;
	uint16_t data;
	I2C_StartCondition();
	I2C_SendByte(0b11101100);
	I2C_SendByte(address);
	I2C_StopCondition();
	I2C_StartCondition();
	I2C_SendByte(0b11101101);
	lsb = I2CReadAck();
	data = I2CReadNak();
	I2C_StopCondition();
	data = (data << 4) + (lsb>>4);
	return data;
}
void Registers(void)
{
	dig_T1=BME_Calibration(0x88);
	dig_T2=BME_Calibration(0x8A);
	dig_T3=BME_Calibration(0x8C);
	dig_P1=BME_Calibration(0x8E);
	dig_P2=BME_Calibration(0x90);
	dig_P3=BME_Calibration(0x92);
	dig_P4=BME_Calibration(0x94);
	dig_P5=BME_Calibration(0x96);
	dig_P6=BME_Calibration(0x98);
	dig_P7=BME_Calibration(0x9A);
	dig_P8=BME_Calibration(0x9C);
	dig_P9=BME_Calibration(0x9E);
	dig_H1=I2C_ReadByte(0xA1);
	dig_H2=BME_Calibration(0xE1);
	dig_H3=I2C_ReadByte(0xE3);
	dig_H4=Calib_H4(0xE4);
	dig_H5=Calib_H5(0xE5);
	dig_H6=I2C_ReadByte(0xE7);
}
void Calib(void)
{
I2C_WriteByte(0xF5,0b01010000);
I2C_WriteByte(0xF4,0b00100110);
_delay_ms(50);
adc_T=I2C_Read24(0xFA);
adc_T=(adc_T>>4);
adc_P=I2C_Read24(0xF7);
adc_P=(adc_P>>4);
adc_H=(int32_t)I2C_Read16(0xFD);
}
int32_t readTempC( void )
{
	// Returns temperature in DegC, resolution is 0.01 DegC. Output value of “5123” equals 51.23 DegC.
	// t_fine carries fine temperature as global value
	int32_t var1, var2;
	var1 = ((((adc_T>>3) - ((int32_t)dig_T1<<1))) * ((int32_t)dig_T2)) >> 11;
	var2 = (((((adc_T>>4) - ((int32_t)dig_T1)) * ((adc_T>>4) - ((int32_t)dig_T1))) >> 12) *
((int32_t)dig_T3)) >> 14;
	t_fine = var1 + var2;
	int output = (t_fine * 5 + 128) >> 8;	
	return output;
}
uint32_t readPress(void)
{
	int64_t var1,var2,p;
	var1 = ((int64_t)t_fine) - 128000;
	var2 = var1 * var1 * (int64_t)dig_P6;
	var2 = var2 + ((var1*(int64_t)dig_P5)<<17);
	var2 = var2 + (((int64_t)dig_P4)<<35);
	var1 = ((var1 * var1 * (int64_t)dig_P3)>>8) +
	((var1 * (int64_t)dig_P2)<<12);
	var1 = (((((int64_t)1)<<47)+var1))*((int64_t)dig_P1)>>33;
	if (var1 == 0) 
	{
	return 0; // avoid exception caused by division by zero
	}
	p = 1048576 - adc_P;
	p = (((p<<31) - var2)*3125) / var1;
	var1 = (((int64_t)dig_P9) * (p>>13) * (p>>13)) >> 25;
	var2 = (((int64_t)dig_P8) * p) >> 19;
	p = ((p + var1 + var2) >> 8) + (((int64_t)dig_P7)<<4);
	return (uint32_t)p/256;
}
uint32_t readHum(void)
{
	int32_t v_x1_u32r;

	v_x1_u32r = (t_fine - ((int32_t)76800));

	v_x1_u32r = (((((adc_H << 14) - (((int32_t)dig_H4) << 20) -
	(((int32_t)dig_H5) * v_x1_u32r)) + ((int32_t)16384)) >> 15) *
	(((((((v_x1_u32r * ((int32_t)dig_H6)) >> 10) *
	(((v_x1_u32r * ((int32_t)dig_H3)) >> 11) + ((int32_t)32768))) >> 10) +
	((int32_t)2097152)) * ((int32_t)dig_H2) + 8192) >> 14));

	v_x1_u32r = (v_x1_u32r - (((((v_x1_u32r >> 15) * (v_x1_u32r >> 15)) >> 7) *
	((int32_t)dig_H1)) >> 4));

	v_x1_u32r = (v_x1_u32r < 0 ? 0 : v_x1_u32r);
	v_x1_u32r = (v_x1_u32r > 419430400 ? 419430400 : v_x1_u32r);
	return  (uint32_t)(v_x1_u32r>>12)/1.024;
}