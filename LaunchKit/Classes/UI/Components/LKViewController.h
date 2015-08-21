//
//  LKViewController.h
//  LaunchKitRemoteUITest
//
//  Created by Rizwan Sattar on 6/15/15.
//  Copyright (c) 2015 Cluster Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LKViewControllerFlowResult)
{
    LKViewControllerFlowResultNotSet,
    LKViewControllerFlowResultCompleted,
    LKViewControllerFlowResultCancelled,
    LKViewControllerFlowResultFailed,
};

@class LKViewController;
@protocol LKViewControllerFlowDelegate <NSObject>

- (void)launchKitController:(nonnull LKViewController *)controller
        didFinishWithResult:(LKViewControllerFlowResult)result
                   userInfo:(nullable NSDictionary *)userInfo;

@end


@interface LKViewController : UIViewController

@property (weak, nonatomic, nullable) id <LKViewControllerFlowDelegate> flowDelegate;

@property (assign, nonatomic) IBInspectable BOOL statusBarShouldHide;
@property (assign, nonatomic) IBInspectable NSInteger statusBarStyleValue;

@property (strong, nonatomic, nullable) IBInspectable NSString *unwindSegueClassName;
@property (strong, nonatomic, nullable) IBInspectable NSString *presentationStyleName;

@property (assign, nonatomic) IBInspectable CGFloat viewCornerRadius;

#pragma mark - Flow Delegation
- (void) finishFlowWithResult:(LKViewControllerFlowResult)result
                     userInfo:(nullable NSDictionary *)userInfo;

@end
