//
//  KSPopoverViewButtonBase.h
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KSPopoverEventTouchesBegan @"TouchesBegan__"
#define KSPopoverEventTouchesMoved @"TouchesMoved__"
#define KSPopoverEventTouchesEnded @"TouchesEnded__"
typedef NSString* KSPopoverEventType;

@interface KSPopoverViewButtonBase : UIView {
	BOOL _selected;
	NSMutableDictionary *_objectsForState;
}

@property (nonatomic, assign)BOOL selected;

// 渡された座標で自分がイベント処理を行うかどうかの判定（とその処理）。子クラスでオーバーライド
- (BOOL)handleTouchAtPoint:(CGPoint)point withState:(KSPopoverEventType)type;
@end


@interface KSPopoverViewButtonBase (local)
// 各状態で表示させる情報などに利用。使い方は子クラスに任せる
- (void)setObject:(id)obj forState:(KSPopoverEventType)type;
- (id)objectForState:(KSPopoverEventType)type;

@end
