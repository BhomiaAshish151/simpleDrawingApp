//
//  AppDelegate.m
//  PhotoSmart
//
//  Created by Ashish Sharma on 27/05/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h";

@interface AppDelegate ()
#pragma mark Properties
@property(nonatomic, retain) NSString *deviceToken, *payload, *certificate;
@end

@implementation AppDelegate
@synthesize nav,loginClass,FinelDeviceId;

- (id)init {
	self = [super init];
	if(self != nil) {
		self.deviceToken = @"";
		self.payload = @"{\"aps\":{\"alert\":\"This is some fancy message.\",\"badge\":1}}";
		self.certificate = [[NSBundle mainBundle] pathForResource:@"apns" ofType:@"cer"];
	}
	return self;
}
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"remote notification: %@",[userInfo description]);
//
//    NSString *contentsInfo = [userInfo objectForKey:@"contTag"];
//    NSLog(@"Received contents info : %@", contentsInfo);
//
//    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
//
//    NSString *alert = [apsInfo objectForKey:@"alert"];
//    NSLog(@"Received Push Alert: %@", alert);
//
//    NSString *sound = [apsInfo objectForKey:@"sound"];
//    NSLog(@"Received Push Sound: %@", sound);
//
//    if (application.applicationState == UIApplicationStateActive)
//
//    {
//
//    }
//    else
//    {
//       }
//}
//-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//
//    NSString *str_device = [NSString
//                            stringWithFormat:@"%@",deviceToken];
//    NSLog(@"str_device%@",str_device);
//    NSString * search = [str_device stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString * devicestr = [search stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    NSString * devicestr1 = [devicestr stringByReplacingOccurrencesOfString:@">" withString:@""];
//    //    NSString *trimmedDeviceToken = [str_device stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    // int intLoginId = [devicestr1 intValue];
//    NSLog(@"devicestr1%@",devicestr1);
//    //     int LoginId = [devicestr1 intValue];
//    GlobalDevice=devicestr1;
//    NSLog(@"GlobalDevice%@",GlobalDevice);
//    GlobalDevice = [[NSString alloc] initWithFormat: devicestr1, 7];
//    NSLog(@"GlobalDevice%@",GlobalDevice);
//    FinelDeviceId=GlobalDevice;
//     NSLog(@"FinelDeviceIdApp%@",FinelDeviceId);
//
//}
//

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    
    if (IS_IPHONE )
    {
        loginClass=[[Timeline alloc]initWithNibName:@"Timeline" bundle:nil];
    }
    else
    {
        loginClass=[[Timeline alloc]initWithNibName:@"Timeline_ipad" bundle:nil];
    }
    
    
    nav=[[UINavigationController alloc]initWithRootViewController:loginClass];
    [self.window addSubview:nav.view];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];
    
    
    
    
    
    NSLog(@"Registering for push notifications...");
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    NSDictionary* userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    NSString *params=[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"];
    NSLog(@"params%@",params);
    
    if ([params length] > 0 ) {//app launch when VIEW button of push notification clicked
        
        //do some processing
        //
        //        masterViewController *masterViewClass =
        //        [[masterViewController alloc] initWithNibName:@"masterViewController" bundle:[NSBundle    mainBundle]];
        //        // Put your custom code
        //
        //
        //        [[self navigationController ] pushViewController:masterViewClass animated:YES];
        //        [_window addSubview:masterViewClass.view];
        //        [masterViewClass release];
    }
    
    NSString *alertMsg = @"";
    NSString *badge = @"";
    NSString *sound = @"";
    
    if( [apsInfo objectForKey:@"alert"] != NULL)
    {
        alertMsg = [apsInfo objectForKey:@"alert"];
    }
    
    
    if( [apsInfo objectForKey:@"badge"] != NULL)
    {
        badge = [apsInfo objectForKey:@"badge"];
    }
    
    
    if( [apsInfo objectForKey:@"sound"] != NULL)
    {
        sound = [apsInfo objectForKey:@"sound"];
    }
    
    if (    ! [alertMsg isEqualToString:@""] ||
        ! [badge isEqualToString:@""]  ||
        ! [sound isEqualToString:@""]
        )
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Smart"
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
