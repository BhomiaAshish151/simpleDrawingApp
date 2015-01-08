//
//  AppDelegate.h
//  PhotoSmart
//
//  Created by Ashish Sharma on 27/05/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timeline.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>
{
    UINavigationController *nav;
    Timeline *loginClass;
    NSString *FinelDeviceId;
    
}
@property (strong, nonatomic)  NSString *FinelDeviceId;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)UINavigationController *nav;
@property(nonatomic,retain)Timeline *loginClass;
@end

