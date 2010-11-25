//
//  KSPopoverViewController.h
//  KSPopoverView
//
//  Created by 加藤 寛人 on 10/11/25.
//  Copyright 2010 KatokichiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSPopoverParentButton;

@interface KSPopoverViewController : UIViewController {
	NSMutableArray *childs;

	KSPopoverParentButton *parentButton;
}

@property (nonatomic, retain)KSPopoverParentButton *parentButton;
@property (nonatomic, retain)NSMutableArray *childs;
@end
