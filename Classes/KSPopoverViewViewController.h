//
//  KSPopoverViewViewController.h
//  KSPopoverView
//
//  Created by 加藤寛人 on 10/11/19.
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSPopoverViewViewController : UIViewController {
	IBOutlet UIButton *parentButton;
	IBOutlet UIButton *childButtons1;
	IBOutlet UIButton *childButtons2;
}

- (IBAction)touchDownParent:(UIButton *)button;
- (IBAction)touchUpParent:(UIButton *)button;
- (IBAction)touchDragEnter:(UIButton *)button;
- (IBAction)touchDragExit:(UIButton *)button;
- (IBAction)touchDragInside:(UIButton *)button;
- (IBAction)touchDragOutside:(UIButton *)button;

@end

