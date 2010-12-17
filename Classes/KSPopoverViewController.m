//
//  KSPopoverViewController.m
//  KSPopoverView
//
//  Copyright 2010 KatokichiSoft. All rights reserved.
//

#import "KSPopoverViewController.h"
#import "KSPopoverViewButtonLabel.h"

@interface KSPopoverViewController (private)
- (void)forwardTouches:(NSSet *)touches withEventType:(KSPopoverEventType)type;
- (UIView *)viewContainsPoint:(CGPoint)point;
- (void)hideChilds;
- (void)didEndHideChilds:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end

@implementation KSPopoverViewController
@synthesize button=_button;
@synthesize childs;

- (void)loadView {
	[super loadView];
	_state = KSPopoverStateNormal;
	
	_normalFrame = CGRectMake(100.0f, 300.0f, 100.0f, 50.0f);
	_openedFrame = CGRectMake(100.0f, 100.0f, 120.0f, 250.0f);

	self.view.frame = _normalFrame;
	self.view.backgroundColor = [UIColor redColor];
	self.view.multipleTouchEnabled = YES;
	self.view.userInteractionEnabled = YES;

	self.childs = [[NSMutableArray alloc] init];
	
	// メニューを引き出す契機になるボタン相当の領域を描画
	CGRect buttonFrame = CGRectInset(_normalFrame, 5.0f, 5.0f);
	buttonFrame.origin.x -= _normalFrame.origin.x;
	buttonFrame.origin.y -= _normalFrame.origin.y;
	self.button = [[UILabel alloc] initWithFrame:buttonFrame];
	self.button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	self.button.backgroundColor = [UIColor blueColor];
	self.button.text = @"Touch me";
	self.button.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:self.button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
#pragma mark KSPopoverViewButtonBaseのテスト
#if 1
	KSPopoverViewButtonLabel *b = [[[KSPopoverViewButtonLabel alloc] initWithFrame:CGRectZero]
								  autorelease];
	[b setObject:@"hoge" forState:KSPopoverEventTouchesBegan];
	NSAssert([@"hoge" isEqualToString:[b objectForState:KSPopoverEventTouchesBegan]], @"mismatch");
	[b setObject:@"fuga" forState:KSPopoverEventTouchesMoved];
	NSAssert([@"fuga" isEqualToString:[b objectForState:KSPopoverEventTouchesMoved]], @"mismatch");
	[b setObject:@"moga" forState:KSPopoverEventTouchesEnded];
	NSAssert([@"moga" isEqualToString:[b objectForState:KSPopoverEventTouchesEnded]], @"mismatch");
	[b setObject:@"moga" forState:KSPopoverEventTouchesBegan];
	NSAssert([@"moga" isEqualToString:[b objectForState:KSPopoverEventTouchesBegan]], @"mismatch");
	[b handleTouchAtPoint:CGPointZero withState:KSPopoverEventTouchesBegan];
#endif
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
	self.button = nil;
	self.childs = nil;
}


- (void)dealloc {
	self.button = nil;
	self.childs = nil;
    [super dealloc];
}

- (UIView *)viewContainsPoint:(CGPoint)point {
    if (self.view.hidden==NO && CGRectContainsPoint(self.view.bounds, point)) {
		if (CGRectContainsPoint(self.button.frame, point)) {
			return self.button;
		}
		for (UIView *v in childs) {
			if (CGRectContainsPoint(v.bounds, point)) {
				return v;
			}
		}
    }
	
    return nil;
}

#pragma mark -
- (void)setFrame:(CGRect)rect forState:(KSPopoverState)state {
	switch (state) {
		case KSPopoverStateNormal:
			_normalFrame = rect;
			break;
		case KSPopoverStateOpened:
			_openedFrame = rect;
			break;
		default:
			break;
	}
	// 現在の状態も書き換え
	if (_state == state) {
		self.view.frame = rect;
	}
}

#pragma mark -
- (void)forwardTouches:(NSSet *)touches withEventType:(KSPopoverEventType)type {
	NSArray *array = [touches allObjects];
	for (UITouch *t in array) {
		for (id child in _childs) {
			// ボタンに位置を渡して、イベントハンドリングを確認する
			// 返戻値がYESだったら、イベントは処理されたとしてbreak
		}
		UIView *v = [self viewContainsPoint:[t locationInView:self.view]];
		if (v==self.button) NSLog(@"view:%@", v);
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = KSPopoverStateOpened;
	self.view.frame = _openedFrame;
	// フレームのサイズ変更、ボタンの配置

	[self forwardTouches:touches withEventType:KSPopoverEventTouchesBegan];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = KSPopoverStateOpened;

	[self forwardTouches:touches withEventType:KSPopoverEventTouchesMoved];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = KSPopoverStateNormal;
	self.view.frame = _normalFrame;
	// ボタンとのヒットテストで、そのボタンにイベントを送る
	[self hideChilds];

	[self forwardTouches:touches withEventType:KSPopoverEventTouchesEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = KSPopoverStateNormal;
	self.view.frame = _normalFrame;
	
	[self hideChilds];

	[self forwardTouches:touches withEventType:KSPopoverEventTouchesEnded];
}

#pragma mark -
#pragma mark Animation selector
- (void)hideChilds {
	[UIView beginAnimations:@"FadeoutKSPopoverView" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.1f];
	[UIView setAnimationDidStopSelector:@selector(didEndFadeout:finished:context:)];
	self.view.frame = _normalFrame;
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
