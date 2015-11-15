//
//  PhotoCaptureViewController.m
//  storyteller
//
//  Created by Alin Hila on 8/25/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import "PhotoCaptureViewController.h"
#import "Config.h"
#import "PhotoTextViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

@implementation PhotoCaptureViewController

@synthesize imagePicker, photoResponse;
@synthesize cameraView, halfView, takePhotoButton, cancelButton;
@synthesize flashButton, confirmButton, backButton, cameraButton;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self createImagePicker];
}

- (void) viewWillAppear:(BOOL)animated
{
    imagePicker.view.frame = cameraView.frame;
    [cameraView addSubview:imagePicker.view];
    
    [cameraView sendSubviewToBack:imagePicker.view];
    
    [flashButton setHidden:NO];
    [cameraButton setHidden:NO];
    [takePhotoButton setHidden:NO];
    
    [cancelButton setHidden:YES];
    [confirmButton setHidden:YES];
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [imagePicker.view removeFromSuperview];
}

- (void)createImagePicker
{
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
//    imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    //imagePicker.videoMaximumDuration = 30.0f;
    
    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = NO;
    
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    float cameraAspectRatio = 4.0/3.0;
    float imageWidth = floorf(screenSize.width * cameraAspectRatio);
    float scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
    imagePicker.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
//    imagePicker.cameraViewTransform = CGAffineTransformIdentity;
    
    // not all devices have two cameras or a flash so just check here
    if ( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear] ) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        if ( [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront] ) {
            //            showCameraSelection = YES;
        }
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    if ( [UIImagePickerController isFlashAvailableForCameraDevice:imagePicker.cameraDevice] ) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
    
    imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
    
    imagePicker.delegate = self;
//    imagePicker.wantsFullScreenLayout = YES;
}

- (IBAction) changeCameraDevice;
{
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

- (IBAction) dismissThisView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)togglePhotoButton:(id)sender
{
    [imagePicker takePicture];
}

- (IBAction)useThisPhoto:(id)sender
{
//    if (self.photoResponse) {
//        [[currentTopic.questions objectAtIndex:currentTab - 1] setPhoto_response:self.photoResponse];
//        [[currentTopic.questions objectAtIndex:currentTab - 1] setVideo_response:nil];
//    } else {
//        NSLog(@"photoResponse is null");
//    }
//    
//    UITabBarController *mainView = [self.navigationController.viewControllers objectAtIndex:TabViewControllerIndex];
//    [mainView setSelectedIndex:currentTab + 1];
//    [self.navigationController popToViewController:mainView animated:YES];
}

- (IBAction)cancelThisPhoto:(id)sender
{
    self.photoResponse = nil;
    
    [self dismissThisView:nil];
}

#pragma mark - ImagePicker
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    self.photoResponse = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [imagePicker.view removeFromSuperview];
    UIImageView *photoView = [[UIImageView alloc] initWithImage:self.photoResponse];
    [photoView setFrame:cameraView.frame];
    [cameraView addSubview:photoView];
    [cameraView sendSubviewToBack:photoView];
    
    [flashButton setHidden:YES];
    [cameraButton setHidden:YES];
    [takePhotoButton setHidden:YES];
    
    //show cancel /confirm button
    [cancelButton setHidden:NO];
    [confirmButton setHidden:NO];
}

#pragma mark - storyboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"commitText"]) {
        PhotoTextViewController *controller = (PhotoTextViewController *)[segue destinationViewController];
        [controller setImage:self.photoResponse];
    }
}

@end