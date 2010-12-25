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

@protocol KSPopoverViewControllerDelegate;

@interface KSPopoverViewController : UIViewController {
	@private
	// メニュー内の子要素
	NSMutableArray *_childs;
	
	// 通常時、広がったときのサイズ
	CGRect _normalFrame;
	CGRect _openedFrame;
	KSPopoverState _state;
	
	// ユーザーに見せるボタン相当
	UIImageView *_button;
	UITouch *_firstTouch;
	
	id<KSPopoverViewControllerDelegate> _delegate;
}

@property(nonatomic, retain) UIImageView *button;
@property(retain) NSMutableArray *childs;
@property(nonatomic, assign) id<KSPopoverViewControllerDelegate> delegate;
@property(nonatomic, assign) CGRect frame;

- (id)initWithImage:(UIImage *)buttonImage point:(CGPoint)point;
- (NSInteger)addButtonWithTitle:(NSString *)title;
@end

#pragma mark -
@protocol KSPopoverViewControllerDelegate <NSObject>
@optional
- (void)popoverViewController:(KSPopoverViewController *)controller
			   selectedButton:(KSPopoverViewButtonBase *)button
					  AtIndex:(NSInteger)buttonIndex;
@end

