//
//  ResponseTypeViewController.m
//  storyteller
//
//  Created by Alin Hila on 8/23/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import "ResponseTypeViewController.h"
#import "Config.h"

@implementation ResponseTypeViewController

@synthesize imagePicker, cameraView;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:NavBlackBG];
    self.navigationController.navigationBar.topItem.title = TopicViewTitle;
    
    CGRect theRect = [imagePicker.view frame];
    [cameraView setFrame:theRect];
    [cameraView addSubview:imagePicker.view];
    [cameraView sendSubviewToBack:imagePicker.view];
    
//    [self createImagePicker];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self createImagePicker];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [imagePicker.view removeFromSuperview];
}

- (IBAction)backToMainTabView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createImagePicker {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
//
    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = NO;
    imagePicker.cameraViewTransform = CGAffineTransformIdentity;
}
@end
