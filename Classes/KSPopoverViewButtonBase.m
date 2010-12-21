//
//  KSPopoverViewButtonBase.m
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import "KSPopoverViewButtonBase.h"

@implementation KSPopoverViewButtonBase
@synthesize selected=_selected;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		NSLog(@"initWithFrame:%@", NSStringFromCGRect(frame));
		_selected = NO;
		_objectsForState = [[NSMutableDictionary alloc] init];
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
	NSLog(@"dealloc");
	[_objectsForState release];
    [super dealloc];
}

- (BOOL)handleTouchAtPoint:(CGPoint)point withState:(KSPopoverEventType)type {
	BOOL isIn = [self containsPoint:point];
	if (isIn) {
		// ここでイベント処理
		if ([type isEqualToString:KSPopoverEventTouchesBegan]) {
			self.selected = YES;
			// Touch downイベントの発生
			[self setNeedsDisplay];
			
		} else if ([type isEqualToString:KSPopoverEventTouchesMoved]) {
			if (self.selected == NO) {
				self.selected = YES;
				// Touch downイベントの発生
				[self setNeedsDisplay];
				
			}
		} else if ([type isEqualToString:KSPopoverEventTouchesEnded]) {
			self.selected = NO;
			// Touch upイベントの発生
			[self setNeedsDisplay];
		}
	} else {
		if ([type isEqualToString:KSPopoverEventTouchesMoved]) {
			if (self.selected == YES) {
				self.selected = NO;
				// Touch cancelledイベントの発生
				[self setNeedsDisplay];
			}
		}
	}
	
	return isIn;
}

// protected method
- (void)setObject:(id)obj forState:(KSPopoverEventType)type {
	[_objectsForState setObject:obj forKey:type];
}
// protected method
- (id)objectForState:(KSPopoverEventType)type {
	return [_objectsForState objectForKey:type];
}

// protected
- (BOOL)containsPoint:(CGPoint)point {
    if (self.hidden==NO && CGRectContainsPoint(self.frame, point)) {
		return YES;
    } else {
		return NO;
	}
}

@end
