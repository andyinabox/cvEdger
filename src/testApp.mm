#include "testApp.h"

#include "opencv2/imgproc/imgproc.hpp"

//--------------------------------------------------------------
void testApp::setup(){
    ofSetOrientation(OF_ORIENTATION_90_RIGHT);//Set iOS to Orientation Landscape Right
    
    ofSetFrameRate(30);
    
    bErode = false;
	capW = 480;
	capH = 360;
    cannyThreshold1 = 80;
    cannyThreshold2 = 100;
    
    vidGrabber.initGrabber(capW, capH);
    capW = vidGrabber.getWidth();
    capH = vidGrabber.getHeight();
    
    colorImg.allocate(capW,capH);
    grayImage.allocate(capW,capH);
    cannyImg.allocate(capW, capH);
    erodeImg.allocate(capW, capH);
    
}

//--------------------------------------------------------------
void testApp::update(){
	ofBackground(50,130,170);
    
    bool bNewFrame = false;
    
    vidGrabber.update();
    bNewFrame = vidGrabber.isFrameNew();
    
	if (bNewFrame){
        
        if( vidGrabber.getPixels() != NULL ){
            
            colorImg.setFromPixels(vidGrabber.getPixels(), capW, capH);
            grayImage = colorImg;
            
            IplImage *out = cvCreateImage(
              cvGetSize(grayImage.getCvImage()),
              IPL_DEPTH_8U,
              1
            );

            if(bErode) {
                cvErode(grayImage.getCvImage(), out, NULL, 5);
                cvCanny(out, out, cannyThreshold1, cannyThreshold2, 3);
            } else {
                cvCanny(grayImage.getCvImage(), out, cannyThreshold1, cannyThreshold2, 3);
            }
            
            cannyImg = out;
            
            cvReleaseImage(&out);

            
		}
	}
}

//--------------------------------------------------------------
void testApp::draw(){
    
    cannyImg.draw(0,0);

    
	ofSetHexColor(0xffffff);
	char reportStr[1024];
	sprintf(reportStr, "t1: %u t2: %u fps: %f", cannyThreshold1, cannyThreshold2, ofGetFrameRate());
	ofDrawBitmapString(reportStr, 10, 10);
    
}

//--------------------------------------------------------------
void testApp::exit(){
    
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    //	bLearnBakground = true;
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    cannyThreshold1 = int(touch.x);
    cannyThreshold2 = int(touch.y);
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
    cout << "double tap!" << endl;
    bErode = !bErode;
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    
}
