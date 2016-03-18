//
//  TableViewController.h
//  TestBaasApp
//
//  Created by Subodh Parulekar on 11/26/14.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseInterface.h"
#import "DataClass.h"
@interface TableViewController : UITableViewController<NSURLSessionDelegate>
{

}

@property (nonatomic,strong) NSMutableArray *mAllFetchedObjectsArray;

@property (nonatomic,strong) NSDictionary *mDictCurrentStatus;
@property (nonatomic,strong) NSString *mUser;
@property (nonatomic,strong) NSString *mUsername;
@property (nonatomic,strong) UILabel *lblTitle;

@property (nonatomic,strong) NSDate *mExpectedCheckinDate;

@property BOOL mIsAdmin;
@property BOOL mIsManager;
@property BOOL mIsCheckedOut;
@property NSTimer *mTimer;
@property (strong , nonatomic) UILabel *lblNavigationTitle;

@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong,nonatomic) NSString *mCurrDeviceModel;
@end
