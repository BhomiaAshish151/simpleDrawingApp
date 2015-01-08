//
//  PhotoPaint.h
//  PhotoSmart
//
//  Created by Ashish Sharma on 29/05/14.
//  Copyright (c) 2014 Ashish Sharma. All rights reserved.
//
#import "InfColorPickerController.h"
#import "RNGridMenu.h"
#import <UIKit/UIKit.h>
#import "PatientInfo.h"
@class ACEDrawingView;



@interface PhotoPaint : UIViewController<InfColorPickerControllerDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,RNGridMenuDelegate>
{
    NSMutableArray *TempArr;
    NSTimer *timer;
    UIColor *color;
    UITextView *commentText;
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    UIImage *CameraImage;
    IBOutlet UIImageView *imgView,*drawImage;
    IBOutlet UIToolbar *TopBar,*bottombar;
    
    IBOutlet UIButton *colorChange,*toolChange,*toggleWidthSlider,*toggleAlphaSlider,*alphaChange,*MoreBtn;
    
    UIActionSheet *sheet;
    CGFloat animatedDistance;
}
typedef struct {
    int redValue;
    int greenValue;
    int blueValue;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} RgbColor;
@property(nonatomic,retain)NSMutableArray *TempArr;
@property (nonatomic, unsafe_unretained) IBOutlet ACEDrawingView *drawingView;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineWidthSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineAlphaSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *previewImageView;

@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *undoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *colorButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *toolButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *alphaButton;

// actions
- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)takeScreenshot:(id)sender;
- (IBAction)MoreBtn:(id)sender;
-(IBAction)BackBtn:(id)sender;
// settings
- (IBAction)colorChange:(id)sender;
- (IBAction)toolChange:(id)sender;
- (IBAction)toggleWidthSlider:(id)sender;
- (IBAction)widthChange:(UISlider *)sender;
- (IBAction)toggleAlphaSlider:(id)sender;
- (IBAction)alphaChange:(UISlider *)sender;
@property(nonatomic,retain) UIImage *CameraImage;
@end
