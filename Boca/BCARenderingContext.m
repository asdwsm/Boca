//
//  BCARenderingContext.m
//  Boca
//
//  Created by Tom Zhu on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "BCARenderingContext.h"
#import "BCAPoint.h"
#import "BCATriangle.h"

@implementation BCARenderingContext {
	NSMutableArray *polygons;
}

- (instancetype)initWithWidth:(float)width height:(float)height depth:(float)depth {
	if ((self = [super init])) {
		polygons = [[NSMutableArray alloc] init];
		_width = width;
		_height = height;
		_depth = depth;
		// Where should the default perspective be? (0,0)?
		self.perspectiveLocation = [BCAPoint pointWithXCoordinate:0 yCoordinate:0 zCoordinate:0];
		_pixelBuffer = malloc(sizeof(uint32_t) * (int)width * (int)height * (int)depth);
		bzero(_pixelBuffer, sizeof(uint32_t) * (int)width * (int)height * (int)depth);
	}
	return self;
}

- (void)addPolygon:(BCAPolygon *)poly {
	[polygons addObject:poly];
}

- (NSArray *)_polygons {
	return polygons;
}

@end
