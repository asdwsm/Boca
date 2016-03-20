//
//  BCARectangle.m
//  Boca
//
//  Created by Max Shavrick on 3/19/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "BCARectangle.h"
#import "BCATriangle.h"

@implementation BCARectangle

- (instancetype)initWithPoints:(NSArray<BCAPoint *> *)points {
	if ((self = [super init])) {
		
		BCATriangle *triangle1 = [[BCATriangle alloc] initWithPoints:@[points[0], points[1], points[2]]];
		
		BCATriangle *triangle2 = [[BCATriangle alloc] initWithPoints:@[points[2], points[0], points[3]]];
		
		self.triangles = @[triangle1, triangle2];

		// Make triangles here.
		// self.triangles = ...
	}
	return self;
}

@end
