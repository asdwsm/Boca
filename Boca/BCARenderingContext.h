//
//  BCARenderingContext.h
//  Boca
//
//  Created by Tom Zhu on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCAPoint, BCATriangle;
@interface BCARenderingContext : NSObject
@property (nonatomic, strong) BCAPoint *perspectiveLocation;
@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) float height;
@property (nonatomic, readonly) uint32_t *pixelBuffer;
// This will store all of our objects. We don't have any objects right now, so I don't know
// What data types will go in this class. 
- (instancetype)initWithWidth:(float)width height:(float)height;
- (void)addTriangle:(BCATriangle *)triangle;
- (NSArray *)_polygons;
@end
