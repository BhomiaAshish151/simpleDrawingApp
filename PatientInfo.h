//
//  PatientInfo.h
//  PhotoSmart
//
//  Created by Ashish Sharma on 29/05/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proAlertView.h"
#import "Global.h"
#import "Timeline.h"
@interface PatientInfo : UIViewController
{
    UIActivityIndicatorView * progress;
    proAlertView * mycustomAlertView;
    NSMutableArray *ImagesArray;
    Global *glblClass;
    IBOutlet UIImageView *imgView;
    UIImage *image;
    IBOutlet UITextField *nameTxtFld;
    IBOutlet UITextView *notesTxtView;
    IBOutlet UIButton *SendBtn;
    NSString *strGlobalId;
    NSData *imageData;
     CGFloat animatedDistance;
    UIToolbar *keyboardToolbar;
    UISegmentedControl *nextPreviousControl;
    UIAlertView *ErrorAlert;
    NSString *run;
}
@property(nonatomic,retain) NSMutableArray *ImagesArray;
-(IBAction)BackBtn:(id)sender;
-(IBAction)DoneBtn:(id)sender;
-(IBAction)SendBtn:(id)sender;
@property(nonatomic,retain)UIImage *image;
@end
