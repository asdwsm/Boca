//
//  ViewController.m
//  Boca
//
//  Created by Max Shavrick on 3/15/16.
//  Copyright © 2016 mxms. All rights reserved.
//

#import "ViewController.h"
#import "BCADrawingView.h"
#import "engine.h"

@implementation ViewController {
	BCADrawingView *drawingView;
	BCARenderingContext *context;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	drawingView = [[BCADrawingView alloc] init];
	[self.view addSubview:drawingView];
	[drawingView setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
	
	CGFloat bufferWidth = (drawingView.frame.size.width);
	CGFloat bufferHeight = (drawingView.frame.size.height);
	
	NSLog(@"(w:%f, h:%f)", bufferWidth, bufferHeight);
	
	[drawingView setPixelBufferWidth:bufferWidth];
	[drawingView setPixelBufferHeight:bufferHeight];
	
	
	// This is just an example. The rendering engine will give us an uint32_t buffer every 1/60th of second
	// Which will only be new if something has changed. (Marked "Dirty")
	
	context = BCACreateRenderingContextWithDimensions(bufferWidth, bufferHeight, 100);

	for (int i = 0; i < 2; i++)
		[self pushRandomTriangle];
//	for (int i = 0; i < 300; i++) {
//		[self pushRandomRectangle];
//	}
//	[self pushRandomTriangleWithDifferentZ];
	
	uint32_t *buffer = BCAPixelBufferForRenderingContext(context);
	// this probably won't work first try ;P
	// Cool , it did. lol
	
	[drawingView setPixelBuffer:buffer];
	
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)pushRandomRectangle {
	int width = (int)BCAContextGetWidth(context);
	int height = (int)BCAContextGetHeight(context);
	int ranX = arc4random() % (width - 1);
	int ranY = arc4random() % (height - 1);
	
	BCAPoint p = BCAPointMake(ranX, ranY, 0);

	int ranWidth = arc4random() % (width - ranX - 1);
	int ranHeight = arc4random() % (height - ranY - 1);
	
	BCAPoint bottomLeft = BCAPointMake(p.x, p.y + ranHeight, 0);
	BCAPoint bottomRight = BCAPointMake(p.x + ranWidth, p.y + ranHeight, 0);
	BCAPoint topRight = BCAPointMake(p.x + ranWidth, p.y, 0);
	
//	NSLog(@"(%f,%f,%f)(%f,%f,%f)(...)", p.x,)
	
	BCAPolygon *triangle = BCAPolygonWithColorAndPoints4(0xFF0000FF, p, bottomLeft, bottomRight, topRight);
	
	BCAAddPolygonToContext(context, triangle);
}

- (void)pushRandomTriangleWithDifferentZ {
	
//	NSMutableArray *points = [[NSMutableArray alloc] init];
//	
//	for (int i = 0; i < 3; i++) {
//		int width = (int)context->width;
//		int height = (int)context->height;
//		int ranX = arc4random() % (width - 1);
//		int ranY = arc4random() % (height - 1);
//		
//		BCAPoint *p = [BCAPoint pointWithXCoordinate:ranX yCoordinate:ranY zCoordinate:3];
//		[points addObject:p];
//		
//	}
//	
//	BCAPolygon *triangle = BCAPolygonWithColorAndPoints(0x00FF00FF, points[0], points[1], points[2], nil);
//	
//	[context addPolygon:triangle];
}

- (void)pushRandomTriangle {
	
	int width = (int)BCAContextGetWidth(context);
	int height = (int)BCAContextGetHeight(context);
	
	BCAPoint *points = malloc(sizeof(BCAPoint) * 3);
	
	
	for (int i = 0; i < 3; i++) {
		int ranX = arc4random() % (width - 1);
		int ranY = arc4random() % (height - 1);
		
		points[i] = BCAPointMake(ranX, ranY, 0);
		
	}
	
	NSLog(@"(%f,%f,%f)(%f,%f,%f)(%f,%f,%f)", points[0].x, points[0].y, points[0].z, points[1].x, points[1].y, points[1].z, points[2].x, points[2].y, points[3].z);
	
	BCAPolygon *triangle = BCAPolygonWithColorAndPoints3(0xFF0000FF, points[0], points[1], points[2]);
	
	BCAAddPolygonToContext(context, triangle);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
