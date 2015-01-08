//
//  Global.m
//  timePassOfTIR
//
//  Created by pankaj tak on 05/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Global.h"

@implementation Global
{
    //
}
NSMutableArray *arrayForImages;
NSString *web_service=@"";
NSString *GlobalDeviceId=@"";
NSString  *userNameGlobal=@"";
NSString *emailGlobal=@"";
int GlobalReplyScreenId;
int GlobalReplyCategoryId;
NSString *GlobalReplySreen=@"";
-(id)init
{
    self = [super init];
    if ( self ) {
        [self FillMessages];
        //Initialization code here
    }
    return self;
}
//http://beautypalacejewellers.com/mystrygramc
//NSString *const web_service = @"http://192.168.100.113/PhotoSmart/photosmart.php?";


//NSString *const newweb_service = @"http://192.168.0.105/mystrygram/webservices/";
//NSString *const web_service =@"http://192.168.0.105/mystrygram/webservices/";
//NSString *const IMAGEWebService = @"http://192.168.0.105/mystrygram/";
-(void)FillMessages
{
    msgDict = [[NSMutableDictionary alloc] init];
    [msgDict setObject:@"Photo Smart" forKey:@"title"];
    [msgDict setObject:@"No internet connection found. Please try again later.." forKey:@"internet_connection"];
    //==LOGIN PAGE====
    [msgDict setObject:@"Either email ID or password is missing." forKey:@"login_message"];
    [msgDict setObject:@"Please enter valid email ID." forKey:@"validemail_message"];
    [msgDict setObject:@"Either email ID is invalid or password is wrong." forKey:@"wrongemailpassword"];
   [msgDict setObject:@"Login Sucessfully" forKey:@"Sucess"];
    //REGISTRATION PAGE
    [msgDict setObject:@"Select your gender." forKey:@"gender_message"];
    [msgDict setObject:@"Date Of Birth can not be left blank." forKey:@"dateofbirth_message"];
    [msgDict setObject:@"Name can not be left blank." forKey:@"name_message"];
    [msgDict setObject:@"Email ID can not be left blank." forKey:@"email_message"];
    [msgDict setObject:@"Select atleast one category." forKey:@"category_message"];
    [msgDict setObject:@"Password can not be left blank." forKey:@"password_message"];
    [msgDict setObject:@"Confirm password can not be left blank." forKey:@"conpassword_message"];
    [msgDict setObject:@"Password does not match." forKey:@"matchpassword_message"];
    [msgDict setObject:@"Congratulations! You have registered successfully." forKey:@"registrationcorrect"];
    [msgDict setObject:@"Sorry your age should be more than 18 to show interest in such categories." forKey:@"PrivateCategory"];
    [msgDict setObject:@"Sorry ! emailID already exist." forKey:@"registrationwrong"];
    [msgDict setObject:@"Sorry ! emailID not exist." forKey:@"emailwrong"];
    [msgDict setObject:@"Error in processing request. Please try again later." forKey:@"registrationfaild"];
    //FORGOT PASSWORD PAGE===
    //[msgDict setObject:@"Forgetpassword can not be blank" forKey:@"forgetpassword_message"];
    [msgDict setObject:@"Sorry there is no user registered with given email ID." forKey:@"FORGOTWRONGMESSAGE"];
    [msgDict setObject:@"Kindly check your email, we have sent password there." forKey:@"FORGOTCORRECTMESSAGE"];
     [msgDict setObject:@"please select your security answer" forKey:@"Answer"];
    [msgDict setObject:@"Old Password does not Exists." forKey:@"OldPasswordWrong"];
}
-(NSString *)GetMessage: (NSString *) msgKey{
    NSString * msg =  @"";
    msg = [msgDict objectForKey:msgKey];
    NSLog(@"%@",msgKey);
    NSLog(@"%@",msg);
    return msg;
}
 int globalId;
 int FinalDeviceId;


@end
