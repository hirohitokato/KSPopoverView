//
//  KSPopoverViewButtonLabel.m
//  KSPopoverView
//
//  Copyright 2010, 2011 KatokichiSoft. All rights reserved.
//

#import "KSPopoverViewButtonLabel.h"
#import "KSCGUtils.h"

#define MIN_HEIGHT 30.0f
#define INSET_WIDTH 7.0f

@implementation KSPopoverViewButtonLabel

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.textColor = [UIColor whiteColor];
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
	[KSCGUtils clipRoundRect:rect withRadius:4.0f inContext:ctx];
	[KSCGUtils drawGlossGradient:ctx color:bkgcolor inRect:rect];
	[super drawRect:rect];
	CGContextRestoreGState(ctx);
}

- (void)drawTextInRect:(CGRect)rect {
	// テキストの描画領域を指定
	[super drawTextInRect:CGRectInset(rect, INSET_WIDTH, 0)]; // 若干内側にバランス
}

- (void)dealloc {
	NSLog(@"label(%@) is deallocated",self.text);
    [super dealloc];
}

#pragma mark -

- (CGSize)preferredSize {
	return CGSizeMake([self.text sizeWithFont:self.font].width+INSET_WIDTH*2,
					  fmax([self.text sizeWithFont:self.font].height, MIN_HEIGHT));
}
@end
