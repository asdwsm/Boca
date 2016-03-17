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

- (instancetype)initWithWidth:(float)width height:(float)height {
	if ((self = [super init])) {
		polygons = [[NSMutableArray alloc] init];
		_width = width;
		_height = height;
		// Where should the default perspective be? (0,0)?
		self.perspectiveLocation = [BCAPoint pointWithXCoordinate:0 yCoordinate:0];
	}
	return self;
}

- (void)addTriangle:(BCATriangle *)triangle {
	[polygons addObject:triangle];
}

- (NSArray *)_polygons {
	return polygons;
}

@end
