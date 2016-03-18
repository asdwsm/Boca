//
//  engine.m
//  Boca
//
//  Created by Tom Zhu on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#include "engine.h"

// We're going to mix C and Objective-C.
// We need a context data stru
// This is where we will do the math for rendering our data structures into our buffer.

BCARenderingContext *BCACreateRenderingContextWithDimensions(float width, float height) {
	BCARenderingContext *context = [[BCARenderingContext alloc] initWithWidth:width height:height];
	
	return context;
}

void BCAAddTriangleToContextWithVertices(BCARenderingContext *context, BCATriangle *triangle) {
	[context addTriangle:triangle];
}

void BCASetPixelColorForBufferAtPoint(uint32_t *buffer, float bufferWidth, float bufferHeight, uint32_t color, BCAPoint *point) {
	if (point.x > bufferWidth || point.x < 0 || point.y > bufferHeight || point.y < 0) {
		
		NSLog(@"BAD COORDINATES. %@", point);
		
		return;
	}
	
	buffer[(int)point.y * (int)bufferWidth + (int)point.x] = color;
}


void pickPoints (BCAPoint *p1, BCAPoint *p2, BCAPoint *p3) {

	if (p1.x > p2.x) {
		int tmpX;
		int tmpY;
		tmpX = p1.x;
		tmpY = p1.y;
		p1.x = p2.x;
		p1.y = p2.y;
		p2.x = tmpX;
		p2.y = tmpX;
	}
	
	if (p1.x > p3.x) {
		int tmpX;
		int tmpY;
		tmpX = p1.x;
		tmpY = p1.y;
		p1.x = p3.x;
		p1.y = p3.y;
		p3.x = tmpX;
		p3.y = tmpX;
	}
	
	if (p2.x > p3.x) {
		int tmpX;
		int tmpY;
		tmpX = p2.x;
		tmpY = p2.y;
		p2.x = p3.x;
		p2.y = p3.y;
		p3.x = tmpX;
		p3.y = tmpX;
	}
}

uint32_t *BCAPixelBufferForRenderingContext(BCARenderingContext *context) {
	// This is where your turn comes in. :-)
	// allocate a uint32_t buffer of size context.width * context.height * sizeof(uint32_t)
	//uint32_t buffer = context.width * context.height * sizeof(float);
	// no
	uint32_t *buffer = malloc(sizeof(uint32_t) * context.width * context.height);
	// make sense?
	
	bzero(buffer, sizeof(uint32_t) * context.width * context.height);
	// fills `buffer` with 0s. so every pixel is by default black.
	
	uint32_t blueColor = 0x0000FFFF;
	//					   rrggbbaa
	// FF = red = 255
	// FF = green = 255
	// 00 = blue = 0
	// FF = alpha = 255 (not transparent, opaque)
	
	
	for (BCATriangle *triangle in [context _polygons]) {
		// Put blueColor in every spot where a triangle vertex is.
		// Use either loop style.
		NSArray *vertices = triangle.vertices;
	
		BCAPoint *p1 = vertices[0], *p2 = vertices[1], *p3 = vertices[2];
		
		pickPoints(p1, p2, p3);
		
		// Choose two points. p1,p2.
		// Slope, m = (y2-y1)/(x2-x1)
		float slope = (-p2.y + p1.y) / (p2.x -p1.x);
		// equatin of line containing p1, wiht slope m, y - y1 = m(x-x1)
		// y = m(x - p.x) + p.y
		// Now, we need to decide which direction to go in, because p1 could be above, or below p2.
		// Got the idea? yes
		// want me to continue? let me try
		//first line
		NSLog(@"P1 %@", p1);
		NSLog(@"P2 %@", p2);
		NSLog(@"P3 %@", p3);
		NSLog(@"Slope %f", slope);
		if (p1.x == p2.x) {
			if(p1.y < p2.y){
				for (int i = p1.y; i < p2.y; i++) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:p1.x yCoordinate:i];
					NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
				}
			}
			else {
				for (int i = p2.y; i < p1.y; i++) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:p2.x yCoordinate:i];
					NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
				}
			}
		}
		else if (p2.y - p1.y > 0) {
			for (double i = p2.x; i > p1.x; i = i - 0.5) {
				BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:fabs(slope * (i - p1.x) - p1.y)];
				NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
			}
		}
		else {
			for (double i = p1.x; i < p2.x; i = i + 0.5) {
				BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:fabs(slope * (i - p2.x) - p2.y)];
				NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
			}
		}
		
		//second line
		slope = (-p3.y + p1.y) / (p3.x -p1.x);
		NSLog(@"P1 %@", p1);
		NSLog(@"P3 %@", p3);
		NSLog(@"Slope %f", slope);
		if (p1.x == p3.x) {
			if(p1.y < p3.y){
				for (int i = p1.y; i < p3.y; i++) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:p1.x yCoordinate:i];
					NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
				}
			}
			else {
				for (int i = p3.y; i < p1.y; i++) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:p3.x yCoordinate:i];
					NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
				}
			}
		}
		else if (p3.y - p1.y > 0) {
			for (double i = p3.x; i > p1.x; i = i - 0.5) {
				BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:fabs(slope * (i - p1.x) - p1.y)];
				NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
			}
		}
		else {
			for (double i = p1.x; i < p3.x; i = i + 0.5) {
				BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:fabs(slope * (i - p3.x) - p3.y)];
				NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
			}
		}
		
		//third line
		slope = (-p3.y + p2.y) / (p3.x -p2.x);
		NSLog(@"P2 %@", p2);
		NSLog(@"P3 %@", p3);
		NSLog(@"Slope %f", slope);
		if (p2.x == p3.x) {
			if(p2.y < p3.y){
				for (int i = p1.y; i < p3.y; i++) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:p2.x yCoordinate:i];
					NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
				}
			}
			else {
				for (int i = p3.y; i < p2.y; i++) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:p3.x yCoordinate:i];
					NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
				}
			}
		}
		else if (p3.y - p2.y > 0) {
			for (double i = p3.x; i > p2.x; i = i - 0.5) {
				BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:fabs(slope * (i - p2.x) - p2.y)];
				NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
			}
		}
		else {
			for (double i = p2.x; i < p3.x; i = i + 0.5) {
				BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:fabs(slope * (i - p3.x) - p3.y)];
				NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
			}
		}

//

//		BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, [BCAPoint pointWithXCoordinate:299 yCoordinate:299]);
//		BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, [BCAPoint pointWithXCoordinate:1 yCoordinate:1]);
//		
//		for (int i = p1.x ; i < p2.x; i++) {
//			for (int j = p1.y; j > p2.y; j++) {
//				// create NEW point. :)doesn't work though
//				// Let's try this.
//				BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:j];
//				BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, blueColor, newPoint);
//			}
//		}
		
		// Suppose you have a function f(0) = p1, f(n) = p2. then you iterate over (0,n)
		
		for (BCAPoint *point in vertices) {
			// nooppe
			// use point.x and point.y and insert into `buffer`
			// ok so this isn't entirely obvious because of the way it's done.
//			buffer[(int)point.y * (int)context.width + (int)point.x] = blueColor;
			// This probably makes no sense. Right? It's ok. it'll make sense soon. ;-)
			// try to fill in buffer with blueColor inside of the triangle. Start with the lines connecting the vertices :)
			// actually, let's make this easier for you.
			// now you can just insert (x,y) coordinates.
			
			BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, 0xFFFFFFFF, point);
			
			// Ok! Now try to fill in points in the triangle, starrting with the permiters. :)
			// You can declare the 3 points and do it outside of this loop if that will make it easier for you to do the math.
			
			
		}
	}

	// Let's test our code.
	
	return buffer;
	
}
