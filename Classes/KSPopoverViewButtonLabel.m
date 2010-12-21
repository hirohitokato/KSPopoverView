//
//  KSPopoverViewButtonLabel.m
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import "KSPopoverViewButtonLabel.h"
#import "KSCGUtils.h"

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
		bkgcolor = [UIColor blueColor];
	}

	/*
	CGContextBeginPath(ctx);
	CGContextAddRect(ctx, rect);
	CGContextClosePath(ctx);
	 */
	[[UIColor greenColor] setStroke];
	[KSCGUtils clipRoundRect:rect withRadius:4.0f inContext:ctx];
	[KSCGUtils drawGlossGradient:ctx color:bkgcolor inRect:rect];
	[super drawRect:rect];
	CGContextRestoreGState(ctx);
}

- (void)dealloc {
    [super dealloc];
}

@end
