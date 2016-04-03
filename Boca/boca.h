//
//  boca.h
//  Boca
//
//  Created by Max Shavrick on 3/21/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#ifndef boca_h
#define boca_h

// drre6375
typedef int BCAContextOrientation;

typedef struct BCAPoint {
	float x;
	float y;
	float z;
} BCAPoint;

typedef struct BCATriangle {
	BCAPoint *points;
	uint32_t color;
} BCATriangle;

typedef struct BCAPolygon {
	uint32_t color;
	struct BCATriangle *triangles;
	int triangleCount;
	//	struct BCAPolygon *polygons; for now, polygons can only contain triangles.
	//	int polygonCount;
} BCAPolygon; // immutable

typedef struct BCA3DTransform {
	float t11, t12, t13, t14; // [ a b c tx ]
	float t21, t22, t23, t24; // [ d e f ty ]
	float t31, t32, t33, t34; // [ g h i tz ]
	float t41, t42, t43, t44; // [ j k l 1  ]
} BCA3DTransform;

typedef struct BCARenderingContext {
	float width;
	float height;
	float depth;
	BCAPolygon *polygons;
	int polygonCount;
	int availableSpace;
	uint32_t *buffer;
	uint32_t *workingBuffer;
	BCAContextOrientation orientation;
	BCA3DTransform transform;
	double angle;
	char axis;
} BCARenderingContext; // internally mutable

BCAPolygon *BCAPolygonWithColorAndPoints3(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3);
BCAPolygon *BCAPolygonWithColorAndPoints4(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4);
BCAPolygon *BCAPolygonWithColorAndPoints5(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4, BCAPoint p5);
BCAPolygon *BCAPolygonWithColorAndPoints6(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4, BCAPoint p5, BCAPoint p6);
BCAPolygon *BCAPolygonWithColorAndPoints7(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4, BCAPoint p5, BCAPoint p6, BCAPoint p7);
BCAPolygon *BCAPolygonWithColorAndPoints8(uint32_t c, BCAPoint p1, BCAPoint p2, BCAPoint p3, BCAPoint p4, BCAPoint p5, BCAPoint p6, BCAPoint p7, BCAPoint p8);

__attribute__((always_inline)) inline BCAPoint BCAPointMake(float x, float y, float z) {
	BCAPoint p = {x,y,z};
	return p;
}

__attribute__((always_inline)) inline float BCAContextGetWidth(BCARenderingContext *context) {
	return context->width;
}
__attribute__((always_inline)) inline float BCAContextGetHeight(BCARenderingContext *context) {
	return context->height;
}
__attribute__((always_inline)) inline float BCAContextGetDepth(BCARenderingContext *context) {
	return context->depth;
}


#endif /* boca_h */
