//
//  engine.h
//  Boca
//
//  Created by Tom Zhu on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#ifndef engine_h
#define engine_h

#include <stdio.h>

#import "BCARenderingContext.h"
#import "BCATriangle.h"
#import "BCAPoint.h"

BCARenderingContext *BCACreateRenderingContextWithDimensions(float width, float height, float depth);
void BCAAddTriangleToContextWithVertices(BCARenderingContext *context, BCATriangle *vertices);
uint32_t *BCAPixelBufferForRenderingContext(BCARenderingContext *context);
#endif /* engine_h */
