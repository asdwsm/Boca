//
//  engine.m
//  Boca
//
//  Created by Tom Zhu on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#include "engine.h"

static const uint32_t blueColor = 0x0000FFFF;
static const uint32_t whiteColor = 0xFFFFFFFF;
static const uint32_t blackColor = 0x000000FF;

// We're going to mix C and Objective-C.
// We need a context data stru
// This is where we will do the math for rendering our data structures into our buffer.

BCARenderingContext *BCACreateRenderingContextWithDimensions(float width, float height, float depth) {
	BCARenderingContext *context = [[BCARenderingContext alloc] initWithWidth:width height:height depth:depth];
	
	return context;
}

void BCAAddTriangleToContextWithVertices(BCARenderingContext *context, BCATriangle *triangle) {
	[context addPolygon:triangle];
}


void BCASetPixelColorForBufferAtPoint(uint32_t *buffer, float width, float height, float depth, uint32_t color, BCAPoint *point) {

	if (point.x > width	|| point.x < 0 || point.y > height || point.y < 0 || point.z > depth || point.z < 0) {
		NSLog(@"BAD COORDINATES. %@", point);
		return;
	}
	
	if (point.z > 0) {
		NSLog(@"uwot");
	}
	
	buffer[(int)(width * height) * (int)point.z + (int)point.y * (int)width + (int)point.x] = color;
}

void BCASetPixelColorForContextWithBufferAtPoint(BCARenderingContext *context, uint32_t *buffer, uint32_t color, BCAPoint *point) {
	BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, context.depth, color, point);
}

void BCASetPixelColorForContextAtPoint(BCARenderingContext *context, uint32_t color, BCAPoint *point) {
	BCASetPixelColorForContextWithBufferAtPoint(context, context.pixelBuffer, color, point);
}

void BCADrawLineWithContext (BCARenderingContext *context,BCAPoint *p1, BCAPoint *p2, uint32_t *buffer, uint32_t color){
	
	//NSLog(@"P1 %@", p1);
	//NSLog(@"P2 %@", p2);
	
	if(p1.x > p2.x){
		BCAPoint *tmp = p1;
		p1 = p2;
		p2 = tmp;
	}
	float slope = (-p2.y + p1.y) / (p2.x -p1.x);
	//NSLog(@"Slope %f", slope);
	if (p1.x == p2.x) {
		if(p1.y < p2.y){
			for (int i = p1.y; i < p2.y; i++) {
				BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:p1.x yCoordinate:i zCoordinate:0];
				//NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForContextAtPoint(context, color, newPoint);
			}
		}
		else {
			for (int i = p2.y; i < p1.y; i++) {
				BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:p2.x yCoordinate:i zCoordinate:0];
				//NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForContextAtPoint(context, color, newPoint);
			}
		}
	}
	else if (p2.y - p1.y > 0) {
		for (double i = p2.x; i > p1.x; i = i - 0.5) {
			BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:fabs(slope * (i - p1.x) - p1.y) zCoordinate:0];
			//NSLog(@"Inserting. %@", newPoint);
			BCASetPixelColorForContextAtPoint(context, color, newPoint);
		}
	}
	else {
		for (double i = p1.x; i < p2.x; i = i + 0.5) {
			BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:fabs(slope * (i - p2.x) - p2.y) zCoordinate:0];
			//NSLog(@"Inserting. %@", newPoint);
			BCASetPixelColorForContextAtPoint(context, color, newPoint);
		}
	}
}

void BCAFillTriangleWithContext(BCAPoint *p1, BCAPoint *p2, BCAPoint *p3, uint32_t color, BCARenderingContext *context){
	BCAPoint *tip = nil;
	BCAPoint *bottom1 = nil;
	BCAPoint *bottom2 = nil;
	
	BCAPoint *high = nil;
	BCAPoint *low = nil;
	
	if (p1.x == p2.x) {
		if (p1.y < p2.y) {
			tip = p1;
			high = p1;
			if (p2.x < p3.x) {
				bottom1 = p2;
				bottom2 = p3;
			}
			else {
				bottom1 = p3;
				bottom2 = p2;
			}
		}
		else {
			tip = p2;
			high = p2;
			if (p1.x < p3.x) {
				bottom1 = p1;
				bottom2 = p3;
			}
			else {
				bottom1 = p3;
				bottom2 = p1;
			}
		}
	}
	
	if (p1.x == p3.x) {
		if (p1.y < p3.y) {
			tip = p1;
			high = p1;
			if (p3.x < p2.x) {
				bottom1 = p3;
				bottom2 = p2;
			}
			else {
				bottom1 = p2;
				bottom2 = p3;
			}
		}
		else {
			tip = p3;
			high = p3;
			if (p1.x < p2.x) {
				bottom1 = p1;
				bottom2 = p2;
			}
			else {
				bottom1 = p2;
				bottom2 = p1;
			}
		}
	}
	
	if (p2.x == p3.x) {
		if (p2.y < p3.y) {
			tip = p2;
			high = p2;
			if (p3.x < p1.x) {
				bottom1 = p3;
				bottom2 = p1;
			}
			else {
				bottom1 = p1;
				bottom2 = p3;
			}
		}
		else {
			tip = p3;
			high = p3;
			if (p2.x < p1.x) {
				bottom1 = p2;
				bottom2 = p1;
			}
			else {
				bottom1 = p1;
				bottom2 = p2;
			}
		}
	}

	if ((p1.x > p2.x && p1.x < p3.x) || (p1.x > p3.x && p1.x < p2.x)) {
		tip = p1;
		
		if (p2.x < p3.x) {
			bottom1 = p2;
			bottom2 = p3;
		}
		else {
			bottom1 = p3;
			bottom2 = p2;
		}
		float m = (-bottom1.y + bottom2.y) / (bottom1.x - bottom2.x);
		float distance = (m * p1.x + p1.y + (m * bottom1.x - bottom1.y) ) / sqrt(m * m + 1);
		NSLog(@"distance %f", distance);
		if (p1.y > fabsf(m * (p1.x - bottom1.x) - bottom1.y))
			low = p1;
		else
			high = p1;
	}
	
	if ((p2.x > p1.x && p2.x < p3.x) || (p2.x > p3.x && p2.x < p1.x)) {
		tip = p2;

		if (p1.x < p3.x) {
			bottom1 = p1;
			bottom2 = p3;
		}
		else {
			bottom1 = p3;
			bottom2 = p1;
		}
		float m = (-bottom1.y + bottom2.y) / (bottom1.x - bottom2.x);
		float distance = (m * p2.x + p2.y + (m * bottom1.x - bottom1.y) ) / sqrt(m * m + 1);
		NSLog(@"distance %f", distance);
		if (p2.y > fabsf(m * (p2.x - bottom1.x) - bottom1.y))
			low = p2;
		else
			high = p2;
	}
	
	
	if ((p3.x > p2.x && p3.x < p1.x) || (p3.x > p1.x && p3.x < p2.x)) {
		tip = p3;
	
		if (p1.x < p2.x) {
			bottom1 = p1;
			bottom2 = p2;
		}
		else {
			bottom1 = p2;
			bottom2 = p1;
		}
		float m = (-bottom1.y + bottom2.y) / (bottom1.x - bottom2.x);

		if (p3.y > fabsf(m * (p3.x - bottom1.x) - bottom1.y))
			low = p3;
		else
			high = p3;
	}

	//try to fill in now
	NSLog(@"P1 %@", p1);
	NSLog(@"P2 %@", p2);
	NSLog(@"P3 %@", p3);
	NSLog(@"HIGH %@", high);
	NSLog(@"LOW %@", low);
	NSLog(@"tip %@", tip);
	NSLog(@"BOTTOM1 %@", bottom1);
	NSLog(@"BOTTOM2 %@", bottom2);
	//when tip on top
	if (tip == high) {
		float m1 = (-bottom1.y + high.y) / (bottom1.x - high.x);
		float m2 = (-bottom1.y + bottom2.y) / (bottom1.x - bottom2.x);
		float m3 = (-bottom2.y + high.y) / (bottom2.x - high.x);
		
		NSLog(@"m1 %f", m1);
		NSLog(@"m2 %f", m2);
		
		for (int i = bottom1.x; i < bottom2.x; i++) {
			
			float j = fabsf((m2 * (i - bottom1.x) - bottom1.y));
			if (i < high.x) {
				while (j > fabsf(m1 * (i - bottom1.x) - bottom1.y)) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:j zCoordinate:0];
					//NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForContextAtPoint(context, color, newPoint);
					j--;
				}
			}
			else {
				while (j > fabsf(m3 * (i - bottom2.x) - bottom2.y)) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:j zCoordinate:0];
					//NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForContextAtPoint(context, color, newPoint);
					j--;
				}
			}
		}
		
	}
	
	//when tip on bot
	if (tip == low) {
		float m1 = (-bottom1.y + low.y) / (bottom1.x - low.x);
		float m2 = (-bottom1.y + bottom2.y) / (bottom1.x - bottom2.x);
		float m3 = (-bottom2.y + low.y) / (bottom2.x - low.x);
		
		NSLog(@"m1 %f", m1);
		NSLog(@"m2 %f", m2);
		
		for (int i = bottom1.x; i < bottom2.x; i++) {
			
			float j = fabsf((m2 * (i - bottom1.x) - bottom1.y));
			if (i < low.x) {
				while (j < fabsf(m1 * (i - bottom1.x) - bottom1.y)) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:j zCoordinate:0];
					//NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForContextAtPoint(context, color, newPoint);
					j++;
				}
			}
			else {
				while (j < fabsf(m3 * (i - bottom2.x) - bottom2.y)) {
					BCAPoint *newPoint = [BCAPoint pointWithXCoordinate:i yCoordinate:j zCoordinate:0];
					//NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForContextAtPoint(context, color, newPoint);
					j++;
				}
			}
		}
		
	}
}

uint32_t BCAGetPixelFromContextAtPoint(BCARenderingContext *context, BCAPoint *point) {
	uint32_t *buffer = context.pixelBuffer;
	return buffer[(int)point.z * (int)(context.width * context.height) + (int)point.y * (int)context.width + (int)point.x];
}

uint32_t *BCAPixelBufferForRenderingContext(BCARenderingContext *context) {
	// This is where your turn comes in. :-)
	// allocate a uint32_t buffer of size context.width * context.height * sizeof(uint32_t)
	//uint32_t buffer = context.width * context.height * sizeof(float);
	// no
	uint32_t *buffer = malloc(sizeof(uint32_t) * (int)context.width * (int)context.height);
	// make sense?
	
	bzero(buffer, sizeof(uint32_t) * context.width * context.height);
	// fills `buffer` with 0s. so every pixel is by default black.
	//					   rrggbbaa
	// FF = red = 255
	// FF = green = 255
	// 00 = blue = 0
	// FF = alpha = 255 (not transparent, opaque)
	
	NSMutableArray *triangles = [[NSMutableArray alloc] init];
	
	for (BCAPolygon *polygon in [context _polygons]) {
		[triangles addObjectsFromArray:[polygon triangles]];
	}
	
	
	
	
	for (BCATriangle *triangle in triangles) {
		// Put blueColor in every spot where a triangle vertex is.
		// Use either loop style.
		NSArray *vertices = triangle.vertices;
		
		BCAPoint *p1 = vertices[0], *p2 = vertices[1], *p3 = vertices[2];
		
		BCADrawLineWithContext (context, p1, p2, context.pixelBuffer, blueColor);
		BCADrawLineWithContext (context, p1, p3, context.pixelBuffer, blueColor);
		BCADrawLineWithContext (context, p2, p3, context.pixelBuffer, blueColor);
		
		BCAFillTriangleWithContext(p1, p2, p3, triangle.color, context);

		
		for (BCAPoint *point in vertices) {
			// nooppe
			// use point.x and point.y and insert into `buffer`
			// ok so this isn't entirely obvious because of the way it's done.
			//			buffer[(int)point.y * (int)context.width + (int)point.x] = blueColor;
			// This probably makes no sense. Right? It's ok. it'll make sense soon. ;-)
			// try to fill in buffer with blueColor inside of the triangle. Start with the lines connecting the vertices :)
			// actually, let's make this easier for you.
			// now you can just insert (x,y) coordinates.
			
			BCASetPixelColorForContextAtPoint(context, 0xFFFFFFFF, point);
			
			// Ok! Now try to fill in points in the triangle, starrting with the permiters. :)
			// You can declare the 3 points and do it outside of this loop if that will make it easier for you to do the math
			
		}
	}
	
	for (int z = context.depth - 1; z >= 0; z--) {
		for (int y = 0; y < context.height; y++) {
			for (int x = 0; x < context.width; x++) {
				uint32_t pixel = BCAGetPixelFromContextAtPoint(context, BCAPointMake(x, y, z));
				
				uint8_t alpha = (uint8_t)pixel;


				if (alpha != 0) {
					BCASetPixelColorForBufferAtPoint(buffer, context.width, context.height, 0, pixel, BCAPointMake(x, y, 0));
				}
			}
		}
	}
	
	// Let's test our code.
	
	return buffer;
	
}