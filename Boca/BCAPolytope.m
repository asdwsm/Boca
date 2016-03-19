//
//  BCAPolytope.m
//  Boca
//
//  Created by Max Shavrick on 3/19/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "BCAPolytope.h"
#import "BCAPoint.h"

@implementation BCAPolytope

- (NSArray *)triangles {
	NSMutableArray *triangles = [[NSMutableArray alloc] init];
	
	for (BCAPolytope *tope in self.polytopes) {
		[triangles addObjectsFromArray:[tope triangles]];
	}
	
	return triangles;
}

@end
