//
//  BCATriangle.h
//  Boca
//
//  Created by Max Shavrick on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCAPolygon.h"

@class BCAPoint;
@interface BCATriangle : BCAPolygon
// Triangle has 3 points, so let's define an array for the points
@property (nonatomic, strong) NSArray<BCAPoint *> *vertices;
@property (nonatomic, assign) uint32_t color;
// - (instancetype)init is here by default.
@end
