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
#include "C:/Users/vane_/Desktop/Sistemas Embebidos/opencv-vs2015-samples/modules/objdetect/include/opencv2/objdetect/objdetect_c.h"
#include "C:/Users/vane_/Desktop/Sistemas Embebidos/opencv-vs2015-samples/modules/videoio/include/opencv2/videoio/videoio_c.h"
#include "C:/Users/vane_/Desktop/Sistemas Embebidos/opencv-vs2015-samples/modules/highgui/include/opencv2/highgui/highgui_c.h"
#include "C:/Users/vane_/Desktop/Sistemas Embebidos/opencv-vs2015-samples/modules/imgproc/include/opencv2/imgproc/imgproc_c.h"

#include <stdio.h>

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

using namespace std;
using namespace cv;

/** Function Headers */
void detectAndDisplay( Mat frame );

/** Global variables */
String face_cascade_name = "lbpcascade_frontalface.xml";
String eyes_cascade_name = "haarcascade_eye_tree_eyeglasses.xml";
CascadeClassifier face_cascade;
CascadeClassifier eyes_cascade;
String window_name = "Capture - Face detection";

int main() {

	void *virtual_base;
	int fd;


	LCD_CANVAS LcdCanvas;

	VideoCapture capture;
	Mat frame;

	//-- 1. Load the cascade
	if( !face_cascade.load( face_cascade_name ) ){ printf("--(!)Error loading face cascade\n"); return -1; };
	if( !eyes_cascade.load( eyes_cascade_name ) ){ printf("--(!)Error loading eyes cascade\n"); return -1; };

	//-- 2. Read the video stream
	capture.open( -1 );
	if ( ! capture.isOpened() ) { printf("--(!)Error opening video capture\n"); return -1; }
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

    // clear screen
    DRAW_Clear(&LcdCanvas, LCD_WHITE);

		// demo grphic api
 //   DRAW_Rect(&LcdCanvas, 0,0, LcdCanvas.Width-1, LcdCanvas.Height-1, LCD_BLACK); // retangle
  //  DRAW_Circle(&LcdCanvas, 10, 10, 6, LCD_BLACK);
   // DRAW_Circle(&LcdCanvas, LcdCanvas.Width-10, 10, 6, LCD_BLACK);
 //   DRAW_Circle(&LcdCanvas, LcdCanvas.Width-10, LcdCanvas.Height-10, 6, LCD_BLACK);
  //  DRAW_Circle(&LcdCanvas, 10, LcdCanvas.Height-10, 6, LCD_BLACK);
	while ( capture.read(frame) )
	{
			if( frame.empty() )
			{
					printf(" --(!) No captured frame -- Break!");
					DRAW_Refresh(&LcdCanvas);
					DRAW_PrintString(&LcdCanvas, 40, 5, "Face no detected", LCD_BLACK, &font_16x16);
					break;
			}

			//-- 3. Apply the classifier to the frame
			DRAW_Refresh(&LcdCanvas);
			DRAW_PrintString(&LcdCanvas, 40, 5, "Face detected", LCD_BLACK, &font_16x16);
			detectAndDisplay( frame );

			//-- bail out if escape was pressed
			int c = waitKey(10);
			if( (char)c == 27 ) { break; }
	}
    // demo font




    free(LcdCanvas.pFrame);
	}

	// clean up our memory mapping and exit

	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}
void detectAndDisplay( Mat frame )
{
    std::vector<Rect> faces;
    Mat frame_gray;

    cvtColor( frame, frame_gray, COLOR_BGR2GRAY );
    equalizeHist( frame_gray, frame_gray );

    //-- Detect faces
    face_cascade.detectMultiScale( frame_gray, faces, 1.1, 2, 0, Size(80, 80) );

    for( size_t i = 0; i < faces.size(); i++ )
    {
        Mat faceROI = frame_gray( faces[i] );
        std::vector<Rect> eyes;

        //-- In each face, detect eyes
        eyes_cascade.detectMultiScale( faceROI, eyes, 1.1, 2, 0 |CASCADE_SCALE_IMAGE, Size(30, 30) );
        if( eyes.size() == 2)
        {
            //-- Draw the face
            Point center( faces[i].x + faces[i].width/2, faces[i].y + faces[i].height/2 );
            ellipse( frame, center, Size( faces[i].width/2, faces[i].height/2 ), 0, 0, 360, Scalar( 255, 0, 0 ), 2, 8, 0 );

            for( size_t j = 0; j < eyes.size(); j++ )
            { //-- Draw the eyes
                Point eye_center( faces[i].x + eyes[j].x + eyes[j].width/2, faces[i].y + eyes[j].y + eyes[j].height/2 );
                int radius = cvRound( (eyes[j].width + eyes[j].height)*0.25 );
                circle( frame, eye_center, radius, Scalar( 255, 0, 255 ), 3, 8, 0 );
            }
        }

    }

    char str[100];
    static struct timeval last_time;
    struct timeval current_time;
    static float last_fps;
    float t;
    float fps;

    gettimeofday(&current_time, NULL);
    t = (current_time.tv_sec - last_time.tv_sec) + (current_time.tv_usec - last_time.tv_usec) / 1000000.;
    fps = 1. / t;
    fps = last_fps * 0.8 + fps * 0.2;
    last_fps = fps;
    last_time = current_time;
    sprintf(str, "%2.2f", fps);
    //cout << str << endl;
    putText(frame, str, Point(20, 40), FONT_HERSHEY_DUPLEX, 1, Scalar(0, 0, 255));

    //-- Show what you got
    imshow( window_name, frame );

}
