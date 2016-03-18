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
	
	BCARenderingContext *context = BCACreateRenderingContextWithDimensions(bufferWidth, bufferHeight);
	
	BCATriangle *triangle = [[BCATriangle alloc] init];
	triangle.vertices = @[
						  [BCAPoint pointWithXCoordinate:1 yCoordinate:1],
						  [BCAPoint pointWithXCoordinate:1 yCoordinate:15],
						  [BCAPoint pointWithXCoordinate:182 yCoordinate:182]
						  ];
	
	BCAAddTriangleToContextWithVertices(context, triangle);
	
	uint32_t *buffer = BCAPixelBufferForRenderingContext(context);
	// this probably won't work first try ;P
	// Cool , it did. lol
	
	[drawingView setPixelBuffer:buffer];
	
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
