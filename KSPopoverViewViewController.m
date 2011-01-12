//
//  KSPopoverViewViewController.m
//  KSPopoverView
//
//  Copyright 2010 Katokichi Software. All rights reserved.
//

#import "KSPopoverViewViewController.h"

@implementation KSPopoverViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	UIImage *image = [UIImage imageNamed:@"katokichi"];
	_menu = [[KSPopoverViewController alloc] initWithType:KSPopoverTypeOnOffLabel
													image:image
													point:CGPointMake(50.0f, 340.0f)];
	_menu.delegate = self;
	_menu.position = KSPopoverPositionTopRight;
	//_menu.debug = YES;
	[self.view addSubview:_menu.view];

	[_menu addButtonWithTitle:@"11111111"];
	[_menu addButtonWithTitle:@"2222222222"];
	[_menu addButtonWithTitle:@"3333333"];
	[_menu addButtonWithTitle:@"444444444"];
	[_menu addButtonWithTitle:@"555"];
	[_menu addButtonWithTitle:@"666666666666"];
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
	[_menu release];
	_menu = nil;
}


- (void)dealloc {
	[_menu release];
    [super dealloc];
}

#pragma mark -
- (void)popoverViewController:(KSPopoverViewController *)controller
		  selectedButtonIndex:(NSInteger)buttonIndex {
	KSPopoverViewButtonBase *button = [controller labelAtIndex:buttonIndex];
	button.text = @"pressed";
}

@end
