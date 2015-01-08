//
//  Patient_Detail.h
//  PhotoSmart
//
//  Created by Ashish Sharma on 04/06/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "ASIHTTPRequest.h"
//#import "SDWebImage/UIImageView+WebCache.h"
@interface Patient_Detail : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>
{
    Global *glblClass;
    IBOutlet UIImageView *imgView;
    UIImage *image,*ZoomImage;
    IBOutlet UITextField *nameTxtFld;
    IBOutlet UITextView *notesTxtView;
    IBOutlet UIButton *SendBtn;
    IBOutlet UILabel *displyLbl;
    NSString *PatientNameStr,*notesStr,*imageStr,*IDStr;
   IBOutlet UIView *imagePopOverView;
    IBOutlet UIScrollView *scrollImageView;
    IBOutlet UIImageView *imgSelected;
    UIAlertView *NoFriendsFoundAlert;
    NSMutableArray *ZoomurlStr;
}
@property(nonatomic,retain) NSString *PatientNameStr,*notesStr,*imageStr,*IDStr;
-(IBAction)BackBtn:(id)sender;
-(IBAction)DoneBtn:(id)sender;
-(IBAction)SendBtn:(id)sender;
@property(nonatomic,retain)UIImage *image;
@end
