//
//  KSPopoverViewParentButton.h
//  KSPopoverView
//
//  Copyright 2010, 2011 KatokichiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KSPopoverViewParentButton : UIView {
@private
	UIImage *_image;
}

@property (nonatomic, retain) UIImage *image;

- (id)initWithImage:(UIImage *)image;
@end
