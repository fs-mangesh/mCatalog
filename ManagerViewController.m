//
//  ManagerViewController.m
//  PushNotificationSample
//
//  Created by afour on 2015-01-09.
//  Copyright (c) 2015 afourtech. All rights reserved.
//

#import "ManagerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ManagerViewController ()

@end

@implementation ManagerViewController
@synthesize mArrayOfDeviceModel,mPickerArray,mPickerDeviceMakeParentView,mArrayOfRequest,mLabelMostRequestD1,mLabelMostRequestN1,mLabelMostCheckoutN2,mLabelMostCheckoutD1,mLabelMostCheckckoutN1,mArrayOfCheckoutDevice,mLabelLeastD1,mArrayOfDeviceMake,mArrayOfHours,mDatePicker,mEndDate,mLabelInventoryPercent,mLabelLeastD2,mLabelLeastD3,mLabelLeastN1,mLabelLeastN2,mLabelLeastN3,mLabelMostCheckoutD2,mLabelMostCheckoutD3,mLabelMostCheckoutN3,mLabelMostRequestD2,mLabelMostRequestD3,mLabelMostRequestN2,mLabelMostRequestN3,mLeastCheckoutView,mMostCheckoutView,mMostRequestView,flagDate,flagMake,flagModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    flagDate = 0;
    flagMake = 0;
    flagModel = 0;
    
//    mArrayOfDeviceModel = [[NSMutableArray alloc]init];
//    mArrayOfDeviceMake = [[NSMutableArray alloc]init];
//    mPickerArray = [[NSMutableArray alloc]init];
//    
//    [mArrayOfDeviceMake addObject:@"Apple"];
//    [mArrayOfDeviceMake addObject:@"Samsung"];
//    [mArrayOfDeviceMake addObject:@"Sony Ericson"];
//    [mArrayOfDeviceMake addObject:@"Nexus"];
//    [mArrayOfDeviceMake addObject:@"Lenovo"];
//    
//    [self setDevicePickerView];
//    
// 
//    [self setPickerView];

    
    
    mArrayOfCheckoutDevice  = [[NSMutableArray alloc]init];
    mArrayOfRequest = [[NSMutableArray alloc]init];

    
    NSDate *currDate = [NSDate date];
    NSDate *newDate = [currDate dateByAddingTimeInterval:-3600*24*7];
    
    [self loadData:newDate :currDate];
}

-(void)loadData :(NSDate *)from :(NSDate *)to{
    mLabelInventoryPercent.text = [NSString stringWithFormat:@"%@ %%",[[ParseInterface sharedInstance]getInventoryUtilization]];
    
    mArrayOfCheckoutDevice  = [[ParseInterface sharedInstance]getMostCheckedoutDevices];
    mArrayOfRequest = [[ParseInterface sharedInstance]getMostRequestedDevices];
    
    //displaying least checkedout devices
    mLabelLeastN1.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:0]];
    mLabelLeastD1.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:1]];
    
    mLabelLeastN2.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:2]];
    mLabelLeastD2.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:3]];
    
    mLabelLeastN3.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:4]];
    mLabelLeastD3.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:5]];
    
    //displaying most checkedout devices
    mLabelMostCheckckoutN1.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:6]];
    mLabelMostCheckoutD1.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:7]];
    
    mLabelMostCheckoutN2.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:8]];
    mLabelMostCheckoutD2.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:9]];
    
    mLabelMostCheckoutN3.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:10]];
    mLabelMostCheckoutD3.text = [NSString stringWithFormat:@"%@",[mArrayOfCheckoutDevice objectAtIndex:11]];
    
    //displaying most requested devices
    mLabelMostRequestN1.text = [NSString stringWithFormat:@"%@",[mArrayOfRequest objectAtIndex:0]];
    mLabelMostRequestD1.text = [NSString stringWithFormat:@"%@",[mArrayOfRequest objectAtIndex:1]];
    
    mLabelMostRequestN2.text = [NSString stringWithFormat:@"%@",[mArrayOfRequest objectAtIndex:2]];
    mLabelMostRequestD2.text = [NSString stringWithFormat:@"%@",[mArrayOfRequest objectAtIndex:3]];
    
    mLabelMostRequestN3.text = [NSString stringWithFormat:@"%@",[mArrayOfRequest objectAtIndex:4]];
    mLabelMostRequestD3.text = [NSString stringWithFormat:@"%@",[mArrayOfRequest objectAtIndex:5]];
}
//
//-(void)setDevicePickerView{
//    
//    //Picker View which will display list of devices
//    mPickerDeviceMake = [[UIPickerView alloc]init];
//    
//    // Connect data
//    self.mPickerDeviceMake.dataSource = self;
//    self.mPickerDeviceMake.delegate = self;
//    
//    //setting toolBar on pickerView
//    UIToolbar *lToolBar = [[UIToolbar alloc]init];
//    lToolBar.barStyle = UIBarStyleDefault;
//    
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(makeModelWasSelected:)];
//    
//    [lToolBar setItems:[NSArray arrayWithObject:doneButton]];
//    
//    mPickerDeviceMakeParentView = [[UIView alloc] init];
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
////        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {
////            lToolBar.frame = CGRectMake(0, 0, 375, 44);
////            mPickerDeviceMakeParentView.frame = CGRectMake(0, 60, 375, 200);
////        }
////        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]){
////            lToolBar.frame = CGRectMake(0, 0, 414, 44);
////            mPickerDeviceMakeParentView.frame = CGRectMake(0, 60, 414, 200);
////        }
////        else{
////            lToolBar.frame = CGRectMake(0, 0, 320, 44);
////            mPickerDeviceMakeParentView.frame = CGRectMake(0, 60, 320, 200);
////        }
//        
//    }
//    else{
//        lToolBar.frame = CGRectMake(0, 0, 768, 50);
//        mPickerDeviceMakeParentView.frame = CGRectMake(0, 774, 768, 250);
//        mPickerDeviceMake.frame = CGRectMake(0, 50, 768, 200);
//    }
//    
//    [mPickerDeviceMakeParentView addSubview:mPickerDeviceMake];
//    [mPickerDeviceMakeParentView addSubview:lToolBar];
//    [mTextFieldMake setInputView:mPickerDeviceMakeParentView];
//    [mTextFieldModel setInputView:mPickerDeviceMakeParentView];
//}
//-(void)setPickerView{
//    mPickerParentView = [[UIView alloc]init];
//    
//    mDatePicker = [[UIDatePicker alloc]init];
//    [mDatePicker setDate:[NSDate date]];
//    mDatePicker.datePickerMode = UIDatePickerModeDate;
//    [mDatePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
//    //setting toolBar on pickerView
//    UIToolbar *lToolBar = [[UIToolbar alloc]init];
//    lToolBar.barStyle = UIBarStyleDefault;
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
////        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {
////            lToolBar.frame = CGRectMake(0, 0, 375, 44);
////            mDatePicker.frame = CGRectMake(0, 50, 375, 100);
////            mPickerParentView.frame = CGRectMake(0, 60, 375, 200);
////        }
////        
////        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]){
////            lToolBar.frame = CGRectMake(0, 0, 414, 44);
////            mDatePicker.frame = CGRectMake(0, 50, 414, 100);
////            mPickerParentView.frame = CGRectMake(0, 60, 414, 200);
////        }
////        else{
////            lToolBar.frame = CGRectMake(0, 0, 320, 44);
////            mDatePicker.frame = CGRectMake(0, 50, 320, 100);
////            mPickerParentView.frame = CGRectMake(0, 60, 320, 200);
////        }
//        
//    }
//    else{
//        lToolBar.frame = CGRectMake(0, 0, 768, 44);
//        mPickerParentView.frame = CGRectMake(0, 400, 768, 300);
//        mDatePicker.frame = CGRectMake(0, 50, 768, 300);
//    }
//    
//    
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(itemWasSelected:)];
//    
//    [lToolBar setItems:[NSArray arrayWithObject:doneButton]];
//    
//    [mPickerParentView addSubview:lToolBar];
//    [mPickerParentView addSubview:mDatePicker];
//    
//    [mTextFieldTo setInputView:mPickerParentView];
//    [mTextFieldTo setDelegate:self];
//    
//    [mTextFieldFrom setInputView:mPickerParentView];
//    [mTextFieldFrom setDelegate:self];
//}
//
//-(void)updateTextField:(id)sender
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"dd.MM.YY"];
//    NSString *dateString = [dateFormatter stringFromDate:mDatePicker.date];
//
//    if (tag == 0) {
//                mStartDate = mDatePicker.date;
//                mTextFieldFrom.text = dateString;
//            }
//            else{
//                mEndDate = mDatePicker.date;
//                mTextFieldTo.text = dateString;
//            }
//    
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    tag = (int)textField.tag;
//    if (tag == 2) {
//        mTextFieldModel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];
//        mTextFieldMake.textColor = [UIColor blueColor];
//        [mPickerDeviceMake reloadAllComponents];
//        mPickerArray = mArrayOfDeviceMake;
//    }
//    else if (tag == 3){
//        mTextFieldMake.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];
//        mTextFieldModel.textColor = [UIColor blueColor];
//        mPickerArray = mArrayOfDeviceModel;
//        
//        if (mArrayOfDeviceModel != nil) {
//            mArrayOfDeviceModel = nil;
//        }
//        mArrayOfDeviceModel = [[NSMutableArray alloc]init];
//        if ([mTextFieldMake.text isEqualToString:@"Make"]) {
//            NSArray *arr = [[NSArray alloc]init];
//            PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
//            
//            arr = [query findObjects];
//            
//            if(arr.count!=0)
//            {
//                for (PFObject *object in arr) {
//                    
//                    Device *lDevice = [[Device alloc]init];
//                    lDevice.mDeviceModel = [object valueForKey:@"deviceModel"];
//                    [mArrayOfDeviceModel addObject:lDevice.mDeviceModel];
//                }
//                
//            }
//            mPickerArray = mArrayOfDeviceModel;
//            [mPickerDeviceMake reloadAllComponents];
//        }
//        else{
//            //array of device model
//            if (mArrayOfDeviceModel != nil) {
//                mArrayOfDeviceModel = nil;
//            }
//            mArrayOfDeviceModel = [[NSMutableArray alloc]init];
//            NSMutableArray *arr = [[NSMutableArray alloc]init];
//            arr =[[ParseInterface sharedInstance]searchDevices:mTextFieldMake.text];
//            for (int i = 0; i<arr.count; i++) {
//                Device *lDevice = [[Device alloc]init];
//                lDevice = [arr objectAtIndex:i];
//                [mArrayOfDeviceModel addObject:lDevice.mDeviceModel];
//            }
//        }
//        mPickerArray = mArrayOfDeviceModel;
//        [mPickerDeviceMake reloadAllComponents];
//    }
//}
//
//
//-(void)itemWasSelected:(id)sender
//{
//    [mTextFieldTo resignFirstResponder];
//    [mTextFieldFrom resignFirstResponder];
//    
//    if (tag == 1) {
//        if ([mStartDate compare:mEndDate]==NSOrderedAscending) {
//            [self loadData:mStartDate :mEndDate];
//        }
//        else{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Start date must be less than end date" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [alert show];
//        }
//    }
//}
//
//-(void)makeModelWasSelected:(id)sender{
//    [mTextFieldModel resignFirstResponder];
//    [mTextFieldMake resignFirstResponder];
//    
//    if (tag == 2) {
//        mTextFieldMake.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];
//    }
//    else if (tag == 3){
//        mTextFieldModel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]];
//    }
//}
//- (IBAction)dateFilterClicked:(id)sender {
//    [mTextFieldMake resignFirstResponder];
//    [mTextFieldModel resignFirstResponder];
//    
//    if (flagDate == 0) {
//
//        [mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        flagDate = 1;
//        [mButtonDate setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [mButtonDate setTitle:@"Done" forState:UIControlStateNormal];
//        mTextFieldMake.hidden = YES;
//        mTextFieldModel.hidden = YES;
//    }
//    else{
//
//        [mScrollView setContentOffset:CGPointMake(0, 50) animated:YES];
//        [mButtonDate setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bar.png"]] forState:UIControlStateNormal];
//        [mButtonDate setTitle:@"Date" forState:UIControlStateNormal];
//        flagDate = 0;
//        mTextFieldModel.hidden = NO;
//        mTextFieldMake.hidden = NO;
//    }
//}
//
//
//
//#pragma pickerView
//
//// The number of columns of data
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//// The number of rows of data
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return mPickerArray.count;
//}
//
//// The data to return for the row and component (column) that's being passed in
//- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
//    return mPickerArray[row];
//    
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    if (tag == 2) {
//        mTextFieldMake.text = [mPickerArray objectAtIndex:row];
//    }
//    
//    else if(tag == 3){
//        mTextFieldModel.text = [mPickerArray objectAtIndex:row];
//    }
//
//}
//
@end
