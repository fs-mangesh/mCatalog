//
//  TableViewController.m
//  TestBaasApp
//
//  Created by Subodh Parulekar on 11/26/14.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "CheckedOutTableViewController.h"
#import "SearchDeviceTableViewController.h"
#import "CheckoutViewController.h"
#import "DeviceActivityTableViewController.h"
#import "DateHistoryTableViewController.h"
#import "ManagerViewController.h"


@interface TableViewController ()<UIDataSourceModelAssociation>

@end

@implementation TableViewController
@synthesize mAllFetchedObjectsArray;
@synthesize mUser,mUsername,mDictCurrentStatus;
@synthesize mIsAdmin,mIsCheckedOut,mIsManager;
@synthesize lblNavigationTitle;
@synthesize storyboard;
@synthesize mCurrDeviceModel;

int hours, minutes, seconds;
int secondsLeft;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    [self setNavigationLabel];
    
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];

}
-(void)getData
{
    if(mAllFetchedObjectsArray)
    {
        
    }
    mAllFetchedObjectsArray = [[NSMutableArray alloc]init];
    
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Getting Data..Please wait" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [errorAlertView show];
    
    [self checkIfAdminAndCheckeOutStatus];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"storeData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dict = [[NSDictionary alloc]init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSMutableDictionary *arr = [dict objectForKey:@"storelocator"];
    NSMutableArray *arrData = [arr objectForKey:@"item"];
    
    if (mIsManager) {
        for (NSDictionary *dict1 in arrData) {
            if ([[dict1 objectForKey:@"role"]isEqualToString:@"manager"]) {
                NSArray *lArr = [dict1 objectForKey:@"data"];
                for (NSDictionary *lDict in lArr) {
                    Options *lOptions = [[Options alloc]init];
                    lOptions.mHeading = [lDict objectForKey:@"heading"];
                    lOptions.mSubHeading = [lDict objectForKey:@"subheading"];
                    lOptions.mImageStr = [lDict objectForKey:@"image"];
                    [mAllFetchedObjectsArray addObject:lOptions];
                }
            }
        }
    }
    else{
        if (mIsAdmin && !mIsCheckedOut) {
        
            for(NSDictionary *dict1 in arrData)
            {
                if([[dict1 objectForKey:@"role"] isEqualToString:@"admin"] && [[dict1 objectForKey:@"status"] isEqualToString:@"checkout"])
                {
                    NSArray *lArr = [dict1 objectForKey:@"data"];
                    for(NSDictionary *lDict in lArr)
                    {
                        Options *lOptions = [[Options alloc]init];
                        lOptions.mHeading = [lDict objectForKey:@"heading"];
                        lOptions.mSubHeading = [lDict objectForKey:@"subheading"];
                        lOptions.mImageStr = [lDict objectForKey:@"image"];
                        [mAllFetchedObjectsArray addObject:lOptions];
                    }
                
                }
            }
        }
        else if (mIsAdmin && mIsCheckedOut)
        {
            for(NSDictionary *dict1 in arrData)
            {
                if([[dict1 objectForKey:@"role"] isEqualToString:@"admin"] && [[dict1 objectForKey:@"status"] isEqualToString:@"checkoutDone"])
                {
                    NSArray *lArr = [dict1 objectForKey:@"data"];
                    for(NSDictionary *lDict in lArr)
                    {
                        Options *lOptions = [[Options alloc]init];
                        lOptions.mHeading = [lDict objectForKey:@"heading"];
                        lOptions.mSubHeading = [lDict objectForKey:@"subheading"];
                        lOptions.mImageStr = [lDict objectForKey:@"image"];
                        [mAllFetchedObjectsArray addObject:lOptions];
                    }
                }
            }
        }
        else if (!mIsAdmin && mIsCheckedOut)
        {
            for(NSDictionary *dict1 in arrData)
            {
                if([[dict1 objectForKey:@"role"] isEqualToString:@"user"] && [[dict1 objectForKey:@"status"] isEqualToString:@"checkoutDone"])
                {
                    NSArray *lArr = [dict1 objectForKey:@"data"];
                    for(NSDictionary *lDict in lArr)
                    {
                        Options *lOptions = [[Options alloc]init];
                        lOptions.mHeading = [lDict objectForKey:@"heading"];
                        lOptions.mSubHeading = [lDict objectForKey:@"subheading"];
                        lOptions.mImageStr = [lDict objectForKey:@"image"];
                        [mAllFetchedObjectsArray addObject:lOptions];
                    }
                }
            }
            
        }
    }

    [errorAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [self.tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [self getData];
    if(mIsCheckedOut)
    {
        [self updateCountdown];
    }
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSArray *arrViews = [self.navigationController.navigationBar subviews];
    for(UIView *view in arrViews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    [self.mTimer invalidate];
    
}


-(void)checkIfAdminAndCheckeOutStatus
{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
    [query whereKey:@"deviceId" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    
    NSArray *objects = [query findObjects];
    if(objects.count!=0)
    {
        PFObject *object = [objects objectAtIndex:0];
        
            mIsCheckedOut = [[object valueForKey:@"isCheckedOut"]boolValue];
            if(mIsCheckedOut)
            {
                self.mExpectedCheckinDate = [object valueForKey:@"expectedCheckinDate"];
            }
    }
    else
    {
        mIsCheckedOut = NO;
    }
    
}

//Checkout screen for user will be displayed
-(void)showCheckout:(id)sender
{
    CheckedOutTableViewController *lChOTVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckedOutTableViewController"];
    [self.navigationController pushViewController:lChOTVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  
    return mAllFetchedObjectsArray.count;;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //using table view cell which is created dynamically
    static NSString *simpleTableIdentifier = @"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        else{
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell_iPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
    }

    Options *lOptions = [mAllFetchedObjectsArray objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mLabelHeading.text = lOptions.mHeading;
    cell.mLabelSubHeading.text = lOptions.mSubHeading;
    cell.mImageView.image = [UIImage imageNamed:lOptions.mImageStr];
    if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]||[mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
        cell.mLabelHeading.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
        cell.mLabelSubHeading.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 100;
    }
    else{
        return 192;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    
    if (mIsManager) {
        switch (indexPath.row) {
            case 0:{
                ManagerViewController *lMVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ManagerViewController"];
                [self.navigationController pushViewController:lMVC animated:YES];
            }
                break;
                
            case 1:{
                DeviceActivityTableViewController *lDeAVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceActivityTableViewController"];
                [self.navigationController pushViewController:lDeAVC animated:YES];
            }
                break;
                
            case 2:{
                DateHistoryTableViewController *lDaAVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DateHistoryTableViewController"];
                [self.navigationController pushViewController:lDaAVC animated:YES];
            }
                break;
                
            case 3:{
                [self logOut];
            }
                break;
            default:
                break;
        }
    }
    
    else{
    
     if ([mUser isEqualToString:@"user"] && mIsCheckedOut) {
        switch (indexPath.row) {
            
            case 0:
            {
                CheckoutViewController *lChVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
                lChVC.mUsername = self.mUsername;
                lChVC.mBtnOption = @"Extend";
                [self.navigationController pushViewController:lChVC animated:YES];
            }
                break;
            case 1:
            {
                CheckoutViewController *lChVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
                lChVC.mUsername = self.mUsername;
                lChVC.mBtnOption = @"Retain";
                [self.navigationController pushViewController:lChVC animated:YES];
            }
                break;
                
            case 2:
            {
                SearchDeviceTableViewController *lSeDVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchDeviceTableViewController"];
                lSeDVC.mUsername = mUsername;
                [self.navigationController pushViewController:lSeDVC animated:YES];
            }
                break;
            
            case 3:{
                [self logOut];
            }
                break;
            default:
                break;
        }
    }

    else if([mUser isEqualToString:@"admin"] && !mIsCheckedOut) {
        switch (indexPath.row) {
            case 0:
            {
                CheckoutViewController *lChVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
                lChVC.mUsername = self.mUsername;
                lChVC.mBtnOption = @"Register";
                [self.navigationController pushViewController:lChVC animated:YES];

            }
                break;
            case 1:
            {
                DeviceActivityTableViewController *lDeAVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceActivityTableViewController"];
                [self.navigationController pushViewController:lDeAVC animated:YES];
                
            }
                break;
                
            case 2:
            {
                DateHistoryTableViewController *lDaAVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DateHistoryTableViewController"];
                [self.navigationController pushViewController:lDaAVC animated:YES];
            }
                break;
                
            case 3:
            {
                CheckoutViewController *lChVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
                lChVC.mUsername = self.mUsername;
                lChVC.mBtnOption = @"Checkout";
                [self.navigationController pushViewController:lChVC animated:YES];
            }
                break;
            
            case 4:{
                [self logOut];
            }
                break;
            default:
                break;
        }
    }
    else if([mUser isEqualToString:@"admin"] && mIsCheckedOut) {
        switch (indexPath.row) {
            case 0:
            {
                DeviceActivityTableViewController *lDeAVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceActivityTableViewController"];
                [self.navigationController pushViewController:lDeAVC animated:YES];
            }
                break;
                
            case 1:
            {
                DateHistoryTableViewController *lDaAVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DateHistoryTableViewController"];
                [self.navigationController pushViewController:lDaAVC animated:YES];
            }
                break;
                
            case 2:
            {
                [self checkinCurrentDevice];
            }
                break;
                
            case 3:{
                [self logOut];
            }
                break;
            default:
                break;
        }
    }
    }
}

-(void)setNavigationLabel
{
    
    lblNavigationTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    lblNavigationTitle.text = @"Home";
    lblNavigationTitle.textColor = [UIColor whiteColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        lblNavigationTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    }
    else{
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]||[mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            lblNavigationTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        }
        else{
        lblNavigationTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        }
    }
    lblNavigationTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lblNavigationTitle;
}

-(void)logOut
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)checkinCurrentDevice
{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
        [query whereKey:@"deviceId" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        
        
        PFObject *lDevice = [[query findObjects]objectAtIndex:0];
       
        //calculating net checkout hours
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +SS"];
        
        NSDate *currDate = [NSDate date];
        NSString *date = [NSString stringWithFormat:@"%@",[lDevice objectForKey:@"expectedCheckinDate"]];
        NSDate *expDate = [dateFormatter dateFromString:date];
        NSTimeInterval distanceBetweenDates = [currDate timeIntervalSinceDate:expDate];
        double secondsInAnHour = 3600;
        int hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
        
        int checkoutHours = [[lDevice objectForKey:@"checkoutHours"]intValue];
        NSString *lFinalCheckoutHours = [NSString stringWithFormat:@"%i",checkoutHours-hoursBetweenDates];
        
        NSString *lCurrentUser = [lDevice objectForKey:@"deviceCurrentUser"];
        [lDevice setObject:[NSDate date] forKey:@"checkinDate"];
        [lDevice setObject:appDel.mCompanyName forKey:@"companyName"];
        [lDevice setObject:lFinalCheckoutHours forKey:@"checkoutHours"];
        [lDevice setObject:@"" forKey:@"deviceCurrentUser"];
        [lDevice setObject:[NSNumber numberWithBool:NO] forKey:@"isCheckedOut"];
        [lDevice setObject:@"Free" forKey:@"deviceStatus"];
        [lDevice setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"checkoutDate"];
        [lDevice setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"expectedCheckinDate"];
        [lDevice saveEventually:^(BOOL succeeded, NSError *error) {
            if(succeeded)
            {
                lblNavigationTitle.text = @"Home";
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Checked In Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                [self getData];
                [[ParseInterface sharedInstance] setMRegistrartionNumber:[lDevice valueForKey:@"registrationNumber"]];
                [[ParseInterface sharedInstance]addTransactionToHistory:lCurrentUser action:@"checkin"];
                NSArray *arrViews = [self.navigationController.navigationBar subviews];
                for(UIView *view in arrViews)
                {
                    if([view isKindOfClass:[UILabel class]])
                    {
                        [view removeFromSuperview];
                    }
                }
                [self.mTimer invalidate];
                
            }
            else
            {
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                
            }
            
        }];
               // When finished call back on the main thread:
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.tableView reloadData];
            // Return data and update on the main thread
            // Task 3: Deliver the data to a 3rd party component (always do this on the main thread, especially UI).
        });
    });
    
    
}



-(void)updateCountdown
{

    NSDate* date1 = [NSDate date];
    NSDate* date2 = self.mExpectedCheckinDate;
    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];

    secondsLeft = distanceBetweenDates / 1;

    self.mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateCounter:)
                                                    userInfo:nil
                                                     repeats:YES];
    
    
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        if (!mIsManager) {
            self.lblNavigationTitle.text =[NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
        }
    }
    else{
        if (secondsLeft == 0) {
            [self.mTimer invalidate];
            lblNavigationTitle.text = @"Home";
        }
    }
}


@end
