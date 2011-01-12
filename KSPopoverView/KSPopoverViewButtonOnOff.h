//
//  KSPopoverViewButtonOnOff.h
//  KSPopoverView
//
//  Copyright 2010, 2011 KatokichiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPopoverViewButtonBase.h"


@interface KSPopoverViewButtonOnOff : KSPopoverViewButtonBase {
	BOOL _on;
}

@property (nonatomic, assign)BOOL on;
@end
