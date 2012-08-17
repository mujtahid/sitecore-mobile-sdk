//
//  ViewController.m
//  SCViewTest
//
//  Created by Alr on 09.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@implementation ViewController

@synthesize webBrowser;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [ super viewDidLoad ];
	// Do any additional setup after loading the view, typically from a nib.

   [ webBrowser loadURLWithString: @"http://ws-alr1.dk.sitecore.net/" ];
}

-(void)viewDidUnload
{
   [ super viewDidUnload ];
   // Release any retained subviews of the main view.
   // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   // Return YES for supported orientations
   return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end