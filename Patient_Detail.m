//
//  Patient_Detail.m
//  PhotoSmart
//
//  Created by Ashish Sharma on 04/06/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import "Patient_Detail.h"
#import "UIImage+GIF.h"
#include <mach/mach_time.h>
//#import "SDWebImageManager.h"

@interface Patient_Detail ()<UIViewControllerTransitioningDelegate>

@end

@implementation Patient_Detail
@synthesize PatientNameStr,notesStr,imageStr,IDStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // Here You can do additional code or task instead of writing with keyboard
    return NO;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
      return NO;
}
-(void)viewWillAppear:(BOOL)animated
{
      imagePopOverView.hidden = YES;
    
    scrollImageView.contentSize = imgSelected.frame.size;
    scrollImageView.minimumZoomScale = scrollImageView.frame.size.width / imgSelected.frame.size.width;
	scrollImageView.maximumZoomScale = 2.0;
	[scrollImageView setZoomScale:scrollImageView.minimumZoomScale];
    
    
    UITapGestureRecognizer *tapZoomedImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnZoomedImage:)];
    [imgSelected addGestureRecognizer:tapZoomedImage];
    imgSelected.userInteractionEnabled = YES;
    tapZoomedImage.numberOfTapsRequired = 2;
    
	//imgContainerMain = scrollImageView;
    imgSelected.userInteractionEnabled = YES;
  
}
- (void)tapOnZoomedImage:(UITapGestureRecognizer *)gestureRecognizer
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(cancelAnimationStopped:finished:context:)];
    CGAffineTransform transform = CGAffineTransformMakeScale(0.0, 0.0);
    imagePopOverView.transform = transform;
    imagePopOverView.hidden = YES;
    
    [UIView commitAnimations];
}






- (void)viewDidLoad
{
    
   
  
    displyLbl.backgroundColor=[UIColor colorWithWhite:.1 alpha:.3];
    
    
        NSLog(@"nameStr=%@",PatientNameStr);
     NSLog(@"IDStr=%@",IDStr);
     NSLog(@"notesStr=%@",notesStr);
    nameTxtFld.text=PatientNameStr;
    if ([notesStr isEqualToString:@""]) {
        notesTxtView.text=@"Notes";
    }
    else
    {
    notesTxtView.text=notesStr;
    }
    
    
    NSString* getImgMethod=@"method=getImageData&patienthistoryID=%@";
    
    NSString *getImgWebService=[NSString stringWithFormat:@"%@%@",web_service ,getImgMethod];
   
    NSString *urlStr=[NSString stringWithFormat:getImgWebService,IDStr];
    NSLog(@"urlStr=%@",urlStr);
    
    // urlStr=[urlStr stringByReplacingOccurrencesOfString:@" " withString:@"__"];
    
    UIImage* images ;
    if (IS_IPHONE) {
        images = [UIImage animatedGIFNamed:@"loading40"];
    }
    else
    {
        images = [UIImage animatedGIFNamed:@"loading40"];
    }

    // [ProfilePhoto setImageWithURL:[NSURL URLWithString:urlStr]
    // placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    imgView.userInteractionEnabled=YES;
//    imgView setContentMode:UIViewContentModeScaleToFill
    
    UITapGestureRecognizer *UsrImgtapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)];
    UsrImgtapped.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:UsrImgtapped];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)BackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)DoneBtn:(id)sender{
    NoFriendsFoundAlert = [[UIAlertView alloc] initWithTitle:@"Photo Smart"
                                                     message:@"Are you sure to delete this photo?"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:@"Cancel",nil];
    
    [NoFriendsFoundAlert show];
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if(alertView == NoFriendsFoundAlert)
    {
        if(buttonIndex == 0)
            
        {
            NSString* getImgMethod=@"method=ImageDelete&patienthistoryID=%@";
            
            NSString *getImgWebService=[NSString stringWithFormat:@"%@%@",web_service ,getImgMethod];
            
            NSString *urlStr=[NSString stringWithFormat:getImgWebService,IDStr];
            NSLog(@"urlStr=%@",urlStr);
             [self calldelete:urlStr];
        }
    }
}
-(void)calldelete:(NSString *)passURL

{
    dispatch_async( kBgQueue, ^{
        NSURL *url=[NSURL URLWithString:[passURL  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //NSLog(@"hhh    %@",url);
        NSData *data=[NSData dataWithContentsOfURL:url];
        if (data!=NULL)
        {
            [self performSelectorOnMainThread:@selector(fetchNewsFeedReply:)
                                   withObject:data waitUntilDone:YES];
        }
        else
        {
            
            //msg=internet_connection;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SELFIEGAME" message:@"No internet connection found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                //Show alert here
                [alert show];
            });
            
        }
        
    });
    
}

- (void)fetchNewsFeedReply:(NSData *)responseData {
    //parse out the json data
    
    //NSLog(@"1111111111");
    NSError* error;
    NSDictionary* jsonUsers = [NSJSONSerialization
                               JSONObjectWithData:responseData //1
                               
                               options:kNilOptions
                               error:&error];
    
    NSLog(@"jsonUsersfriends%@",jsonUsers);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
