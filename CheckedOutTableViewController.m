//
//  CheckedOutTableViewController.m
//  PushNotificationSample
//
//  Created by afour on 2014-11-28.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import "CheckedOutTableViewController.h"
#import "TableViewCell.h"

@interface CheckedOutTableViewController ()

@end

@implementation CheckedOutTableViewController
@synthesize mArrayOfHeading,mArrayOfSubHeading,mArrayOfImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    mArrayOfHeading = [[NSMutableArray alloc]init];
    mArrayOfSubHeading = [[NSMutableArray alloc]init];
    mArrayOfImages = [[NSMutableArray alloc]init];
    
        //arrOfHeading
    [mArrayOfHeading addObject:@"CheckIn"];
    [mArrayOfHeading addObject:@"Extend"];
    [mArrayOfHeading addObject:@"Retain"];
    [mArrayOfHeading addObject:@"Search"];
        
        //array of subheading
        
    [mArrayOfSubHeading addObject:@"This device"];
    [mArrayOfSubHeading addObject:@"This device"];
    [mArrayOfSubHeading addObject:@"This device"];
    [mArrayOfSubHeading addObject:@"For a device"];
        
        //array of images
        
    [mArrayOfImages addObject:@"checkin.png"];
    [mArrayOfImages addObject:@"extend.png"];
    [mArrayOfImages addObject:@"retain.png"];
    [mArrayOfImages addObject:@"search.png"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return mArrayOfHeading.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //using table view cell which is created dynamically
    static NSString *simpleTableIdentifier = @"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //    PFObject *obj1 = [mAllFetchedObjectsArray objectAtIndex:indexPath.row];
    //    // Configure the cell...
    
    cell.mLabelHeading.text = [mArrayOfHeading objectAtIndex:indexPath.row];
    cell.mLabelSubHeading.text = [mArrayOfSubHeading objectAtIndex:indexPath.row];
    cell.mImageView.image = [UIImage imageNamed:[mArrayOfImages objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //setting height of row according to number of options and screenHeight
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    return ((screenHeight-154)/3);

}
@end
