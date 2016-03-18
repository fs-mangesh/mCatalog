//
//  DateHistoryTableViewController.h
//  PushNotificationSample
//
//  Created by afour on 2014-12-05.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseInterface.h"
#import "DataClass.h"
#import <Parse/Parse.h>

@interface DateHistoryTableViewController : UITableViewController<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *mTextFieldDate;
@property (strong, nonatomic)NSMutableArray *mArrayOfDeviceObjects;

@property (strong, nonatomic)NSDate *mCheckDate;

@property (strong, nonatomic)NSMutableArray *mArrayOfUser;
@property (strong, nonatomic)NSMutableArray *mArrayOfDeviceName;
@property (strong, nonatomic)NSMutableArray *mArrayOfCheckoutDate;
@property (strong, nonatomic)NSMutableArray *mArrayOfCheckoutTime;
@property (strong, nonatomic)NSMutableArray *mArrayOfCheckinDate;
@property (strong, nonatomic)NSMutableArray *mArrayOfCheckinTime;

@property (strong,nonatomic) NSString *mCurrDeviceModel;
@property (strong,nonatomic) UIView *mPickerParentView;
@property (strong,nonatomic) UIDatePicker *mDatePicker;
@end
