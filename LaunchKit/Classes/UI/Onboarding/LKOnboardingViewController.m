//
//  LKOnboardingViewController.m
//  Pods
//
//  Created by Rizwan Sattar on 1/25/16.
//
//

#import "LKOnboardingViewController.h"

#import "LKLog.h"

@interface LKOnboardingViewController ()

#if !TARGET_OS_TV
@property (assign, nonatomic) BOOL shouldLockOrientation;
@property (assign, nonatomic) UIInterfaceOrientation lockedOrientation;
#endif
@property (strong, nonatomic, nullable) UIImageView *launchImageView;
@property (strong, nonatomic, nullable) UIView *launchScreenView;
@property (strong, nonatomic, nullable) UIViewController *launchViewController;

@end

@implementation LKOnboardingViewController

- (void) loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];

    BOOL loadedLaunchImage = [self loadLaunchImageIfPossible];
    BOOL loadedLaunchStoryboard = NO;
    if (!loadedLaunchImage) {
        loadedLaunchStoryboard = [self loadLaunchStoryboardIfPossible];
    } else {
#if !TARGET_OS_TV
        self.shouldLockOrientation = YES;
#endif
    }
    if (!loadedLaunchImage && !loadedLaunchStoryboard) {
        LKLogError(@"Neither LaunchImage or Launch screen was loaded");
    }
}

- (BOOL) loadLaunchImageIfPossible
{
    UIImage *launchImage = [UIImage imageNamed:@"LaunchImage"];
    if (launchImage != nil) {
        self.launchImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.launchImageView.image = launchImage;
        [self.view addSubview:self.launchImageView];
        return YES;
    }

    return NO;
}

- (BOOL) loadLaunchStoryboardIfPossible
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *launchScreenName = [NSBundle mainBundle].infoDictionary[@"UILaunchStoryboardName"];
    if (launchScreenName.length > 0) {
        // Try storyboard first
        UIViewController *launchViewController = nil;
        @try {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:launchScreenName bundle:bundle];
            launchViewController = [storyboard instantiateInitialViewController];
        }
        @catch (NSException *exception) {
            // Storyboard could not load, so move on
            LKLogWarning(@"%@.storyboard not found", launchScreenName);
        }
        @finally {
            //
        }

        // Try xib next
        @try {
            UINib *nib = [UINib nibWithNibName:launchScreenName bundle:bundle];
            UIViewController *nibVC = [[UIViewController alloc] init];
            NSArray *topLevelObjects = [nib instantiateWithOwner:nibVC options:nil];

            if ([topLevelObjects.firstObject isKindOfClass:[UIView class]]) {
                self.launchScreenView = (UIView *)topLevelObjects.firstObject;
            } else if ([topLevelObjects.firstObject isKindOfClass:[UIViewController class]]) {
                self.launchViewController = (UIViewController *)topLevelObjects.firstObject;
            }
        }
        @catch (NSException *exception) {
            // Nib could not be loaded
            LKLogWarning(@"%@.nib not found", launchScreenName);
        }
        @finally {
            //
        }

        if (self.launchViewController != nil && self.launchScreenView == nil) {
            self.launchViewController = launchViewController;
            self.launchScreenView = self.launchViewController.view;
        }

        if (self.launchScreenView != nil) {
            if (self.launchViewController != nil) {
                [self addChildViewController:self.launchViewController];
            }
            [self.view addSubview:self.launchScreenView];
            self.launchScreenView.frame = self.view.bounds;
            self.launchScreenView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            return YES;
        }
    }
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dismissalHandler) {
            self.dismissalHandler(LKViewControllerFlowResultCompleted);
        }
        self.dismissalHandler = nil;
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end