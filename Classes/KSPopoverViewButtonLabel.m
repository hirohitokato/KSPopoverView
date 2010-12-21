//
//  KSPopoverViewButtonLabel.m
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import "KSPopoverViewButtonLabel.h"
#import "KSCGUtils.h"

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

	UIColor *bkgcolor;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	if (super.selected) {
		// 選択中状態の表示
		bkgcolor = [UIColor redColor];
	} else {
		// 非選択中状態の表示
		bkgcolor = [UIColor clearColor];
	}

	CGContextBeginPath(ctx);
	CGContextAddRect(ctx, rect);
	CGContextClosePath(ctx);
	[KSCGUtils drawGlossGradient:ctx color:bkgcolor inRect:rect];
	[[UIColor blackColor] setStroke];
	CGContextDrawPath(ctx, kCGPathEOFillStroke);
	[super drawRect:rect];
	CGContextRestoreGState(ctx);
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
			[self setNeedsDisplay];

		} else if ([type isEqualToString:KSPopoverEventTouchesMoved]) {
			if (super.selected == NO) {
				super.selected = YES;
				// Touch downイベントの発生
				[self setNeedsDisplay];

			}
		} else if ([type isEqualToString:KSPopoverEventTouchesEnded]) {
			super.selected = NO;
			// Touch upイベントの発生
			[self setNeedsDisplay];
		}
	} else {
		if ([type isEqualToString:KSPopoverEventTouchesMoved]) {
			if (super.selected == YES) {
				super.selected = NO;
				// Touch cancelledイベントの発生
				[self setNeedsDisplay];
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
