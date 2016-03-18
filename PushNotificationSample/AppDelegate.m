//
//  AppDelegate.m
//  PushNotificationSample
//
//  Created by Subodh Parulekar on 11/20/14.
//  Copyright (c) 2014 afourtech. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize mDeviceToken;
@synthesize mCompanyName;

#define BUNDLEMINVERSION 2
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    // [Parse setApplicationId:@"your_application_id" clientKey:@"your_client_key"];
    // ****************************************************************************
    [Parse setApplicationId:@"WXB98ArNaxNeuuboZA27zk7QNtwdVeXytSYX4ZnE" clientKey:@"AbrsDp92fetE361u8Nomrr959lSivEHZc9pXGgOY"];
//    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
//                                                    UIUserNotificationTypeBadge |
//                                                    UIUserNotificationTypeSound);
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
//                                                                             categories:nil];
//    [application registerUserNotificationSettings:settings];
//    [application registerForRemoteNotifications];
//
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    [[UINavigationBar appearance]setTintColor:[UIColor colorWithRed:33.0 green:72.0 blue:112.0 alpha:1]];
    [[UINavigationBar appearance]setBarTintColor:[self colorWithHexString:@"#214870"]];
    
//    NSDictionary *remoteNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
//    if(remoteNotif)
//    {
//         [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
//    }
    
    
//    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
//        //[self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
//        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"launchOptions" message:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [errorAlertView show];
//    }

   
    
    return YES;
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    unsigned rgbValue = 0;
    NSScanner *scanner =[NSScanner scannerWithString:hex];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *token1 = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    mDeviceToken = token1;
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([userInfo objectForKey:@"type"])
    {
        // do something with job id
        NSString *lType = [userInfo objectForKey:@"type"];

    }
    [PFPush handlePush:userInfo];
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        if(!self.isTableViewCtrl)
        {
            
            UINavigationController *nav = (UINavigationController*)self.window.rootViewController;

            if([nav viewControllers].count ==1)
            {
                [nav popToRootViewControllerAnimated:YES];
            }
            else
            {
                TableViewController *notificationController = [[nav viewControllers]objectAtIndex:1];
                notificationController.mUsername = self.mUsername;
                //self.window.rootViewController = notificationController;
                [nav popToViewController:notificationController animated:YES];
            }
            
        }

       
    }
}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{

    app.applicationIconBadgeNumber = notif.applicationIconBadgeNumber -1;
    
    notif.soundName = UILocalNotificationDefaultSoundName;
    
    [self _showAlert:[NSString stringWithFormat:@"%@",@"Your time is up.Checkin the device or Extend the duration!!"]withTitle:@"Device Tracker"];
//    if ( app.applicationState == UIApplicationStateInactive || app.applicationState == UIApplicationStateBackground)
//    {
//        UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//        TableViewController *notificationController = [nav.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
//        
//        [nav pushViewController:notificationController animated:YES];
//        
//    }
    
}

- (void) _showAlert:(NSString*)pushmessage withTitle:(NSString*)title
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:title message:pushmessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];

}

//-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
//{
//    NSString *restorationBundleVersion = [coder decodeObjectForKey:UIApplicationStateRestorationBundleVersionKey];
//    if ([restorationBundleVersion integerValue] < BUNDLEMINVERSION)
//    {
//        NSLog(@"Ignoring restoration data for bundle version: %@",restorationBundleVersion);
//        return NO;
//    }
//    
//    // Retrieve the User Interface Idiom (iPhone or iPad) for the device that created the restoration Data.
//    // This allows us to ignore the restoration data when the user interface idiom that created the data
//    // does not match the current device user interface idiom.
//    
//    UIDevice *currentDevice = [UIDevice currentDevice];
//    UIUserInterfaceIdiom restorationInterfaceIdiom = [[coder decodeObjectForKey:UIApplicationStateRestorationUserInterfaceIdiomKey] integerValue];
//    UIUserInterfaceIdiom currentInterfaceIdiom = currentDevice.userInterfaceIdiom;
//    if (restorationInterfaceIdiom != currentInterfaceIdiom)
//    {
//        NSLog(@"Ignoring restoration data for interface idiom: %d",restorationInterfaceIdiom);
//        return NO;
//    }
//    
//    return YES;
//
//}
//
//-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
//{
//    return YES;
//}

-(UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return nil;
}

-(void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder
{
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if([[[nav visibleViewController]restorationIdentifier]isEqualToString:@"TableViewController"])
        {
            TableViewController *tblVC =(TableViewController*)[nav visibleViewController];
            [tblVC.mTimer invalidate];
        }
    
    
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    UINavigationController *nav = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if([[[nav visibleViewController]restorationIdentifier]isEqualToString:@"TableViewController"])
    {
        TableViewController *tblVC =(TableViewController*)[nav visibleViewController];
        [tblVC viewWillAppear:YES];
        self.isTableViewCtrl = YES;
    }
    else
    {
        self.isTableViewCtrl = NO;
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
