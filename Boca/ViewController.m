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
	[drawingView setClearsContextBeforeDrawing:YES];
	[drawingView setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
	
	CGFloat bufferWidth = (drawingView.frame.size.width);
	CGFloat bufferHeight = (drawingView.frame.size.height);
	
	NSLog(@"(w:%f, h:%f)", bufferWidth, bufferHeight);
	
	[drawingView setPixelBufferWidth:bufferWidth];
	[drawingView setPixelBufferHeight:bufferHeight];
	
	
	// This is just an example. The rendering engine will give us an uint32_t buffer every 1/60th of second
	// Which will only be new if something has changed. (Marked "Dirty")
	
	context = BCACreateRenderingContextWithDimensions(bufferWidth, bufferHeight, 200);
	BCASetTransformMake(context, 0, 'X');
	context->angle = 0.0;
	context->axis = 'X';

	for (int i = 0; i < 5; i++)
		[self pushRandomTriangle];
//	for (int i = 0; i < 300; i++) {
//		[self pushRandomRectangle];
//	}
//	[self pushRandomTriangleWithDifferentZ];
	
	//uint32_t *buffer;
	uint32_t *buffer = BCAPixelBufferForRenderingContext(context);
	// this probably won't work first try ;P
	// Cool , it did. lol
	
	[drawingView setPixelBuffer:buffer];
	[drawingView setNeedsDisplay];
	
	// Do any additional setup after loading the view, typically from a nib.
	
	
	UIButton *upButton = [[UIButton alloc] init];
	[upButton setTitle:@"^" forState:UIControlStateNormal];
	[upButton addTarget:self action:@selector(buttonPressUp:) forControlEvents:UIControlEventTouchUpInside];
	[upButton setFrame:CGRectMake(280, 600, 30, 30)];
	[upButton setBackgroundColor:[UIColor grayColor]];
	[self.view addSubview:upButton];
	
	UIButton *leftButton = [[UIButton alloc] init];
	[leftButton setTitle:@"<" forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(buttonPressLeft:) forControlEvents:UIControlEventTouchUpInside];
	[leftButton setFrame:CGRectMake(250, 615, 30, 30)];
	[leftButton setBackgroundColor:[UIColor grayColor]];
	[self.view addSubview:leftButton];
	
	UIButton *rightButton = [[UIButton alloc] init];
	[rightButton setTitle:@">" forState:UIControlStateNormal];
	[rightButton addTarget:self action:@selector(buttonPressRight:) forControlEvents:UIControlEventTouchUpInside];
	[rightButton setFrame:CGRectMake(310, 615, 30, 30)];
	[rightButton setBackgroundColor:[UIColor grayColor]];
	[self.view addSubview:rightButton];
	
	UIButton *downButton = [[UIButton alloc] init];
	[downButton setTitle:@"v" forState:UIControlStateNormal];
	[downButton addTarget:self action:@selector(buttonPressDown:) forControlEvents:UIControlEventTouchUpInside];
	[downButton setFrame:CGRectMake(280, 630, 30, 30)];
	[downButton setBackgroundColor:[UIColor grayColor]];
	[self.view addSubview:downButton];
	
	UIButton *rotateX = [[UIButton alloc] init];
	[rotateX setTitle:@"X" forState:UIControlStateNormal];
	[rotateX addTarget:self action:@selector(buttonPressX:) forControlEvents:UIControlEventTouchUpInside];
	[rotateX setFrame:CGRectMake(100, 615, 30, 30)];
	[rotateX setBackgroundColor:[UIColor grayColor]];
	[self.view addSubview:rotateX];
	
	//[[NSRunLoop mainRunLoop] addTimer:[NSTimer timerWithTimeInterval:1 target:self selector:@selector(redrawBuffer) userInfo:nil repeats:YES] forMode:NSRunLoopCommonModes];
	// comment this out to try redrawing only when necessary
	
}

- (void)redrawBuffer {
	
	uint32_t *buffer = BCAPixelBufferForRenderingContext(context);

	[drawingView setPixelBuffer:buffer];
	[drawingView setNeedsDisplay];
}

- (void)buttonPressX:(UIButton *)b {
	
//	double angle = 90.0;
//	char axis = 'Y';
//	BCASetTransformMake (context ,angle, axis);
	context->angle = 10.0;
	context->axis = 'X';
	
	[self redrawBuffer]; // comment this to try redrawing immediately
}

- (void)buttonPressDown:(UIButton *)b {
	BCAContextOrientation orientation = context->orientation; // write accessor/setter for this
	switch (orientation) {

	}
}

- (void)buttonPressRight:(UIButton *)b {
	
}

- (void)buttonPressLeft:(UIButton *)b {
	
}

- (void)buttonPressUp:(UIButton *)b {
	
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
	int depth = (int)BCAContextGetDepth(context);
	
	BCAPoint *points = malloc(sizeof(BCAPoint) * 3);
	
	uint32_t color = 0x000000FF;
	
	for (int i = 0; i < 3; i++) {
		int ranX = arc4random() % (width - 1);
		int ranY = arc4random() % (height - 1);
		int ranZ = arc4random() % (depth - 1);
		
		points[i] = BCAPointMake(ranX, ranY, ranZ);
		
		int ranRed = arc4random() % 255;
		int ranGreen = arc4random() % 255;
		int ranBlue = arc4random() % 255;
		
		color = (ranRed << 24) + (ranGreen << 16) + (ranBlue << 8) + 0xFF;
		
	}
	
	NSLog(@"(%f,%f,%f)(%f,%f,%f)(%f,%f,%f)", points[0].x, points[0].y, points[0].z, points[1].x, points[1].y, points[1].z, points[2].x, points[2].y, points[3].z);
	
	BCAPolygon *triangle = BCAPolygonWithColorAndPoints3(color, points[0], points[1], points[2]);
	
	BCAAddPolygonToContext(context, triangle);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
