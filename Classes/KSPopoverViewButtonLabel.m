//
//  KSPopoverViewButtonLabel.m
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import "KSPopoverViewButtonLabel.h"

@interface KSPopoverViewButtonLabel (private)
- (BOOL)containsPoint:(CGPoint)point;
@end

@implementation KSPopoverViewButtonLabel


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	NSLog(@"drawRect is called.");
	if (super.selected) {
		// 選択中状態の表示
	} else {
		// 選択中状態の表示
	}
}

- (void)dealloc {
    [super dealloc];
}

- (BOOL)handleTouchAtPoint:(CGPoint)point withState:(KSPopoverEventType)type {
	BOOL isIn = [self containsPoint:point];
	if (isIn) {
		// ここでイベント処理
		if ([type isEqualToString:KSPopoverEventTouchesBegan]) {
			super.selected = YES;
			// Touch downイベントの発生

		} else if ([type isEqualToString:KSPopoverEventTouchesMoved]) {
			if (super.selected == NO) {
				super.selected = YES;
				// Touch downイベントの発生

			}
		} else if ([type isEqualToString:KSPopoverEventTouchesEnded]) {
			super.selected = NO;
			// Touch upイベントの発生

		}
	} else {
		if ([type isEqualToString:KSPopoverEventTouchesMoved]) {
			if (super.selected == YES) {
				super.selected = NO;
				// Touch cancelledイベントの発生
			}
		}
	}

	return isIn;
}

- (BOOL)containsPoint:(CGPoint)point {
    if (self.hidden==NO && CGRectContainsPoint(self.frame, point)) {
		return YES;
    } else {
		return NO;
	}
}

@end
