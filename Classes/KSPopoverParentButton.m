//
//  KSPopoverParentButton.m
//  KSPopoverView
//
//  Created by KatokichiSoft on 10/11/25.
//  Copyright 2010 KatokichiSoft. All rights reserved.
//

#import "KSPopoverParentButton.h"


@implementation KSPopoverParentButton

- (id)initWithFrame:(CGRect)frame {
	NSLog(@"created");
	if (self = [super initWithFrame:frame]) {
		
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	NSLog(@"decode");
	self = [super initWithCoder:aDecoder];
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"began %@", event);
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"move %@", event);
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"ended %@", event);
	[super touchesEnded:touches withEvent:event];
}

@end
