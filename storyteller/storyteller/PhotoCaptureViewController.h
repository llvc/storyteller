//
//  PhotoCaptureViewController.h
//  storyteller
//
//  Created by Alin Hila on 8/25/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCaptureViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *imagePicker;

@property (nonatomic) UIImage *photoResponse;

@property (nonatomic, retain) IBOutlet UIView *cameraView;
@property (nonatomic, retain) IBOutlet UIView *halfView;
@property (nonatomic, retain) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *confirmButton;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) IBOutlet UIButton *flashButton;

- (void)createImagePicker;
- (IBAction) changeCameraDevice;
- (IBAction) dismissThisView:(id)sender;


- (IBAction)togglePhotoButton:(id)sender;
- (IBAction)useThisPhoto:(id)sender;
- (IBAction)cancelThisPhoto:(id)sender;

@end
