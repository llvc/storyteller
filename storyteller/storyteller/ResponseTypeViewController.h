//
//  ResponseTypeViewController.h
//  storyteller
//
//  Created by Alin Hila on 8/23/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ResponseTypeViewController : UIViewController

@property (nonatomic, retain) UIImagePickerController *imagePicker;

@property (nonatomic, retain) IBOutlet UIImageView *cameraView;

- (IBAction)backToMainTabView:(id)sender;

- (void)createImagePicker;
@end