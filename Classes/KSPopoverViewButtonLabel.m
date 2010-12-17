//
//  KSPopoverViewButtonLabel.m
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import "KSPopoverViewButtonLabel.h"

@interface KSPopoverViewButtonLabel (private)
- (BOOL)isOnPoint:(CGPoint)point;
@end

@implementation KSPopoverViewButtonLabel


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
    [super dealloc];
}

- (BOOL)handleTouchAtPoint:(CGPoint)point withState:(KSPopoverEventType)type {
	BOOL isIn = [self isOnPoint:point];
	if (isIn) {
		// ここでイベント処理
	}
	NSLog(@"result: %@", isIn?@"handled":@"ignored");
	return isIn;
}

- (BOOL)isOnPoint:(CGPoint)point {
    if (self.hidden==NO && CGRectContainsPoint(self.frame, point)) {
		return YES;
    } else {
		return NO;
	}
}

@end
