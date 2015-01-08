//
//  Timeline.m
//  PhotoSmart
//
//  Created by Ashish Sharma on 28/05/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import "Timeline.h"
#import "PhotoPaint.h"
#import "NSData+Base64.h"
#import "UIImage+Resize.h"

#import "UIImage+GIF.h"
#include <mach/mach_time.h>


//#import "SDWebImage/UIImageView+WebCache.h"


static uint64_t startTime;
void startRec(void);
void startRec() {
    startTime = mach_absolute_time();
}

uint64_t stopRec(BOOL log);
uint64_t stopRec(BOOL log) {
    uint64_t endTime = mach_absolute_time();
    
    uint64_t elapsedTime = endTime - startTime;
    if (log) {
        NSLog(@"Recorded Time:%llu", elapsedTime);
    }
    return elapsedTime;
}

@interface Timeline ()

@end
static uint64_t startTime;




@implementation Timeline
@synthesize  nameTxtFld,srchTodateStr,srchFromdateStr,loginClassString,pickerType,SearchNameStr,srcImage,searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        Search *obj=[[Search alloc]init];
//        obj.delegate=self;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    

}
- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden=YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    PhotoPaint *newclass;
       if (IS_IPHONE )
       {
           newclass=[[PhotoPaint alloc]initWithNibName:@"PhotoPaint" bundle:nil];
           UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
           newclass.CameraImage=outputImage;
           [self.navigationController pushViewController:newclass animated:YES];
       }
       else{
           UIImageView *imgview1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,468)];

           newclass=[[PhotoPaint alloc]initWithNibName:@"PhotoPaint_ipad" bundle:nil];
           
           self.srcImage = [info objectForKey:UIImagePickerControllerEditedImage];
           if (!self.srcImage) return;
           UIImage* scaledImgV = [self.srcImage resizedImageToFitInSize:imgview1.bounds.size scaleIfSmaller:NO];
           NSLog(@"Scaled image horizontal (%@), width: %.0f, height: %.0f, scale: %0.2f",scaledImgV,scaledImgV.size.width, scaledImgV.size.height, scaledImgV.scale);
           [imgview1 setImage:scaledImgV];
           
           
           newclass.CameraImage=scaledImgV;
           [self.navigationController pushViewController:newclass animated:YES];

           
           
           newclass=[[PhotoPaint alloc]initWithNibName:@"PhotoPaint_ipad" bundle:nil];
           
           

       }
   
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
      [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    [imageView setImage:[UIImage imageNamed:@"demo"]];
    [demoView addSubview:imageView];
    
    return demoView;
}
- (void)pickerDone:(id)sender
{
    [GenderactionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)AddBtn:(id)sender{
    
    [self showGrid];

}

- (void)showGrid {
    loginClassString=@"PhotoPaint";
    if (IS_IPHONE )
    {
        NSInteger numberOfOptions = 2;
        NSArray *items = @[
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera-ipad"] title:@"Camera"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"gallery 5"] title:@"Gallery"]
                           ];
        
        RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
        av.delegate = self;
        //    av.bounces = NO;
        [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];  }
    else
    {
        
        
        
        NSInteger numberOfOptions = 2;
        NSArray *items = @[
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"camera-ipad"] title:@"Camera"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"gallery-ipad"] title:@"Gallery"]
                           ];
        
        RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
        av.delegate = self;
        //    av.bounces = NO;
        [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
    }

    
    
    
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %ld: %@", (long)itemIndex, item.title);
    if ([item.title isEqualToString:@"Camera"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            
            //  [self presentModalViewController:imagePicker animated:YES];
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                           message:@"Unable to find a camera on your device."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        }
 
    }
    else if ([item.title isEqualToString:@"Gallery"])
    {
        if([UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            imgPicker.delegate = self;
            imgPicker.allowsEditing = YES;
            [self presentViewController:imgPicker animated:YES completion:NULL];
        }
 
    }
    else if ([item.title isEqualToString:@"Logout"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"strGlobalId1"];
       
        [defaults removeObjectForKey:@"rember"];
        [defaults removeObjectForKey:@"iddddd"];
        [defaults removeObjectForKey:@"RememberMeBool"];
       
            }

    else if ([item.title isEqualToString:@"Settings"])
    {
        
        
    }
    
  
    

}











@end
