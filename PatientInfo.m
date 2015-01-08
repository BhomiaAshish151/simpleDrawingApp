//
//  PatientInfo.m
//  PhotoSmart
//
//  Created by Ashish Sharma on 29/05/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
#import "PatientInfo.h"

#import "ASIFormDataRequest.h"


@interface PatientInfo ()

@end

@implementation PatientInfo
@synthesize image,ImagesArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)showAlertforwait
{
     progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 80, 30, 30)];
    progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    mycustomAlertView= [[proAlertView alloc]initWithTitle:@"Photo Smart" message:@"Please wait ..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	[mycustomAlertView addSubview:progress];
    [progress startAnimating];
    [mycustomAlertView show];
    
}
-(void) textViewDidBeginEditing:(UITextView *)textView {
    
  //  ;
    if ([notesTxtView.text isEqualToString:@" Notes"]) {
        
        notesTxtView.text = @"";
    }
    notesTxtView.textColor = [UIColor blackColor];
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
    }else{
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == nameTxtFld) {
        [nameTxtFld resignFirstResponder];
    }
    return NO;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
   if (notesTxtView.text.length == 0)  {
        
        // Disable More Button
        notesTxtView.text = @" Notes";
        notesTxtView.textColor=[UIColor lightGrayColor];
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    CGRect textFieldRect = [self.view.window convertRect:nameTxtFld.bounds fromView:nameTxtFld];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
    }else{
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}-(IBAction)DoneBtn:(id)sender{
    [nameTxtFld resignFirstResponder];
    [notesTxtView resignFirstResponder];
}
- (void)viewDidLoad
{
    NSLog(@"ImagesArray%@",ImagesArray);
    if ([ImagesArray count]==0) {
        ImagesArray =[[NSMutableArray alloc]init];
    }
//
   //  GlobalDevice=@"b7c8a2e25996a406d3492208962f044fd6632f6398892795833a109215bc8504";
    self.navigationController.navigationBarHidden=YES;
     //self.navigationController.navigationBar.topItem.title = @"";
    [imgView setImage:image];
    glblClass=[[Global alloc]init];
    strGlobalId = [NSString stringWithFormat:@"%d", globalId];
    NSLog(@"strGlobalId=%@",strGlobalId);
    if (keyboardToolbar==nil) {
        keyboardToolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        [keyboardToolbar setBackgroundColor:[UIColor blueColor]];
        [[UIBarButtonItem appearance] setTintColor:[UIColor darkGrayColor]];
        UIBarButtonItem *extraSpaces=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *DoneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneBtn:)];
        [keyboardToolbar setItems:[[NSArray alloc]initWithObjects:extraSpaces,DoneButton,nil]];
        
    }
    notesTxtView.inputAccessoryView=keyboardToolbar;
    nameTxtFld.inputAccessoryView=keyboardToolbar;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if([text isEqualToString:@"\n"])
//        [textView resignFirstResponder];
//    return YES;
//}

 

- (void)uploadRequestFinished:(ASIHTTPRequest *)request{
   [mycustomAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    NSLog(@"registerFinished %@",[request responseString]);
    NSLog(@"responseData %@",[request responseData]);
    
    NSString *statusMessage = [request responseString];
    NSLog(@"statusMessage%@",statusMessage);
    NSDictionary *dic_data=[[NSDictionary alloc]init];
    NSError* error;
    dic_data = [NSJSONSerialization
                JSONObjectWithData:[request responseData]
                
                options:kNilOptions
                error:&error];
    NSLog(@"dic_data %@",dic_data);
    NSString *Response=[NSString stringWithFormat:@"%@",[dic_data objectForKey:@"statusId"]];
    NSLog(@"Response=%@",Response);
    
    if ([Response isEqualToString:@"200"]) {
        Timeline *newclass;
          if (IS_IPHONE) {
                  newclass=[[Timeline alloc]initWithNibName:@"Timeline" bundle:nil];
          }
          else{
               newclass=[[Timeline alloc]initWithNibName:@"Timeline_ipad" bundle:nil];
          }
     
        [self.navigationController pushViewController:newclass animated:YES];

        
    }
  else  if ([Response isEqualToString: @"500"]) {
        
        ErrorAlert = [[UIAlertView alloc] initWithTitle:@"Photo Smart" message:@"Your session has been expired, please login again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [ErrorAlert show];
    }
  else  if ([Response isEqualToString: @"203"]) {
      
     
      
      UIAlertView*  alert =[[UIAlertView alloc]initWithTitle:@"Photo Smart"
                                                     message:@"Name already exist."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil,nil];
      [alert show];
  }
   else
    {
        UIAlertView*  alert =[[UIAlertView alloc]initWithTitle:@"Photo Smart"
                                                       message:@"Process failed."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil,nil];
		[alert show];

    }
    }
-(IBAction)BackBtn:(id)sender{
      [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
