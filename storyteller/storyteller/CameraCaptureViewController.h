//
//  CameraCaptureViewController.h
//  storyteller
//
//  Created by Alin Hila on 8/25/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

@interface CameraCaptureViewController : UIViewController  <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic) BOOL startedRecording;
@property (nonatomic) NSTimer *recordingTimer;
@property (nonatomic) int seconds;
@property (nonatomic) NSURL *choosenURL;

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

@property (nonatomic, assign) BOOL isShown;

@property (nonatomic, retain) IBOutlet UIView *cameraView;
@property (nonatomic, retain) IBOutlet UIView *halfView;
@property (nonatomic, retain) IBOutlet UIButton *recordingButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *confirmButton;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) IBOutlet UIImageView *shimmer_dot;
@property (nonatomic, retain) IBOutlet UILabel *timeStamp;

- (void)createImagePicker;
- (IBAction) changeCameraDevice;
- (IBAction) dismissThisView:(id)sender;

- (void) startRecording;
- (void) stopRecording;

- (void) countRecordingTime;

- (IBAction)toggleRecordingButton:(id)sender;
- (IBAction)useThisVideo:(id)sender;
- (IBAction)cancelThisVideo:(id)sender;

- (NSString*)getTimeStr : (int) secondsElapsed ;

@end
