//
//  KSCGUtils.h
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KSCGUtils : NSObject {

}

// グロッシーなグラデーションを描画
+ (void)drawGlossGradient:(CGContextRef)context color:(UIColor*)color inRect:(CGRect)inRect;
// 角丸矩形を描画
+ (void)drawRoundRect:(CGRect)rect withRadius:(CGFloat)radius inContext:(CGContextRef)context;
// 角丸のクリッピングパス
+ (void)clipRoundRect:(CGRect)rect withRadius:(CGFloat)radius inContext:(CGContextRef)context;
@end
