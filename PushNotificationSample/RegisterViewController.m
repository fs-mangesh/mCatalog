//
//  RegisterViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 6/27/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import "RegisterViewController.h"

#import <Parse/Parse.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize userRegisterTextField = _userRegisterTextField, passwordRegisterTextField = _passwordRegisterTextField,lblNavigationTitle;

@synthesize mButtonSignUp;
@synthesize mCurrDeviceModel;
@synthesize mTxtConfirmPasswd,mTxtEmail;
@synthesize mCompanyLine,mConfirmPasswordLine,mEmailLine,mPasswordLine,mSwitchIsAdmin,mTextFieldCompanyName,mUsernameLine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        mTxtEmail.frame = CGRectMake(((screenWidth-mTxtEmail.frame.size.width)/2), mTxtEmail.frame.origin.y, mTxtEmail.frame.size.width, 30);
        self.userRegisterTextField.frame = CGRectMake(((screenWidth-self.userRegisterTextField.frame.size.width)/2), self.userRegisterTextField.frame.origin.y, self.userRegisterTextField.frame.size.width, 30);
        self.passwordRegisterTextField.frame = CGRectMake(((screenWidth-self.passwordRegisterTextField.frame.size.width)/2), self.passwordRegisterTextField.frame.origin.y, self.passwordRegisterTextField.frame.size.width, 30);
        self.mTxtConfirmPasswd.frame = CGRectMake(((screenWidth-self.mTxtConfirmPasswd.frame.size.width)/2), self.mTxtConfirmPasswd.frame.origin.y, self.mTxtConfirmPasswd.frame.size.width, 30);
        mTextFieldCompanyName.frame = CGRectMake(((screenWidth-mTextFieldCompanyName.frame.size.width)/2), mTextFieldCompanyName.frame.origin.y, mTextFieldCompanyName.frame.size.width, 30);
        mButtonSignUp.frame = CGRectMake(((screenWidth-mButtonSignUp.frame.size.width)/2), mButtonSignUp.frame.origin.y, mButtonSignUp.frame.size.width, 30);
    }
    

    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationLabel];
    
    self.userRegisterTextField.delegate = self;
    self.passwordRegisterTextField.delegate =self;
    self.mTxtConfirmPasswd.delegate = self;
    self.mTxtEmail.delegate =self;
    
    self.passwordRegisterTextField.secureTextEntry = YES;
    self.mTxtConfirmPasswd.secureTextEntry = YES;
    
    
    mEmailLine = [[UIView alloc]initWithFrame:CGRectMake(mTxtEmail.frame.origin.x, mTxtEmail.frame.origin.y+30, mTxtEmail.frame.size.width, 1)];
    mEmailLine.backgroundColor = [UIColor lightGrayColor];
    
    mUsernameLine = [[UIView alloc]initWithFrame:CGRectMake(self.userRegisterTextField.frame.origin.x, self.userRegisterTextField.frame.origin.y+30, self.userRegisterTextField.frame.size.width, 1)];
    mUsernameLine.backgroundColor = [UIColor lightGrayColor];
    
    mPasswordLine = [[UIView alloc]initWithFrame:CGRectMake(self.passwordRegisterTextField.frame.origin.x, self.passwordRegisterTextField.frame.origin.y+30, self.passwordRegisterTextField.frame.size.width, 1)];
    mPasswordLine.backgroundColor = [UIColor lightGrayColor];
    
    mConfirmPasswordLine = [[UIView alloc]initWithFrame:CGRectMake(self.mTxtConfirmPasswd.frame.origin.x, self.mTxtConfirmPasswd.frame.origin.y+30, self.mTxtConfirmPasswd.frame.size.width, 1)];
    mConfirmPasswordLine.backgroundColor = [UIColor lightGrayColor];
    
    mCompanyLine = [[UIView alloc]initWithFrame:CGRectMake(mTextFieldCompanyName.frame.origin.x, mTextFieldCompanyName.frame.origin.y+30, mTextFieldCompanyName.frame.size.width, 1)];
    mCompanyLine.backgroundColor = [UIColor lightGrayColor];

    [self.view addSubview:mEmailLine];
    [self.view addSubview:mUsernameLine];
    [self.view addSubview:mPasswordLine];
    [self.view addSubview:mCompanyLine];
    [self.view addSubview:mConfirmPasswordLine];
    
    self.passwordRegisterTextField.tag =0;
    self.mTxtConfirmPasswd.tag = 1;
    self.userRegisterTextField.tag = 2;
    self.mTxtEmail.tag = 3;

}



//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (textField.tag == 0 || textField.tag == 1) {
//        if ([mCurrDeviceModel isEqualToString:@"iPhone 4S"]||[mCurrDeviceModel isEqualToString:@"iPhone 4"]||[mCurrDeviceModel isEqualToString:@"iPhone 3G"]||[mCurrDeviceModel isEqualToString:@"iPhone 3GS"]){
//            [mScrollView setContentOffset:CGPointMake(0,110) animated:YES];
//            mImgViewLock.hidden = YES;
//            mLabelPassword.hidden = YES;
//
//        }
//        else{
//            [mScrollView setContentOffset:CGPointMake(0,85) animated:YES];
//            mImgViewLock.hidden = YES;
//            mLabelPassword.hidden = YES;
//        }
//    }
//    
//}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//
//    if (textField.tag == 3 && self.mTxtEmail.text.length > 0){
//        self.userRegisterTextField.text = [self.mTxtEmail.text stringByReplacingOccurrencesOfString:@"@afourtech.com" withString:@""];
//    }
//}
-(void)setNavigationLabel
{
    
    lblNavigationTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 185, 20)];
    lblNavigationTitle.text = @"SignUp";
    lblNavigationTitle.textColor = [UIColor whiteColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        lblNavigationTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    }
    else{
        lblNavigationTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    }
    lblNavigationTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lblNavigationTitle;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userRegisterTextField = nil;
    self.passwordRegisterTextField = nil;
}


#pragma mark IB Actions

////Sign Up Button pressed
-(IBAction)signUpUserPressed:(id)sender
{
    if(([self.userRegisterTextField.text length] !=0) && ([self.passwordRegisterTextField.text length] !=0) && ([self.mTxtEmail.text length] !=0) && ([self.mTxtConfirmPasswd.text length] !=0)&&([mTextFieldCompanyName.text length]!= 0))
    {
        if([self.passwordRegisterTextField.text isEqualToString:self.mTxtConfirmPasswd.text])
        {
            if([self isValidEmail:self.mTxtEmail.text])
            {
                PFUser *user = [PFUser user];
                user.username = self.userRegisterTextField.text;
                user.password = self.passwordRegisterTextField.text;
                user.email = self.mTxtEmail.text;
                if ([mSwitchIsAdmin isOn] == YES) {
                    [user setObject:[NSNumber numberWithBool:YES] forKey:@"isAdmin"];
                }
                else{
                    [user setObject:[NSNumber numberWithBool:NO] forKey:@"isAdmin"];
                }
                
                [user setObject:mTextFieldCompanyName.text forKey:@"companyName"];
                
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        //The registration was succesful, go to the wall
                        //            [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Sign Up Successful" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alertView show];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        
                        //saving info in users classses
                        PFObject *object = [[PFObject alloc]initWithClassName:@"Users"];
                        [object setObject:self.userRegisterTextField.text forKey:@"userName"];
                        [object setObject:mTextFieldCompanyName.text forKey:@"companyName"];
                        if ([mSwitchIsAdmin isOn] == YES) {
                            [user setObject:@"true" forKey:@"isAdmin"];
                        }else{
                             [user setObject:@"false" forKey:@"isAdmin"];
                        }
                        
                        [object setObject:@"0" forKey:@"checkoutNumber"];
                        [object save];
                        
                    } else {
                        //Something bad has ocurred
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [errorAlertView show];
                    }
                }];

            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Please enter a valid email!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Please confirm password again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Please enter Valid values" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(BOOL) isValidEmail:(NSString *)tempMail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:tempMail];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
