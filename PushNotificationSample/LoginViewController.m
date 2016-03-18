//
//  LoginViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 6/23/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//



#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "TableViewController.h"
#import "ManagerViewController.h"



@implementation LoginViewController
@synthesize mImageView;
@synthesize mTextFieldUsername,mTextFieldPassword;
@synthesize mScrollview,mSpinnerBackground;
@synthesize mButtonLogin;
@synthesize mCurrDeviceModel;
@synthesize mBu,mButtonSignUp,mLabelNewOnDT;
@synthesize mLabelDevice,mLabelTracker;

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
    mCurrDeviceModel = [self platformNiceString];
    
    [mScrollview setScrollEnabled:NO];
    
    mImageView.image = [UIImage imageNamed:@"mobile-devices.png"];
    
    
    //setting loginView
    UIView *lLoginBackground = [[UIView alloc]init];
    lLoginBackground.backgroundColor = [UIColor whiteColor];
    
    
    //separator between two textFields
    UIView *lLineView = [[UIView alloc]init];
    lLineView.backgroundColor = [UIColor lightGrayColor];
    
    //setting imageView of username and password
    UIImageView *lImgViewUsername = [[UIImageView alloc]init];
    UIImageView *lImgViewPassword = [[UIImageView alloc]init];
    
    lImgViewUsername.image = [UIImage imageNamed:@"info.png"];
    lImgViewPassword.image = [UIImage imageNamed:@"lock.png"];
    
    //setting frame of textField
    mTextFieldUsername = [[UITextField alloc]init];
    mTextFieldPassword = [[UITextField alloc]init];
    
    
    
    mTextFieldPassword.delegate = self;
    mTextFieldUsername.delegate = self;
    
    mTextFieldUsername.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mTextFieldPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    mTextFieldPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    mTextFieldUsername.autocorrectionType = UITextAutocorrectionTypeNo;
    
    mTextFieldUsername.placeholder = @"Username";
    mTextFieldPassword.placeholder = @"Password";
    
    mTextFieldPassword.secureTextEntry =YES;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 4S"]||[mCurrDeviceModel isEqualToString:@"iPhone 4"]||[mCurrDeviceModel isEqualToString:@"iPhone 3G"]||[mCurrDeviceModel isEqualToString:@"iPhone 3GS"]) {
            mImageView.frame = CGRectMake(80, 100, 160, 160);
            
            lLoginBackground.frame = CGRectMake(40, 260, 240, 80);
            
            lLineView.frame = CGRectMake(20, 40, 220, 0.5);
            
            lImgViewUsername.frame = CGRectMake(5, 10, 20, 20);
            lImgViewPassword.frame = CGRectMake(2, 48, 20, 20);
            
            mTextFieldUsername.frame = CGRectMake(30, 5, 210, 30);
            mTextFieldPassword.frame = CGRectMake(30, 45, 210, 30);
            
            //font of textField
            mTextFieldPassword.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            mTextFieldUsername.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            
            lLoginBackground.layer.cornerRadius = 10.0;
            
            mBu.frame = CGRectMake(100, 360, 120, 30);
            mButtonLogin.frame = CGRectMake(40, 400, 240, 40);
            mLabelNewOnDT.frame = CGRectMake(65, 450, 140, 20);
            mButtonSignUp.frame = CGRectMake(195, 450, 63, 20);
        }
        
       else if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
             mScrollview.frame = CGRectMake(0, 0, 414, 736);
           mLabelDevice.font = [ UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0];
           mLabelTracker.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
            mLabelDevice.frame = CGRectMake(136, 75, 56, 21);
            mLabelTracker.frame = CGRectMake(192, 75, 80, 21);
           
            mImageView.frame = CGRectMake(90, 120, 234, 234);
            
            lLoginBackground.frame = CGRectMake(87, 390, 240, 80);
            
            lLineView.frame = CGRectMake(20, 40, 220, 0.5);
            
            lImgViewUsername.frame = CGRectMake(5, 10, 20, 20);
            lImgViewPassword.frame = CGRectMake(2, 48, 20, 20);
            
            mTextFieldUsername.frame = CGRectMake(30, 5, 210, 30);
            mTextFieldPassword.frame = CGRectMake(30, 45, 210, 30);
            
            //font of textField
            mTextFieldPassword.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
            mTextFieldUsername.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
            
            lLoginBackground.layer.cornerRadius = 10.0;
            
            mBu.frame = CGRectMake(143, 525, 150, 30);
            mBu.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
           
           mButtonLogin.frame = CGRectMake(87, 560, 240, 40);
            mButtonLogin.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
           
           mLabelNewOnDT.frame = CGRectMake(105, 610, 180, 20);
           mLabelNewOnDT.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
           
            mButtonSignUp.frame = CGRectMake(243, 610, 80, 20);
           mButtonSignUp.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        }
        
       else if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {

           mScrollview.frame = CGRectMake(0, 0, 375, 667);
           
           mLabelDevice.font = [ UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0];
           mLabelTracker.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
           
           mLabelDevice.frame = CGRectMake(116, 75, 56, 21);
           mLabelTracker.frame = CGRectMake(172, 75, 80, 21);
           
           mImageView.frame = CGRectMake(70, 120, 234, 234);
           
           lLoginBackground.frame = CGRectMake(67, 390, 240, 80);
           
           lLineView.frame = CGRectMake(20, 40, 220, 0.5);
           
           lImgViewUsername.frame = CGRectMake(5, 10, 20, 20);
           lImgViewPassword.frame = CGRectMake(2, 48, 20, 20);
           
           mTextFieldUsername.frame = CGRectMake(30, 5, 210, 30);
           mTextFieldPassword.frame = CGRectMake(30, 45, 210, 30);
           
           //font of textField
           mTextFieldPassword.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
           mTextFieldUsername.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
           
           lLoginBackground.layer.cornerRadius = 10.0;
           
           mBu.frame = CGRectMake(113, 525, 150, 30);
           mBu.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
           
           mButtonLogin.frame = CGRectMake(67, 560, 240, 40);
           mButtonLogin.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
           
           mLabelNewOnDT.frame = CGRectMake(80, 608, 180, 20);
           mLabelNewOnDT.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
           
           mButtonSignUp.frame = CGRectMake(218, 610, 80, 20);
           mButtonSignUp.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
       }
        
        else{
            mScrollview.frame = CGRectMake(0, 0, 414, 736);
            lLoginBackground.frame = CGRectMake(40, 331, 240, 80);
        
            lLineView.frame = CGRectMake(20, 40, 220, 0.5);
        
            lImgViewUsername.frame = CGRectMake(5, 10, 20, 20);
            lImgViewPassword.frame = CGRectMake(2, 48, 20, 20);
        
            mTextFieldUsername.frame = CGRectMake(30, 5, 210, 30);
            mTextFieldPassword.frame = CGRectMake(30, 45, 210, 30);
        
            //font of textField
            mTextFieldPassword.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            mTextFieldUsername.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        
            lLoginBackground.layer.cornerRadius = 10.0;
        }
    }
    else{
        lLoginBackground.frame = CGRectMake(167, 610, 435, 200);
        lLineView.frame = CGRectMake(20, 100, 415, 0.5);
        lImgViewUsername.frame = CGRectMake(10,30 , 30, 30);
        lImgViewPassword.frame = CGRectMake(8, 125, 30, 30);
        
        mTextFieldUsername.frame = CGRectMake(50, 30, 380, 30);
        mTextFieldPassword.frame = CGRectMake(50, 130, 380, 30);
        
        //font of textField
        mTextFieldPassword.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
        mTextFieldUsername.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
        
        lLoginBackground.layer.cornerRadius = 20.0;
    }
    
    lLoginBackground.clipsToBounds = YES;
    
  
    mTextFieldUsername.clearButtonMode = UITextFieldViewModeAlways;
    mTextFieldPassword.clearButtonMode = UITextFieldViewModeAlways;
    
    //adding textFields on loginView
    [lLoginBackground addSubview:mTextFieldUsername];
    [lLoginBackground addSubview:mTextFieldPassword];
    
    //adding imageView
    [lLoginBackground addSubview:lImgViewPassword];
    [lLoginBackground addSubview:lImgViewUsername];
    
    
    
    [lLoginBackground addSubview:lLineView];
    
    //adding loginView on scrollView
    [mScrollview addSubview:lLoginBackground];
    [mScrollview addSubview:mButtonLogin];
    
    //setting activityIndicator
    mySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    mySpinner.frame = CGRectMake(10, 10, 60, 60);
    mySpinner.transform = CGAffineTransformMakeScale(2,2);
    [mySpinner sizeToFit];
    mySpinner.hidesWhenStopped = YES;
    
    mSpinnerBackground = [[UIView alloc]init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {
            mSpinnerBackground.frame = CGRectMake(147.5, 150, 80, 80);
        }
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]){
            mSpinnerBackground.frame = CGRectMake(167, 150, 80, 80);
        }
        else{
            mSpinnerBackground.frame = CGRectMake(120, 150, 80, 80);
        }
    }
    else{
        mSpinnerBackground.frame = CGRectMake(344, 350, 80, 80);
    }
    mSpinnerBackground.layer.cornerRadius = 10.0;
    mSpinnerBackground.backgroundColor = [UIColor blackColor];
    [mSpinnerBackground addSubview:mySpinner];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [mScrollview setContentOffset:CGPointMake(0, 150) animated:YES];
        
    }
    else{
        [mScrollview setContentOffset:CGPointMake(0, 250) animated:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
       [mScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
        [mScrollview setContentOffset:CGPointMake(0, 60) animated:YES];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.mTextFieldUsername = nil;
    self.mTextFieldPassword = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.mTextFieldPassword.text = @"";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [mScrollview setContentSize:CGSizeMake(320, 700)];
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            [mScrollview setContentSize:CGSizeMake(414, 736)];
        }
     
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {
            [mScrollview setContentSize:CGSizeMake(375, 667)];
        }
        
    }
    else{
        [mScrollview setContentOffset:CGPointMake(0,60) animated:YES];
    }
}

#pragma mark IB Actions

//Login button pressed
-(IBAction)logInPressed:(id)sender
{
    [NSThread detachNewThreadSelector: @selector(Start) toTarget:self withObject:nil];
    [self.view addSubview:mSpinnerBackground];
    [PFUser logInWithUsernameInBackground:mTextFieldUsername.text password:mTextFieldPassword.text block:^(PFUser *user, NSError *error) {
        if (user) {
            
            //check whether user is admin or normal user
            TableViewController *tblVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TableViewController"];
            tblVC.mUsername = self.mTextFieldUsername.text;
            tblVC.mCurrDeviceModel = mCurrDeviceModel;
            AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
            appDel.mUsername = tblVC.mUsername;
            appDel.mCompanyName = [user objectForKey:@"companyName"];
            if ([[user objectForKey:@"isManager"]boolValue]) {
                [mySpinner stopAnimating];
                [mSpinnerBackground removeFromSuperview];
                tblVC.mIsManager = YES;
                [self.navigationController pushViewController:tblVC animated:YES];
                
            }else{
            
            if ([[user objectForKey:@"isAdmin"]boolValue]) {
              tblVC.mUser = @"admin";
                tblVC.mIsAdmin = YES;
                [mySpinner stopAnimating];
                [mSpinnerBackground removeFromSuperview];
                [self.navigationController pushViewController:tblVC animated:YES];
            }
            else{
                tblVC.mUser = @"user";
                tblVC.mIsAdmin = NO;
                [mySpinner stopAnimating];
                [mSpinnerBackground removeFromSuperview];
                
                PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
                [query whereKey:@"deviceToken" equalTo:appDel.mDeviceToken];
                
                NSArray *objects = [query findObjects];
                if(objects.count!=0)
                {
                    for (PFObject *object in objects) {
                        
                        if ([mTextFieldUsername.text isEqualToString:[object valueForKey:@"deviceCurrentUser"]]) {
                             [self.navigationController pushViewController:tblVC animated:YES];
                        }
                        else{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Device Tracker" message:@"This device is not checked out on your username. Please ask admin to checkout this device" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Device Tracker" message:@"This device is not registered yet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
                
            }
            }
            
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [mySpinner stopAnimating];
            [mSpinnerBackground removeFromSuperview];
            [errorAlertView show];
        }
    }];

    
    
    //send Push notification in background
    /*
    NSString *message=[[@"Test" stringByAppendingString:@" "]stringByAppendingString:@"sent you test msg"];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"1", @"content-available",
                          nil];
    PFPush *push = [[PFPush alloc] init];
    
    //NSError *error;
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"deviceToken"equalTo:@"c33c257446271d1241e5b038dc56c6e31a2c5499a4068d59aa4f2c2cb9609b9c"];
    [push setQuery:pushQuery];
    [push setData:data];
    [push sendPushInBackground];
     */
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [mScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
        [mScrollview setContentOffset:CGPointMake(0, 60) animated:YES];
    }
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [mScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
        [mScrollview setContentOffset:CGPointMake(0, 60) animated:YES];
    }
    return YES;
}

#pragma tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (void) Start
{
    mySpinner.hidden = NO;
    [mySpinner startAnimating];
}

-(IBAction)signUpClicked:(id)sender
{
    RegisterViewController *lChVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    lChVC.mCurrDeviceModel = mCurrDeviceModel;
    [self.navigationController pushViewController:lChVC animated:YES];
}

-(IBAction)forgotPasswordClicked:(id)sender
{
    ForgotPasswordViewController *lChVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    lChVC.mCurrDeviceModel = mCurrDeviceModel;
    [self.navigationController pushViewController:lChVC animated:YES];
}


- (NSString *)platformNiceString {
    NSString *platform = [self platformRawString];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6+";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (4G,2)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (4G,3)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

- (NSString *)platformRawString {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
@end
