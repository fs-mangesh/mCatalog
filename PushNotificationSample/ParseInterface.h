//
//  ParseInterface.h
//  PushNotificationSample
//
//  Created by Subodh Parulekar on 11/27/14.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "DataClass.h"
#import <sys/sysctl.h>

@protocol ParseInterfaceDelegate <NSObject>

@required
-(void)getCurrentLOcation:(CLLocation *)currLocation;
-(void)didEnterGeofencedRegion:(CLRegion *)gRegion;
-(void)didLeaveGeofencedRegion:(CLRegion *)gRegion;
@end

@interface ParseInterface : NSObject<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
{
    
}
//properties
@property(nonatomic, assign)id<ParseInterfaceDelegate> parseDelegate;
@property(nonatomic,retain) NSString *mRegistrartionNumber;
@property(nonatomic,strong) NSDictionary *responseDictionary;
@property(nonatomic,strong) NSString *mDeviceNameMax;
@property(nonatomic,strong) NSString *mDeviceNameMin;
@property(nonatomic,strong) NSMutableArray *mArrayOfCheckoutDevice;
@property(nonatomic,strong) NSMutableArray *mArrayOfCheckoutHours;
@property(nonatomic,strong) NSMutableArray *mArrayOfRequestedDevice;

//methods
+ (ParseInterface*) sharedInstance;
-(NSArray*)getAllRowsForTable:(NSString*)tableName;
-(void)checkoutCurrentDevice:(NSString*)username duration:(NSDate*)date :(NSString *)hours;
-(NSMutableArray*)searchDevices:(NSString*)make;
-(void)addTransactionToHistory:(NSString*)username action:(NSString*)action;
-(void)retainCurrrentDevice:(NSString*)str;
-(void)extendCurrentDeviceDuration:(NSString*)duration user:(NSString*)username;
-(NSMutableArray*)searchDeviceHistory:(NSString*)name;
-(void)registerThisDevice:(NSString*)deviceRegistrationNo username:(NSString*)username;
-(NSMutableArray*)searchDateHistory:(NSString*)date;

- (void)sendData :(NSDate *)from :(NSDate *)to  completion:(void (^)(NSMutableArray *))completion ;
- (void)sendDataHours :(NSDate *)from :(NSDate *)to  completion:(void (^)(NSMutableArray *))completion;
- (void)sendDataRequest :(NSDate *)from :(NSDate *)to completion:(void (^)(NSMutableArray *))completion;
-(NSString *)getInventoryUtilization;
-(NSMutableArray *)getMostCheckedoutDevices;
-(NSMutableArray *)getMostRequestedDevices;
@end
