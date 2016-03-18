//
//  TableViewCell.h
//  PushNotificationSample
//
//  Created by afour on 2014-11-27.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mLabelHeading;
@property (weak, nonatomic) IBOutlet UILabel *mLabelSubHeading;

@end
