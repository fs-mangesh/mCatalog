//
//  DeviceActivityTableViewController.h
//  PushNotificationSample
//
//  Created by afour on 2014-12-08.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceActivityTableViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) UITextField *mDeviceNameTextField;


@property (strong, nonatomic) NSArray *mAllFetchedObjectsArray;

@property (strong, nonatomic) NSMutableArray *mArrayOfDeviceName;

@property (strong, nonatomic) UIPickerView *mPickerDeviceName;


- (void)displayActivities:(id)sender;

@property (strong, nonatomic)NSMutableArray *mArrayOfDeviceObjects;

@property (strong, nonatomic)NSMutableArray *mArrayOfUser;
@property (strong, nonatomic)NSMutableArray *mArrayOfCheckoutDate;
@property (strong, nonatomic)NSMutableArray *mArrayOfCheckoutTime;
@property (strong, nonatomic)NSMutableArray *mArrayOfCheckinDate;
@property (strong, nonatomic)NSMutableArray *mArrayOfCheckinTime;
@property (strong, nonatomic) UIView *mPickerDeviceMakeParentView;

@property (strong,nonatomic) NSString *mCurrDeviceModel;
@end
