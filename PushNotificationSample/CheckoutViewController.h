//
//  CheckoutViewController.h
//  PushNotificationSample
//
//  Created by afour on 2014-11-28.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>


@interface CheckoutViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mTextFieldUsername;

@property (nonatomic,strong) IBOutlet UITextField *mTxtBooktime;
@property (nonatomic,strong) NSString *mUsername;
@property (nonatomic,strong) NSString *mBtnOption;
@property (nonatomic,weak) IBOutlet UIButton *btnCheckout;

@property (nonatomic,strong) NSDate *d1;
@property (nonatomic,strong) NSDate *d2;
@property (nonatomic,strong) NSCalendar *sysCalendar;
@property  NSTimeInterval timeInterval;
-(IBAction)checkoutDone:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mLabelHeading;

@property (weak, nonatomic) IBOutlet UIImageView *mImageViewHeading;

@property (strong, nonatomic) NSString *mCurrentUserEmail;
@property (strong, nonatomic) NSString *mCurrentDeviceName;
@property (strong, nonatomic) NSString *mDeviceCheckIn;
@property (strong, nonatomic) UIAlertView *mAlertEmail;

@property (strong, nonatomic) UIView *lInfoLowerView;
@property (strong, nonatomic) UIView *lInfoUpperView;

@property (strong,nonatomic) NSString *mCurrDeviceModel;
@end
