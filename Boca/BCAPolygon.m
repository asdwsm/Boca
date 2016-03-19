//
//  BCAPolygon.m
//  Boca
//
//  Created by Max Shavrick on 3/19/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "BCAPolygon.h"
#import "BCAPoint.h"
#import "BCATriangle.h"
#import "BCARectangle.h"

BCAPolygon *BCAPolygonWithColorAndPoints(uint32_t c, ...) {
	va_list ap;
	va_start(ap, c);
	
	BCAPolygon *poly = nil;
	
	BCAPoint *pt = nil;
	
	NSMutableArray *points = [[NSMutableArray alloc] init];
	
	while ((pt = va_arg(ap, id))) {
		[points addObject:pt];
	}
	
	va_end(ap);
	
	if ([points count] <= 2) {
		// Cannot have a polygon with less than 3 points.
		NSLog(@"ERROR.");
		return nil;
	}
	
	if ([points count] == 3) {
		BCATriangle *triangle = [[BCATriangle alloc] initWithPoints:points];
		poly = triangle;
		// allocate triangle
	}
	else if ([points count] == 4) {
		BCARectangle *rectangle = [[BCARectangle alloc] initWithPoints:points];
		poly = rectangle;
		// allocate rectangle
	}
	else {
		BCAPolygon *polygon = [[BCAPolygon alloc] initWithPoints:points];
		poly = polygon;
		// allocate polygon
	}
	
	return poly;
}

@implementation BCAPolygon

- (instancetype)initWithPoints:(NSArray<BCAPoint *> *)points {
	if ((self = [super init])) {
		// make triangles here. self.triangles = ...
	}
	return self;
}

@end
