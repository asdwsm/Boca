//
//  BCATriangle.m
//  Boca
//
//  Created by Max Shavrick on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "BCATriangle.h"

@implementation BCATriangle

- (instancetype)initWithPoints:(NSArray<BCAPoint *> *)points {
	if ((self = [super init])) {
		self.vertices = points;
		self.color = 0xFFFFFFFF;
	}
	return self;
}

- (NSArray *)triangles {
	return @[self];
}

@end
