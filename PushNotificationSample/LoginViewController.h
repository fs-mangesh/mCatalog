//
//  LoginViewController.h
//  TutorialBase
//
//  Created by Antonio MG on 6/23/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    UIActivityIndicatorView *mySpinner;
}


@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollview;
@property (weak, nonatomic) IBOutlet UIButton *mButtonLogin;


-(IBAction)logInPressed:(id)sender;

@property (strong,nonatomic) UITextField *mTextFieldUsername;
@property (strong,nonatomic) UITextField *mTextFieldPassword;

@property (strong,nonatomic) UIView *mSpinnerBackground;
@property (strong,nonatomic) NSString *mCurrDeviceModel;
@property (weak, nonatomic) IBOutlet UILabel *mLabelNewOnDT;
@property (weak, nonatomic) IBOutlet UIButton *mButtonSignUp;
@property (weak, nonatomic) IBOutlet UIButton *mBu;
@property (weak, nonatomic) IBOutlet UILabel *mLabelDevice;
@property (weak, nonatomic) IBOutlet UILabel *mLabelTracker;

@end
