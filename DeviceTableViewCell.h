//
//  DeviceTableViewCell.h
//  PushNotificationSample
//
//  Created by afour on 2014-12-09.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mLabelUser;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCheckoutDate;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCheckoutTime;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCheckinDate;
@property (weak, nonatomic) IBOutlet UILabel *mLabelCheckinTime;
@property (weak, nonatomic) IBOutlet UILabel *mLabelDevice;

@end
