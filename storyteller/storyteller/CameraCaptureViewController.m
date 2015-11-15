//
//  CameraCaptureViewController.m
//  storyteller
//
//  Created by Alin Hila on 8/25/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import "CameraCaptureViewController.h"
#import "Config.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation CameraCaptureViewController

@synthesize imagePicker, cameraView, halfView, startedRecording;
@synthesize backButton, cameraButton, recordingButton, cancelButton, confirmButton;
@synthesize recordingTimer, seconds;
@synthesize timeStamp, shimmer_dot, isShown;
@synthesize moviePlayer;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self createImagePicker];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    isShown = YES;
    
    CGRect theRect = [imagePicker.view frame];
    [cameraView setFrame:theRect];
    [cameraView addSubview:imagePicker.view];
    [cameraView sendSubviewToBack:imagePicker.view];

    // init variable
    startedRecording = NO;
    
    seconds = 30;
    
    [timeStamp setText:[self getTimeStr:seconds]];
    
    //show camera button
    [cameraButton setHidden:NO];
    
    //hide red dot
    [shimmer_dot setHidden:YES];
    
    //hide cancel/confirm buttun
    [cancelButton setHidden:YES];
    [confirmButton setHidden:YES];
    
//    shimmer_dot.frame =  CGRectMake(shimmer_dot.frame.origin.x + 5, shimmer_dot.frame.origin.y + 5, 0, 0);
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [imagePicker.view removeFromSuperview];
}

- (void)createImagePicker {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    //imagePicker.videoMaximumDuration = 30.0f;
    
    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = NO;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    float cameraAspectRatio = 4.0/3.0;
    float imageWidth = floorf(screenSize.width * cameraAspectRatio);
    float scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
    imagePicker.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
    
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
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
//        showFlashMode = YES;
    }
    
    imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
    
    imagePicker.delegate = self;
//    imagePicker.wantsFullScreenLayout = YES;
    [imagePicker setVideoMaximumDuration:30];
}

- (IBAction) changeCameraDevice
{
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

#pragma mark - recording methods

- (void) startRecording
{
    startedRecording = [imagePicker startVideoCapture];
    
    if (startedRecording == YES) {
        //hide backbutton
        [backButton setHidden:YES];
        
        //recordingButton
        [recordingButton setImage:[UIImage imageNamed:@"recording_video_btn"] forState:UIControlStateNormal];
        
        //hide camera button
        [cameraButton setHidden:YES];
        
        //show red dot
        [shimmer_dot setHidden:NO];
        
        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                               target:self
                                                             selector:@selector(countRecordingTime)
                                                             userInfo:nil
                                                              repeats:YES];
    }
    
//    void (^hideControls)(void);
//    
//    hideControls = ^(void) {
//        //hide backbutton
//        [backButton setHidden:YES];
//        
//        //recordingButton
//        [recordingButton setImage:[UIImage imageNamed:@"recording_video_btn"] forState:UIControlStateNormal];
//        
//        //hide camera button
//        [cameraButton setHidden:YES];
//        
//        //show red dot
//        [shimmer_dot setHidden:NO];
//        
//    };
//    
//    void (^recordMovie)(BOOL finished);
//    
//    recordMovie = ^(BOOL finished) {
//        //record video
//        [imagePicker startVideoCapture];
//        
//        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                               target:self
//                                                             selector:@selector(countRecordingTime)
//                                                             userInfo:nil
//                                                              repeats:YES];
//    };
//    
//    // Hide controls
//    [UIView  animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:hideControls completion:recordMovie];
}

- (void) countRecordingTime
{
    seconds --;
    
    if (seconds==0){
        
        [self stopRecording];
    }
    
    if (!isShown) {
//        shimmer_dot.frame =  CGRectMake(shimmer_dot.frame.origin.x + 5, shimmer_dot.frame.origin.y + 5, 0, 0);
        [UIView animateWithDuration:0.1 animations:^{
            shimmer_dot.frame =  CGRectMake(shimmer_dot.frame.origin.x - 5, shimmer_dot.frame.origin.y - 5, 10, 10);
        }];
        isShown = YES;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            shimmer_dot.frame =  CGRectMake(shimmer_dot.frame.origin.x+5, shimmer_dot.frame.origin.y+5, 0, 0);
        }];
        isShown = NO;
    }
    
    [timeStamp setText:[self getTimeStr:seconds]];
}

- (void) stopRecording
{
    [imagePicker stopVideoCapture];
}

- (IBAction)toggleRecordingButton:(id)sender
{
    if (startedRecording) {
        [self stopRecording];
    } else {
        [self startRecording];
    }
}

- (IBAction)useThisVideo:(id)sender
{
    if (self.choosenURL) {
        [[currentTopic.questions objectAtIndex:currentTab - 1] setQuestion_response:self.choosenURL];
        [[currentTopic.questions objectAtIndex:currentTab - 1] setResponseType:VideoResponse];
        
        [self moviePlayBackDidFinish];
    } else {
        NSLog(@"choosen URL is null");
    }

    UITabBarController *mainView = [self.navigationController.viewControllers objectAtIndex:TabViewControllerIndex];
    [mainView setSelectedIndex:currentTab + 1];
    [self.navigationController popToViewController:mainView animated:YES];
}

- (IBAction)cancelThisVideo:(id)sender
{
    self.choosenURL = nil;
    
    //remove movie player view
    [moviePlayer.view removeFromSuperview];
    
    [self dismissThisView:nil];
}

- (NSString*)getTimeStr : (int) secondsElapsed {
    if (secondsElapsed < 0) {
        secondsElapsed = 0;
    }
    
    int sec = secondsElapsed % 60;
    int min = secondsElapsed / 60;
    return [NSString stringWithFormat:@"00:%02d:%02d", min, sec];
}

- (IBAction)dismissThisView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ImagePicker 
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.choosenURL = [info valueForKey:UIImagePickerControllerMediaURL];
    
    [self fixOrientationOfVideoAtURL:self.choosenURL];
}

#pragma mark - PlayVideo
- (void) playVideo:(NSURL *) _url
{
    moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:_url];
    
    //remove camera view
    [imagePicker.view removeFromSuperview];
    
    //set movie player view
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.repeatMode = MPMovieRepeatModeOne;
    moviePlayer.shouldAutoplay = YES;

    CGRect theRect = [cameraView bounds];
    [moviePlayer.view setFrame:theRect];
    [cameraView addSubview:moviePlayer.view];
    [cameraView sendSubviewToBack:moviePlayer.view];
    
    [moviePlayer play];
}

- (void) moviePlayBackDidFinish
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [moviePlayer.view removeFromSuperview];
    }
}

-(void)fixOrientationOfVideoAtURL:(NSURL *)videoURL {
    
    AVAsset *firstAsset = [AVAsset assetWithURL:videoURL];
    if(firstAsset !=nil && [[firstAsset tracksWithMediaType:AVMediaTypeVideo] count]>0){
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
        
        if ([[firstAsset tracksWithMediaType:AVMediaTypeAudio] count]>0) {
            //AUDIO TRACK
            AVMutableCompositionTrack *firstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [firstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        }else{
            NSLog(@"warning: video has no audio");
        }
        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
        
        BOOL  isFirstAssetPortrait_  = NO;
        
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)
        {
            FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)
        {
            FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)
        {
            FirstAssetOrientation_ =  UIImageOrientationUp;
        }
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0)
        {
            FirstAssetOrientation_ = UIImageOrientationDown;
        }
        
        CGFloat FirstAssetScaleToFitRatio = 480.0/FirstAssetTrack.naturalSize.width;
        
        if(isFirstAssetPortrait_)
        {
            FirstAssetScaleToFitRatio = 480.0/FirstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }
        else
        {
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,nil];;
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(480.0, 640.0);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self exportDidFinish:exporter];
             });
         }];
    }else{
        NSLog(@"Error, video track not found");
    }
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"Video Saving Failed: %@", error.localizedDescription);
                        
                        //show camera button
                        [cameraButton setHidden:NO];
                        
                        //change recordingbutton image
                        [recordingButton setImage:[UIImage imageNamed:@"take_photo_btn"] forState:UIControlStateNormal];
                        
                        //hide cancel/confirm buttun
                        [cancelButton setHidden:YES];
                        [confirmButton setHidden:YES];
                    } else {
                        NSLog(@"Saved fixed orientation video to album");

                        self.choosenURL = assetURL;
                        
                        //play video
                        [self playVideo:assetURL];
                        
                        //reset recording time
                        seconds = 30;
                        
                        //stop video record time counting
                        [self.recordingTimer invalidate];
                        self.recordingTimer = nil;
                        
                        //show/hide buttons related to recording
                        [recordingButton setHidden:YES];
                        [recordingButton setImage:[UIImage imageNamed:@"take_photo_btn"] forState:UIControlStateNormal];
                        [cancelButton setHidden:NO];
                        [confirmButton setHidden:NO];
                        [shimmer_dot setHidden:YES];
                    }
                });
            }];
        }
    }
}

@end