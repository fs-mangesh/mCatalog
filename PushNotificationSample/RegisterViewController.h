//
//  RegisterViewController.h
//  TutorialBase
//
//  Created by Antonio MG on 6/27/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterViewController : UIViewController<UITextFieldDelegate>{
}

@property (nonatomic, strong) IBOutlet UITextField *userRegisterTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordRegisterTextField;
@property (nonatomic, strong) IBOutlet UITextField *mTxtConfirmPasswd;
@property (nonatomic, strong) IBOutlet UITextField *mTxtEmail;


-(IBAction)signUpUserPressed:(id)sender;


@property (nonatomic ,strong) UILabel *lblNavigationTitle;



@property (weak, nonatomic) IBOutlet UIButton *mButtonSignUp;

@property (weak, nonatomic) IBOutlet UITextField *mTextFieldCompanyName;
@property (weak, nonatomic) IBOutlet UISwitch *mSwitchIsAdmin;

@property (strong, nonatomic) UIView *mEmailLine;
@property (strong, nonatomic) UIView *mUsernameLine;
@property (strong, nonatomic) UIView *mPasswordLine;
@property (strong, nonatomic) UIView *mConfirmPasswordLine;
@property (strong, nonatomic) UIView *mCompanyLine;

@property (strong,nonatomic) NSString *mCurrDeviceModel;
@end
