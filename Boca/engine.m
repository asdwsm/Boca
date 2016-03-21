//
//  engine.m
//  Boca
//
//  Created by Tom Zhu on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#include "engine.h"
#include <stdlib.h>
#include <Foundation/Foundation.h>

static const __unused uint32_t blueColor = 0x0000FFFF;
static const __unused uint32_t whiteColor = 0xFFFFFFFF;
static const __unused uint32_t blackColor = 0x000000FF;

// We're going to mix C and Objective-C.
// We need a context data stru
// This is where we will do the math for rendering our data structures into our buffer.


BCAPolygon *BCAPolygonWithColorAndPoints3(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3) {
	BCAPolygon *polygon = calloc(sizeof(BCAPolygon), 1);
	
	BCATriangle *triangle = calloc(sizeof(BCATriangle), 1);

	BCAPoint *region = calloc(sizeof(BCAPoint) * 3, 1);
	region[0] = p1;
	region[1] = p2;
	region[2] = p3;
	triangle->points = region;
	
	polygon->triangles = triangle;
	polygon->triangleCount = 1;
	
	return polygon;
}
BCAPolygon *BCAPolygonWithColorAndPoints4(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4) {
		return NULL;
}
BCAPolygon *BCAPolygonWithColorAndPoints5(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4, BCAPoint p5) {
		return NULL;
}
BCAPolygon *BCAPolygonWithColorAndPoints6(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4, BCAPoint p5, BCAPoint p6) {
		return NULL;
}
BCAPolygon *BCAPolygonWithColorAndPoints7(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4, BCAPoint p5, BCAPoint p6, BCAPoint p7) {
		return NULL;
}

BCAPolygon *BCAPolygonWithColorAndPoints8(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4, BCAPoint p5, BCAPoint p6, BCAPoint p7, BCAPoint p8) {
//	BCAPolygon *poly = nil;
//	
//	BCAPoint pt;
//	
//	NSMutableArray *points = [[NSMutableArray alloc] init];
//	
//	while ((pt = va_arg(ap, BCAPoint))) {
////		[points addObject:pt];
//	}
//	
//	va_end(ap);
//	
//	if ([points count] <= 2) {
//		// Cannot have a polygon with less than 3 points.
//		NSLog(@"ERROR.");
//		return nil;
//	}
//	
//	if ([points count] == 3) {
//		BCATriangle *triangle = [[BCATriangle alloc] initWithPoints:points];
//		triangle.color = c;
//		poly = triangle;
//		// allocate triangle
//	}
//	else if ([points count] == 4) {
//		BCARectangle *rectangle = [[BCARectangle alloc] initWithPoints:points];
//		poly = rectangle;
//		// allocate rectangle
//	}
//	else {
//		BCAPolygon *polygon = [[BCAPolygon alloc] initWithPoints:points];
//		poly = polygon;
//		// allocate polygon
//	}
//	
//	return poly;
	return NULL;
}

BCARenderingContext *BCACreateRenderingContextWithDimensions(float width, float height, float depth) {
	uint32_t *buffer = calloc(sizeof(uint32_t) * width * height * depth, 1);
	
	BCARenderingContext *context = calloc(sizeof(BCARenderingContext), 1);
	
	context->width = width;
	context->height = height;
	context->depth = depth;
	context->buffer = buffer;
	
	context->polygonCount = 0;
	
	return context;
}

void BCAAddPolygonToContext(BCARenderingContext *context, BCAPolygon *polygon) {
	if (!context->polygons) {
		context->polygons = calloc(sizeof(BCAPolygon *) * 5, 1); // extra space. Can be resized later.
		context->availableSpace = 5;
	}
	
	int placement = context->polygonCount;
	
	if (context->availableSpace > 0) {
		context->polygons[placement] = *polygon;
		context->polygonCount++;
		context->availableSpace--;
		// this is probably wrong.
	}
	
	else {
		NSLog(@"NEEDS RESIZE.");
		
	}
}

void BCASetPixelColorForBufferAtPoint(uint32_t *buffer, float width, float height, float depth, uint32_t color, BCAPoint point) {

	if (point.x > width	|| point.x < 0 || point.y > height || point.y < 0 || point.z > depth || point.z < 0) {
//		NSLog(@"BAD COORDINATES. %s", BCAStringFromPoint(point));
		return;
	}
	
	buffer[(int)(width * height) * (int)point.z + (int)point.y * (int)width + (int)point.x] = color;
}

void BCASetPixelColorForContextWithBufferAtPoint(BCARenderingContext *context, uint32_t *buffer, uint32_t color, BCAPoint point) {
	BCASetPixelColorForBufferAtPoint(buffer, context->width, context->height, context->depth, color, point);
}

void BCASetPixelColorForContextAtPoint(BCARenderingContext *context, uint32_t color, BCAPoint point) {
	BCASetPixelColorForContextWithBufferAtPoint(context, context->buffer, color, point);
}

void BCADrawLineWithContext (BCARenderingContext *context, BCAPoint p1, BCAPoint p2, uint32_t color) {
	
	if(p1.x > p2.x){
		BCAPoint tmp = p1;
		p1 = p2;
		p2 = tmp;
	}
	float slope = (-p2.y + p1.y) / (p2.x -p1.x);
	//NSLog(@"Slope %f", slope);
	if (p1.x == p2.x) {
		if(p1.y < p2.y){
			for (int i = p1.y; i < p2.y; i++) {
				BCAPoint newPoint = BCAPointMake(p1.x, i, 0);
				//NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForContextAtPoint(context, color, newPoint);
			}
		}
		else {
			for (int i = p2.y; i < p1.y; i++) {
				BCAPoint newPoint = BCAPointMake(p2.x, i, 0);
				//NSLog(@"Inserting. %@", newPoint);
				BCASetPixelColorForContextAtPoint(context, color, newPoint);
			}
		}
	}
	else if (p2.y - p1.y > 0) {
		for (double i = p2.x; i > p1.x; i = i - 0.5) {
			BCAPoint newPoint = BCAPointMake(i, fabs(slope * (i - p1.x) - p1.y), 0);
			
			//NSLog(@"Inserting. %@", newPoint);
			BCASetPixelColorForContextAtPoint(context, color, newPoint);
		}
	}
	else {
		for (double i = p1.x; i < p2.x; i = i + 0.5) {
			BCAPoint newPoint = BCAPointMake(i, fabs(slope * (i - p2.x) - p2.y), 0);
			//NSLog(@"Inserting. %@", newPoint);
			BCASetPixelColorForContextAtPoint(context, color, newPoint);
		}
	}
}

void BCAFillTriangleWithContext(BCAPoint p1, BCAPoint p2, BCAPoint p3, uint32_t color, BCARenderingContext *context) {
	
	BCAPoint tip;
	BCAPoint bottom1;
	BCAPoint bottom2;
	
	BCAPoint high;
	BCAPoint low;
	
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
//	NSLog(@"P1 %@", p1);
//	NSLog(@"P2 %@", p2);
//	NSLog(@"P3 %@", p3);
//	NSLog(@"HIGH %@", high);
//	NSLog(@"LOW %@", low);
//	NSLog(@"tip %@", tip);
//	NSLog(@"BOTTOM1 %@", bottom1);
//	NSLog(@"BOTTOM2 %@", bottom2);
	//when tip on top
	if (tip.x == high.x && tip.y == high.y) {
		float m1 = (-bottom1.y + high.y) / (bottom1.x - high.x);
		float m2 = (-bottom1.y + bottom2.y) / (bottom1.x - bottom2.x);
		float m3 = (-bottom2.y + high.y) / (bottom2.x - high.x);
//		
//		NSLog(@"m1 %f", m1);
//		NSLog(@"m2 %f", m2);
		
		for (int i = bottom1.x; i < bottom2.x; i++) {
			
			float j = fabsf((m2 * (i - bottom1.x) - bottom1.y));
			if (i < high.x) {
				while (j > fabsf(m1 * (i - bottom1.x) - bottom1.y)) {
					BCAPoint newPoint = BCAPointMake(i, j, 0);
					//NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForContextAtPoint(context, color, newPoint);
					j--;
				}
			}
			else {
				while (j > fabsf(m3 * (i - bottom2.x) - bottom2.y)) {
					BCAPoint newPoint = BCAPointMake(i, j, 0);
					//NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForContextAtPoint(context, color, newPoint);
					j--;
				}
			}
		}
		
	}
	
	//when tip on bot
	if (tip.x == low.x && tip.y == low.y) {
		float m1 = (-bottom1.y + low.y) / (bottom1.x - low.x);
		float m2 = (-bottom1.y + bottom2.y) / (bottom1.x - bottom2.x);
		float m3 = (-bottom2.y + low.y) / (bottom2.x - low.x);
//		
//		NSLog(@"m1 %f", m1);
//		NSLog(@"m2 %f", m2);
		
		for (int i = bottom1.x; i < bottom2.x; i++) {
			
			float j = fabsf((m2 * (i - bottom1.x) - bottom1.y));
			if (i < low.x) {
				while (j < fabsf(m1 * (i - bottom1.x) - bottom1.y)) {
					BCAPoint newPoint = BCAPointMake(i, j, 0);
					//NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForContextAtPoint(context, color, newPoint);
					j++;
				}
			}
			else {
				while (j < fabsf(m3 * (i - bottom2.x) - bottom2.y)) {
					BCAPoint newPoint = BCAPointMake(i, j, 0);
					//NSLog(@"Inserting. %@", newPoint);
					BCASetPixelColorForContextAtPoint(context, color, newPoint);
					j++;
				}
			}
		}
		
	}
}

uint32_t BCAGetPixelFromBufferWithSizeAtPoint(uint32_t *buffer, float width, float height, float depth, float x, float y, float z) {
	return buffer[(int)z * (int)(width * height) + (int)y * (int)width + (int)x];
}

uint32_t *BCAPixelBufferForRenderingContext(BCARenderingContext *context) {
	// This is where your turn comes in. :-)
	// allocate a uint32_t buffer of size context.width * context.height * sizeof(uint32_t)
	//uint32_t buffer = context.width * context.height * sizeof(float);
	// no
	uint32_t *buffer = calloc(sizeof(uint32_t) * (int)context->width * (int)context->height, 1);
	// make sense?

	// fills `buffer` with 0s. so every pixel is by default black.
	//					   rrggbbaa
	// FF = red = 255
	// FF = green = 255
	// 00 = blue = 0
	// FF = alpha = 255 (not transparent, opaque)
	
	BCATriangle *triangles = calloc(sizeof(BCATriangle) * context->polygonCount * 3, 1);
	// Probably a bad guess on size. Can be resized as needed later.
	int triangleCount = 0;
	
	for (int i = 0; i < context->polygonCount; i++) {
		BCAPolygon polygon = context->polygons[i];
		for (int j = 0; j < polygon.triangleCount; j++) {
			triangles[triangleCount] = polygon.triangles[j];
			triangleCount++;
		}
	}
	
	for (int i = 0; i < triangleCount; i++) {
		BCATriangle triangle = triangles[i];
		NSLog(@"triangle found with vertices (%f,%f,%f),(%f,%f,%f),(%f,%f,%f)", triangle.points[0].x, triangle.points[0].y, triangle.points[0].z, triangle.points[1].x, triangle.points[1].y, triangle.points[1].z, triangle.points[2].x, triangle.points[2].y, triangle.points[2].z);
		
		BCAPoint p1 = triangle.points[0];
		BCAPoint p2 = triangle.points[1];
		BCAPoint p3 = triangle.points[2];
		BCADrawLineWithContext(context, p1, p2, blueColor);
		BCADrawLineWithContext(context, p1, p3, blueColor);
		BCADrawLineWithContext(context, p2, p3, blueColor);
		
		BCAFillTriangleWithContext(p1, p2, p3, whiteColor, context);
	}
	

//	
//	for (BCATriangle *triangle in triangles) {
//		// Put blueColor in every spot where a triangle vertex is.
//		// Use either loop style.
//		NSArray *vertices = triangle.vertices;
//		
//		BCAPoint *p1 = vertices[0], *p2 = vertices[1], *p3 = vertices[2];
//		
//		BCADrawLineWithContext (context, p1, p2, context.pixelBuffer, blueColor);
//		BCADrawLineWithContext (context, p1, p3, context.pixelBuffer, blueColor);
//		BCADrawLineWithContext (context, p2, p3, context.pixelBuffer, blueColor);
//		
//		BCAFillTriangleWithContext(p1, p2, p3, triangle.color, context);
//
//		
//		for (BCAPoint *point in vertices) {
//			// nooppe
//			// use point.x and point.y and insert into `buffer`
//			// ok so this isn't entirely obvious because of the way it's done.
//			//			buffer[(int)point.y * (int)context.width + (int)point.x] = blueColor;
//			// This probably makes no sense. Right? It's ok. it'll make sense soon. ;-)
//			// try to fill in buffer with blueColor inside of the triangle. Start with the lines connecting the vertices :)
//			// actually, let's make this easier for you.
//			// now you can just insert (x,y) coordinates.
//			
//			BCASetPixelColorForContextAtPoint(context, 0xFFFFFFFF, point);
//			
//			// Ok! Now try to fill in points in the triangle, starrting with the permiters. :)
//			// You can declare the 3 points and do it outside of this loop if that will make it easier for you to do the math
//			
//		}
//	}
//	
	for (int z = context->depth - 1; z >= 0; z--) {
		for (int y = 0; y < context->height; y++) {
			for (int x = 0; x < context->width; x++) {
				uint32_t pixel = BCAGetPixelFromBufferWithSizeAtPoint(context->buffer, context->width, context->height, context->depth, x, y, z);
				
				uint8_t alpha = (uint8_t)pixel;


				if (alpha != 0) {
					BCASetPixelColorForBufferAtPoint(buffer, context->width, context->height, 0, pixel, BCAPointMake(x, y, 0));
				}
			}
		}
	}
//
//	// Let's test our code.
//	
	return buffer;
	
}