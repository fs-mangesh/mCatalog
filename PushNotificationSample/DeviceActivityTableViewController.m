//
//  DeviceActivityTableViewController.m
//  PushNotificationSample
//
//  Created by afour on 2014-12-08.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import "DeviceActivityTableViewController.h"
#import "ParseInterface.h"
#import <Parse/Parse.h>
#import "DeviceTableViewCell.h"

@interface DeviceActivityTableViewController ()

@end

@implementation DeviceActivityTableViewController
@synthesize mDeviceNameTextField;
@synthesize mAllFetchedObjectsArray,mArrayOfDeviceName;
@synthesize mPickerDeviceName;
@synthesize mArrayOfDeviceObjects;
@synthesize mArrayOfCheckinDate,mArrayOfCheckinTime,mArrayOfCheckoutDate,mArrayOfCheckoutTime,mArrayOfUser;
@synthesize mPickerDeviceMakeParentView;
@synthesize mCurrDeviceModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    //setting delegate of textField
    self.mDeviceNameTextField.delegate = self;
    
    mCurrDeviceModel = [self platformNiceString];
    
    //setting data source and delegates
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //Picker View which will display list of devices
    mPickerDeviceName = [[UIPickerView alloc]init];
    
    
    
    //array of all fetched object device
    mAllFetchedObjectsArray = [[NSArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        mAllFetchedObjectsArray = [[ParseInterface sharedInstance]getAllRowsForTable:@"Devices"];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            
        });
    });
    
    // Connect data
    self.mPickerDeviceName.dataSource = self;
    self.mPickerDeviceName.delegate = self;
    [self setPickerView];
    self.tableView.tableHeaderView = [self setHeaderView];

}

-(UIView *)setHeaderView{
    //setting textField of date
    mDeviceNameTextField = [[UITextField alloc]init];
    mDeviceNameTextField.backgroundColor = [UIColor whiteColor];
    mDeviceNameTextField.placeholder = @"Select device";
    mDeviceNameTextField.textAlignment = NSTextAlignmentCenter;
    
    mDeviceNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    //giving input of textfield as picker view
    [self.mDeviceNameTextField setInputView:mPickerDeviceMakeParentView];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header.png"]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            mDeviceNameTextField.frame = CGRectMake(7, 10, 400, 30);
            
            headerView.frame = CGRectMake(0, 0, 414, 50);
            
            mDeviceNameTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        }
        
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]){
            mDeviceNameTextField.frame = CGRectMake(10, 10, 355, 30);

            
            headerView.frame = CGRectMake(0, 0, 375, 50);
            
            mDeviceNameTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        }
        
        else{
            mDeviceNameTextField.frame = CGRectMake(10, 4, 300, 30);

            headerView.frame = CGRectMake(0, 0, 320, 38);
            
            mDeviceNameTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        }
        
    }
    else{
        mDeviceNameTextField.frame = CGRectMake(15, 20, 738, 45);
        
        headerView.frame = CGRectMake(0, 0, 768, 85);
        
        mDeviceNameTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    }
    
    mDeviceNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    [headerView addSubview:mDeviceNameTextField];
    return headerView;
}

-(void)setPickerView{
    
    //Picker View which will display list of devices
    mPickerDeviceName = [[UIPickerView alloc]init];
    
    // Connect data
    self.mPickerDeviceName.dataSource = self;
    self.mPickerDeviceName.delegate = self;
    
    //setting toolBar on pickerView
    UIToolbar *lToolBar = [[UIToolbar alloc]init];
    lToolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(itemWasSelected:)];
    
    [lToolBar setItems:[NSArray arrayWithObject:doneButton]];
    
    mPickerDeviceMakeParentView = [[UIView alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {
            lToolBar.frame = CGRectMake(0, 0, 375, 44);
            mPickerDeviceMakeParentView.frame = CGRectMake(0, 60, 375, 200);
        }
        
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]){
            lToolBar.frame = CGRectMake(0, 0, 414, 44);
            mPickerDeviceMakeParentView.frame = CGRectMake(0, 60, 414, 200);
        }
        else{
            lToolBar.frame = CGRectMake(0, 0, 320, 44);
            mPickerDeviceMakeParentView.frame = CGRectMake(0, 60, 320, 200);
        }
        
    }
    else{
        lToolBar.frame = CGRectMake(0, 0, 768, 44);
        mPickerDeviceMakeParentView.frame = CGRectMake(0, 60, 768, 300);
        mPickerDeviceName.frame = CGRectMake(0, 0, 768, 300);
    }
    
    [mPickerDeviceMakeParentView addSubview:mPickerDeviceName];
    [mPickerDeviceMakeParentView addSubview:lToolBar];
    
}
-(void)itemWasSelected:(id)sender
{
    [mDeviceNameTextField resignFirstResponder];
    [self displayActivities:nil];
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
//method for dismissing picker view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma pickerView

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //array of device names
    mArrayOfDeviceName = [[NSMutableArray alloc]init];
    for (int i =0; i<mAllFetchedObjectsArray.count; i++) {
        PFObject *obj1 = [mAllFetchedObjectsArray objectAtIndex:i];
        [mArrayOfDeviceName addObject:[obj1 objectForKey:@"deviceName"]];
    }
    return mArrayOfDeviceName.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return mArrayOfDeviceName[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    mDeviceNameTextField.text = [mArrayOfDeviceName objectAtIndex:row];
}




#pragma tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mArrayOfUser.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
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
    History *lDevice = [[History alloc]init];
    lDevice = [mArrayOfDeviceObjects objectAtIndex:indexPath.row];
   
    cell.mLabelUser.text = [mArrayOfUser objectAtIndex:indexPath.row];
    cell.mLabelDevice.text = @"";
    cell.mLabelCheckoutTime.text = [mArrayOfCheckoutTime objectAtIndex:indexPath.row];
    cell.mLabelCheckoutDate.text = [mArrayOfCheckoutDate objectAtIndex:indexPath.row];
    cell.mLabelCheckinTime.text = [mArrayOfCheckinTime objectAtIndex:indexPath.row];
    cell.mLabelCheckinDate.text = [mArrayOfCheckinDate objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            return [NSString stringWithFormat:@"User                          Checkout         Checkin"];
        }
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]){
            return [NSString stringWithFormat:@"User                   Checkout         Checkin"];
        }
        else{
            return [NSString stringWithFormat:@"User                      Checkout          Checkin"];
        }
      
        
    }
    else{
     return [NSString stringWithFormat:@"\t\t\tUser\t\t\t\t\t\t\t  Checkout\t\t\t\t\t\t\t\t\t\t\t                    Checkin"];
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
}
- (void)displayActivities:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
    [mDeviceNameTextField resignFirstResponder];
    if ([mDeviceNameTextField.text isEqualToString:@""]) {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select any device from the list" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else{
        [self initArrays];
        
        NSMutableArray *lArraOfDevices =  [[ParseInterface sharedInstance]searchDeviceHistory:mDeviceNameTextField.text];
        mArrayOfDeviceObjects = [NSMutableArray arrayWithArray:lArraOfDevices];
        
        History *lLastDevice = [[History alloc]init];
        lLastDevice = [mArrayOfDeviceObjects objectAtIndex:mArrayOfDeviceObjects.count-1];
        if ([lLastDevice.mDeviceAction isEqualToString:@"checkout"]) {
            
            [mArrayOfUser addObject:lLastDevice.mDeviceCurrentUser];
            [mArrayOfCheckoutTime addObject:[self getAmPmTime:lLastDevice.mDeviceCheckoutDate]];
            [mArrayOfCheckoutDate addObject:[dateFormatter stringFromDate:lLastDevice.mDeviceCheckoutDate]];
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
                [mArrayOfCheckoutTime addObject:[self getAmPmTime:lDevice.mDeviceCheckoutDate]];
                [mArrayOfCheckoutDate addObject:[dateFormatter stringFromDate:lDevice.mDeviceCheckoutDate]];
                [mArrayOfCheckinTime addObject:[self getAmPmTime:lNextDevice.mDeviceCheckinDate]];
                [mArrayOfCheckinDate addObject:[dateFormatter stringFromDate:lNextDevice.mDeviceCheckinDate]];
            }
            else if ([lDevice.mDeviceAction isEqualToString:@"register"]) {
                
                [mArrayOfUser addObject:lDevice.mDeviceCurrentUser];
                [mArrayOfCheckoutTime addObject:@""];
                [mArrayOfCheckoutDate addObject:@"Registered"];
                [mArrayOfCheckinTime addObject:@""];
                [mArrayOfCheckinDate addObject:@""];
            }
        
        }
        
        if(mArrayOfDeviceObjects.count == 1 && [lLastDevice.mDeviceAction isEqualToString:@"register"]){
            [mArrayOfUser addObject:lLastDevice.mDeviceCurrentUser];
            [mArrayOfCheckoutTime addObject:@""];
            [mArrayOfCheckoutDate addObject:@"Registered"];
            [mArrayOfCheckinTime addObject:@""];
            [mArrayOfCheckinDate addObject:@""];
        }
        [self.tableView reloadData];
    }
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
