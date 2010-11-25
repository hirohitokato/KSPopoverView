//
//  KSPopoverViewAppDelegate.h
//  KSPopoverView
//
//  Created by 加藤寛人 on 10/11/19.
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSPopoverViewViewController;

@interface KSPopoverViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    KSPopoverViewViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet KSPopoverViewViewController *viewController;

@end

