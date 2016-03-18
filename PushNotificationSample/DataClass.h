//
//  DataClass.h
//  PushNotificationSample
//
//  Created by Subodh Parulekar on 12/3/14.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject

@end

@interface Options : NSObject
@property NSString *mHeading;
@property NSString *mSubHeading;
@property NSString *mImageStr;

@end

@interface Device : NSObject
@property NSString *mDeviceId;
@property NSString *mDeviceToken;
@property NSString *mDeviceMake;
@property NSString *mDeviceModel;
@property NSString *mDeviceName;
@property NSString *mDeviceStatus;
@property NSString *mDeviceCurrentUser;
@property NSString *mDeviceVersion;
@property NSString *mDeviceRegistrationNumber;
@property NSString *mCompanyName;

@end 

@interface History : NSObject
@property NSString *mDeviceName;
@property NSDate *mDeviceCheckoutDate;
@property NSString *mDeviceCurrentUser;
@property NSString *mDeviceAction;
@property NSDate *mDeviceCheckinDate;
@property NSString *mObjectId;
@property NSString *mCompanyName;
@end
