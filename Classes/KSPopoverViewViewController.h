//
//  KSPopoverViewViewController.h
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPopoverViewController.h"

@interface KSPopoverViewViewController : UIViewController <KSPopoverViewControllerDelegate> {
	IBOutlet UIButton *childButtons1;
	IBOutlet UIButton *childButtons2;
}

@end

