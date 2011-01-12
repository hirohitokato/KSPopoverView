//
//  KSPopoverViewParentButton.m
//  KSPopoverView
//
//  Copyright 2010, 2011 KatokichiSoft. All rights reserved.
//

#import "KSPopoverViewParentButton.h"


@implementation KSPopoverViewParentButton
@synthesize image=_image;

- (id)initWithImage:(UIImage *)image {

	CGRect frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    self = [super initWithFrame:frame];
    if (self) {
		self.image = image;
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
	self.image = nil;
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
	[self.image drawInRect:rect];
}

@end
