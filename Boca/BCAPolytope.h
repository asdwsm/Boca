//
//  BCAPolytope.h
//  Boca
//
//  Created by Max Shavrick on 3/19/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCAPolytope;
BCAPolytope *BCAPolytopesWithPointsAndColor(uint32_t color, ...);

@interface BCAPolytope : NSObject
@property (nonatomic, strong) NSArray<BCAPolytope *> *polytopes;
- (NSArray *)triangles;
@end
