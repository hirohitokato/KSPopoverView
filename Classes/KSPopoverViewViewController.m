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
	KSPopoverViewController *vc = [[KSPopoverViewController alloc] initWithNibName:nil
																			bundle:nil];
	[vc addButtonWithTitle:@"1111111111"];
	[vc addButtonWithTitle:@"2222222222"];
	[vc addButtonWithTitle:@"3333333333"];
	[vc addButtonWithTitle:@"4444444444"];
	[vc addButtonWithTitle:@"5555555555"];
	[vc addButtonWithTitle:@"6666666666"];
	vc.delegate = self;
	[self.view addSubview:vc.view];
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

#pragma mark -
- (void)popoverViewController:(KSPopoverViewController *)controller
			   selectedButton:(KSPopoverViewButtonBase *)button
					  AtIndex:(NSInteger)buttonIndex {
	button.text = @"pressed";
}

@end
