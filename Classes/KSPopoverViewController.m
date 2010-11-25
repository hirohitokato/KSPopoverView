    //
//  KSPopoverViewController.m
//  KSPopoverView
//
//  Created by 加藤 寛人 on 10/11/25.
//  Copyright 2010 KatokichiSoft. All rights reserved.
//

#import "KSPopoverViewController.h"
#import "KSPopoverParentButton.h"

@interface KSPopoverViewController (private)
- (UIView *)viewContainsPoint:(CGPoint)point withEvent:(UIEvent *)event;
- (void)hideChilds;
- (void)didEndHideChilds:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end

@implementation KSPopoverViewController
@synthesize parentButton, childs;

- (void)loadView {
	[super loadView];
	
	self.view.frame = CGRectMake(100.0f, 300.0f, 120.0f, 50.0f);
	self.view.backgroundColor = [UIColor redColor];
	self.view.multipleTouchEnabled = YES;
	self.view.userInteractionEnabled = YES;

	self.childs = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.parentButton = nil;
	self.childs = nil;
}


- (void)dealloc {
	[self.parentButton release];
	[self.childs release];
    [super dealloc];
}

- (UIView *)viewContainsPoint:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.view.hidden==NO && CGRectContainsPoint(self.view.bounds, point)) {
		for (UIView *v in childs) {
			if (CGRectContainsPoint(v.bounds, point)) {
				return v;
			}
		}
    }
	
    return nil;
}

#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"began %@", event);
	self.view.frame = CGRectMake(100.0f, 100.0f, 120.0f, 250.0f);
	// フレームのサイズ変更、ボタンの配置
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"moved %@", event);
	// ボタンとのヒットテストで、そのボタンにイベントを送る
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"ended %@", event);
	// ボタンとのヒットテストで、そのボタンにイベントを送る
	[self hideChilds];
}

#pragma mark -
#pragma mark Animation selector
- (void)hideChilds {
	[UIView beginAnimations:@"FadeoutKSPopoverView" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.1f];
	[UIView setAnimationDidStopSelector:@selector(didEndFadeout:finished:context:)];
	self.view.frame = CGRectMake(100.0f, 300.0f, 120.0f, 50.0f);
	for (UIView *v in childs) {
		v.alpha = 0.0f;
	}
	[UIView commitAnimations];
}

- (void)didEndHideChilds:(NSString *)animationID
				finished:(NSNumber *)finished
				 context:(void *)context {
	// ボタン群をビューから除去
	for (UIView *v in childs) {
		v.alpha = 1.0f;
		[v removeFromSuperview];
	}
}

@end
