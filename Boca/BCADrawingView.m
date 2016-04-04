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
	
	CGContextClearRect(ctx, rect);
	
	CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
	CGContextRef btmpCtx = CGBitmapContextCreate(self.pixelBuffer, self.pixelBufferWidth, self.pixelBufferHeight, 8, 4 * self.pixelBufferWidth, cs, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
	CGImageRef ref = CGBitmapContextCreateImage(btmpCtx);
	
	CGContextTranslateCTM(ctx, 0.0, rect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	CGContextDrawImage(ctx, rect, ref);
	CGImageRelease(ref);
	
}

@end
