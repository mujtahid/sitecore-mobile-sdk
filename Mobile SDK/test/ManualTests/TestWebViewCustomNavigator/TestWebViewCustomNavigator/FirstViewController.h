#import <UIKit/UIKit.h>

@class SCWebBrowser;

@interface FirstViewController : UIViewController

@property ( nonatomic, weak ) IBOutlet SCWebBrowser* webBrowser;
@property ( nonatomic, weak ) IBOutlet UISlider* widthSlider;
@property ( nonatomic, weak ) IBOutlet UISlider* heightSlider;

- (IBAction)didChangeWidth:(id)sender;
- (IBAction)didChangeHeight:(id)sender;

@end
