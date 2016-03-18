//
//  CheckoutViewController.m
//  PushNotificationSample
//
//  Created by afour on 2014-11-28.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#define APP ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#import "CheckoutViewController.h"
#import <Parse/Parse.h>
#import "ParseInterface.h"

@interface CheckoutViewController ()

@end

@implementation CheckoutViewController
static NSString *UYLKeyCapital = @"UYLKeyCapital";
@synthesize d1,d2,sysCalendar,timeInterval;
@synthesize mTextFieldUsername;
@synthesize mImageViewHeading,mLabelHeading;
@synthesize mAlertEmail,mCurrentUserEmail,mDeviceCheckIn,mCurrentDeviceName;
@synthesize lInfoLowerView,lInfoUpperView;
@synthesize mCurrDeviceModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    mCurrDeviceModel = [self platformNiceString];

    [self.btnCheckout setTitle:self.mBtnOption forState:UIControlStateNormal];
    self.navigationController.navigationBarHidden = NO;
    self.mTxtBooktime.delegate = self;
    mTextFieldUsername.delegate = self;
    mTextFieldUsername.hidden = NO;
    
    lInfoLowerView = [[UIView alloc]init];
    lInfoLowerView.backgroundColor = [UIColor lightGrayColor];
    
    lInfoUpperView = [[UIView alloc]init];
    lInfoUpperView.backgroundColor = [UIColor lightGrayColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {
            mImageViewHeading.frame = CGRectMake(130, 93, 25, 25);
            mLabelHeading.frame = CGRectMake(158, 90, 90, 30);
            
            mTextFieldUsername.frame = CGRectMake(61, 205, 252, 30);
            self.mTxtBooktime.frame = CGRectMake(61, 277, 252, 30);
            
            lInfoUpperView.frame = CGRectMake(61, 235, 252, 0.5);
            lInfoLowerView.frame = CGRectMake(61, 307, 252, 0.5);
            
            self.btnCheckout.frame = CGRectMake(108, 382, 160, 40);
            
            mTextFieldUsername.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
            self.mTxtBooktime.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
            mLabelHeading.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
            self.btnCheckout.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
        }
        
       else if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            mImageViewHeading.frame = CGRectMake(153, 100, 25, 25);
            mLabelHeading.frame = CGRectMake(180, 98, 90, 30);
            
            mTextFieldUsername.frame = CGRectMake(81, 205, 252, 30);
            self.mTxtBooktime.frame = CGRectMake(81, 277, 252, 30);
            
            lInfoUpperView.frame = CGRectMake(81, 235, 252, 0.5);
            lInfoLowerView.frame = CGRectMake(81, 307, 252, 0.5);
            
            self.btnCheckout.frame = CGRectMake(127, 390, 161, 40);
           
           mTextFieldUsername.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
           self.mTxtBooktime.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
           mLabelHeading.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
           self.btnCheckout.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
        }
        
        else{
            lInfoUpperView.frame = CGRectMake(34, 185, 252, 0.5);
            lInfoLowerView.frame = CGRectMake(34, 257, 252, 0.5);
        }
    }
    else{
        lInfoUpperView.frame = CGRectMake(189, 299, 390, 0.5);
        lInfoLowerView.frame = CGRectMake(189, 398, 390, 0.5);
    }
    [self.view addSubview:lInfoUpperView];
    [self.view addSubview:lInfoLowerView];
    lInfoUpperView.hidden = NO;
    
    if([self.mBtnOption isEqualToString:@"Retain"])
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setDate:[NSDate date]];
        [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
        [self.mTxtBooktime setInputView:datePicker];
        self.mTxtBooktime.placeholder = @"Select date";
        mTextFieldUsername.hidden = YES;
        lInfoUpperView.hidden = YES;
        mLabelHeading.text = @"Retain";
        mImageViewHeading.image = [UIImage imageNamed:@"retain.png"];
    }
    if([self.mBtnOption isEqualToString:@"Register"])
    {
        [self.mTxtBooktime setKeyboardType:UIKeyboardTypeDefault];
        self.mTxtBooktime.placeholder = @"Enter Registration Identifier";
        mTextFieldUsername.hidden = YES;
        lInfoUpperView.hidden = YES;
        mLabelHeading.text = @"Register";
        mImageViewHeading.image = [UIImage imageNamed:@"register.png"];
    }
    if ([self.mBtnOption isEqualToString:@"Extend"]) {
        mTextFieldUsername.hidden = YES;
        lInfoUpperView.hidden = YES;
        mLabelHeading.text = @"Extend";
        mImageViewHeading.image = [UIImage imageNamed:@"extend.png"];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSArray *arrViews = [self.navigationController.navigationBar subviews];
    for(UIView *view in arrViews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
}

-(void)checkoutDone:(id)sender
{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    if([self.mBtnOption isEqualToString:@"Checkout"])
    {
        if([self.mTxtBooktime.text length]!=0||mTextFieldUsername.text.length != 0)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"Users"];
            [query whereKey:@"userName" equalTo:mTextFieldUsername.text];
            [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
            NSArray *objects = [query findObjects];
            if(objects.count!=0)
            {
                PFObject *user = [objects objectAtIndex:0];
                int checkoutNumber = [[user objectForKey:@"checkoutNumber"]intValue];
                checkoutNumber++;
                NSString *checkoutNumberString = [NSString stringWithFormat:@"%i",checkoutNumber];
                [user setObject:checkoutNumberString forKey:@"checkoutNumber"];
                [user saveEventually:^(BOOL succeeded, NSError *error) {
                
                    if(succeeded)
                    {
                        
                        
                        
                        timeInterval = [self.mTxtBooktime.text integerValue]*60*60;
                        d2 = [NSDate dateWithTimeInterval:timeInterval sinceDate:[NSDate date]];
                        [[ParseInterface sharedInstance]checkoutCurrentDevice:mTextFieldUsername.text duration:[NSDate dateWithTimeIntervalSinceNow:[self.mTxtBooktime.text integerValue]*60*60] :self.mTxtBooktime.text];
                        [self setLocalNotifications:self.mTxtBooktime.text];
                        
                        
                        
                        
                        mCurrentDeviceName = [UIDevice currentDevice].name;
                        mCurrentUserEmail = [mTextFieldUsername.text stringByAppendingString:@"@afourtech.com"];
                        mDeviceCheckIn = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSinceNow:[self.mTxtBooktime.text integerValue]*60*60]];
                        
//                        mAlertEmail = [[UIAlertView alloc]initWithTitle:@"Device Tracker" message:@"Email notification will be sent to user about device allocation" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        mAlertEmail = [[UIAlertView alloc]initWithTitle:@"Device Tracker" message:@"Device checked out successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];

                        [mAlertEmail show];
                    }

                }];
            
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Device Tracker" message:@"Please check username. If respective user has not signed up, request him to sign up at login screen" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
    
        }
        else
        {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Please enter all fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
       
    }
    else if([self.mBtnOption isEqualToString:@"Retain"])
    {
        if([self.mTxtBooktime.text length] !=0)
        {
            [[ParseInterface sharedInstance]retainCurrrentDevice:self.mUsername];
            [self setLocalNotifications:@"24"];
        }
        else
        {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Please enter valid duration" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }
    else if([self.mBtnOption isEqualToString:@"Extend"])
    {
        if([self.mTxtBooktime.text length] !=0)
        {
            [[ParseInterface sharedInstance]extendCurrentDeviceDuration:self.mTxtBooktime.text user:self.mUsername];
            
            [self setLocalNotifications:self.mTxtBooktime.text];
        }
        else
        {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Please enter valid duration" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }
    else if([self.mBtnOption isEqualToString:@"Register"])
    {
        if([self.mTxtBooktime.text length] !=0)
        {
            [[ParseInterface sharedInstance]registerThisDevice:self.mTxtBooktime.text username:self.mUsername];
            
        }
        else
        {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Please enter valid registration Number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }
    
    
}

-(void)setLocalNotifications:(NSString*)duration
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSString *string = self.mTxtBooktime.text;
    int value = [string intValue];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:value*60*60];
    localNotification.alertAction = nil;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertBody = @"Your time is up.Checkin the device or Extend the duration!!";
    localNotification.alertAction = NSLocalizedString(@"Read Msg", nil);
    localNotification.applicationIconBadgeNumber=3;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.repeatInterval=NSDayCalendarUnit;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.mTxtBooktime.inputView;
    
    NSDate *mydate = [NSDate date];
    NSTimeInterval secondsInEightHours = 24 * 60 * 60;
    NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours];
    [picker setMaximumDate:dateEightHoursAhead];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    self.mTxtBooktime.text = [NSString stringWithFormat:@"%@",dateString];
    
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == mAlertEmail) {
        if (buttonIndex == 0) {

           // [self helpEmail];

        }
    }
}

//-(void)helpEmail
//{
//    
////    if ( [MFMailComposeViewController canSendMail] )
////    {
////        [APP.globalMailComposer setToRecipients:
////         [NSArray arrayWithObjects: [NSString stringWithFormat:@"%@",mCurrentUserEmail], nil] ];
////        [APP.globalMailComposer setSubject:@"Notification regarding device allocation"];
////        [APP.globalMailComposer setMessageBody:[NSString stringWithFormat:@"Hi,\n\nThis is to inform you that device %@ is allocated on your username.\nYour expected checkin time for this device is %@\n\nRegards,\nAdmin",mCurrentDeviceName,mDeviceCheckIn] isHTML:NO];
////        APP.globalMailComposer.mailComposeDelegate = self;
////        [self presentViewController:APP.globalMailComposer
////                           animated:YES completion:nil];
////    }
////    else
////    {
////      //  [UIAlertView ok:@"Unable to mail. No email on this device?"];
////        [APP cycleTheGlobalMailComposer];
////    }
//    
//    // Email Subject
//    NSString *emailTitle = @"Notification regarding device allocation";
//    // Email Content
//    NSString *messageBody = [NSString stringWithFormat:@"Hi,\n\nThis is to inform you that device %@ is allocated on your username.\nYour expected checkin time for this device is %@\n\nRegards,\nAdmin",mCurrentDeviceName,mDeviceCheckIn]; // Change the message body to HTML
//    // To address
//    NSArray *toRecipents = [NSArray arrayWithObjects: [NSString stringWithFormat:@"%@",mCurrentUserEmail], nil];
//    
//    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//    mc.mailComposeDelegate = self;
//    [mc setSubject:emailTitle];
//    [mc setMessageBody:messageBody isHTML:YES];
//    [mc setToRecipients:toRecipents];
//    
//    // Present mail view controller on screen
//    [self presentViewController:mc animated:YES completion:NULL];
//}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
    
            break;
        case MFMailComposeResultSaved:

            break;
        case MFMailComposeResultSent:
 
            break;
        case MFMailComposeResultFailed:
 ;
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
