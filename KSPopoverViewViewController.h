//
//  KSPopoverViewViewController.h
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPopoverViewController.h"

@interface KSPopoverViewViewController : UIViewController <KSPopoverViewControllerDelegate> {
	KSPopoverViewController *_menu;
}

@end

