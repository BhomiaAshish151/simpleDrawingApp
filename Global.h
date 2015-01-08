//
//  Global.h
//  timePassOfTIR
//
//  Created by pankaj tak on 05/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
NSString *GlobalDevice;

@interface Global : NSObject
{
    NSMutableDictionary *msgDict;
}
extern NSMutableArray *arrayForImages;
extern NSString *GlobalDevice;
extern int globalId;
extern int FinalDeviceId;
extern NSString *web_service;
extern NSString *gobal_ename;
extern NSString *GlobalDeviceId;
extern int GlobalReplyScreenId;
extern int GlobalReplyCategoryId;
extern NSString *GlobalReplySreen;
extern NSString *userNameGlobal;
extern NSString *emailGlobal;
//FOUNDATION_EXPORT NSString *const newweb_service;
// FOUNDATION_EXPORT NSString *const web_service;
// FOUNDATION_EXPORT NSString *const IMAGEWebService;
-(void)FillMessages;
-(NSString *)GetMessage: (NSString *) msgKey;

@end
