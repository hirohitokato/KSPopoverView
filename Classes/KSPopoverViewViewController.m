//
//  KSPopoverViewViewController.m
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import "KSPopoverViewViewController.h"
#import "KSPopoverViewController.h"

@implementation KSPopoverViewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	KSPopoverViewController *vc = [[KSPopoverViewController alloc] initWithNibName:nil
																			bundle:nil];
	[self.view addSubview:vc.view];
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

@end
