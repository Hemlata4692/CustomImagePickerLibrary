

#import "AssetsDataIsInaccessibleViewController.h"

@interface AssetsDataIsInaccessibleViewController ()
@property (weak, nonatomic) IBOutlet UITextView *explanationTextView;

@end

@implementation AssetsDataIsInaccessibleViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.explanationTextView.text = self.explanation;
}

- (IBAction)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
