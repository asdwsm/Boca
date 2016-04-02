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
	
	if (!_pixelBuffer) return;
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	uint16_t width = self.pixelBufferWidth;
	uint16_t height = self.pixelBufferHeight;
	uint32_t *buffer = self.pixelBuffer;
	
	
	for (int i = 0; i < width; i++) {
		for (int j = 0; j < height; j++) {
			uint32_t pixel = buffer[j * width + i];
			
			uint32_t rgba = pixel;
//			NSLog(@"c 0x%x", rgba);
			uint8_t red = rgba >> 24;
			uint8_t green = rgba >> 16;
			uint8_t blue = rgba >> 8;
			
			uint8_t alpha = rgba;
			
//			NSLog(@"rgb 0x%x (r:%d,g:%d,b:%d)", rgba, red, green, blue);
			
			CGFloat color[4] = {red / 255.0, green / 255.0, blue / 255.0, alpha / 255.0};
			CGContextSetFillColor(ctx, color);
			CGContextFillRect(ctx, (CGRect){{i, j}, {1, 1}});
		}
	}
}

@end
