//
//  SearchDeviceTableViewController.h
//  PushNotificationSample
//
//  Created by afour on 2014-12-03.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseInterface.h"
#import "DataClass.h"
#import <Parse/Parse.h>

@interface SearchDeviceTableViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>


@property (strong, nonatomic) UITextField *mTextFieldDeviceMake;
@property (strong, nonatomic) UITextField *mTextFieldDeviceModel;
@property (strong, nonatomic) UITextField *mTextFieldDeviceStatus;


//setting properties of pickerView for deviceMake text field
@property (strong, nonatomic) UIView *mPickerDeviceMakeParentView;
@property (strong, nonatomic) UIPickerView *mPickerDeviceMake;
@property (strong, nonatomic) NSArray *mArrayOfDeviceMake;


@property (strong, nonatomic) NSMutableArray *mArrayOfDeviceModel;

@property (strong, nonatomic) NSMutableArray *mArrayOfDeviceStatus;

@property (strong, nonatomic) NSMutableArray *mPickerArray;
@property (strong, nonatomic) NSString *checkString;

@property (nonatomic,strong) NSMutableArray *mArrayOfDeviceForTable;
@property (nonatomic,strong) NSMutableArray *mArrayOfCopiedObjects;;
@property (nonatomic,strong) NSString *mUsername;
//
//@property (nonatomic,strong) UIAlertView *mAlertViewBusy;
//@property (nonatomic,strong) UIAlertView *mAlertViewFree;

@property (nonatomic,strong) NSString *mCurrentDeviceToken;

@property (strong,nonatomic) NSString *mCurrDeviceModel;
@end
