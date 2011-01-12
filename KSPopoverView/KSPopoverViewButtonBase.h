//
//  KSPopoverViewButtonBase.h
//  KSPopoverView
//
//  Copyright 2010, 2011 KatokichiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

// KSPopoverEventTypeを保存するときのマクロ
#define OBJ_OF(x) [NSNumber numberWithInt:x]
typedef enum {
	KSPopoverEventTouchesBegan = 0,
	KSPopoverEventTouchesMoved,
	KSPopoverEventTouchesEnded,
	KSPopoverEventTouchesOther,
} KSPopoverEventType;

@interface KSPopoverViewButtonBase : UILabel {
	BOOL _selected;
	NSMutableDictionary *_objectsForState;
}

@property (nonatomic, assign)BOOL selected;

// 渡された座標で自分がイベント処理を行うかどうかの判定（とその処理）。子クラスでオーバーライド
- (BOOL)handleTouchAtPoint:(CGPoint)point withState:(KSPopoverEventType)type;

// 自分の表示して欲しいサイズをCGRectで返す
- (CGSize)preferredSize;

// 選択/非選択状態のリセット
- (void)resetSelected;
@end


// 以下のメソッドはいずれもProtectedメソッドのため、他のクラスから呼ばないこと
@interface KSPopoverViewButtonBase (local)
// 各状態で表示させる情報などに利用。使い方は子クラスに任せる
- (void)setObject:(id)obj forState:(KSPopoverEventType)type;
- (id)objectForState:(KSPopoverEventType)type;

// ヒットテストに使用（デフォルトでframeにマッチしていればOKを返すようにしてある）
- (BOOL)containsPoint:(CGPoint)point;

@end
