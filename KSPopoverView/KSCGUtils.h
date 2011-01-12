//
//  KSCGUtils.h
//
//  Copyright 2010, 2011 KatokichiSoft. All rights reserved.
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
// 角丸のパスだけ描画
+ (void)pathForRoundRect:(CGContextRef)context rect:(CGRect)rect radius:(CGFloat)radius;
@end
