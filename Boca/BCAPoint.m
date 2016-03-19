//
//  BCAPoint.m
//  Boca
//
//  Created by Max Shavrick on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "BCAPoint.h"

BCAPoint *BCAPointMake(float x, float y, float z) {
	BCAPoint *p = [BCAPoint pointWithXCoordinate:x yCoordinate:y zCoordinate:z];
	return p;
}

@implementation BCAPoint

+ (instancetype)pointWithXCoordinate:(float)x yCoordinate:(float)y zCoordinate:(float)z {
	BCAPoint *point = [[BCAPoint alloc] init];
	point.x = x;
	point.y = y;
	point.z = z;
	return point;
}

- (instancetype)initWithXCoordinate:(float)x yCoordinate:(float)y zCoordinate:(float)z {
	if ((self = [super init])) {
		self.x = x;
		self.y = y;
		self.z = z;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(%f, %f, %f)", self.x, self.y, self.z];
}

@end
