//
//  BCADrawingView.h
//  Boca
//
//  Created by Max Shavrick on 3/15/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCADrawingView : UIView
@property (nonatomic, assign) uint32_t *pixelBuffer;
@property (nonatomic, assign) uint16_t pixelBufferWidth;
@property (nonatomic, assign) uint16_t pixelBufferHeight;
@end
