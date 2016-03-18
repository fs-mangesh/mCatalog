//
//  ManagerViewController.h
//  PushNotificationSample
//
//  Created by afour on 2015-01-09.
//  Copyright (c) 2015 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseInterface.h"

@interface ManagerViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong) NSMutableArray *mArrayOfCheckoutDevice;
@property(nonatomic,strong) NSMutableArray *mArrayOfRequest;
@property(nonatomic,strong) NSMutableArray *mArrayOfHours;


@property (weak, nonatomic) IBOutlet UILabel *mLabelInventoryPercent;

@property (weak, nonatomic) IBOutlet UIView *mMostCheckoutView;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostCheckoutD1;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostCheckckoutN1;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostCheckoutD2;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostCheckoutN2;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostCheckoutD3;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostCheckoutN3;

@property (weak, nonatomic) IBOutlet UIView *mLeastCheckoutView;
@property (weak, nonatomic) IBOutlet UILabel *mLabelLeastD1;
@property (weak, nonatomic) IBOutlet UILabel *mLabelLeastN1;
@property (weak, nonatomic) IBOutlet UILabel *mLabelLeastD2;
@property (weak, nonatomic) IBOutlet UILabel *mLabelLeastN2;
@property (weak, nonatomic) IBOutlet UILabel *mLabelLeastD3;
@property (weak, nonatomic) IBOutlet UILabel *mLabelLeastN3;

@property (weak, nonatomic) IBOutlet UIView *mMostRequestView;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostRequestD1;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostRequestN1;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostRequestD2;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostRequestN2;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostRequestD3;
@property (weak, nonatomic) IBOutlet UILabel *mLabelMostRequestN3;

@property (strong,nonatomic) UIView *mPickerParentView;
@property (strong,nonatomic) UIDatePicker *mDatePicker;

@property (nonatomic) int tag;
@property (nonatomic,strong) NSDate *mStartDate;
@property (nonatomic,strong) NSDate *mEndDate;



@property (nonatomic) int flagDate;
@property (nonatomic) int flagMake;
@property (nonatomic) int flagModel;

@property (strong, nonatomic) UIView *mPickerDeviceMakeParentView;
@property (strong, nonatomic) UIPickerView *mPickerDeviceMake;
@property (strong, nonatomic) NSMutableArray *mArrayOfDeviceMake;
@property (strong, nonatomic) NSMutableArray *mArrayOfDeviceModel;
@property (strong, nonatomic) NSMutableArray *mPickerArray;


@end
