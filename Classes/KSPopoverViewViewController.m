//
//  KSPopoverViewViewController.m
//  KSPopoverView
//
//  Created by 加藤寛人 on 10/11/19.
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import "KSPopoverViewViewController.h"

@implementation KSPopoverViewViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	[parentButton setTitle:@"touch me" forState:UIControlStateNormal];
	//childButtons1.hidden = YES;
	//childButtons2.hidden = YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)touchDownParent:(UIButton *)button {
	childButtons1.hidden = NO;
	childButtons2.hidden = NO;
	UIResponder *obj = [button nextResponder];
	while (obj) {
		NSLog(@"nextResponder is %@", obj);
		obj = [obj nextResponder];
	}
}
- (IBAction)touchUpParent:(UIButton *)button {
	//childButtons1.hidden = YES;
	//childButtons2.hidden = YES;
}
- (IBAction)touchDragEnter:(UIButton *)button {
	NSLog(@"Entered inside a button%d", button.tag);
	button.backgroundColor = [UIColor redColor];
}
- (IBAction)touchDragExit:(UIButton *)button {
	NSLog(@"Exit from a button%d", button.tag);
	button.backgroundColor = [UIColor whiteColor];
}
- (IBAction)touchDragInside:(UIButton *)button {
	NSLog(@"Drag inside a button%d", button.tag);
	button.backgroundColor = [UIColor yellowColor];
	UIResponder *obj = [button nextResponder];
	while (obj) {
		NSLog(@"nextResponder is %@", obj);
		obj = [obj nextResponder];
	}
}
- (IBAction)touchDragOutside:(UIButton *)button {
	NSLog(@"Drag outside a button%d", button.tag);
	button.backgroundColor = [UIColor purpleColor];
	UIResponder *obj = [button nextResponder];
	while (obj) {
		NSLog(@"nextResponder is %@", obj);
		obj = [obj nextResponder];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// 上のボタンビューがイベントを拾っているため、ここには来ない
	NSLog(@"began %@", event);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// 上のボタンビューがイベントを拾っているため、ここには来ない
	NSLog(@"began %@", event);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// 上のボタンビューがイベントを拾っているため、ここには来ない
	NSLog(@"began %@", event);
}
@end
