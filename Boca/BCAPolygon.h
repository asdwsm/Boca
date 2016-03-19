//
//  BCAPolygon.h
//  Boca
//
//  Created by Max Shavrick on 3/19/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "BCAPolytope.h"

@class BCAPolygon, BCATriangle, BCAPoint;

BCAPolygon *BCAPolygonWithColorAndPoints(uint32_t c, ...);

@interface BCAPolygon : BCAPolytope
// Perhaps a polygon can have multiple polygons.
// Maybe not. This works fine for now.
@property (nonatomic, strong) NSArray<BCATriangle *> *triangles;
- (instancetype)initWithPoints:(NSArray<BCAPoint *> *)points;
@end
