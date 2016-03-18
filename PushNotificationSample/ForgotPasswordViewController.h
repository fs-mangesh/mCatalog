//
//  ForgotPasswordViewController.h
//  PushNotificationSample
//
//  Created by Subodh Parulekar on 12/4/14.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UITextField *mTxtEmail;

-(IBAction)sendPasswordResetRequest:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mLabelContact;
@property (weak, nonatomic) IBOutlet UIImageView *mImageViewContact;
@property (weak, nonatomic) IBOutlet UIButton *mButtonReset;
@property (strong,nonatomic) NSString *mCurrDeviceModel;
@end
