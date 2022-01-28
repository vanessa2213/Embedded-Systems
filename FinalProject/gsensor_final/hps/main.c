// ============================================================================
// Copyright (c) 2013 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development
//   Kits made by Terasic.  Other use of this code, including the selling
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use
//   or functionality of this code.
//
// ============================================================================
//
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================

#include "terasic_os_includes.h"
#include "LCD_Lib.h"
#include "lcd_graphic.h"
#include "font.h"
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "hwlib.h"
#include "ADXL345.h"
#include "ADXL345.c"
#include <sys/mman.h>
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"							//declaration of the LEDs and 7 segments displays

#define HEX_DISPLAY_CLEAR (0x7F)
#define HEX_DISPLAY_ZERO (0x40)
#define HEX_DISPLAY_ONE (0x79)
#define HEX_DISPLAY_TWO (0x24)
#define HEX_DISPLAY_THREE (0x30)
#define HEX_DISPLAY_FOUR (0x19)
#define HEX_DISPLAY_FIVE (0x12)
#define HEX_DISPLAY_SIX (0x02)
#define HEX_DISPLAY_SEVEN (0x78)
#define HEX_DISPLAY_EIGHT (0x00)
#define HEX_DISPLAY_NINE (0x18)
#define HEX_DISPLAY_A (0x08)
#define HEX_DISPLAY_B (0x03)
#define HEX_DISPLAY_C (0x46)
#define HEX_DISPLAY_D (0x21)

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

bool ADXL345_REG_WRITE(int file, uint8_t address, uint8_t value){
	bool bSuccess = false;
	uint8_t szValue[2];

	// write to define register
	szValue[0] = address;
	szValue[1] = value;
	if (write(file, &szValue, sizeof(szValue)) == sizeof(szValue)){
			bSuccess = true;
	}
	return bSuccess;
}

bool ADXL345_REG_READ(int file, uint8_t address,uint8_t *value){
	bool bSuccess = false;
	uint8_t Value;
	// write to define register
	if (write(file, &address, sizeof(address)) == sizeof(address)){

		// read back value
		if (read(file, &Value, sizeof(Value)) == sizeof(Value)){
			*value = Value;
			bSuccess = true;
		}
	}
	return bSuccess;
}

bool ADXL345_REG_MULTI_READ(int file, uint8_t readaddr,uint8_t readdata[], uint8_t len){
	bool bSuccess = false;

	// write to define register
	if (write(file, &readaddr, sizeof(readaddr)) == sizeof(readaddr)){
		// read back value
		if (read(file, readdata, len) == len){
			bSuccess = true;
		}
	}


	return bSuccess;
}
int hex_num(int num){
		switch(num){
			case 0: return HEX_DISPLAY_ZERO;
			case 1: return HEX_DISPLAY_ONE;
			case 2: return HEX_DISPLAY_TWO;
			case 3: return HEX_DISPLAY_THREE;
			case 4: return HEX_DISPLAY_FOUR;
			case 5: return HEX_DISPLAY_FIVE;
			case 6: return HEX_DISPLAY_SIX;
			case 7: return HEX_DISPLAY_SEVEN;
			case 8: return HEX_DISPLAY_EIGHT;
			case 9: return HEX_DISPLAY_NINE;
			return HEX_DISPLAY_CLEAR;
		}
}

int main(int argc, char *argv[]) {

		void *virtual_base;
		int fd;
	  int X_i;
		int Y_c;
		int Z_i;
		//int n;
	  char cad_X[3];
		char cad_Y[3];
		char cad_Z[3];

		int cad_Y_1;
		int cad_Y_2;
		int cad_Y_3;
		int cad_Y_4;

		LCD_CANVAS LcdCanvas;
		int file;
		const char *filename = "/dev/i2c-0";
		uint8_t id;
		bool bSuccess;
		const int mg_per_digi = 4;
		uint16_t szXYZ[3];
		int cnt=0, max_cnt=0;
		int led_mask;
		int seg0_mask;
		int seg1_mask;
		int seg2_mask;
		int seg3_mask;
		int seg4_mask;
		int seg5_mask;

		void *h2p_lw_led_addr;
		void *h2p_lw_seg0_addr;
		void *h2p_lw_seg1_addr;
		void *h2p_lw_seg2_addr;
		void *h2p_lw_seg3_addr;
		void *h2p_lw_seg4_addr;
		void *h2p_lw_seg5_addr;

		printf("===== gsensor test =====\r\n");
		if (argc == 2){
			max_cnt = atoi(argv[1]);
		}
		if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
			printf( "ERROR: could not open \"/dev/mem\"...\n" );
			return( 1 );
		}

		virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

		if( virtual_base == MAP_FAILED ) {
			printf( "ERROR: mmap() failed...\n" );
			close( fd );
			return( 1 );
		}

		h2p_lw_led_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + LED_PIO_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
		h2p_lw_seg0_addr= virtual_base +( ( unsigned long  )(ALT_LWFPGASLVS_OFST + SEG0_BASE) );
		h2p_lw_seg1_addr= virtual_base +( ( unsigned long  )(ALT_LWFPGASLVS_OFST + SEG1_BASE) );
		h2p_lw_seg2_addr= virtual_base +( ( unsigned long  )(ALT_LWFPGASLVS_OFST + SEG2_BASE) );
		h2p_lw_seg3_addr= virtual_base +( ( unsigned long  )(ALT_LWFPGASLVS_OFST + SEG3_BASE) );
		h2p_lw_seg4_addr= virtual_base +( ( unsigned long  )(ALT_LWFPGASLVS_OFST + SEG4_BASE) );
		h2p_lw_seg5_addr= virtual_base +( ( unsigned long  )(ALT_LWFPGASLVS_OFST + SEG5_BASE) );

		// toggle the LEDs a bit



		// open bus
		if ((file = open(filename, O_RDWR)) < 0) {
				/* ERROR HANDLING: you can check errno to see what went wrong */
				perror("Failed to open the i2c bus of gsensor");
				exit(1);
		}


		// init
		// gsensor i2c address: 101_0011
		int addr = 0b01010011;
		if (ioctl(file, I2C_SLAVE, addr) < 0) {
				printf("Failed to acquire bus access and/or talk to slave.\n");
				/* ERROR HANDLING; you can check errno to see what went wrong */
				exit(1);
		}


			// configure accelerometer as +-2g and start measure
			bSuccess = ADXL345_Init(file);
			if (bSuccess){
					// dump chip id
					bSuccess = ADXL345_IdRead(file, &id);
					if (bSuccess)
							printf("id=%02Xh\r\n", id);
			}

		// map the address space for the LED registers into user space so we can interact with them.
		// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span
		if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {

			printf( "ERROR: could not open \"/dev/mem\"...\n" );
			return( 1 );
		}

		virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );



		if( virtual_base == MAP_FAILED ) {
			printf( "ERROR: mmap() failed...\n" );
			close( fd );
			return( 1 );

		}



		//printf("Can you see LCD?(CTRL+C to terminate this program)\r\n");
		printf("Graphic LCD Demo\r\n");

			LcdCanvas.Width = LCD_WIDTH;
			LcdCanvas.Height = LCD_HEIGHT;
			LcdCanvas.BitPerPixel = 1;
			LcdCanvas.FrameSize = LcdCanvas.Width * LcdCanvas.Height / 8;
			LcdCanvas.pFrame = (void *)malloc(LcdCanvas.FrameSize);


	if (LcdCanvas.pFrame == NULL){
			printf("failed to allocate lcd frame buffer\r\n");
	}else{

		LCDHW_Init(virtual_base);
		LCDHW_BackLight(true); // turn on LCD backlight

    LCD_Init();

		while(bSuccess && (max_cnt == 0 || cnt < max_cnt)){
				DRAW_Clear(&LcdCanvas, LCD_WHITE); // clear screen
				seg0_mask = HEX_DISPLAY_CLEAR;
				seg1_mask = HEX_DISPLAY_CLEAR;
				seg2_mask = HEX_DISPLAY_CLEAR;
				seg3_mask = HEX_DISPLAY_CLEAR;
				seg4_mask = HEX_DISPLAY_CLEAR;
				seg5_mask = HEX_DISPLAY_CLEAR;
				led_mask = 0x000;
				if (ADXL345_IsDataReady(file)){
            bSuccess = ADXL345_XYZ_Read(file, szXYZ);
            if (bSuccess){
	              cnt++;

								X_i = (int16_t)szXYZ[0]*mg_per_digi;
								Y_c = (int16_t)szXYZ[1]*mg_per_digi;
								Z_i = (int16_t)szXYZ[2]*mg_per_digi;
								printf("[%d]X=%d mg, Y=%d mg, Z=%d mg\r\n", cnt,X_i, Y_c, Z_i);

								sprintf(cad_X, "%d", X_i);
								sprintf(cad_Y, "%d", Y_c);
								sprintf(cad_Z, "%d", Z_i);

								DRAW_PrintString(&LcdCanvas, 15, 5, "X=", LCD_BLACK, &font_16x16);
								DRAW_PrintString(&LcdCanvas, 40, 5, cad_X, LCD_BLACK, &font_16x16);
								DRAW_PrintString(&LcdCanvas, 15, 5+16, "Y=", LCD_BLACK, &font_16x16);
								DRAW_PrintString(&LcdCanvas, 40, 5+16, cad_Y, LCD_BLACK, &font_16x16);
								DRAW_PrintString(&LcdCanvas, 15, 5+32, "Z=", LCD_BLACK, &font_16x16);
								DRAW_PrintString(&LcdCanvas, 40, 5+32, cad_Z, LCD_BLACK, &font_16x16);
								DRAW_Refresh(&LcdCanvas);

								//turning on the leds depending of the Y position

								if(Y_c<-770){
									led_mask = 0x100; //LED 9
								}
								else if(-770<=Y_c && Y_c<-550){
									led_mask = 0x80; //LED 8
								}
								else if(-550<=Y_c && Y_c<-330){
									led_mask = 0x40; //LED 7
								}
								else if(-330<=Y_c && Y_c<-110){
									led_mask = 0x20; //LED 6
								}
								else if(-110<=Y_c && Y_c<110){
									led_mask = 0x10; //LED 5
								}
								else if(110<=Y_c && Y_c<330){
									led_mask = 0x08; //LED 4
								}
								else if(330<=Y_c && Y_c<550){
									led_mask = 0x04; //LED 3
								}
								else if(550<=Y_c && Y_c<771){
									led_mask = 0x02; //LED 2
								}
								else{
									led_mask = 0x01; //LED 1
								}

								//turn the 7 segments depending of the number
								cad_Y_4 = Y_c/1000;
								cad_Y_3 = (Y_c - cad_Y_4*1000)/100;
								cad_Y_2 = (Y_c - cad_Y_4*1000 - cad_Y_3*100 )/10;
								cad_Y_1 = (Y_c - cad_Y_4*1000 - cad_Y_3*100 - cad_Y_2*10);
								if(cad_Y_4 > 0 ){
									seg4_mask= hex_num(cad_Y_4);
									seg3_mask= hex_num(cad_Y_3);
									seg2_mask= hex_num(cad_Y_2);
									seg1_mask= hex_num(cad_Y_1);
								}
								else if(cad_Y_3 > 0){
									seg3_mask= hex_num(cad_Y_3);
									seg2_mask= hex_num(cad_Y_2);
									seg1_mask= hex_num(cad_Y_1);
								}
								else if (cad_Y_2 > 0){
									seg2_mask= hex_num(cad_Y_2);
									seg1_mask= hex_num(cad_Y_1);
								}
								else if (cad_Y_1 >0){
									seg1_mask= hex_num(cad_Y_1);
								}
								else if(Y_c < 0 ){
									Y_c = Y_c * -1;
									cad_Y_4 = Y_c/1000;
									cad_Y_3 = (Y_c - cad_Y_4*1000)/100;
									cad_Y_2 = (Y_c - cad_Y_4*1000 - cad_Y_3*100 )/10;
									cad_Y_1 = (Y_c - cad_Y_4*1000 - cad_Y_3*100 - cad_Y_2*10);
									seg5_mask= 0x3F ;
									if(cad_Y_4 > 0 ){
										seg4_mask= hex_num(cad_Y_4);
										seg3_mask= hex_num(cad_Y_3);
										seg2_mask= hex_num(cad_Y_2);
										seg1_mask= hex_num(cad_Y_1);
									}
									else if(cad_Y_3 > 0){
										seg3_mask= hex_num(cad_Y_3);
										seg2_mask= hex_num(cad_Y_2);
										seg1_mask= hex_num(cad_Y_1);
									}
									else if (cad_Y_2 > 0){
										seg2_mask= hex_num(cad_Y_2);
										seg1_mask= hex_num(cad_Y_1);
									}
									else if (cad_Y_1 >0){
										seg1_mask= hex_num(cad_Y_1);
									}
								}


            }
        }

				*(uint32_t *)h2p_lw_led_addr = led_mask;
				*(uint32_t *)h2p_lw_seg0_addr = seg0_mask;
				*(uint32_t *)h2p_lw_seg1_addr = seg1_mask;
				*(uint32_t *)h2p_lw_seg2_addr = seg2_mask;
				*(uint32_t *)h2p_lw_seg3_addr = seg3_mask;
				*(uint32_t *)h2p_lw_seg4_addr = seg4_mask;
				*(uint32_t *)h2p_lw_seg5_addr = seg5_mask;
				usleep(1000*1000);
    }

    free(LcdCanvas.pFrame);
	}

	close( fd );

	return( 0 );
}
