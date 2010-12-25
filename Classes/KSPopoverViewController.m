//
//  KSPopoverViewController.m
//  KSPopoverView
//
//  Copyright 2010 KatokichiSoft. All rights reserved.
//

#import "KSPopoverViewController.h"
#import "KSPopoverViewButtonLabel.h"

#define BUTTON_GAP	5.0f	// ボタンの配置間隔

@interface KSPopoverViewController (private)
- (void)forwardTouches:(NSSet *)touches withEventType:(KSPopoverEventType)type;
- (void)hideMenu;
- (void)openMenu;
- (void)didEndHideChilds:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end

@implementation KSPopoverViewController
@synthesize button=_button;
@synthesize childs=_childs;
@synthesize delegate=_delegate;

- (id)initWithImage:(UIImage *)buttonImage point:(CGPoint)point {
	if ([super init]) {
		_state = KSPopoverStateNormal;
		
		_normalFrame = CGRectMake(point.x, point.y,
								  buttonImage.size.width, buttonImage.size.height);
		_openedFrame = CGRectZero;
		self.button = [[UIImageView alloc] initWithImage:buttonImage];
		self.button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
		self.button.userInteractionEnabled = YES;

		self.childs = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)loadView {
	[super loadView];

	self.view.frame = _normalFrame;
	self.view.backgroundColor = [UIColor clearColor];
	self.view.multipleTouchEnabled = YES;
	self.view.userInteractionEnabled = YES;

	[self.view addSubview:self.button];

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
	NSLog(@"viewDidUnload is called.");
	self.button = nil;
	self.childs = nil;
}


- (void)dealloc {
	NSLog(@"deallocated:%@", self);

	self.button = nil;
	self.childs = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Convenience methods
- (void)updateFrameSize {
	CGFloat maxWidth = 0.0f;
	CGFloat sumHeights = 0.0f;
	for (KSPopoverViewButtonBase *v in self.childs) {
		maxWidth = (maxWidth>[v preferredSize].width)?maxWidth:[v preferredSize].width;
		sumHeights += [v preferredSize].height + BUTTON_GAP;
	}
	_openedFrame = CGRectMake(_normalFrame.origin.x,
							  _normalFrame.origin.y-sumHeights,
							  fmax(_normalFrame.size.width, maxWidth),
							  _normalFrame.size.height+sumHeights);
}

#pragma mark -
- (CGRect)frame {
	return _normalFrame;
}
- (void)setFrame:(CGRect)rect {
	_normalFrame = rect;

	// 現在の状態も書き換え
	if (_state == KSPopoverStateNormal) {
		self.view.frame = rect;
	}
}

#pragma mark -
- (void)forwardTouches:(NSSet *)touches withEventType:(KSPopoverEventType)type {
	NSArray *array = [touches allObjects];
	for (UITouch *t in array) {
		NSUInteger index = 0;
		for (KSPopoverViewButtonBase *child in self.childs) {
			// ボタンに位置を渡して、イベントハンドリングを確認する
			// 返戻値がYESだったら、イベントは処理されたとしてbreak,次のタッチイベントへ
			BOOL handled = [child handleTouchAtPoint:[t locationInView:self.view]
										 withState:type];
			if (handled) {
				if (self.delegate) {
					if ([self.delegate respondsToSelector:
						 @selector(popoverViewController:selectedButton:AtIndex:)]) {
						[self.delegate popoverViewController:self
											  selectedButton:child
													 AtIndex:index];
						break;
					} else {
						NSLog(@"delegate object does not implement required methods.");
					}
				} else {
					NSLog(@"delegate is not set.");
				}
			}
			++index;
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_state == KSPopoverStateNormal) {
		_state = KSPopoverStateOpened;
		[self openMenu];
		_firstTouch = [touches anyObject];
	}

	[self forwardTouches:touches withEventType:KSPopoverEventTouchesBegan];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = KSPopoverStateOpened;

	[self forwardTouches:touches withEventType:KSPopoverEventTouchesMoved];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = KSPopoverStateNormal;

	[self forwardTouches:touches withEventType:KSPopoverEventTouchesEnded];

	if ([[touches allObjects] count] == 1 && _firstTouch==[touches anyObject]) {
		[self performSelector:@selector(hideMenu) withObject:nil afterDelay:0.1f];
		_firstTouch = nil;
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = KSPopoverStateNormal;

	[self forwardTouches:touches withEventType:KSPopoverEventTouchesEnded];

	if ([[touches allObjects] count] == 1 && _firstTouch==[touches anyObject]) {
		[self performSelector:@selector(hideMenu) withObject:nil afterDelay:0.1f];
		_firstTouch = nil;
	}
}

#pragma mark -
#pragma mark Animation selector
- (void)openMenu {
	// childsのラベルを配置
	[self updateFrameSize];
	for (KSPopoverViewButtonBase *v in self.childs) {
		// 場所を計算
		v.frame = CGRectMake(self.button.frame.origin.x,
							 self.button.frame.origin.y,
							 _openedFrame.size.width,
							 [v preferredSize].height);
		v.alpha = 0.0f;
		v.userInteractionEnabled = YES;
		[self.view addSubview:v];
	}
	
	// アニメーション開始
	[UIView beginAnimations:@"FadeInKSPopoverView" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.2f];
	self.view.frame = _openedFrame;
	CGFloat sumHeight = 0.0;
	for (KSPopoverViewButtonBase *v in self.childs) {
		v.frame = CGRectMake(v.frame.origin.x,
							 sumHeight,
							 v.frame.size.width,
							 v.frame.size.height);
		v.alpha = 1.0f;

		sumHeight += v.frame.size.height + BUTTON_GAP;
	}
	[UIView commitAnimations];
}
- (void)hideMenu {
	for (KSPopoverViewButtonBase *v in self.childs) {
		v.userInteractionEnabled = NO;
	}
	[UIView beginAnimations:@"FadeOutKSPopoverView" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationDidStopSelector:@selector(didEndFadeout:finished:context:)];
	self.view.frame = _normalFrame;
	// 親ボタンに集合
	for (KSPopoverViewButtonBase *v in self.childs) {
		v.frame = CGRectMake(self.button.frame.origin.x,
							 self.button.frame.origin.y,
							 v.frame.size.width, v.frame.size.height);
		v.alpha = 0.0f;
		[v resetSelected];
	}
	[UIView commitAnimations];
}

- (void)didEndHideChilds:(NSString *)animationID
				finished:(NSNumber *)finished
				 context:(void *)context {
	// ボタン群をビューから除去
	for (KSPopoverViewButtonBase *v in self.childs) {
		v.alpha = 1.0f;
		[v removeFromSuperview];
	}
}

#pragma mark -
- (NSInteger)addButtonWithTitle:(NSString *)title {
	KSPopoverViewButtonLabel *label = [[KSPopoverViewButtonLabel alloc]
									   initWithFrame:CGRectZero];
	// 子ボタンの追加
	label.text = title;
	[self.childs addObject:label];
	[label release];
	
	return [self.childs count] - 1;
}

@end
