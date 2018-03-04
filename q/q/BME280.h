#ifndef BME280_H_
#define BME280_H_

#include "main.h"
uint16_t BME_Calibration(uint8_t address);
uint16_t Calib_H4(uint8_t address);
uint16_t Calib_H5(uint8_t address);
void Registers(void);
void Calib(void);
int32_t readTempC( void );
uint32_t readPress(void);
uint32_t readHum(void);
uint16_t dig_T1;
int16_t dig_T2;
int16_t dig_T3;
uint16_t dig_P1;
int16_t dig_P2;
int16_t dig_P3;
int16_t dig_P4;
int16_t dig_P5;
int16_t dig_P6;
int16_t dig_P7;
int16_t dig_P8;
int16_t dig_P9;
unsigned char dig_H1;
int16_t dig_H2;
unsigned char dig_H3;
int16_t dig_H4;
int16_t dig_H5;
signed char dig_H6;
int32_t adc_T;
int32_t adc_P;
int32_t adc_H;
int32_t t_fine;

#endif /* BME280_H_ */