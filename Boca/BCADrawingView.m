//
//  BCADrawingView.m
//  Boca
//
//  Created by Max Shavrick on 3/15/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "BCADrawingView.h"

@implementation BCADrawingView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	for (int i = 0; i < self.pixelBufferWidth; i++) {
		for (int j = 0; j < self.pixelBufferHeight; j++) {
			uint32_t pixel = self.pixelBuffer[i * self.pixelBufferHeight + j];
		
			uint32_t rgba = pixel;
			//		NSLog(@"c 0x%x", rgba);
			uint8_t red = rgba >> 24;
			uint8_t green = rgba >> 16;
			uint8_t blue = rgba >> 8;
			
//			NSLog(@"rgb 0x%x (r:%d,g:%d,b:%d)", rgba, red, green, blue);
			
			UIColor *pixelColor = [UIColor colorWithRed:(red / 255.0) green:(green / 255.0) blue:(blue / 255.0) alpha:1.0];
			[pixelColor set];
			UIRectFill(CGRectMake(i	* 2, j * 2, 2, 2));
		}
	}
}

@end
