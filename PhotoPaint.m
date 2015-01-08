//
//  PhotoPaint.m
//  PhotoSmart
//
//  Created by Ashish Sharma on 29/05/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//

#import "PhotoPaint.h"
#import "ACEDrawingView.h"
#import <QuartzCore/QuartzCore.h>
#import "InfColorPicker.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
#define kActionSheetColor       100
#define kActionSheetTool        101
#define COLOR_COMPONENT_RED_INDEX 0
#define COLOR_COMPONENT_GREEN_INDEX 1
#define COLOR_COMPONENT_BLUE_INDEX 2
@interface PhotoPaint ()<UIActionSheetDelegate, ACEDrawingViewDelegate>

@end

@implementation PhotoPaint
@synthesize CameraImage,TempArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    self.drawingView.lineWidth = 5;
     //GlobalDevice=@"b7c8a2e25996a406d3492208962f044fd6632f6398892795833a109215bc8504";
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=TRUE;
     [imgView setImage:CameraImage];
    // set the delegate
    self.drawingView.delegate = self;
//    self.drawingView.backgroundColor = [UIColor colorWithPatternImage:CameraImage];
   
    // start with a black pen
//    self.lineWidthSlider.value = self.drawingView.lineWidth;
    
    // init the preview image
    self.previewImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.previewImageView.layer.borderWidth = 2.0f;
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 4.0;
    opacity = 1.0;
    
    
    UILongPressGestureRecognizer *gestureSmall = [[UILongPressGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(myButtonPressed:)];
    // you can control how many seconds before the gesture is recognized
    gestureSmall.minimumPressDuration = .60f;
    // attach the gesture to your button
    [self.view addGestureRecognizer:gestureSmall];
    
    
    

}
- (void) myButtonPressed:(UILongPressGestureRecognizer *)gestureSmall


{
    
    if (gestureSmall.state == UIGestureRecognizerStateEnded) {
        //NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
    }
    else if (gestureSmall.state == UIGestureRecognizerStateBegan){
        self.drawingView.drawTool = ACEDrawingToolTypeText;
        
        [self.drawingView touchesMoved];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerCalled) userInfo:nil repeats:NO];
    }

   
    
}
-(void)timerCalled
{
   self.drawingView.drawTool = ACEDrawingToolTypePen;
    // Your Code
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    self.drawingView.drawTool = ACEDrawingToolTypePen;
   
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)commitAndHideTextEntry {
    [commentText resignFirstResponder];
    [commentText setEditable:NO];
       commentText.layer.borderColor = [UIColor clearColor].CGColor;
   
   commentText = nil;
}
-(void)resizeTextViewFrame: (CGPoint)adjustedSize {
    
    int minimumAllowedHeight = commentText.font.pointSize * 2;
    int minimumAllowedWidth = commentText.font.pointSize * 0.5;
    
    CGRect frame = commentText.frame;
    
    //adjust height
    int adjustedHeight = adjustedSize.y - commentText.frame.origin.y;
    if (adjustedHeight > minimumAllowedHeight) {
        frame.size.height = adjustedHeight;
    }
    
    //adjust width
    int adjustedWidth = adjustedSize.x - commentText.frame.origin.x;
    if (adjustedWidth > minimumAllowedWidth) {
        frame.size.width = adjustedWidth;
    }
    
    frame = [self adjustFrameToFitWithinDrawingBounds:frame];
    commentText.frame = frame;
}
- (CGRect)adjustFrameToFitWithinDrawingBounds: (CGRect)frame {
    
    //check that the frame does not go beyond bounds of parent view
    if ((frame.origin.x + frame.size.width) > self.view.frame.size.width) {
        frame.size.width = self.view.frame.size.width - frame.origin.x;
    }
    if ((frame.origin.y + frame.size.height) > self.view.frame.size.height) {
        frame.size.height = self.view.frame.size.height - frame.origin.y;
    }
    return frame;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self commitAndHideTextEntry];
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
#pragma mark - Actions

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}

- (IBAction)takeScreenshot:(id)sender
{
//    CGRect grabRect = CGRectMake(0,100,320,400);
    self.lineAlphaSlider.hidden = YES;
    self.lineWidthSlider.hidden = YES;
    CGRect grabRect = imgView.frame;
    //for retina displays
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
       UIGraphicsBeginImageContextWithOptions(grabRect.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(grabRect.size);
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -grabRect.origin.x, -grabRect.origin.y);
    [self.view.layer renderInContext:ctx];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    PatientInfo *newclass;
    if (IS_IPHONE ){
        newclass=[[PatientInfo alloc]initWithNibName:@"PatientInfo" bundle:Nil];
    }
    else{
        newclass=[[PatientInfo alloc]initWithNibName:@"PatientInfo_ipad" bundle:Nil];
    }
    newclass.image=viewImage;
    newclass.ImagesArray=TempArr;
    [self.navigationController pushViewController:newclass animated:YES];
}
- (IBAction)MoreBtn:(id)sender
{
    self.lineAlphaSlider.hidden = YES;
    self.lineWidthSlider.hidden = YES;
    
    [self showGridReundo];
    
        }

- (void)showGridReundo {
    if (IS_IPHONE )
    {
       
        [colorChange setImage:[UIImage imageNamed:@"color-1.png"] forState:UIControlStateNormal];
        [toolChange setImage:[UIImage imageNamed:@"pen-1.png"] forState:UIControlStateNormal];
        [toggleWidthSlider setImage:[UIImage imageNamed:@"width-1.png"] forState:UIControlStateNormal];
        [toggleAlphaSlider setImage:[UIImage imageNamed:@"alpha-1.png"] forState:UIControlStateNormal];
        NSInteger numberOfOptions = 3;
        NSArray *items = @[
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"undo"] title:@"Undo"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"redo"] title:@"Redo"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"006767-3d-transparent-glass-icon-arrows-arrows-rotated"] title:@"Clear"]];
                           
        RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
        av.delegate = self;
        //    av.bounces = NO;
        [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];   }
    else
    {
      
        [colorChange setImage:[UIImage imageNamed:@"color-ipad.png"] forState:UIControlStateNormal];
        [toolChange setImage:[UIImage imageNamed:@"pen-ipad.png"] forState:UIControlStateNormal];
        [toggleWidthSlider setImage:[UIImage imageNamed:@"width-ipad.png"] forState:UIControlStateNormal];
        [toggleAlphaSlider setImage:[UIImage imageNamed:@"alpha-ipad.png"] forState:UIControlStateNormal];
        
        
        NSInteger numberOfOptions = 3;
        NSArray *items = @[
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"undo-ipad"] title:@"Undo"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"redo-ipad"] title:@"Redo"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"006767-3d-transparent-glass-icon-arrows-arrows-rotated"] title:@"Clear"]];
        
        RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
        av.delegate = self;
        //    av.bounces = NO;
        [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];   }
    
    
    
}

-(IBAction)choos_color:(id)sender
{
    self.lineAlphaSlider.hidden = YES;
    self.lineWidthSlider.hidden = YES;
    
    
    if (IS_IPHONE )
    {
        [colorChange setImage:[UIImage imageNamed:@"colorActive-1.png"] forState:UIControlStateNormal];
        [toolChange setImage:[UIImage imageNamed:@"pen-1.png"] forState:UIControlStateNormal];
        [toggleWidthSlider setImage:[UIImage imageNamed:@"width-1.png"] forState:UIControlStateNormal];
        [toggleAlphaSlider setImage:[UIImage imageNamed:@"alpha-1.png"] forState:UIControlStateNormal];    }
    else
    {
        
        
        
        
        [colorChange setImage:[UIImage imageNamed:@"colorActive-ipad.png"] forState:UIControlStateNormal];
        [toolChange setImage:[UIImage imageNamed:@"pen-ipad.png"] forState:UIControlStateNormal];
        [toggleWidthSlider setImage:[UIImage imageNamed:@"width-ipad.png"] forState:UIControlStateNormal];
        [toggleAlphaSlider setImage:[UIImage imageNamed:@"alpha-ipad.png"] forState:UIControlStateNormal];
        
        
    }
    

    
    
    InfColorPickerController* picker = [ InfColorPickerController colorPickerViewController ];
	
	picker.sourceColor = self.view.backgroundColor;
	picker.delegate = self;
	
	[ picker presentModallyOverViewController: self ];
    
    
}
-(IBAction)BackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
	
    NSLog(@"%@",picker.resultColor);
    
    color=picker.resultColor;
    self.drawingView.lineColor = color;
    CGColorRef coloref = [color CGColor];
    const CGFloat* components = CGColorGetComponents(coloref);
    
    red = components[0];
    green = components[1];
    blue = components[2];
    CGFloat alpha =1;
    
    
    NSLog(@"%f",red);
    NSLog(@"%f",green);
    NSLog(@"%f",blue);
    NSLog(@"%f",alpha);
    
	[ self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %ld:", (long)itemIndex);
    if ([item.title isEqualToString:@"Pen"]) {
        
        self.drawingView.drawTool = ACEDrawingToolTypePen;
        
    }
    else if ([item.title isEqualToString:@"Line"]) {
        self.drawingView.drawTool = ACEDrawingToolTypeLine;
        
        
    }
  else  if ([item.title isEqualToString:@"Rectstroke"]) {
      self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
      
      
    }
   else if ([item.title isEqualToString:@"Rectfill"]) {
       self.drawingView.drawTool = ACEDrawingToolTypeRectagleFill;
       
        
    }
   else if ([item.title isEqualToString:@"Ellipsstroke"]) {
       self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
       
        
    }
    else if ([item.title isEqualToString:@"Ellipsfill"]) {
        self.drawingView.drawTool = ACEDrawingToolTypeEllipseFill;
        
        
    }
   else if ([item.title isEqualToString:@"Eraser"]) {
       self.drawingView.drawTool = ACEDrawingToolTypeEraser;
       
        
    }
   else if ([item.title isEqualToString:@"Text"]) {
       self.drawingView.drawTool = ACEDrawingToolTypeText;
        
    }
   else if ([item.title isEqualToString:@"Undo"]) {
       [self.drawingView undoLatestStep];
       [self updateButtonStatus];
       
   }
   else if ([item.title isEqualToString:@"Redo"]) {
       [self.drawingView redoLatestStep];
       [self updateButtonStatus];

       
   }
   else if ([item.title isEqualToString:@"Clear"]) {
       [self.drawingView clear];
       [self updateButtonStatus];
       
   }
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

  {
    if (actionSheet==sheet) {
       
  
    if (buttonIndex == 0) {
        
    } else if (buttonIndex == 1) {
            } else if (buttonIndex == 2) {
        
    }
    else{
        [actionSheet dismissWithClickedButtonIndex:3 animated:YES];
    }

    
    }
    
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (actionSheet.tag == kActionSheetColor) {
            
            self.colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.lineColor = [UIColor blackColor];
                    break;
                    
                case 1:
                    self.drawingView.lineColor = [UIColor redColor];
                    break;
                    
                case 2:
                    self.drawingView.lineColor = [UIColor greenColor];
                    break;
                    
                case 3:
                    self.drawingView.lineColor = [UIColor blueColor];
                    break;
            }
            
        } else {
            
            self.toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    
                    break;
                    
                case 1:
                    
                    break;
                    
                case 2:
                    
                    break;
                    
                case 3:
                    
                    break;
                    
                case 4:
                    
                    break;
                    
                case 5:
                    
                    break;
                    
                case 6:
                    
                    break;
                    
                case 7:
                    
                    break;
            }
            
            // if eraser, disable color and alpha selection
            self.colorButton.enabled = self.alphaButton.enabled = buttonIndex != 6;
        }
    }
}

#pragma mark - Settings

- (IBAction)toolChange:(id)sender
 {
     self.lineAlphaSlider.hidden = YES;
     self.lineWidthSlider.hidden = YES;
     if (IS_IPHONE )
     {
         
         [colorChange setImage:[UIImage imageNamed:@"color-1.png"] forState:UIControlStateNormal];
         [toolChange setImage:[UIImage imageNamed:@"penActive-1.png"] forState:UIControlStateNormal];
         [toggleWidthSlider setImage:[UIImage imageNamed:@"width-1.png"] forState:UIControlStateNormal];
         [toggleAlphaSlider setImage:[UIImage imageNamed:@"alpha-1.png"] forState:UIControlStateNormal];
     }
     else
     {
         [colorChange setImage:[UIImage imageNamed:@"color-ipad.png"] forState:UIControlStateNormal];
         [toolChange setImage:[UIImage imageNamed:@"penActive-ipad.png"] forState:UIControlStateNormal];
         [toggleWidthSlider setImage:[UIImage imageNamed:@"width-ipad.png"] forState:UIControlStateNormal];
         [toggleAlphaSlider setImage:[UIImage imageNamed:@"alpha-ipad.png"] forState:UIControlStateNormal];
     }
    [self showGrid];
    

}





- (void)showGrid {
   
    if (IS_IPHONE )
    {
        
        
        NSInteger numberOfOptions = 9;
        NSArray *items = @[
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"pen"] title:@"Pen"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"line"] title:@"Line"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"rectstrok"] title:@"Rectstroke"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"rectfill"] title:@"Rectfill"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ellipsstroke"] title:@"Ellipsstroke"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ellipsfill"] title:@"Ellipsfill"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"eraser"] title:@"Eraser"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"text"] title:@"Text"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@""] title:@""]
                           ];
        
        RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
        av.delegate = self;
        //    av.bounces = NO;
        [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];   }
    else
    {
        
        
        
        NSInteger numberOfOptions = 9;
        NSArray *items = @[
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"pen2-ipad"] title:@"Pen"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"line-ipad"] title:@"Line"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"rectstrok-ipad"] title:@"Rectstroke"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"rectfill-ipad"] title:@"Rectfill"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ellipsstroke-ipad"] title:@"Ellipsstroke"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ellipsfill-ipad.png"] title:@"Ellipsfill"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"eraser-ipad.png"] title:@"Eraser"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"text-ipad"] title:@"Text"],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@""] title:@""]
                           ];
        
        RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
        av.delegate = self;
        //    av.bounces = NO;
        [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
        
        
    }

    
    
   
}

- (IBAction)toggleWidthSlider:(id)sender
{
    if (IS_IPHONE )
    {
        [colorChange setImage:[UIImage imageNamed:@"color-1.png"] forState:UIControlStateNormal];
        [toolChange setImage:[UIImage imageNamed:@"pen-1.png"] forState:UIControlStateNormal];
        [toggleWidthSlider setImage:[UIImage imageNamed:@"widthActive-1.png"] forState:UIControlStateNormal];
        [toggleAlphaSlider setImage:[UIImage imageNamed:@"alpha-1.png"] forState:UIControlStateNormal];    }
    else
    {
        
        
        
        
        [colorChange setImage:[UIImage imageNamed:@"color-ipad.png"] forState:UIControlStateNormal];
        [toolChange setImage:[UIImage imageNamed:@"pen-ipad.png"] forState:UIControlStateNormal];
        [toggleWidthSlider setImage:[UIImage imageNamed:@"widthActive-ipad.png"] forState:UIControlStateNormal];
        [toggleAlphaSlider setImage:[UIImage imageNamed:@"alpha-ipad.png"] forState:UIControlStateNormal];
        
        
    }

    
    
    
    // toggle the slider
    self.lineWidthSlider.hidden = !self.lineWidthSlider.hidden;
    self.lineAlphaSlider.hidden = YES;
}


- (IBAction)widthChange:(UISlider *)sender
{
    self.drawingView.lineWidth = sender.value;
}

- (IBAction)toggleAlphaSlider:(id)sender
{
    
    if (IS_IPHONE )
    {
        [colorChange setImage:[UIImage imageNamed:@"color-1.png"] forState:UIControlStateNormal];
        [toolChange setImage:[UIImage imageNamed:@"pen-1.png"] forState:UIControlStateNormal];
        [toggleWidthSlider setImage:[UIImage imageNamed:@"width-1.png"] forState:UIControlStateNormal];
        [toggleAlphaSlider setImage:[UIImage imageNamed:@"alphaActive-1.png"] forState:UIControlStateNormal];    }
    else
    {
        
        
        
        
        [colorChange setImage:[UIImage imageNamed:@"color-ipad.png"] forState:UIControlStateNormal];
        [toolChange setImage:[UIImage imageNamed:@"pen-ipad.png"] forState:UIControlStateNormal];
        [toggleWidthSlider setImage:[UIImage imageNamed:@"width-ipad.png"] forState:UIControlStateNormal];
        [toggleAlphaSlider setImage:[UIImage imageNamed:@"alphaActive-ipad.png"] forState:UIControlStateNormal];
        
        
    }
    
    

    

    // toggle the slider
    self.lineAlphaSlider.hidden = !self.lineAlphaSlider.hidden;
    self.lineWidthSlider.hidden = YES;
}
-(void) textViewDidBeginEditing:(UITextView *)textView {
    
    
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



- (IBAction)alphaChange:(UISlider *)sender
{
    self.drawingView.lineAlpha = sender.value;
     commentText.alpha = sender.value;
}

@end
