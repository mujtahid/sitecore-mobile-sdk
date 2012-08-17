#import "FirstViewController.h"

@implementation FirstViewController

@synthesize webBrowser
, widthSlider
, heightSlider;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(CGRect)webViewRect
{
    return CGRectMake( self.view.bounds.size.width*(1.f - widthSlider.value)/2.f
                      , self.view.bounds.size.height*(1.f - heightSlider.value)/2.f
                      , self.view.bounds.size.width*widthSlider.value
                      , self.view.bounds.size.height*heightSlider.value );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.webBrowser.frame = [ self webViewRect ];
    [self.webBrowser loadURLWithString: @"http://mobilesdk.sc-demo.net/"];

    UIView* view_ = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, 110.f, 80.f)];
    view_.backgroundColor  = [UIColor greenColor];
    view_.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [ self.webBrowser setCustomToollbarView: view_ ];
    //STODO call all methods to test
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)didChangeWidth:( id )sender
{
    self.webBrowser.frame = [ self webViewRect ];
}

- (IBAction)didChangeHeight:( id )sender
{
    self.webBrowser.frame = [ self webViewRect ];
}

@end
