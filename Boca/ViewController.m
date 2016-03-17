//
//  ViewController.m
//  Boca
//
//  Created by Max Shavrick on 3/15/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "ViewController.h"
#import "BCADrawingView.h"

@implementation ViewController {
	BCADrawingView *drawingView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	drawingView = [[BCADrawingView alloc] init];
	[self.view addSubview:drawingView];
	[drawingView setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
	
	CGFloat bufferWidth = (drawingView.frame.size.width / 2);
	CGFloat bufferHeight = (drawingView.frame.size.height / 2);
	
	[drawingView setPixelBufferWidth:bufferWidth];
	[drawingView setPixelBufferHeight:bufferHeight];
	
	
	// This is just an example. The rendering engine will give us an uint32_t buffer every 1/60th of second
	// Which will only be new if something has changed. (Marked "Dirty")
	// I will set this up so it redraws every 1/60th of a second.
	// There's a logic issue somewhere in here too. But I'll figure it out later. ;P
	
	uint32_t *gradientBuffer = malloc(sizeof(uint32_t) * bufferHeight * bufferWidth);
	
	for (int i = 0; i < bufferWidth; i++) {
		for (int j = 0; j < bufferHeight; j++) {
			
			uint8_t red = 255;
			uint8_t green = 255;
			uint8_t blue = 255;
			
			blue *= 1 - (j / bufferHeight);
			green -= j / 4.0;
			red -= j;
			
			uint32_t rgba = (red << 24) + (green << 16) + (blue << 8) + (0xFF);
			
			gradientBuffer[(int)(i * (int)bufferHeight) + j] = rgba;
		}
	}
	
	[drawingView setPixelBuffer:gradientBuffer];
	
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
