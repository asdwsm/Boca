//
//  BCAPoint.m
//  Boca
//
//  Created by Max Shavrick on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "BCAPoint.h"

BCAPoint *BCAPointMake(float x, float y) {
	BCAPoint *p = [BCAPoint pointWithXCoordinate:x yCoordinate:y];
	return p;
}

@implementation BCAPoint

+ (instancetype)pointWithXCoordinate:(float)x yCoordinate:(float)y {
	BCAPoint *point = [[BCAPoint alloc] init];
	point.x = x;
	point.y = y;
	return point;
}

- (instancetype)initWithXCoordinate:(float)x yCoordinate:(float)y {
	if ((self = [super init])) {
		self.x = x;
		self.y = y;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(%f, %f)", self.x, self.y];
}

@end
