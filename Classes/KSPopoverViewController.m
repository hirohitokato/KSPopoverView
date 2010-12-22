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
- (void)hideMenu;
- (void)openMenu;
- (void)didEndHideChilds:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end

@implementation KSPopoverViewController
@synthesize button=_button;
@synthesize childs=_childs;
@synthesize delegate=_delegate;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
	if ([super initWithNibName:nibName bundle:nibBundle]) {
		_state = KSPopoverStateNormal;
		
		_normalFrame = CGRectMake(100.0f, 300.0f, 100.0f, 50.0f);
		_openedFrame = CGRectMake(100.0f, 100.0f, 120.0f, 250.0f);

		self.childs = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)loadView {
	[super loadView];

	self.view.frame = _normalFrame;
	self.view.backgroundColor = [UIColor blackColor];
	self.view.multipleTouchEnabled = YES;
	self.view.userInteractionEnabled = YES;

	// メニューを引き出す契機になるボタン相当の領域を描画(ビューより5px内側)
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
	self.button = nil;
	self.childs = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Convenience methods
#define FIXME_FRAME_X	100.0f
#define FIXME_FRAME_Y	350.0f
#define FIXME_BUTTON_PARENT_HEIGHT	50.0f
#define FIXME_BUTTON_HEIGHT	35.0f
#define FIXME_BUTTON_WIDTH	110.0f
#define FIXME_BUTTON_GAP	5.0f
- (void)updateFrameSize {
	CGFloat height = FIXME_BUTTON_PARENT_HEIGHT+FIXME_BUTTON_HEIGHT*[self.childs count]+FIXME_BUTTON_GAP*3;
	_openedFrame = CGRectMake(FIXME_FRAME_X, FIXME_FRAME_Y-height, FIXME_BUTTON_WIDTH, height);
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
						NSLog(@"delegate does not define methods.");
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
	NSUInteger i = 0;
	for (KSPopoverViewButtonBase *v in self.childs) {
		// 場所を計算
		v.frame = CGRectMake(self.button.frame.origin.x,
							 self.button.frame.origin.y,
							 FIXME_BUTTON_WIDTH-FIXME_BUTTON_GAP*2,
							 30.0f);
		v.alpha = 0.0f;
		v.userInteractionEnabled = YES;
		[self.view addSubview:v];

		++i;
	}
	
	// アニメーション開始
	[UIView beginAnimations:@"FadeInKSPopoverView" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.2f];
	self.view.frame = _openedFrame;
	i = 0;
	for (KSPopoverViewButtonBase *v in self.childs) {
		v.frame = CGRectMake(v.frame.origin.x,
							 35.0f*i+5.0f,
							 v.frame.size.width,30.0f);
		v.alpha = 1.0f;

		++i;
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
	NSLog(@"num childs : %d", [self.childs count]);
	
	return [self.childs count] - 1;
}

@end
