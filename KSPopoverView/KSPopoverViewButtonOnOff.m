//
//  KSPopoverViewButtonOnOff.m
//  KSPopoverView
//
//  Copyright 2010, 2011 KatokichiSoft. All rights reserved.
//

#import "KSPopoverViewButtonOnOff.h"
#import "KSCGUtils.h"

#define MIN_HEIGHT 30.0f
#define INSET_WIDTH 7.0f

@implementation KSPopoverViewButtonOnOff
@synthesize on = _on;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	if (super.selected) {
		// 選択中状態の表示
		super.textColor = [UIColor blackColor];

		// 枠線
		CGContextSetRGBFillColor(ctx, 0.3, 0.3, 0.3, 1.0);
		[KSCGUtils pathForRoundRect:ctx rect:rect radius:10];
		CGContextDrawPath(ctx, kCGPathFill);
		// 中塗り
		CGContextSetRGBFillColor(ctx, 0.9, 0.9, 0.9, 0.7);
		[KSCGUtils pathForRoundRect:ctx rect:CGRectInset(rect,1,1) radius:9];
		CGContextDrawPath(ctx, kCGPathFill);
	} else {
		// 非選択中状態の表示
		super.textColor = [UIColor whiteColor];

		// 枠線
		CGContextSetRGBFillColor(ctx, 0.9, 0.9, 0.9, 1.0);
		[KSCGUtils pathForRoundRect:ctx rect:rect radius:10];
		CGContextDrawPath(ctx, kCGPathFill);
		// 中塗り
		CGContextSetRGBFillColor(ctx, 0.3, 0.3, 0.3, 0.7);
		[KSCGUtils pathForRoundRect:ctx rect:CGRectInset(rect,1,1) radius:9];
		CGContextDrawPath(ctx, kCGPathFill);
	}

	CGContextRestoreGState(ctx);
	[super drawRect:rect];
}

#define ONOFF_WIDTH ([@" OFF " sizeWithFont:self.font].width)
#define TEXT_HEIGHT fmax([self.text sizeWithFont:self.font].height, MIN_HEIGHT)
#define TEXT_HEIGHT_ADJUSTMENT 5.0f
- (void)drawTextInRect:(CGRect)rect {
	// ラベルの描画
	[super drawTextInRect:CGRectInset(rect, INSET_WIDTH, 0)]; // 若干内側にバランス

	// ONOFFの描画
	NSString *onoff = _on?@"ON":@"OFF";
	[onoff drawInRect:CGRectMake(self.frame.size.width-ONOFF_WIDTH-INSET_WIDTH*2,
								 TEXT_HEIGHT_ADJUSTMENT,
								 ONOFF_WIDTH+INSET_WIDTH,
								 TEXT_HEIGHT)
			 withFont:self.font
		lineBreakMode:UILineBreakModeTailTruncation
			alignment:UITextAlignmentRight];
}

- (void)dealloc {
	NSLog(@"onoff label(%@) is deallocated",self.text);
    [super dealloc];
}

#pragma mark -

- (CGSize)preferredSize {
	float w = 0.0f;
	float h = TEXT_HEIGHT;

	// 横幅の計算
	w =  [self.text sizeWithFont:self.font].width+INSET_WIDTH*2; // ラベル
	w += 5; // 隙間
	w += ONOFF_WIDTH+INSET_WIDTH*2; // ON/OFF表示

	return CGSizeMake(w,h);
}


@end
