//
//  AppDelegate.h
//  PushNotificationSample
//
//  Created by Subodh Parulekar on 11/20/14.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "LoginViewController.h"
#import <MessageUI/MessageUI.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) NSString *mDeviceToken;
@property NSTimer *mTimer;
@property BOOL isTableViewCtrl;
@property (nonatomic,strong) NSString *mUsername;
@property (nonatomic, strong) NSString *mCompanyName;
@end


