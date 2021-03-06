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
	triangle->color = c;
	
	polygon->triangles = triangle;
	polygon->triangleCount = 1;
	
	return polygon;
}


BCAPolytope *BCAAddPolygonToPolytope (uint32_t c, BCAPolygon *polygon1) {
	
	BCAPolytope *polytope = calloc(sizeof(BCAPolytope), 1);
	
	polytope->color = c;
	polytope->polygonCount = 1;
	polytope->polygon = polygon1;
	
	return polytope;
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
	uint32_t *buffer = calloc(sizeof(uint32_t) * width * height, 1);
	uint8_t *zMap = calloc(sizeof(uint8_t) * width * height, 1);
	
	BCARenderingContext *context = calloc(sizeof(BCARenderingContext), 1);
	
	context->width = width;
	context->height = height;
	context->depth = depth;
	context->buffer = buffer;
	context->zMap = zMap;
	
	context->polytopeCount = 0;
	
	return context;
}

void BCAAddPolytopeToContext(BCARenderingContext *context, BCAPolytope *polytope) {
	if (!context->polytope) {
		context->polytope = calloc(sizeof(BCAPolytope) * 5, 1); // extra space. Can be resized later.
		context->availableSpace = 5;
	}
	
	int placement = context->polytopeCount;
	
//	NSLog(@"Pg: %d, avail: %d", context->polygonCount, context->availableSpace);
	
	if (context->availableSpace > 0) {
		context->polytope[placement] = *polytope;
		context->polytopeCount++;
		context->availableSpace--;
		// this is probably wrong.
	}
	
	else {
		// Off-by-one errors most likely exist in this whole scheme. ;p
		context->polytope->polygon = realloc(context->polytope, sizeof(BCAPolytope) * (context->polytopeCount + 5));
		context->polytopeCount++;
		context->availableSpace += 4;
		context->polytope[placement] = *polytope;
	}
}

__attribute__((always_inline)) inline void BCASetPixelColorForBufferAtPointNoTransform(BCARenderingContext *context, uint32_t *buffer, float width, float height, float depth, uint32_t color, BCAPoint point) {
	if (point.x > width	|| point.x < 0.0f || point.y > height || point.y < 0.0f || point.z > depth || point.z < 0.0f) {
//		NSLog(@"depth %f", depth);
//		NSLog(@"t31 %f", context->transform.t31);
//		NSLog(@"t32 %f", context->transform.t32);
//		NSLog(@"t33 %f", context->transform.t33);
//		NSLog(@"x y z %f %f %f", point.x, point.y, point.z);
		return;
	}
	
	int offset = (int)point.y * (int)width + (int)point.x;
	
	uint8_t *zMap = context->zMap;
	
	uint8_t zVal = zMap[offset];
	
	if (zVal == 0 || point.z <= zVal) {
		buffer[(int)point.y * (int)width + (int)point.x] = color;
	}
	
	zMap[offset] = point.z;

}

__attribute__((always_inline)) inline void BCASetPixelColorForContextAtPoint(BCARenderingContext *context, uint32_t *buffer, float width, float height, float depth, uint32_t color, BCAPoint point) {
	
	float newX = fabs(point.x * context->transform.t11 - point.y * context->transform.t12 + point.z * context->transform.t13);
	float newY = fabs(point.x * context->transform.t21 - point.y * context->transform.t22 + point.z * context->transform.t23);
	float newZ = fabs(point.x * context->transform.t31 - point.y * context->transform.t32 + point.z * context->transform.t33);
	
	point.x = newX;
	point.y = newY;
	point.z = newZ;
	
	BCASetPixelColorForBufferAtPointNoTransform(context, buffer, width, height, depth, color, point);
}

void BCADrawLineWithContext (BCARenderingContext *context, BCAPoint p1, BCAPoint p2, uint32_t color) {
	float n = 400.0;
	float incrementX = (p2.x - p1.x) / n;
	float incrementY = (-p2.y + p1.y) / n;
	float incrementZ = (p2.z - p1.z) / n;
	
	//NSLog(@"Drawing");
	//NSLog(@"incrementX %f", incrementX);
	//NSLog(@"incrementY %f", incrementY);
	//NSLog(@"incrementZ %f", incrementZ);
	
	float startX = p1.x;
	float startY = -p1.y;
	float startZ = p1.z;
	int incrementTimes = 0;
	
	while (incrementTimes != n) {
		BCAPoint newPoint = BCAPointMake(startX, fabsf(startY), startZ);
		//NSLog(@"Point %f %f %f", newPoint.x, newPoint.y, newPoint.z);
		BCASetPixelColorForContextAtPoint(context, context->buffer, context->width, context->height, context->depth, color, newPoint);
		startX = startX + incrementX;
		startY = startY + incrementY;
		startZ = startZ + incrementZ;
		incrementTimes++;
	}
}

BCAPoint BCACrossProduct(BCAPoint a, BCAPoint b) {
	BCAPoint crossProduct = BCAPointMake((a.y * b.z - a.z * b.y), (a.z * b.x - a.x * b.z), (a.x * b.y - a.y * b.x));
	return crossProduct;
	// good job tommy
}

void BCAFillTriangleWithContext(BCAPoint p1, BCAPoint p2, BCAPoint p3, uint32_t color, BCARenderingContext *context) {
	
	
	BCADrawLineWithContext(context, p1, p2, whiteColor);
	BCADrawLineWithContext(context, p2, p3, whiteColor);
	BCADrawLineWithContext(context, p3, p1, whiteColor);
	
	BCAPoint max, middle, min;
	
	float n = 500.0;
	
	if (p1.x == p2.x) {
		if (p1.x > p3.x) {
			min = p3;
			max = p1;
			middle = p2;
			
			float incrementXMinToMax = (max.x - min.x) / n;
			float incrementYMinToMax = (-max.y + min.y) / n;
			float incrementZMinToMax = (max.z - min.z) / n;
			
			float incrementYMinToMiddle = (-middle.y + min.y) / n;
			float incrementZMinToMiddle = (middle.z - min.z) / n;
			
			float startX = min.x;
			float startY1 = min.y;
			float startZ1 = min.z;
			float startY2 = min.y;
			float startZ2 = min.z;
		
			while (startX <= max.x) {
				BCAPoint newPoint1 = BCAPointMake(startX, fabsf(startY1), startZ1);
				BCAPoint newPoint2 = BCAPointMake(startX, fabsf(startY2), startZ2);
				
				startX += incrementXMinToMax;
				startY1 -= incrementYMinToMax;
				startY2 -= incrementYMinToMiddle;
				startZ1 += incrementZMinToMax;
				startZ2 += incrementZMinToMiddle;
				
				BCADrawLineWithContext(context, newPoint1, newPoint2, color);
				
			}
			return;
		}
		else {
			min = p1;
			middle = p2;
			max = p3;
			
			float incrementXMinToMax = (max.x - min.x) / n;
			float incrementYMinToMax = (-max.y + min.y) / n;
			float incrementZMinToMax = (max.z - min.z) / n;
			
			float incrementYMiddleToMax = (-max.y + middle.y) / n;
			float incrementZMiddleToMax = (max.z - middle.z) / n;
			
			float startX = min.x;
			float startY1 = min.y;
			float startZ1 = min.z;
			float startY2 = middle.y;
			float startZ2 = middle.z;
			
//			NSLog(@"middle.y %f", middle.y);
//			NSLog(@"min.x %f", min.x);
			
			while (startX <= max.x) {
				BCAPoint newPoint1 = BCAPointMake(startX, fabsf(startY1), startZ1);
				BCAPoint newPoint2 = BCAPointMake(startX, fabsf(startY2), startZ2);
				
				startX += incrementXMinToMax;
				startY1 -= incrementYMinToMax;
				startY2 -= incrementYMiddleToMax;
				startZ1 += incrementZMinToMax;
				startZ2 += incrementZMiddleToMax;
				
				BCADrawLineWithContext(context, newPoint1, newPoint2, color);
				
			}
			return;
		}
	}
	
	if (p1.x == p3.x) {
		if (p1.x > p2.x) {
			min = p2;
			max = p1;
			middle = p3;
			
			float incrementXMinToMax = (max.x - min.x) / n;
			float incrementYMinToMax = (-max.y + min.y) / n;
			float incrementZMinToMax = (max.z - min.z) / n;
			
			float incrementYMinToMiddle = (-middle.y + min.y) / n;
			float incrementZMinToMiddle = (middle.z - min.z) / n;
			
			float startX = min.x;
			float startY1 = min.y;
			float startZ1 = min.z;
			float startY2 = min.y;
			float startZ2 = min.z;
			
			while (startX <= max.x) {
				BCAPoint newPoint1 = BCAPointMake(startX, fabsf(startY1), startZ1);
				BCAPoint newPoint2 = BCAPointMake(startX, fabsf(startY2), startZ2);
				
				startX += incrementXMinToMax;
				startY1 -= incrementYMinToMax;
				startY2 -= incrementYMinToMiddle;
				startZ1 += incrementZMinToMax;
				startZ2 += incrementZMinToMiddle;
				
				BCADrawLineWithContext(context, newPoint1, newPoint2, color);
				
			}
			return;
		}
		else {
			min = p1;
			middle = p3;
			max = p2;
			
			float incrementXMinToMax = (max.x - min.x) / n;
			float incrementYMinToMax = (-max.y + min.y) / n;
			float incrementZMinToMax = (max.z - min.z) / n;
			
			float incrementYMiddleToMax = (-max.y + middle.y) / n;
			float incrementZMiddleToMax = (max.z - middle.z) / n;
			
			float startX = min.x;
			float startY1 = min.y;
			float startZ1 = min.z;
			float startY2 = middle.y;
			float startZ2 = middle.z;
			
//			NSLog(@"middle.y %f", middle.y);
//			NSLog(@"min.x %f", min.x);
			
			while (startX <= max.x) {
				BCAPoint newPoint1 = BCAPointMake(startX, fabsf(startY1), startZ1);
				BCAPoint newPoint2 = BCAPointMake(startX, fabsf(startY2), startZ2);
				
				startX += incrementXMinToMax;
				startY1 -= incrementYMinToMax;
				startY2 -= incrementYMiddleToMax;
				startZ1 += incrementZMinToMax;
				startZ2 += incrementZMiddleToMax;
				
				BCADrawLineWithContext(context, newPoint1, newPoint2, color);
				
			}
			return;
		}
	}
	
	if (p2.x == p3.x) {
		if (p2.x > p1.x) {
			min = p1;
			max = p2;
			middle = p3;
			
			float incrementXMinToMax = (max.x - min.x) / n;
			float incrementYMinToMax = (-max.y + min.y) / n;
			float incrementZMinToMax = (max.z - min.z) / n;
			
			float incrementYMinToMiddle = (-middle.y + min.y) / n;
			float incrementZMinToMiddle = (middle.z - min.z) / n;
			
			float startX = min.x;
			float startY1 = min.y;
			float startZ1 = min.z;
			float startY2 = min.y;
			float startZ2 = min.z;
			
			while (startX <= max.x) {
				BCAPoint newPoint1 = BCAPointMake(startX, fabsf(startY1), startZ1);
				BCAPoint newPoint2 = BCAPointMake(startX, fabsf(startY2), startZ2);
				
				startX += incrementXMinToMax;
				startY1 -= incrementYMinToMax;
				startY2 -= incrementYMinToMiddle;
				startZ1 += incrementZMinToMax;
				startZ2 += incrementZMinToMiddle;
				
				BCADrawLineWithContext(context, newPoint1, newPoint2, color);
				
			}
			return;
		}
		else {
			min = p2;
			middle = p3;
			max = p1;
			
			float incrementXMinToMax = (max.x - min.x) / n;
			float incrementYMinToMax = (-max.y + min.y) / n;
			float incrementZMinToMax = (max.z - min.z) / n;
			
			float incrementYMiddleToMax = (-max.y + middle.y) / n;
			float incrementZMiddleToMax = (max.z - middle.z) / n;
			
			float startX = min.x;
			float startY1 = min.y;
			float startZ1 = min.z;
			float startY2 = middle.y;
			float startZ2 = middle.z;
			
//			NSLog(@"middle.y %f", middle.y);
//			NSLog(@"min.x %f", min.x);
			
			while (startX <= max.x) {
				BCAPoint newPoint1 = BCAPointMake(startX, fabsf(startY1), startZ1);
				BCAPoint newPoint2 = BCAPointMake(startX, fabsf(startY2), startZ2);
				
				startX += incrementXMinToMax;
				startY1 -= incrementYMinToMax;
				startY2 -= incrementYMiddleToMax;
				startZ1 += incrementZMinToMax;
				startZ2 += incrementZMiddleToMax;
				
				BCADrawLineWithContext(context, newPoint1, newPoint2, color);
				
			}
			return;
		}
	}

	
	if (p1.x == p3.x) {
		if (p1.x > p2.x) {
			min = p2;
			max = p1;
			middle = p3;
		}
		else {
			min = p1;
			middle = p3;
			max = p2;
		}
	}
	
	if (p2.x == p3.x) {
		if (p2.x > p1.x) {
			min = p1;
			max = p2;
			middle = p3;
		}
		else {
			min = p2;
			middle = p3;
			max = p1;
		}
	}
	
	
	if (p1.x > p2.x && p1.x > p3.x) {
		max = p1;
		if (p2.x > p3.x) {
			min = p3;
			middle = p2;
		}
		else {
			min = p2;
			middle = p3;
		}
	}
	
	if (p2.x > p1.x && p2.x > p3.x) {
		max = p2;
		if (p1.x > p3.x) {
			min = p3;
			middle = p1;
		}
		else {
			min = p1;
			middle = p3;
		}
	}
	
	if (p3.x > p1.x && p3.x > p2.x) {
		max = p3;
		if (p1.x > p2.x) {
			min = p2;
			middle = p1;
		}
		else {
			min = p1;
			middle = p2;
		}
	}
	
//	NSLog(@"p1: %f %f %f", p1.x, p1.y, p1.z);
//	NSLog(@"p2: %f %f %f", p2.x, p2.y, p2.z);
//	NSLog(@"p3: %f %f %f", p3.x, p3.y, p3.z);

	
	float minToMiddleX = (middle.x - min.x) / n;
	float minToMiddleY = (-middle.y + min.y) / n;
	float minToMiddleZ = (middle.z - min.z) / n;
	
	//float minToMaxX = (max.x - min.x) / 200.0;
	float minToMaxY = (-max.y + min.y) / (n / (middle.x - min.x) * (max.x - min.x));
	float minToMaxZ = (middle.z - min.z) / (n / (middle.x - min.x) * (max.x - min.x));
	
	float minToMaxY2 = (-max.y + min.y) / (n / (max.x - middle.x) * (max.x - min.x));
	float minToMaxZ2 = (max.z - min.z) / (n / (max.x - middle.x) * (max.x - min.x));
	
	float middleToMaxX = (max.x - middle.x) / n;
	float middleToMaxY = (-max.y + middle.y) / n;
	float middleToMaxZ = (max.z - middle.z) / n;
	
	float startX = min.x;
	float startMinY1 = min.y;
	float startMinY2 = min.y;
	float startMinZ1 = min.z;
	float startMinZ2 = min.z;
	
	while (startX <= middle.x) {
		BCAPoint newPoint1 = BCAPointMake(startX, fabsf(startMinY1), startMinZ1);
		BCAPoint newPoint2 = BCAPointMake(startX, fabsf(startMinY2), startMinZ2);
		
		startX += minToMiddleX;
		startMinY1 -= minToMiddleY;
		startMinY2 -= minToMaxY;
		startMinZ1 += minToMiddleZ;
		startMinZ2 += minToMaxZ;
		
		BCADrawLineWithContext(context, newPoint1, newPoint2, color);
	}
	
	while (startX <= max.x) {
		BCAPoint newPoint1 = BCAPointMake(startX, fabsf(startMinY1), startMinZ1);
		BCAPoint newPoint2 = BCAPointMake(startX, fabsf(startMinY2), startMinZ2);
		
		startX += middleToMaxX;
		startMinY1 -= middleToMaxY;
		startMinY2 -= minToMaxY2;
		startMinZ1 += middleToMaxZ;
		startMinZ2 += minToMaxZ2;
		
		
		BCADrawLineWithContext(context, newPoint1, newPoint2, color);
	}
}

__attribute__((always_inline)) inline uint32_t BCAGetPixelFromBufferWithSizeAtPoint(uint32_t *buffer, float width, float height, float depth, float x, float y, float z) {
	return buffer[(int)z * (int)(width * height) + (int)y * (int)width + (int)x];
}

BCAPoint BCAPerspectiveTransformationAround (BCAPoint point, double angle, char axis) {
	BCAPoint newPoint;
	if (axis  == 'X') {
		double val = M_PI / 180.0;
		
		newPoint = BCAPointMake(fabs(point.x), fabs(cos(angle * val) * -point.y - sin(angle * val) * point.z), fabs(sin(angle * val) * -point.y + cos(angle * val) * point.z));
	}
	else if (axis == 'Y') {
		double val = M_PI / 180.0;
		
		newPoint = BCAPointMake(fabs(cos(angle * val) * point.x + sin(angle * val) * point.z), fabs(-point.y), fabs(-sin(angle * val) * point.x + cos(angle * val) * point.z));
	}
	else if (axis == 'Z') {
		double val = M_PI / 180.0;
		
		newPoint = BCAPointMake(fabs(cos(angle * val) * point.x - sin(angle * val) * -point.y), fabs(sin(angle * val) * point.x + cos(angle * val) * -point.y), point.z);
	}
	
	return  newPoint;
}

void BCASetTransformMake (BCARenderingContext *context, double angle, char axis){
	
	//float t11, t12, t13, t14; // [ a b c tx ]
	//float t21, t22, t23, t24; // [ d e f ty ]
	//float t31, t32, t33, t34; // [ g h i tz ]
	//float t41, t42, t43, t44; // [ j k l 1  ]
	
	double val = M_PI / 180.0;
	
	if (axis == 'X') {
		context->transform.t11 = 1;
		context->transform.t12 = 0;
		context->transform.t13 = 0;
		context->transform.t14 = 0;
		context->transform.t21 = 0;
		context->transform.t22 = cos(angle * val);
		context->transform.t23 = -sin(angle * val);
		context->transform.t24 = 0;
		context->transform.t31 = 0;
		context->transform.t32 = sin(angle * val);
		context->transform.t33 = cos(angle * val);
		context->transform.t34 = 0;
		context->transform.t41 = 0;
		context->transform.t42 = 0;
		context->transform.t43 = 0;
		context->transform.t44 = 1;
	}
	else if (axis == 'Y') {
		context->transform.t11 = cos(angle * val);
		context->transform.t12 = 0;
		context->transform.t13 = sin(angle * val);
		context->transform.t14 = 0;
		context->transform.t21 = 0;
		context->transform.t22 = 1;
		context->transform.t23 = 0;
		context->transform.t24 = 0;
		context->transform.t31 = -sin(angle * val);
		context->transform.t32 = 0;
		context->transform.t33 = cos(angle * val);
		context->transform.t34 = 0;
		context->transform.t41 = 0;
		context->transform.t42 = 0;
		context->transform.t43 = 0;
		context->transform.t44 = 1;
	}
	else if (axis == 'Z') {
		context->transform.t11 = cos(angle * val);
		context->transform.t12 = -sin(angle * val);
		context->transform.t13 = 0;
		context->transform.t14 = 0;
		context->transform.t21 = sin(angle * val);
		context->transform.t22 = cos(angle * val);
		context->transform.t23 = 0;
		context->transform.t24 = 0;
		context->transform.t31 = 0;
		context->transform.t32 = 0;
		context->transform.t33 = 1;
		context->transform.t34 = 0;
		context->transform.t41 = 0;
		context->transform.t42 = 0;
		context->transform.t43 = 0;
		context->transform.t44 = 1;
	}
	else {
		NSLog(@"Wrong corrdinates");
	}
	
}

//void BCAContextTransform(BCARenderingContext *context, BCA3DTransform newTransform) {
//	
//	
//	context->width = fabs(context->width * newTransform.t11 + context->height * newTransform.t12 + context->depth * newTransform.t13);
//	context->height = fabs(context->width * newTransform.t21 + context->height * newTransform.t22 + context->depth * newTransform.t23);
//	context->depth = fabs(context->width * newTransform.t31 + context->height * newTransform.t32 + context->depth * newTransform.t33);
//	
//	NSLog(@"width %f", context->width);
//	NSLog(@"height %f", context->height);
//	NSLog(@"depth %f", context->depth);
//	
//	
//	//BCARenderingContext *newContext = BCACreateRenderingContextWithDimensions(width, height, depth);
//	
//	//return newContext;
//}


uint32_t *BCAPixelBufferForRenderingContext(BCARenderingContext *context)
{
	// This is where your turn comes in. :-)
	// allocate a uint32_t buffer of size context.width * context.height * sizeof(uint32_t)
	//uint32_t buffer = context.width * context.height * sizeof(float);
	// no
	uint32_t *buffer = context->buffer;
	memset(buffer, '\0', sizeof(uint32_t) * context->width * context->height);
	memset(context->zMap, '\0', sizeof(uint8_t) * context->width * context->height);
	// make sense?

	// fills `buffer` with 0s. so every pixel is by default black.
	//					   rrggbbaa
	// FF = red = 255
	// FF = green = 255
	// 00 = blue = 0
	// FF = alpha = 255 (not transparent, opaque)
	
	
	for (int i = 0; i < context->polytopeCount; i++) {
		BCAPolytope polytope = context->polytope[i];
		
		for (int k = 0; k < polytope.polygonCount; k++) {
			BCAPolygon polygon = polytope.polygon[k];
			
			for (int j = 0; j < polytope.polygonCount; j++) {
				
				BCATriangle triangle = polygon.triangles[j];
				
				//BCAPoint p1 = triangle.points[0];
				
				BCAPoint p1 = BCAPerspectiveTransformationAround(triangle.points[0], context->angle, context->axis);
				triangle.points[0] = BCAPerspectiveTransformationAround(triangle.points[0], context->angle, context->axis);
				BCAPoint p2 = BCAPerspectiveTransformationAround(triangle.points[1], context->angle, context->axis);
				triangle.points[1] = BCAPerspectiveTransformationAround(triangle.points[1], context->angle, context->axis);
				BCAPoint p3 = BCAPerspectiveTransformationAround(triangle.points[2], context->angle, context->axis);
				triangle.points[2] = BCAPerspectiveTransformationAround(triangle.points[2], context->angle, context->axis);
				
				//			BCAPoint p2 = triangle.points[1];
				//			BCAPoint p3 = triangle.points[2];
				//BCADrawLineWithContext(context, p1, p2, blueColor);
				//BCADrawLineWithContext(context, p1, p3, blueColor);
				//BCADrawLineWithContext(context, p2, p3, blueColor);
				
				BCAFillTriangleWithContext(p1, p2, p3, triangle.color, context);
				
				
			}
			
		}
		
		
	}
	
//	double angle = 0.0;
//	
	BCAPoint p1 = BCAPointMake(100, 100, 50);
	BCAPoint p2 = BCAPointMake(100, 200, 50);
	BCAPoint p3 = BCAPointMake(120, 150, 0);
	p1 = BCAPerspectiveTransformationAround(p1, context->angle, context->axis);
	p2 = BCAPerspectiveTransformationAround(p2, context->angle, context->axis);
	p3 = BCAPerspectiveTransformationAround(p3, context->angle, context->axis);
	
	BCAFillTriangleWithContext(p1, p2, p3, blueColor, context);
	
//	NSLog(@"p1: %f %f %f", BCAPerspectiveTransformationAroundY(p1, 90.0).x, BCAPerspectiveTransformationAroundY(p1, 90.0).y, BCAPerspectiveTransformationAroundY(p1, 90.0).z);
//	NSLog(@"p2: %f %f %f", BCAPerspectiveTransformationAroundX(p2, 90.0).x, BCAPerspectiveTransformationAroundY(p2, 90.0).y, BCAPerspectiveTransformationAroundY(p2, 90.0).z);
//	NSLog(@"p3: %f %f %f", BCAPerspectiveTransformationAroundX(p3, 90.0).x, BCAPerspectiveTransformationAroundY(p3, 90.0).y, BCAPerspectiveTransformationAroundY(p3, 90.0).z);
	
//BCASetPixelColorForContextAtPoint(context, whiteColor, BCAPerspectiveTransformationAroundX(p1));
	//BCASetPixelColorForContextAtPoint(context, whiteColor, BCAPerspectiveTransformationAroundX(p2));
	//BCASetPixelColorForContextAtPoint(context, whiteColor, BCAPerspectiveTransformationAroundX(p3));
	//BCAFillTriangleWithContext(p1, p2, p3, blueColor, context);
//	BCAFillTriangleWithContext(p1, p2, p3, blueColor, context);
	
//	BCAPoint p4 = BCAPointMake(120, 100, 50);
//	BCAPoint p5 = BCAPointMake(120, 200, 50);
//	BCAPoint p6 = BCAPointMake(10, 150, 0);
//	
//	BCASetPixelColorForContextAtPoint(context, whiteColor, p4);
//	BCASetPixelColorForContextAtPoint(context, whiteColor, p5);
//	BCASetPixelColorForContextAtPoint(context, whiteColor, p6);
//
//	
//	BCAFillTriangleWithContext(p4, p5, p6, whiteColor, context);
	

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
//	
//	float baseOffy = (BCAContextGetHeight(context)/2 - BCAContextGetDepth(context)/2);
//	
//	for (int y = 0; y < BCAContextGetHeight(context); y++) {
//		for (int z = 0; z < BCAContextGetDepth(context); z++) {
//			for (int x = 0; x < BCAContextGetWidth(context); x++) {
//				uint32_t pixel = BCAGetPixelFromBufferWithSizeAtPoint(context->buffer, BCAContextGetWidth(context), BCAContextGetHeight(context), BCAContextGetDepth(context), x, y, z);
//				
//				uint8_t alpha = pixel;
//				if (alpha != 0) {
//					BCASetPixelColorForBufferAtPoint(buffer, BCAContextGetWidth(context), BCAContextGetHeight(context), BCAContextGetDepth(context), pixel, BCAPointMake(x, baseOffy + z, 0));
//				}
//			}
//		}
//	}
//
//	
//normal perspective –
//	for (int z = context->depth - 1; z >= 0; z--) {
//		for (int y = 0; y < context->height; y++) {
//			for (int x = 0; x < context->width; x++) {
//				uint32_t pixel = BCAGetPixelFromBufferWithSizeAtPoint(context->buffer, context->width, context->height, context->depth, x, y, z);
//	
//
//				uint8_t alpha = (uint8_t)pixel;
//				if (alpha != 0) {
//					BCASetPixelColorForBufferAtPointNoTransform(context, buffer, context->width, context->height, context->depth, pixel, BCAPointMake(x, y, 0));
//				}
//			}
//		}
//	}

//	// Let's test our code.
//	
	return buffer;
	
}