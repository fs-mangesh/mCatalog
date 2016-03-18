//
//  SearchDeviceTableViewController.m
//  PushNotificationSample
//
//  Created by afour on 2014-12-03.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import "SearchDeviceTableViewController.h"
#import "DeviceTableViewCell.h"
#import "ParseInterface.h"

@interface SearchDeviceTableViewController ()

@end

@implementation SearchDeviceTableViewController
@synthesize mPickerDeviceMake,mArrayOfDeviceMake,mPickerDeviceMakeParentView;

@synthesize mTextFieldDeviceMake,mTextFieldDeviceModel,mTextFieldDeviceStatus;
@synthesize mArrayOfDeviceModel,mArrayOfDeviceStatus;
@synthesize mPickerArray,mArrayOfDeviceForTable,mArrayOfCopiedObjects;
@synthesize checkString,mUsername,mCurrentDeviceToken;
@synthesize mCurrDeviceModel;
//@synthesize mAlertViewBusy,mAlertViewFree;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
     mCurrDeviceModel = [self platformNiceString];
    
    //allocating arrays
    [self setArrays];
    
    //setting headerView for tableView
    [self setHeaderView];
    
    
    //adding pickerView to textField
    [self setPickerView];
//    [self setPickerViewModel];
    
    self.mTextFieldDeviceModel.delegate  =self;
    self.mTextFieldDeviceMake.delegate = self;
    self.mTextFieldDeviceStatus.delegate =self;
    
    
    //giving input of textfield as picker view
    [self.mTextFieldDeviceMake setInputView:mPickerDeviceMakeParentView];
    [mTextFieldDeviceMake setTag:0];
    
    
    //giving input of textfield as picker view
    [self.mTextFieldDeviceModel setInputView:mPickerDeviceMakeParentView];
    [mTextFieldDeviceModel setTag:1];
    
    [self.mTextFieldDeviceStatus setInputView:mPickerDeviceMakeParentView];
    [mTextFieldDeviceStatus setTag:2];
    

    
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadDataTest];
}

-(void)loadDataTest
{
    UIAlertView *alertViewFree = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please go to admin and checkout this device" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alertViewFree show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
            [alertViewFree dismissWithClickedButtonIndex:1 animated:YES];
            [self.tableView reloadData];
        });
    });
    
    
}
-(void)loadData{
    NSArray *arr = [[NSArray alloc]init];
    if (mArrayOfDeviceForTable != nil) {
        mArrayOfDeviceForTable = nil;
    }
    mArrayOfDeviceForTable = [[NSMutableArray alloc]init];
    
    if (mArrayOfCopiedObjects != nil) {
        mArrayOfCopiedObjects = nil;
    }
    mArrayOfCopiedObjects = [[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
    arr = [query findObjects];
    
    if(arr.count!=0)
    {
        for (PFObject *object in arr) {
            
            Device *lDevice = [[Device alloc]init];
            lDevice.mDeviceToken = [object valueForKey:@"deviceToken"];
            lDevice.mDeviceStatus =[object valueForKey:@"deviceStatus"];
            lDevice.mDeviceName = [object valueForKey:@"deviceName"];
            lDevice.mDeviceCurrentUser = [object valueForKey:@"deviceCurrentUser"];
            lDevice.mDeviceVersion = [object valueForKey:@"deviceVersion"];
            lDevice.mDeviceMake = [object valueForKey:@"deviceMake"];
            lDevice.mDeviceStatus = [object valueForKey:@"deviceStatus"];
            lDevice.mDeviceModel = [object valueForKey:@"deviceModel"];
            lDevice.mDeviceRegistrationNumber = [object valueForKey:@"registrationNumber"];
            [mArrayOfDeviceForTable addObject:lDevice];
        }
        
    }
    mArrayOfCopiedObjects = mArrayOfDeviceForTable;
    
}
-(void)setHeaderView{
    //setting textField of deviceMake
    mTextFieldDeviceMake = [[UITextField alloc]init];
    mTextFieldDeviceMake.backgroundColor = [UIColor whiteColor];
    mTextFieldDeviceMake.placeholder = @"Make";
    mTextFieldDeviceMake.textAlignment = NSTextAlignmentCenter;
    
    mTextFieldDeviceMake.borderStyle = UITextBorderStyleRoundedRect;
    
    //setting textField of deviceModel
    mTextFieldDeviceModel = [[UITextField alloc]init];
    mTextFieldDeviceModel.placeholder = @"Model";
    
    mTextFieldDeviceModel.textAlignment = NSTextAlignmentCenter;
    mTextFieldDeviceModel.borderStyle = UITextBorderStyleRoundedRect;
    mTextFieldDeviceModel.backgroundColor = [UIColor whiteColor];
    
    //setting textField of deviceStatus
    mTextFieldDeviceStatus = [[UITextField alloc]init];
    mTextFieldDeviceStatus.placeholder = @"Status";
    
    mTextFieldDeviceStatus.borderStyle = UITextBorderStyleRoundedRect;
    mTextFieldDeviceStatus.textAlignment = NSTextAlignmentCenter;
    mTextFieldDeviceStatus.backgroundColor = [UIColor whiteColor];

    
    UIView *headerView = [[UIView alloc] init];
   headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header.png"]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]) {
            headerView.frame = CGRectMake(0, 0, 414, 50);
            
            mTextFieldDeviceMake.frame = CGRectMake(6, 10, 130, 30);
            mTextFieldDeviceModel.frame = CGRectMake(142, 10, 130, 30);
            mTextFieldDeviceStatus.frame = CGRectMake(278, 10, 130, 30);

            mTextFieldDeviceMake.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
            mTextFieldDeviceModel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
            mTextFieldDeviceStatus.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        }
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]){
            headerView.frame = CGRectMake(0, 0, 375, 50);
            
            mTextFieldDeviceMake.frame = CGRectMake(11, 10, 110, 30);
            mTextFieldDeviceModel.frame = CGRectMake(132, 10, 110, 30);
            mTextFieldDeviceStatus.frame = CGRectMake(253, 10, 110, 30);

            
            mTextFieldDeviceMake.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
            mTextFieldDeviceModel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
            mTextFieldDeviceStatus.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        }
        else{
            headerView.frame = CGRectMake(0, 0, 320, 38);
            
            mTextFieldDeviceMake.frame = CGRectMake(4, 4, 100, 30);
            mTextFieldDeviceModel.frame = CGRectMake(108, 4, 100, 30);
            mTextFieldDeviceStatus.frame = CGRectMake(212, 4, 100, 30);

            
            mTextFieldDeviceMake.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
            mTextFieldDeviceModel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
            mTextFieldDeviceStatus.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        }

    }
    
    else{
        headerView.frame = CGRectMake(0, 0, 768, 85);
        
        mTextFieldDeviceMake.frame = CGRectMake(15, 20, 236, 45);
        mTextFieldDeviceModel.frame = CGRectMake(265, 20, 236, 45);
        mTextFieldDeviceStatus.frame = CGRectMake(516, 20, 236, 45);


        mTextFieldDeviceMake.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        mTextFieldDeviceModel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        mTextFieldDeviceStatus.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        
        mTextFieldDeviceMake.clearButtonMode = UITextFieldViewModeAlways;
        mTextFieldDeviceModel.clearButtonMode = UITextFieldViewModeAlways;
        mTextFieldDeviceStatus.clearButtonMode = UITextFieldViewModeAlways;
    }
    
   
    
    [headerView addSubview:mTextFieldDeviceMake];
    [headerView addSubview:mTextFieldDeviceModel];
    [headerView addSubview:mTextFieldDeviceStatus];
    
 //   headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header.png"]];
    self.tableView.tableHeaderView = headerView;
}

-(void)setArrays{
//    //array of device make
//    mArrayOfDeviceMake = [[NSMutableArray alloc]init];
//    [mArrayOfDeviceMake addObject:@"Apple"];
//    [mArrayOfDeviceMake addObject:@"Samsung"];
//    [mArrayOfDeviceMake addObject:@"Sony Ericson"];
//    [mArrayOfDeviceMake addObject:@"Nexus"];
//    [mArrayOfDeviceMake addObject:@"Lenovo"];
    
    mPickerArray = [[NSMutableArray alloc]init];
}

-(void)setPickerView{

    //Picker View which will display list of devices
    mPickerDeviceMake = [[UIPickerView alloc]init];
    
    // Connect data
    self.mPickerDeviceMake.dataSource = self;
    self.mPickerDeviceMake.delegate = self;
    
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
        mPickerDeviceMakeParentView.frame = CGRectMake(0, 60, 768, 400);
        mPickerDeviceMake.frame = CGRectMake(0, 60, 768, 400);
    }
    
    [mPickerDeviceMakeParentView addSubview:mPickerDeviceMake];
    [mPickerDeviceMakeParentView addSubview:lToolBar];
    
}




- (void)textFieldDidBeginEditing:(UITextField *)textField{
    AppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    if (textField.tag == 0) {
        //array of device make
        if (mArrayOfDeviceMake != nil) {
            mArrayOfDeviceMake = nil;
        }
        mArrayOfDeviceMake = [[NSArray alloc]init];
         NSMutableArray *duplicateArray = [NSMutableArray array];
        if (duplicateArray != nil) {
            duplicateArray = nil;
        }
        duplicateArray = [[NSMutableArray alloc]init];
        NSArray *arr = [[NSArray alloc]init];
        PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
        [query whereKey:@"companyName" equalTo:appDel.mCompanyName];
        arr = [query findObjects];
        
        if(arr.count!=0)
        {
            for (PFObject *object in arr) {
                
               
                Device *lDevice = [[Device alloc]init];
                lDevice.mDeviceMake = [object valueForKey:@"deviceMake"];
                [duplicateArray addObject:lDevice.mDeviceMake];
            }
            mArrayOfDeviceMake = [[NSSet setWithArray:duplicateArray] allObjects];
            
        }
        [mPickerArray addObjectsFromArray:mArrayOfDeviceMake];
        [mPickerDeviceMake reloadAllComponents];
        checkString = @"make";
    }
    
    else if (textField.tag == 1){
        if (mArrayOfDeviceModel != nil) {
            mArrayOfDeviceModel = nil;
        }
        mArrayOfDeviceModel = [[NSMutableArray alloc]init];
        if ([mTextFieldDeviceMake.text isEqualToString:@""]) {
            NSArray *arr = [[NSArray alloc]init];
            PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
            
            arr = [query findObjects];
            
            if(arr.count!=0)
            {
                for (PFObject *object in arr) {
                    
                    Device *lDevice = [[Device alloc]init];
                    lDevice.mDeviceModel = [object valueForKey:@"deviceModel"];
                    [mArrayOfDeviceModel addObject:lDevice.mDeviceModel];
                }
                
            }
            mPickerArray = mArrayOfDeviceModel;
            [mPickerDeviceMake reloadAllComponents];
            checkString = @"model";
        }
        else{
        //array of device model
            if (mArrayOfDeviceModel != nil) {
                mArrayOfDeviceModel = nil;
            }
            mArrayOfDeviceModel = [[NSMutableArray alloc]init];
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            arr =[[ParseInterface sharedInstance]searchDevices:mTextFieldDeviceMake.text];
            for (int i = 0; i<arr.count; i++) {
                Device *lDevice = [[Device alloc]init];
                lDevice = [arr objectAtIndex:i];
                [mArrayOfDeviceModel addObject:lDevice.mDeviceModel];
            }
        }
     mPickerArray = mArrayOfDeviceModel;
        [mPickerDeviceMake reloadAllComponents];
        checkString = @"model";
    }
   
    else if (textField.tag == 2){
        
            if (mArrayOfDeviceStatus != nil) {
                mArrayOfDeviceStatus = nil;
            }
            mArrayOfDeviceStatus = [[NSMutableArray alloc]init];
            [mArrayOfDeviceStatus addObject:@"Free"];
            [mArrayOfDeviceStatus addObject:@"Busy"];
        mPickerArray = mArrayOfDeviceStatus;
        [mPickerDeviceMake reloadAllComponents];
        checkString = @"status";
        }
    
   
    
}

-(void)displayAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No device found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)itemWasSelected:(id)sender
{
    [mTextFieldDeviceModel resignFirstResponder];
    [mTextFieldDeviceMake resignFirstResponder];
    [mTextFieldDeviceStatus resignFirstResponder];
    [self displayResults:nil];
    
}

-(void)displayResults:(id)sender{
    
    
    Device *lDevice = [[Device alloc]init];
    if (mArrayOfDeviceForTable != nil) {
        mArrayOfDeviceForTable = nil;
    }
    mArrayOfDeviceForTable = [[NSMutableArray alloc]init];
    
    if (mTextFieldDeviceMake.text.length==0&&mTextFieldDeviceModel.text.length == 0 && mTextFieldDeviceStatus.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select atleast one criteria" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    else if(mTextFieldDeviceMake.text.length > 0 &&mTextFieldDeviceModel.text.length > 0&& mTextFieldDeviceStatus.text.length > 0){
        
        for (int i = 0; i<mArrayOfCopiedObjects.count; i++) {
            lDevice = [mArrayOfCopiedObjects objectAtIndex:i];
            if ([lDevice.mDeviceMake isEqualToString:mTextFieldDeviceMake.text]&&[lDevice.mDeviceModel isEqualToString:mTextFieldDeviceModel.text]&&[lDevice.mDeviceStatus isEqualToString:mTextFieldDeviceStatus.text]) {
                [mArrayOfDeviceForTable addObject:lDevice];
            }
        }
  
        if (mArrayOfDeviceForTable.count == 0) {
            [self displayAlert];
        }
        [self.tableView reloadData];
    }
    
    else if(mTextFieldDeviceMake.text.length >0 &&mTextFieldDeviceModel.text.length == 0&& mTextFieldDeviceStatus.text.length == 0){

        for (int i = 0; i<mArrayOfCopiedObjects.count; i++) {
            lDevice = [mArrayOfCopiedObjects objectAtIndex:i];
            if ([lDevice.mDeviceMake isEqualToString:mTextFieldDeviceMake.text]) {
                [mArrayOfDeviceForTable addObject:lDevice];
            }
        }
        
        if (mArrayOfDeviceForTable.count == 0) {
            [self displayAlert];
        }
        [self.tableView reloadData];
    }
    
    else if(mTextFieldDeviceMake.text.length == 0 &&mTextFieldDeviceModel.text.length > 0&& mTextFieldDeviceStatus.text.length== 0){
        
        for (int i = 0; i<mArrayOfCopiedObjects.count; i++) {
            lDevice = [mArrayOfCopiedObjects objectAtIndex:i];
            if ([lDevice.mDeviceModel isEqualToString:mTextFieldDeviceModel.text]) {
                [mArrayOfDeviceForTable addObject:lDevice];
            }
        }
        
        if (mArrayOfDeviceForTable.count == 0) {
            [self displayAlert];
        }
        [self.tableView reloadData];
    }
    
    else if(mTextFieldDeviceMake.text.length == 0 &&mTextFieldDeviceModel.text.length == 0&& mTextFieldDeviceStatus.text.length > 0){
        
        for (int i = 0; i<mArrayOfCopiedObjects.count; i++) {
            lDevice = [mArrayOfCopiedObjects objectAtIndex:i];
            if ([lDevice.mDeviceStatus isEqualToString:mTextFieldDeviceStatus.text]) {
                [mArrayOfDeviceForTable addObject:lDevice];
            }
        }
        
        if (mArrayOfDeviceForTable.count == 0) {
            [self displayAlert];
        }
        [self.tableView reloadData];
    }
    
    else if(mTextFieldDeviceMake.text.length > 0 &&mTextFieldDeviceModel.text.length > 0&& mTextFieldDeviceStatus.text.length == 0){
        
        for (int i = 0; i<mArrayOfCopiedObjects.count; i++) {
            lDevice = [mArrayOfCopiedObjects objectAtIndex:i];
            if ([lDevice.mDeviceMake isEqualToString:mTextFieldDeviceMake.text]&&[lDevice.mDeviceModel isEqualToString:mTextFieldDeviceModel.text]) {
                [mArrayOfDeviceForTable addObject:lDevice];
            }
        }
        
        if (mArrayOfDeviceForTable.count == 0) {
            [self displayAlert];
        }
        [self.tableView reloadData];
    }
    
    else if(mTextFieldDeviceMake.text.length > 0 &&mTextFieldDeviceModel.text.length == 0&& mTextFieldDeviceStatus.text.length > 0){
        
        for (int i = 0; i<mArrayOfCopiedObjects.count; i++) {
            lDevice = [mArrayOfCopiedObjects objectAtIndex:i];
            if ([lDevice.mDeviceMake isEqualToString:mTextFieldDeviceMake.text]&&[lDevice.mDeviceStatus isEqualToString:mTextFieldDeviceStatus.text]) {
                [mArrayOfDeviceForTable addObject:lDevice];
            }
        }
        
        if (mArrayOfDeviceForTable.count == 0) {
            [self displayAlert];
        }
        [self.tableView reloadData];
    }
    
    else if(mTextFieldDeviceMake.text.length == 0 &&mTextFieldDeviceModel.text.length > 0&& mTextFieldDeviceStatus.text.length > 0){
        
        for (int i = 0; i<mArrayOfCopiedObjects.count; i++) {
            lDevice = [mArrayOfCopiedObjects objectAtIndex:i];
            if ([lDevice.mDeviceModel isEqualToString:mTextFieldDeviceModel.text]&&[lDevice.mDeviceStatus isEqualToString:mTextFieldDeviceStatus.text]) {
                [mArrayOfDeviceForTable addObject:lDevice];
            }
        }
        
        if (mArrayOfDeviceForTable.count == 0) {
            [self displayAlert];
        }
        [self.tableView reloadData];
    }
}



#pragma tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return mArrayOfDeviceForTable.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([mCurrDeviceModel isEqualToString:@"iPhone 6"]) {
            return [NSString stringWithFormat:@"Model                                         Status"];
        }
        else if ([mCurrDeviceModel isEqualToString:@"iPhone 6+"]){
            return [NSString stringWithFormat:@"Model                                                Status"];
        }
        else{
            return [NSString stringWithFormat:@"Model                                     Status"];
        }
    }
    else{
        return [NSString stringWithFormat:@"             Model                                                                                 Status"];
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
            header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        }
    }
    else{
        header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    }
    
    header.textLabel.textColor = [UIColor blackColor];
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

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Device *lDevice = [[Device alloc]init];
    lDevice = [mArrayOfDeviceForTable objectAtIndex:indexPath.row];
    cell.mLabelUser.text = lDevice.mDeviceModel;
    
    cell.mLabelDevice.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    cell.mLabelDevice.text = lDevice.mDeviceRegistrationNumber;
    
    if ([lDevice.mDeviceStatus isEqualToString:@"Free"]) {
        cell.mLabelCheckinDate.text = @"free";
        cell.mLabelCheckinTime.text = @"";
        cell.mLabelCheckoutDate.text  = @"";
        cell.mLabelCheckoutTime.text = @"";
    }
    else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
           cell.mLabelCheckinDate.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        }
        else{
            cell.mLabelCheckinDate.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        }
        cell.mLabelCheckinDate.text = @"Allocated to";
        cell.mLabelCheckinTime.text = lDevice.mDeviceCurrentUser;
        cell.mLabelCheckoutDate.text  = @"";
        cell.mLabelCheckoutTime.text = @"";
    }

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

#pragma Tableview delgate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *lDevice = [mArrayOfDeviceForTable objectAtIndex:indexPath.row];

    if ([lDevice.mDeviceStatus isEqualToString:@"Free"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertViewFree = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please go to admin and checkout this device" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertViewFree show];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertViewBusy = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"This device is allocated to %@. Do you want to notify %@ for this device?",lDevice.mDeviceCurrentUser,lDevice.mDeviceCurrentUser] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        mCurrentDeviceToken = lDevice.mDeviceToken;
            
            [alertViewBusy show];
        });
        
    }

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //send Push notification in background
        
        NSString *message= [NSString stringWithFormat:@"%@ has requested for this device",mUsername];
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, @"alert",
                              @"1", @"content-available",
                              @"request",@"type",
                              nil];
        PFPush *push = [[PFPush alloc] init];
        
        //NSError *error;
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"deviceToken"equalTo:mCurrentDeviceToken];
        [push setQuery:pushQuery];
        [push setData:data];
        [push sendPushInBackground];
        
        
        //Update request number
        PFQuery *query = [PFQuery queryWithClassName:@"Devices"];
        [query whereKey:@"deviceToken" equalTo:mCurrentDeviceToken];
        query.limit = 500;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if(objects.count!=0)
                {
                    PFObject *object = [objects objectAtIndex:0];
                    NSString *requestNumberString = [object valueForKey:@"requestNumber"];
                    int requestNumber = [requestNumberString intValue];
                    requestNumber++;
                    NSString *newRequestNumberString = [NSString stringWithFormat:@"%i",requestNumber];
                    [object setObject:newRequestNumberString forKey:@"requestNumber"];
                    
                        [object saveEventually:^(BOOL succeeded, NSError *error) {
                            
                        }];
                        
                }
            }
            }];
    }
    else
    {
        [alertView dismissWithClickedButtonIndex:1 animated:0];
    }
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
    return mPickerArray.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   
        return mPickerArray[row];

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([checkString isEqualToString:@"make"]) {
        mTextFieldDeviceMake.text = [mPickerArray objectAtIndex:row];
    }
  
    else if([checkString isEqualToString:@"model"]){
        mTextFieldDeviceModel.text = [mPickerArray objectAtIndex:row];
    }
  
    else if ([checkString isEqualToString:@"status"]){
        mTextFieldDeviceStatus.text = [mPickerArray objectAtIndex:row];
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
