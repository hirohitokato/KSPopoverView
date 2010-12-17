//
//  KSPopoverViewController.h
//  KSPopoverView
//
//  Copyright 2010 KatokichiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPopoverViewButtonBase.h"

typedef enum {
	KSPopoverStateNormal = 0,
	KSPopoverStateOpened,
} KSPopoverState;

@interface KSPopoverViewController : UIViewController {
	@private
	// メニュー内の子要素
	NSMutableArray *_childs;
	
	// 通常時、広がったときのサイズ
	CGRect _normalFrame;
	CGRect _openedFrame;
	KSPopoverState _state;
	
	// ユーザーに見せるボタン相当
	UILabel *_button;
}

@property (nonatomic, retain)UILabel *button;
@property (nonatomic, retain)NSMutableArray *childs;

- (void)setFrame:(CGRect)rect forState:(KSPopoverState)state;
@end
