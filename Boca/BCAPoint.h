//
//  BCAPoint.h
//  Boca
//
//  Created by Max Shavrick on 3/16/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCAPoint;
BCAPoint *BCAPointMake(float x, float y);

@interface BCAPoint : NSObject
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
+ (instancetype)pointWithXCoordinate:(float)x yCoordinate:(float)y;
- (instancetype)initWithXCoordinate:(float)x yCoordinate:(float)y;
/* + Specifies class method. - speicfies instance method. */
/* Example: [BCAPoint pointWithXCoordinate:...]
	or BCAPoint *point = [[BCAPoint alloc] initWithXCoordinate:...]
		[point flip]; √
		[point pointWithXCoordinate:..] x 
 */
@end
