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
	NSLog(@"Warning: This method should be override by child class!!");
	return NO;
}

// protected method
- (void)setObject:(id)obj forState:(KSPopoverEventType)type {
	[_objectsForState setObject:obj forKey:type];
}
// protected method
- (id)objectForState:(KSPopoverEventType)type {
	return [_objectsForState objectForKey:type];
}

@end
