//
//  ParseInterface.m
//  PushNotificationSample
//
//  Created by Subodh Parulekar on 11/27/14.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import "ParseInterface.h"

@implementation ParseInterface
@synthesize responseDictionary;
@synthesize mDeviceNameMax,mDeviceNameMin;
@synthesize mArrayOfCheckoutDevice,mArrayOfCheckoutHours,mArrayOfRequestedDevice;

static ParseInterface *myInstance;

+ (ParseInterface*) sharedInstance
{
    static dispatch_once_t onceToken;
    if (!myInstance)
    {
        
        dispatch_once( &onceToken, ^{
            myInstance = [[[self class] alloc] init];
        });// = [[LocationManager alloc] init];
        
    }
    return myInstance;
}

-(NSArray *)getAllRowsForTable:(NSString *)tableName
{
    PFQuery *query = [PFQuery queryWithClassName:tableName];
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
    return [query findObjects];

}

-(void)checkoutCurrentDevice:(NSString*)username duration:(NSDate *)date :(NSString *)hours
{
    
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
    [query whereKey:@"deviceId" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    query.limit = 500;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if(objects.count!=0)
            {
                PFObject *object = [objects objectAtIndex:0];
                NSString *checkoutNumberString = [object valueForKey:@"checkoutNumber"];
                int checkoutNumber = [checkoutNumberString intValue];
                checkoutNumber++;
                NSString *newCheckoutNumberString = [NSString stringWithFormat:@"%i",checkoutNumber];
                if([[object valueForKey:@"deviceStatus"] isEqualToString:@"Free"])
                {
                    [object setObject:[NSDate date] forKey:@"checkoutDate"];
                    [object setObject:username forKey:@"deviceCurrentUser"];
                    [object setObject:appDel.mCompanyName forKey:@"companyName"];
                    [object setObject:newCheckoutNumberString forKey:@"checkoutNumber"];
                    [object setObject:[NSNumber numberWithBool:YES] forKey:@"isCheckedOut"];
                    [object setObject:@"Busy" forKey:@"deviceStatus"];
                    [object setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"checkinDate"];
                    [object setObject:[[UIDevice currentDevice]systemVersion] forKey:@"deviceVersion"];
                    [object setObject:date forKey:@"expectedCheckinDate"];
                    self.mRegistrartionNumber = [object valueForKey:@"registrationNumber"];
                    [object saveEventually:^(BOOL succeeded, NSError *error) {
                        if(succeeded)
                        {

                            [[ParseInterface sharedInstance]addTransactionToHistory:username action:@"checkout"];
                        }
                        else
                        {
                            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [errorAlertView show];
                            
                        }
                        
                    }];

                    
                }
                else
                {
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:[NSString stringWithFormat:@"The device is already checked out by %@.Please let him check in!",[object valueForKey:@"deviceCurrentUser"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
               
            }
            else
            {
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Ask Admin to register the device!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                
            }
        } else {
            // Log details of the failure
    
        }
    }];
}

-(void)registerThisDevice:(NSString*)deviceRegistrationNo username:(NSString*)username
{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    self.mRegistrartionNumber = deviceRegistrationNo;
    PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
    query.limit = 500;
    [query whereKey:@"deviceId" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            if(objects.count!=0)
            {
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Device already registered!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];

            }
            else
            {
                PFObject *newCheckout = [[PFObject alloc]initWithClassName:@"Devices"];
                [newCheckout setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString]forKey:@"deviceId"];
                [newCheckout setObject:[UIDevice currentDevice].name forKey:@"deviceName"];
                [newCheckout setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"checkoutDate"];
                [newCheckout setObject:@"" forKey:@"deviceCurrentUser"];
                [newCheckout setObject:@"Apple" forKey:@"deviceMake"];
                [newCheckout setObject:@"0" forKey:@"checkoutNumber"];
                [newCheckout setObject:@"0" forKey:@"requestNumber"];
                [newCheckout setObject:appDel.mCompanyName forKey:@"companyName"];
                [newCheckout setObject:[self platformNiceString] forKey:@"deviceModel"];
                [newCheckout setObject:@"Free" forKey:@"deviceStatus"];
                AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                [newCheckout setObject:appDelegate.mDeviceToken forKey:@"deviceToken"];
                [newCheckout setObject:[NSNumber numberWithBool:NO] forKey:@"isCheckedOut"];
                [newCheckout setObject:[[UIDevice currentDevice]systemVersion] forKey:@"deviceVersion"];
                [newCheckout setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"expectedCheckinDate"];
                [newCheckout setObject:deviceRegistrationNo forKey:@"registrationNumber"];
                [newCheckout saveEventually:^(BOOL succeeded, NSError *error) {
                    if(succeeded)
                    {
                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Registered Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [errorAlertView show];
                        [self addTransactionToHistory:username action:@"register"];
                    }
                    else
                    {
                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [errorAlertView show];
                        
                    }
                    
                }];
                
            }
            // Do something with the found objects
        } else {

        }
    }];


    
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


-(NSMutableArray*)searchDevices:(NSString*)make
{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    NSMutableArray *lResultsArr = [[NSMutableArray alloc]init];
    if (lResultsArr != nil) {
        lResultsArr = nil;
    }
    lResultsArr = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
    [query whereKey:@"deviceMake" equalTo:make];
    [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
    NSArray *objects = [query findObjects];
    if(objects.count!=0)
    {
        for (PFObject *object in objects) {
            
            Device *lDevice = [[Device alloc]init];
            lDevice.mDeviceId = [object valueForKey:@"deviceId"];
            lDevice.mDeviceMake = [object valueForKey:@"deviceMake"];
            lDevice.mDeviceToken = [object valueForKey:@"deviceToken"];
            lDevice.mDeviceStatus =[object valueForKey:@"deviceStatus"];
            lDevice.mDeviceModel = [object valueForKey:@"deviceModel"];
            lDevice.mDeviceName = [object valueForKey:@"deviceName"];
            lDevice.mDeviceCurrentUser = [object valueForKey:@"deviceCurrentUser"];
            lDevice.mDeviceVersion = [object valueForKey:@"deviceVersion"];
            lDevice.mDeviceRegistrationNumber = [object valueForKey:@"registrationNumber"];
                [lResultsArr addObject:lDevice];
        }
        
    }
    else
    {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"No device found!"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }
    
    
    return lResultsArr;
}

-(void)addTransactionToHistory:(NSString*)username action:(NSString*)action
{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd.MM.YY"];
    PFObject *lNewHistoryRow = [[PFObject alloc]initWithClassName:@"DeviceHistory"];
    [lNewHistoryRow setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString]forKey:@"deviceId"];
    [lNewHistoryRow setObject:[UIDevice currentDevice].name forKey:@"deviceName"];
    if([action isEqualToString:@"checkout"])
    {
        [lNewHistoryRow setObject:[NSDate date] forKey:@"checkoutDate"];
        [lNewHistoryRow setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"deviceDate"];
    }
    else if([action isEqualToString:@"checkin"])
    {
        [lNewHistoryRow setObject:[NSDate date] forKey:@"checkinDate"];
        [lNewHistoryRow setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"deviceDate"];
    }
    else if ([action isEqualToString:@"register"]){
        [lNewHistoryRow setObject:[dateFormatter stringFromDate:[NSDate date]] forKey:@"deviceDate"];
    }
    
    [lNewHistoryRow setObject:username forKey:@"deviceUser"];
    [lNewHistoryRow setObject:@"Apple" forKey:@"deviceMake"];
    [lNewHistoryRow setObject:appDel.mCompanyName forKey:@"companyName"];
    [lNewHistoryRow setObject:[self platformNiceString] forKey:@"deviceModel"];
    [lNewHistoryRow setObject:appDel.mDeviceToken forKey:@"deviceToken"];
    [lNewHistoryRow setObject:action forKey:@"action"];
//    if([action isEqualToString:@"register"])
//    {
        [lNewHistoryRow setObject:self.mRegistrartionNumber forKey:@"registrationNumber"];
    //}
    [lNewHistoryRow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
        {
  
        }
        else
        {
        }
    }];

}

-(void)retainCurrrentDevice:(NSString *)username
{
    NSDate *mydate = [NSDate date];
    NSTimeInterval secondsInEightHours = 24 * 60 * 60;
    NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
        query.limit = 500;
        [query whereKey:@"deviceId" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        
        PFObject *lDevice = [[query findObjects]objectAtIndex:0];
        //[lDevice setObject:[NSDate date] forKey:@"checkinDate"];
        [lDevice setObject:username forKey:@"deviceCurrentUser"];
        [lDevice setObject:[NSNumber numberWithBool:YES] forKey:@"isCheckedOut"];
        [lDevice setObject:@"Busy" forKey:@"deviceStatus"];
        //[lDevice setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"checkoutDate"];
        [lDevice setObject:dateEightHoursAhead forKey:@"expectedCheckinDate"];
        [lDevice saveEventually:^(BOOL succeeded, NSError *error) {
            if(succeeded)
            {
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Device retained successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                
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

-(NSString *)getInventoryUtilization{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
    [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
    NSArray *objects = [query findObjects];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +SS"];
    
    NSDate *currDate = [NSDate date];

    
    NSDate *expDate = [currDate dateByAddingTimeInterval:-3600*500];
    NSTimeInterval distanceBetweenDates = [currDate timeIntervalSinceDate:expDate];
    double secondsInAnHour = 3600;
    int hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    int days = hoursBetweenDates/24;
    int objectCount = (int)objects.count;
    
    float totalHours = days*9*objectCount;
    
    float totalCheckoutHours = 0;
    if(objects.count!=0)
    {
        for (PFObject *object in objects) {
            int checkoutHour = [[object valueForKey:@"checkoutHours"]intValue];
            totalCheckoutHours = totalCheckoutHours + checkoutHour;
        }
        
    }
    
    int percentage = (totalCheckoutHours/totalHours)*100;
    NSString *percentageString = [NSString stringWithFormat:@"%d",percentage];
    return percentageString;
}

-(NSMutableArray *)getMostCheckedoutDevices{
    PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
    mArrayOfCheckoutDevice = [[NSMutableArray alloc]init];
    NSArray *objects = [query findObjects];
    NSMutableArray *arrOfCheckouts = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<objects.count;i++) {
        PFObject *object = [objects objectAtIndex:i];
        int number = [[object valueForKey:@"checkoutNumber"] intValue];
        NSNumber *addNumber = [NSNumber numberWithInt:number];
        [arrOfCheckouts addObject:addNumber];
    }
    
    
    NSSortDescriptor *lDescSorter = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    
    NSArray *lDescSorters = [[NSArray alloc] initWithObjects:lDescSorter, nil];
    
    NSArray *lDescSortedArray = [arrOfCheckouts sortedArrayUsingDescriptors:lDescSorters];
    NSMutableArray *lDescending = [[NSMutableArray alloc]init];
    
    NSSortDescriptor *lAscSorter = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    
    NSArray *lAscSorters = [[NSArray alloc] initWithObjects:lAscSorter, nil];
    
    NSArray *lAscSortedArray = [arrOfCheckouts sortedArrayUsingDescriptors:lAscSorters];
    
    NSMutableArray *lAscending = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<3; i++) {
        for (int j = 0; j<objects.count;j++) {
            PFObject *object = [objects objectAtIndex:j];
            NSString *first = [NSString stringWithFormat:@"%@",[lAscSortedArray objectAtIndex:i]];
            NSString *second = [object valueForKey:@"checkoutNumber"];
            if ([first isEqualToString:second]) {
                [lAscending addObject:[lAscSortedArray objectAtIndex:i]];
                [lAscending addObject:[object valueForKey:@"deviceModel"]];
            }
        }
    }
    
    for (int i = 0; i<6; i++) {
        [mArrayOfCheckoutDevice addObject:[lAscending objectAtIndex:i]];
    }
    
    for (int i = 0; i<3; i++) {
        for (int j = 0; j<objects.count;j++) {
            PFObject *object = [objects objectAtIndex:j];
            NSString *first = [NSString stringWithFormat:@"%@",[lDescSortedArray objectAtIndex:i]];
            NSString *second = [object valueForKey:@"checkoutNumber"];
            if ([first isEqualToString:second]) {
                [lDescending addObject:[lDescSortedArray objectAtIndex:i]];
                [lDescending addObject:[object valueForKey:@"deviceModel"]];
            }
        }
    }
    
    for (int i = 0; i<6; i++) {
        [mArrayOfCheckoutDevice addObject:[lDescending objectAtIndex:i]];
    }
    
    return mArrayOfCheckoutDevice;
}

-(NSMutableArray *)getMostRequestedDevices{
    PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
    mArrayOfRequestedDevice = [[NSMutableArray alloc]init];
    NSArray *objects = [query findObjects];
    NSMutableArray *arrOfCheckouts = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<objects.count;i++) {
        PFObject *object = [objects objectAtIndex:i];
        int number = [[object valueForKey:@"requestNumber"] intValue];
        NSNumber *addNumber = [NSNumber numberWithInt:number];
        [arrOfCheckouts addObject:addNumber];
    }
    
    
    NSSortDescriptor *lDescSorter = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    
    NSArray *lDescSorters = [[NSArray alloc] initWithObjects:lDescSorter, nil];
    
    NSArray *lDescSortedArray = [arrOfCheckouts sortedArrayUsingDescriptors:lDescSorters];

    for (int i = 0; i<3; i++) {
        for (int j = 0; j<objects.count;j++) {
            PFObject *object = [objects objectAtIndex:j];
            NSString *first = [NSString stringWithFormat:@"%@",[lDescSortedArray objectAtIndex:i]];
            NSString *second = [object valueForKey:@"requestNumber"];
            if ([first isEqualToString:second]) {
                [mArrayOfRequestedDevice addObject:[lDescSortedArray objectAtIndex:i]];
                [mArrayOfRequestedDevice addObject:[object valueForKey:@"deviceModel"]];
            }
        }
    }

    return mArrayOfRequestedDevice;
}

-(void)extendCurrentDeviceDuration:(NSString*)duration user:(NSString*)username
{

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
        [query whereKey:@"deviceId" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        
        PFObject *lDevice = [[query findObjects]objectAtIndex:0];
        //[lDevice setObject:[NSDate date] forKey:@"checkinDate"];
        [lDevice setObject:username forKey:@"deviceCurrentUser"];
        [lDevice setObject:[NSNumber numberWithBool:YES] forKey:@"isCheckedOut"];
        [lDevice setObject:@"Busy" forKey:@"deviceStatus"];
        //[lDevice setObject:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"checkoutDate"];
        NSTimeInterval secondsInEightHours = [duration integerValue] * 60 * 60;
        NSDate *myDate = [lDevice valueForKey:@"expectedCheckinDate"];
        NSDate *dateEightHoursAhead = [myDate dateByAddingTimeInterval:secondsInEightHours];
        [lDevice setObject:dateEightHoursAhead forKey:@"expectedCheckinDate"];
        [lDevice saveEventually:^(BOOL succeeded, NSError *error) {
            if(succeeded)
            {
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"Checkout duration extended successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                
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

-(NSMutableArray*)searchDeviceHistory:(NSString*)name
{
    NSMutableArray *lResultsArr = [[NSMutableArray alloc]init];
    if (lResultsArr != nil) {
        lResultsArr = nil;
    }
    lResultsArr = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"DeviceHistory"];
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
    query.limit = 500;
    [query whereKey:@"deviceName" equalTo:name];
    
    NSArray *objects = [query findObjects];
    if(objects.count!=0)
    {
        for (PFObject *object in objects) {
            
            History *lDevice = [[History alloc]init];
            lDevice.mDeviceAction =[object valueForKey:@"action"];
            lDevice.mDeviceName = [object valueForKey:@"deviceName"];
            lDevice.mDeviceCurrentUser = [object valueForKey:@"deviceUser"];
            lDevice.mDeviceCheckoutDate = [object valueForKey:@"checkoutDate"];
            lDevice.mDeviceCheckinDate = [object valueForKey:@"checkinDate"];
            [lResultsArr addObject:lDevice];
        }
        
    }
    else
    {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Device Tracker" message:@"No history found!"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }
    
    
    return lResultsArr;
}

-(NSMutableArray*)searchDateHistory:(NSString*)date
{
    NSMutableArray *lResultsArr = [[NSMutableArray alloc]init];
    if (lResultsArr != nil) {
        lResultsArr = nil;
    }
    lResultsArr = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"DeviceHistory"];
    [query whereKey:@"deviceDate" equalTo:date];
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
    query.limit = 500;
    NSArray *objects = [query findObjects];
    if(objects.count!=0)
    {
        for (PFObject *object in objects) {
            
            History *lDevice = [[History alloc]init];
            lDevice.mObjectId = [object valueForKey:@"objectId"];
            lDevice.mDeviceAction =[object valueForKey:@"action"];
            lDevice.mDeviceName = [object valueForKey:@"deviceName"];
            lDevice.mDeviceCurrentUser = [object valueForKey:@"deviceUser"];
            lDevice.mDeviceCheckoutDate = [object valueForKey:@"checkoutDate"];
            lDevice.mDeviceCheckinDate = [object valueForKey:@"checkinDate"];
            [lResultsArr addObject:lDevice];
        }
        
    }
    return lResultsArr;
}

//- (void)sendData :(NSDate *)from :(NSDate *)to  completion:(void (^)(NSMutableArray *))completion {
//    
//    mArrayOfCheckoutDevice = [[NSMutableArray alloc]init];
//    NSString *urlString = @"https://api.parse.com/1/classes/Devices";
//    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    [parseRequest setHTTPMethod:@"GET"];
//    [parseRequest setValue:@"i48dw0oV5E2prYLcPIf4ZEYS1G8PXlWa4sqC3g56" forHTTPHeaderField:@"X-Parse-Application-Id"];
//    [parseRequest setValue:@"OCQb1QWKGP3SsKwoEDqoc8uFygptO28oTcPBA3nV" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
//    
//    
//    
//    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
////        [postDictionary setObject:@"" forKey:@"updatedAt"];
//    //    [postDictionary setObject:@"iPad Mini" forKey:@"deviceModel"];
//    
////    [postDictionary setObject:@{
////                                @"$lte":from,
////                                @"$gte":to
////                                } forKey:@"updatedAt"];
//    
//    NSError *error;
//    NSData *postBody = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* getString=  [[NSString alloc] initWithData:postBody
//                                                encoding:NSUTF8StringEncoding];
//    
//    NSString *venuesQuery = [getString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@%@", urlString, @"where=", venuesQuery]];
//    [parseRequest setURL:requestURL];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:parseRequest
//                                            completionHandler:
//                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
//                                      int big = 0;
//                                      int small = 0;
//                                      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//                                      [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//                                      [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
//                                      if (data) {
//                                          responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                          NSArray *arrOfDict = [responseDictionary objectForKey:@"results"];
//                                          for (int i = 0; i<arrOfDict.count; i++) {
//                                              NSDictionary *dict = [arrOfDict objectAtIndex:i];
//                                              NSString *update = [NSString stringWithFormat:@"%@",[dict objectForKey:@"updatedAt"]];
//                                              NSDate *updatedAt = [dateFormatter dateFromString:update];
//                                              
//                                              if ([updatedAt compare:from]==NSOrderedDescending && [updatedAt compare:to]==NSOrderedAscending) {
//                                                  int count = [[dict objectForKey:@"checkoutNumber"]intValue];
//                                                  if (count>big) {
//                                                      
//                                                      big = count;
//                                                      mDeviceNameMax = [dict objectForKey:@"deviceName"];
//                                                      
//                                                  }
//                                                  if (count<=small) {
//                                                      small = count;
//                                                      mDeviceNameMin = [dict objectForKey:@"deviceName"];
//                                                  }
//                                              }
//                                          }
//                                          [mArrayOfCheckoutDevice addObject:mDeviceNameMin];
//                                          [mArrayOfCheckoutDevice addObject:[NSString stringWithFormat:@"%i",small]];
//                                          [mArrayOfCheckoutDevice addObject:mDeviceNameMax];
//                                          [mArrayOfCheckoutDevice addObject:[NSString stringWithFormat:@"%i",big]];
//                                      }
//                                      completion(mArrayOfCheckoutDevice);
//                                  }];
//    
//    [task resume];
//}
//
//- (void)sendDataHours :(NSDate *)from :(NSDate *)to  completion:(void (^)(NSMutableArray *))completion {
//    
//    mArrayOfCheckoutHours = [[NSMutableArray alloc]init];
//    NSString *urlString = @"https://api.parse.com/1/classes/Devices";
//    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    [parseRequest setHTTPMethod:@"GET"];
//    [parseRequest setValue:@"i48dw0oV5E2prYLcPIf4ZEYS1G8PXlWa4sqC3g56" forHTTPHeaderField:@"X-Parse-Application-Id"];
//    [parseRequest setValue:@"OCQb1QWKGP3SsKwoEDqoc8uFygptO28oTcPBA3nV" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
//    
//    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
//    //    [postDictionary setObject:@"Apple" forKey:@"deviceMake"];
//    //    [postDictionary setObject:@"iPad Mini" forKey:@"deviceModel"];
//    
//    NSError *error;
//    NSData *postBody = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* getString=  [[NSString alloc] initWithData:postBody
//                                                encoding:NSUTF8StringEncoding];
//    
//    NSString *venuesQuery = [getString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@%@", urlString, @"where=", venuesQuery]];
//    [parseRequest setURL:requestURL];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:parseRequest
//                                            completionHandler:
//                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
//                                      int big = 0;
//                                      int small = 0;
//                                      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//                                      [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//                                      [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
//                                      
//                                      if (data) {
//                                          responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                          NSArray *arrOfDict = [responseDictionary objectForKey:@"results"];
//                                          for (int i = 0; i<arrOfDict.count; i++) {
//                                              NSDictionary *dict = [arrOfDict objectAtIndex:i];
//                                              NSString *update = [NSString stringWithFormat:@"%@",[dict objectForKey:@"updatedAt"]];
//                                              NSDate *updatedAt = [dateFormatter dateFromString:update];
//                                              if ([updatedAt compare:from]==NSOrderedDescending && [updatedAt compare:to]==NSOrderedAscending) {
//                                                  int count = [[dict objectForKey:@"checkoutHours"]intValue];
//                                                  if (count>big) {
//                                                      
//                                                      big = count;
//                                                      mDeviceNameMax = [dict objectForKey:@"deviceName"];
//                                                      
//                                                  }
//                                                  if (count<=small) {
//                                                      small = count;
//                                                      mDeviceNameMin = [dict objectForKey:@"deviceName"];
//                                                  }
//                                              }
//                                          }
//                                          if (mDeviceNameMax == nil) {
//                                              mDeviceNameMax = @"No data";
//                                          }
//                                          if (mDeviceNameMin == nil) {
//                                              mDeviceNameMin = @"No data";
//                                          }
//                                          [mArrayOfCheckoutHours addObject:mDeviceNameMin];
//                                          [mArrayOfCheckoutHours addObject:[NSString stringWithFormat:@"%i",small]];
//                                          [mArrayOfCheckoutHours addObject:mDeviceNameMax];
//                                          [mArrayOfCheckoutHours addObject:[NSString stringWithFormat:@"%i",big]];
//                                      }
//                                      completion(mArrayOfCheckoutHours);
//                                  }];
//    
//    [task resume];
//}
//
//- (void)sendDataRequest :(NSDate *)from :(NSDate *)to completion:(void (^)(NSMutableArray *))completion{
//    mArrayOfRequestedDevice = [[NSMutableArray alloc]init];
//    NSString *urlString = @"https://api.parse.com/1/classes/Devices";
//    
//    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    [parseRequest setHTTPMethod:@"GET"];
//    [parseRequest setValue:@"i48dw0oV5E2prYLcPIf4ZEYS1G8PXlWa4sqC3g56" forHTTPHeaderField:@"X-Parse-Application-Id"];
//    [parseRequest setValue:@"OCQb1QWKGP3SsKwoEDqoc8uFygptO28oTcPBA3nV" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
//    
//    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
//    
//    NSError *error;
//    NSData *postBody = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* getString=  [[NSString alloc] initWithData:postBody
//                                                encoding:NSUTF8StringEncoding];
//    
//    NSString *venuesQuery = [getString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@%@", urlString, @"where=", venuesQuery]];
//    [parseRequest setURL:requestURL];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:parseRequest
//                                            completionHandler:
//                                  
//                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
//                                      int big = 0;
//                                      int small = 0;
//                                      
//                                      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//                                      [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//                                      [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
//                                      
//                                      if (data) {
//                                          responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                          NSArray *arrOfDict = [responseDictionary objectForKey:@"results"];
//                                          for (int i = 0; i<arrOfDict.count; i++) {
//                                              NSDictionary *dict = [arrOfDict objectAtIndex:i];
//                                              NSString *update = [NSString stringWithFormat:@"%@",[dict objectForKey:@"updatedAt"]];
//                                              NSDate *updatedAt = [dateFormatter dateFromString:update];
//                                              if ([updatedAt compare:from]==NSOrderedDescending && [updatedAt compare:to]==NSOrderedAscending) {
//                                                  int count = [[dict objectForKey:@"requestNumber"]intValue];
//                                                  if (count>big) {
//                                                      
//                                                      big = count;
//                                                      mDeviceNameMax = [dict objectForKey:@"deviceName"];
//                                                      
//                                                  }
//                                                  if (count<=small) {
//                                                      small = count;
//                                                      mDeviceNameMin = [dict objectForKey:@"deviceName"];
//                                                  }
//                                              }
//                                          }
//                                          if (mDeviceNameMax == nil) {
//                                              mDeviceNameMax = @"No data";
//                                          }
//                                          if (mDeviceNameMin == nil) {
//                                              mDeviceNameMin = @"No data";
//                                          }
//                                          
//                                          [mArrayOfRequestedDevice addObject:mDeviceNameMax];
//                                          [mArrayOfRequestedDevice addObject:[NSString stringWithFormat:@"%i",small]];
//                                          [mArrayOfRequestedDevice addObject:mDeviceNameMin];
//                                          [mArrayOfRequestedDevice addObject:[NSString stringWithFormat:@"%i",big]];
//                                      }
//                                      completion(mArrayOfRequestedDevice);
//                                  }];
//    
//    [task resume];
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"self" ascending:NO];
//}


@end
