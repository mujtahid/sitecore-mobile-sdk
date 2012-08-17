//
//  ViewController.m
//  SCNativeAlertTest
//
//  Created by Alr on 10.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface UIView (ViewController)

-(void)addSubviewAndScale:(UIView *)view;

@end

@implementation ViewController

@synthesize webBrowser;
#pragma mark - View lifecycle

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   NSString* path_ = [ [ NSBundle mainBundle ] pathForResource: @"test"
                                                        ofType: @"html" ];

   NSString* html_file_data_ = [ [ NSString alloc ] initWithContentsOfFile: path_
                                                                  encoding: NSUTF8StringEncoding
                                                                     error: nil ];
   SCWebBrowser* br_ = [ SCWebBrowser new ];
   [ webBrowser addSubviewAndScale: br_ ];
   [ br_ loadHTMLString: html_file_data_ baseURL: nil ];
}

-(void)viewDidUnload
{
   [ super viewDidUnload ];
   // Release any retained subviews of the main view.
   // e.g. self.myOutlet = nil;
}

@end
