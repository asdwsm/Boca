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
#include "boca.h"

BCARenderingContext *BCACreateRenderingContextWithDimensions(float width, float height, float depth);
void BCAAddPolygonToContext(BCARenderingContext *context, BCAPolygon *polygon);
uint32_t *BCAPixelBufferForRenderingContext(BCARenderingContext *context);
#endif /* engine_h */
