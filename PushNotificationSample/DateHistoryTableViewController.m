//
//  DateHistoryTableViewController.m
//  PushNotificationSample
//
//  Created by afour on 2014-12-05.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import "DateHistoryTableViewController.h"
#import "DeviceTableViewCell.h"

@interface DateHistoryTableViewController ()

@end

@implementation DateHistoryTableViewController
@synthesize mTextFieldDate;
@synthesize mArrayOfDeviceObjects;
@synthesize mCheckDate;
@synthesize mArrayOfCheckinDate,mArrayOfCheckinTime,mArrayOfCheckoutDate,mArrayOfCheckoutTime,mArrayOfUser,mArrayOfDeviceName;
@synthesize mCurrDeviceModel;
@synthesize mPickerParentView,mDatePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     mCurrDeviceModel = [self platformNiceString];
    self.tableView.tableHeaderView = [self setHeaderView];

    [self setPickerView];
    
    mCheckDate = [NSDate date];
}

-(void)setPickerView{
    mPickerParentView = [[UIView alloc]init];
    
    mDatePicker = [[UIDatePicker alloc]init];
    [mDatePicker setDate:[NSDate date]];
    mDatePicker.datePickerMode = UIDatePickerModeDate;
    [mDatePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    //setting toolBar on pickerView
    UIToolbar *lToolBar = [[UIToolbar alloc]init];
    lToolBar.barStyle = UIBarStyleDefault;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {
            lToolBar.frame = CGRectMake(0, 0, 375, 44);
            mDatePicker.frame = CGRectMake(0, 50, 375, 100);
            mPickerParentView.frame = CGRectMake(0, 60, 375, 200);
        }
        
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]){
            lToolBar.frame = CGRectMake(0, 0, 414, 44);
            mDatePicker.frame = CGRectMake(0, 50, 414, 100);
            mPickerParentView.frame = CGRectMake(0, 60, 414, 200);
        }
        else{
            lToolBar.frame = CGRectMake(0, 0, 320, 44);
            mDatePicker.frame = CGRectMake(0, 50, 320, 100);
            mPickerParentView.frame = CGRectMake(0, 60, 320, 200);
        }
        
    }
    else{
        lToolBar.frame = CGRectMake(0, 0, 768, 44);
        mPickerParentView.frame = CGRectMake(0, 60, 768, 300);
        mDatePicker.frame = CGRectMake(0, 50, 768, 300);
    }
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(itemWasSelected:)];
    
    [lToolBar setItems:[NSArray arrayWithObject:doneButton]];
    
    [mPickerParentView addSubview:lToolBar];
    [mPickerParentView addSubview:mDatePicker];
    
    [mTextFieldDate setInputView:mPickerParentView];
    [mTextFieldDate setDelegate:self];
    
}

-(void)itemWasSelected:(id)sender
{
    [mTextFieldDate resignFirstResponder];

    [self loadData:mTextFieldDate.text];
}

-(void)viewWillAppear:(BOOL)animated{
    NSDateFormatter *lDateFormatter = [[NSDateFormatter alloc]init];
    [lDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [lDateFormatter setDateFormat:@"dd.MM.YY"];
    [self loadData:[lDateFormatter stringFromDate:mCheckDate]];
}

-(void)initArrays{
    if(mArrayOfDeviceObjects != nil){
        mArrayOfDeviceObjects = nil;
    }
    mArrayOfDeviceObjects = [[NSMutableArray alloc]init];
    
    if(mArrayOfUser != nil){
        mArrayOfUser = nil;
    }
    mArrayOfUser = [[NSMutableArray alloc]init];
    
    if(mArrayOfCheckoutTime != nil){
        mArrayOfCheckoutTime = nil;
    }
    mArrayOfCheckoutTime = [[NSMutableArray alloc]init];
    
    if(mArrayOfCheckoutDate != nil){
        mArrayOfCheckoutDate = nil;
    }
    mArrayOfCheckoutDate = [[NSMutableArray alloc]init];
    
    if(mArrayOfCheckinTime != nil){
        mArrayOfCheckinTime = nil;
    }
    mArrayOfCheckinTime = [[NSMutableArray alloc]init];
    
    if(mArrayOfCheckinDate != nil){
        mArrayOfCheckinDate = nil;
    }
    mArrayOfCheckinDate = [[NSMutableArray alloc]init];
    
    if(mArrayOfDeviceName != nil){
        mArrayOfDeviceName = nil;
    }
    mArrayOfDeviceName = [[NSMutableArray alloc]init];
}

-(void)loadData:(NSString *)checkDate{
    NSDateFormatter *lDateFormatter = [[NSDateFormatter alloc]init];
    [lDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [lDateFormatter setDateFormat:@"dd.MM.YY"];
    [self initArrays];
    mArrayOfDeviceObjects = [[NSMutableArray alloc]init];

    mArrayOfDeviceObjects = [[ParseInterface sharedInstance]searchDateHistory:checkDate];
    
    History *Device = [[History alloc]init];
    for (int i = 0; i<mArrayOfDeviceObjects.count; i++) {
        Device = [mArrayOfDeviceObjects objectAtIndex:i];
    }
    
    
    if (mArrayOfDeviceObjects.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No activity on this day" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
    else{
        
                History *lLastDevice = [[History alloc]init];
                lLastDevice = [mArrayOfDeviceObjects objectAtIndex:mArrayOfDeviceObjects.count-1];
                if ([lLastDevice.mDeviceAction isEqualToString:@"checkout"]) {
    
                    [mArrayOfUser addObject:lLastDevice.mDeviceCurrentUser];
                    [mArrayOfDeviceName addObject:lLastDevice.mDeviceName];
                    [mArrayOfCheckoutTime addObject:[self getAmPmTime:lLastDevice.mDeviceCheckoutDate]];
                    [mArrayOfCheckoutDate addObject:[lDateFormatter stringFromDate:lLastDevice.mDeviceCheckoutDate]];
                    [mArrayOfCheckinTime addObject:@"-"];
                    [mArrayOfCheckinDate addObject:@"-"];
                }
    
        for (int i = (int)(mArrayOfDeviceObjects.count-1); i>0; i--) {
            
            History *lDevice = [[History alloc]init];
            History *lNextDevice = [[History alloc]init];
            
            lDevice = [mArrayOfDeviceObjects objectAtIndex:i-1];
            
            lNextDevice = [mArrayOfDeviceObjects objectAtIndex:(i)];
        
        if ([lDevice.mDeviceAction isEqualToString:@"checkout"]&&[lNextDevice.mDeviceAction isEqualToString:@"checkin"]&&[lDevice.mDeviceCurrentUser isEqualToString:lNextDevice.mDeviceCurrentUser]) {
            
            [mArrayOfUser addObject:lDevice.mDeviceCurrentUser];
            [mArrayOfDeviceName addObject:lDevice.mDeviceName];
            [mArrayOfCheckoutTime addObject:[self getAmPmTime:lDevice.mDeviceCheckoutDate]];
            [mArrayOfCheckoutDate addObject:[lDateFormatter stringFromDate:lDevice.mDeviceCheckoutDate]];
            [mArrayOfCheckinTime addObject:[self getAmPmTime:lNextDevice.mDeviceCheckinDate]];
            [mArrayOfCheckinDate addObject:[lDateFormatter stringFromDate:lNextDevice.mDeviceCheckinDate]];
        }
        else if ([lDevice.mDeviceAction isEqualToString:@"register"]) {
            
            [mArrayOfUser addObject:lDevice.mDeviceCurrentUser];
            [mArrayOfDeviceName addObject:lDevice.mDeviceName];
            [mArrayOfCheckoutTime addObject:@""];
            [mArrayOfCheckoutDate addObject:@"Registered"];
            [mArrayOfCheckinTime addObject:@""];
            [mArrayOfCheckinDate addObject:@""];
        }
        
    }
    }
    [self.tableView reloadData];
}

-(UIView *)setHeaderView{
    //setting textField of date
    mTextFieldDate = [[UITextField alloc]init];
    mTextFieldDate.backgroundColor = [UIColor whiteColor];
    mTextFieldDate.placeholder = @"Select date";
    mTextFieldDate.textAlignment = NSTextAlignmentCenter;
    mTextFieldDate.borderStyle = UITextBorderStyleRoundedRect;
 
    
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header.png"]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            mTextFieldDate.frame = CGRectMake(7, 10, 400, 30);
            
            headerView.frame = CGRectMake(0, 0, 414, 50);
            
            mTextFieldDate.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        }
        
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]){
            mTextFieldDate.frame = CGRectMake(10, 10, 355, 30);
            
            headerView.frame = CGRectMake(0, 0, 375, 50);
            
            mTextFieldDate.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        }
        
        else{
            mTextFieldDate.frame = CGRectMake(10, 4, 300, 30);
            
            headerView.frame = CGRectMake(0, 0, 320, 38);
            
            mTextFieldDate.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        }
    }
    else{
        mTextFieldDate.frame = CGRectMake(15, 20, 738, 45);
        
        headerView.frame = CGRectMake(0, 0, 768, 85);
        
        mTextFieldDate.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    }
    
    mTextFieldDate.clearButtonMode = UITextFieldViewModeAlways;
    [headerView addSubview:mTextFieldDate];
    return headerView;
}

-(void)updateTextField:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
    NSString *dateString = [dateFormatter stringFromDate:mDatePicker.date];
    self.mTextFieldDate.text = [NSString stringWithFormat:@"%@",dateString];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 89;
    }
    else{
        return 105;
    }
}

-(NSString *)getAmPmTime:(NSDate *)taskDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    //timeString will contain only hours and minutes
    NSString *timeString = [formatter stringFromDate:taskDate];
    
    //onlyHour will contain hours & minutes in NSDate object
    NSDate *onlyHour = [formatter dateFromString:timeString];
    [formatter setDateFormat:@"hh:mm a"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //Finally amPm string will contain date in AM PM format
    NSString *amPm = [formatter stringFromDate:onlyHour];
    return amPm;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            return [NSString stringWithFormat:@"Device                       Checkout         Checkin"];
        }
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]){
            return [NSString stringWithFormat:@"Device                Checkout         Checkin"];
        }
        else{
            return [NSString stringWithFormat:@"Device                   Checkout          Checkin"];
        }
        
        
    }
    else{
        return [NSString stringWithFormat:@"\t\t  Device\t\t\t\t\t\t\t  Checkout\t\t\t\t\t\t\t\t\t\t\t                   Checkin"];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]||[mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
        }
        else{
            header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        }
    }
    else{
        header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    }
    
    header.textLabel.textColor = [UIColor blackColor];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return mArrayOfUser.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //using table view cell which is created dynamically
    static NSString *simpleTableIdentifier = @"DeviceTableViewCell";
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell_iPhone6+" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            else if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell_iPhone6" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            else{
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
        }
        else{
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell_iPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    
    cell.mLabelUser.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    cell.mLabelDevice.text = [mArrayOfUser objectAtIndex:indexPath.row];
    cell.mLabelUser.text = [mArrayOfDeviceName objectAtIndex:indexPath.row];
    cell.mLabelCheckoutTime.text = [mArrayOfCheckoutTime objectAtIndex:indexPath.row];
    cell.mLabelCheckoutDate.text = [mArrayOfCheckoutDate objectAtIndex:indexPath.row];
    cell.mLabelCheckinTime.text = [mArrayOfCheckinTime objectAtIndex:indexPath.row];
    cell.mLabelCheckinDate.text = [mArrayOfCheckinDate objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
