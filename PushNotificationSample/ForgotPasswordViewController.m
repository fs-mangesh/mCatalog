//
//  ForgotPasswordViewController.m
//  PushNotificationSample
//
//  Created by Subodh Parulekar on 12/4/14.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize mLabelContact,mButtonReset,mImageViewContact,mCurrDeviceModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.navigationController.navigationBarHidden = NO;
    UIView *lInfoLowerView = [[UIView alloc]init];
    lInfoLowerView.backgroundColor = [UIColor lightGrayColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {
            mLabelContact.frame = CGRectMake(145, 149, 85, 21);
            mImageViewContact.frame = CGRectMake(126, 147, 25,25);
            
            self.mTxtEmail.frame = CGRectMake(61, 236, 252, 30);
            
            lInfoLowerView.frame = CGRectMake(61, 266, 252, 0.5);
            
            mButtonReset.frame = CGRectMake(121, 316, 133, 30);
        }
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            mLabelContact.frame = CGRectMake(165, 149, 85, 21);
            mImageViewContact.frame = CGRectMake(146, 147, 25,25);
            
            self.mTxtEmail.frame = CGRectMake(81, 236, 252, 30);
            
            lInfoLowerView.frame = CGRectMake(81, 266, 252, 0.5);
            
            mButtonReset.frame = CGRectMake(141, 316, 133, 30);
        }
        else{
            lInfoLowerView.frame = CGRectMake(34, 246, 252, 0.5);
        }
    }
    else{
        lInfoLowerView.frame = CGRectMake(190, 414, 391, 0.5);
    }
    [self.view addSubview:lInfoLowerView];
}



-(IBAction)sendPasswordResetRequest:(id)sender
{
    if([self.mTxtEmail.text length]!=0 && [self isValidEmail:self.mTxtEmail.text] )
    {
        [PFUser requestPasswordResetForEmailInBackground:self.mTxtEmail.text block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //The registration was succesful, go to the wall
                //            [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
                NSString *msg = [NSString stringWithFormat:@"Reset Password: Mail has been sent to %@.Please check",self.mTxtEmail.text];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
                
            } else {
                //Something bad has ocurred
                NSString *errorString = [[error userInfo] objectForKey:@"error"];

                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];

    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Device Tracker" message:@"Please enter valid email id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
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
    [self.mTxtEmail resignFirstResponder];
    return YES;
}




@end
