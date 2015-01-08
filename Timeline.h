//
//  Timeline.h
//  PhotoSmart
//
//  Created by Ashish Sharma on 28/05/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import "Global.h"

#import "proAlertView.h"
#import "ASIHTTPRequest.h"
#import "Patient_Detail.h"

@interface Timeline : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,
UISearchBarDelegate,UISearchDisplayDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,ASIHTTPRequestDelegate,UIActionSheetDelegate,RNGridMenuDelegate>
{
    UIToolbar *keyboardToolbar;
    UISegmentedControl *nextPreviousControl;
     BOOL select;
    UIActivityIndicatorView * progress;
    proAlertView * mycustomAlertView;
    IBOutlet UIButton *AddBtn,*optionBtn;
    UIImage* srcImage;
     NSData *dataImage;
    Global *glblClass;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *table;
    NSMutableArray *PaitientImgAry,*PatientRecordAry;
    NSString *strGlobalId,*Title;
    IBOutlet UIButton *LogoutBtn,*CameraBtn,*GalleryBtn,*FromBtn,*ToBtn,*nameBtn;
    NSString *SearchNameStr,*srchTodateStr,*srchFromdateStr,*pickerType;
    IBOutlet UITextField *nameTxtFld;
    UIActionSheet *GenderactionSheet,*sheet,*Optionsheet;
    NSString *DEVICEID1;
    IBOutlet UIButton *OptionBtn;
    NSString *run;
    
    
    
    UIAlertView* ErrorAlert;
    IBOutlet UITextField *txt;
    
    
    ASIHTTPRequest *httpRequest;
}
-(IBAction)CleanData:(id)sender;
@property(nonatomic,retain)UIPopoverController *myPopover;
@property(nonatomic,retain)NSString *loginClassString;
@property(nonatomic,retain) IBOutlet UITextField *nameTxtFld;
@property(nonatomic,retain)   NSDateFormatter *dateFormatter;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) UIImage* srcImage;
@property(nonatomic,retain)  NSString *SearchNameStr,*srchTodateStr,*srchFromdateStr,*pickerType;
@property (nonatomic, strong) UISegmentedControl *SegmentedControl;
@property (nonatomic, retain) UISearchDisplayController	*retainedSearchDisplayController;

-(IBAction)AddBtn:(id)sender;
-(IBAction)OptionBtn:(id)sender;
-(IBAction)SearchBtn:(id)sender;
@end
