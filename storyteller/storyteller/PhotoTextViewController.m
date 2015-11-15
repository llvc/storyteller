//
//  PhotoTextViewController.m
//  storyteller
//
//  Created by Alin Hila on 8/27/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import "PhotoTextViewController.h"
#import "MainTabViewController.h"

#import "IQKeyboardManager.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation PhotoTextViewController

@synthesize image, photoView, myPathDocs, textViewContainer, question;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];

    [photoView setImage:image];
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:self.class];
    
    // Create messageInputBar to contain _textView, messageInputBarBackgroundImageView, & _sendButton.
    UIImageView *messageInputBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kChatBarHeight1, self.view.frame.size.width, kChatBarHeight1)];
    messageInputBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    messageInputBar.opaque = YES;
    messageInputBar.userInteractionEnabled = YES; // makes subviews tappable
    messageInputBar.image = [[UIImage imageNamed:@"MessageInputBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 3, 19, 3)]; // 8 x 40
    
    // Create _textView to compose messages.
    // TODO: Shrink cursor height by 1 px on top & 1 px on bottom.
    _responseTextView = [[MCPlaceholderTextView alloc] initWithFrame:CGRectMake(TEXT_VIEW_X, TEXT_VIEW_Y, TEXT_VIEW_WIDTH, TEXT_VIEW_HEIGHT_MIN)];
    _responseTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _responseTextView.delegate = self;
    _responseTextView.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1];
    _responseTextView.scrollIndicatorInsets = UIEdgeInsetsMake(13, 0, 8, 6);
    _responseTextView.scrollsToTop = NO;
    _responseTextView.font = [UIFont systemFontOfSize:MessageFontSize];
    [_responseTextView becomeFirstResponder];
    _responseTextView.placeholder = NSLocalizedString(@"Enter your response", nil);
    _previousTextViewContentHeight = MessageFontSize+20;
    
    [messageInputBar addSubview:_responseTextView];
    
    // Create messageInputBarBackgroundImageView as subview of messageInputBar.
    UIImageView *messageInputBarBackgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MessageInputFieldBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 12, 18, 18)]]; // 32 x 40
    messageInputBarBackgroundImageView.frame = CGRectMake(TEXT_VIEW_X-2, 0, TEXT_VIEW_WIDTH+2, kChatBarHeight1);
    messageInputBarBackgroundImageView.autoresizingMask = self.view.autoresizingMask;
    [messageInputBar addSubview:messageInputBarBackgroundImageView];
    
    [self.view addSubview:messageInputBar];
    
    UIKeyboardNotificationsObserve();
    
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIKeyboardNotificationsUnobserve();
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect frameEnd;
    NSDictionary *userInfo = [notification userInfo];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&frameEnd];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:0 animations:^{
        CGFloat viewHeight = [self.view convertRect:frameEnd fromView:nil].origin.y;
        UIView *messageInputBar = _responseTextView.superview;
        CGRect frame = messageInputBar.frame;
        frame = CGRectMake(frame.origin.x, viewHeight - frame.size.height, frame.size.width, frame.size.height);
        messageInputBar.frame = frame;
    } completion:nil];
}

- (void)keyboardWillDisappear:(NSNotification *)notification {
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect frameEnd;
    NSDictionary *userInfo = [notification userInfo];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&frameEnd];
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:0 animations:^{
        UIView *messageInputBar = _responseTextView.superview;
        CGRect frame = messageInputBar.frame;
        CGFloat height;
        if (self.responseTextView.text && self.responseTextView.text.length > 0)
            height = frame.size.height;
        else
            height = kChatBarHeight1;
        frame = CGRectMake(frame.origin.x, self.view.frame.size.height - height, frame.size.width, height);
        messageInputBar.frame = frame;
    } completion:nil];
}

-(void)moveViewUp:(BOOL)bMovedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // to slide the view up
    
    CGRect rect = self.view.frame;
    if (bMovedUp) {
        // 1. move the origin of view up so that the text field will come above the keyboard
        rect.origin.y -= k_KEYBOARD_OFFSET;
        
        // 2. increase the height of the view to cover up the area behind the keyboard
        rect.size.height += k_KEYBOARD_OFFSET;
    } else {
        // revert to normal state of the view.
        rect.origin.y += k_KEYBOARD_OFFSET;
        rect.size.height -= k_KEYBOARD_OFFSET;
    }
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (IBAction) popThisView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) submitThisResponse:(id)sender
{
    //resize to 480 * 640
    CGRect rect = CGRectMake(0, 0, 480, 640);
    
    UIGraphicsBeginImageContext( rect.size );
    [self.image drawInRect:rect];
    UIImage *resizedPhoto = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(resizedPhoto);
    self.image=[UIImage imageWithData:imageData];
    
    //draw text on photo
    if (![[_responseTextView text] isEqualToString:@""]) {
        UIImage *combinedImage = [self drawText:[_responseTextView text] inImage:image atPoint:CGPointMake(50, 50)];
        
        //and set it
        self.image = combinedImage;
    }
    
    //define url to save
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                        [NSString stringWithFormat:@"movie-%d.mov",arc4random() % 1000]];
    
    [self savePhotoToLibrary];
}

-(UIImage*) drawText:(NSString*) text inImage:(UIImage*) _image atPoint:(CGPoint) point
{
    UIFont *font = [UIFont boldSystemFontOfSize:30];

    NSDictionary *attr = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: font};
    
    UIGraphicsBeginImageContext(_image.size);
    [_image drawInRect:CGRectMake(0, 0, _image.size.width, _image.size.height)];
    
    int imageHeight = image.size.height;
    int imageWidth = image.size.width;

    
    CGRect rectBG = CGRectMake(0, imageHeight / 2, image.size.width, imageHeight / 2);
    CGRect rectText = CGRectMake(point.x, imageHeight / 2 + point.y, imageWidth - 100, imageHeight / 2 - 100);
    
    [BlueBG set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), rectBG);

    [text drawInRect:rectText withAttributes:attr];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)savePhotoToLibrary
{
    // You just need the height and width of the video here
    // For us, our input and output video was 640 height x 480 width
    // which is what we get from the iOS front camera
    
    int height = self.image.size.height;
    int width = self.image.size.width;
    
    NSURL *videoTempURL = [NSURL fileURLWithPath:self.myPathDocs];
    
    // WARNING: AVAssetWriter does not overwrite files for us, so remove the destination file if it already exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[videoTempURL path]  error:NULL];
    
    
    // Create your own array of UIImages
    NSMutableArray *images = [NSMutableArray array];
    for (int i=0; i < 12; i++)
    {
        // This was our routine that returned a UIImage. Just use your own.
        UIImage *_image =[self.image copy];
        // We used a routine to write text onto every image
        // so we could validate the images were actually being written when testing. This was it below.
        //        image = [self writeToImage:image Text:[NSString stringWithFormat:@"%i",i ]];
        [images addObject:_image];
    }
    
    
    [self writeImageAsMovie:images toPath:self.myPathDocs size:CGSizeMake(width, height)];
}

-(void)writeImageAsMovie:(NSArray *)array toPath:(NSString*)path size:(CGSize)size
{
    
    NSError *error = nil;
    
    // FIRST, start up an AVAssetWriter instance to write your video
    // Give it a destination path (for us: tmp/temp.mov)
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path]
                                                           fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    
    
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    
    AVAssetWriterInput* writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                                                     sourcePixelBufferAttributes:nil];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    //Start a SESSION of writing.
    // After you start a session, you will keep adding image frames
    // until you are complete - then you will tell it you are done.
    [videoWriter startWriting];
    // This starts your video at time = 0
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    
    // This was just our utility class to get screen sizes etc.
    //    ATHSingleton *singleton = [ATHSingleton singletons];
    
    int i = 0;
    while (1)
    {
        // Check if the writer is ready for more data, if not, just wait
        if(writerInput.readyForMoreMediaData){
            
            CMTime frameTime = CMTimeMake(150, 600);
            // CMTime = Value and Timescale.
            // Timescale = the number of tics per second you want
            // Value is the number of tics
            // For us - each frame we add will be 1/4th of a second
            // Apple recommend 600 tics per second for video because it is a
            // multiple of the standard video rates 24, 30, 60 fps etc.
            CMTime lastTime=CMTimeMake(i*150, 600);
            CMTime presentTime=CMTimeAdd(lastTime, frameTime);
            
            if (i == 0) {presentTime = CMTimeMake(0, 600);}
            // This ensures the first frame starts at 0.
            
            
            if (i >= [array count])
            {
                buffer = NULL;
            }
            else
            {
                // This command grabs the next UIImage and converts it to a CGImage
                buffer = [self pixelBufferFromCGImage:[[array objectAtIndex:i] CGImage]];
            }
            
            
            if (buffer)
            {
                // Give the CGImage to the AVAssetWriter to add to your video
                [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
                i++;
            }
            else
            {
                //Finish the session:
                // This is important to be done exactly in this order
                [writerInput markAsFinished];
                // WARNING: finishWriting in the solution above is deprecated.
                // You now need to give a completion handler.
                [videoWriter finishWritingWithCompletionHandler:^{
                    NSLog(@"Finished writing...checking completion status...");
                    if (videoWriter.status != AVAssetWriterStatusFailed && videoWriter.status == AVAssetWriterStatusCompleted)
                    {
                        NSLog(@"Video writing succeeded.");
                        
                        // Move video to camera roll
                        // NOTE: You cannot write directly to the camera roll.
                        // You must first write to an iOS directory then move it!
                        NSURL *videoTempURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@", path]];
                        [self saveToCameraRoll:videoTempURL];
                    } else
                    {
                        NSLog(@"Video writing failed: %@", videoWriter.error);
                    }
                    
                }]; // end videoWriter finishWriting Block
                
                CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
                
                UITabBarController *mainView = [self.navigationController.viewControllers objectAtIndex:TabViewControllerIndex];
                
                question = [currentTopic.questions objectAtIndex:currentTab - 1];
                [question setQuestion_response:[NSURL fileURLWithPath:@"file:///"]];
                [question setResponseType:PhotoTextResponse];
                
                [mainView setSelectedIndex:currentTab + 1];
                
                [self.navigationController popToViewController:mainView animated:NO];
                
                NSLog (@"Done");
                break;
            }
        }
    }
}

- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) _image
{
    // This again was just our utility class for the height & width of the
    // incoming video (640 height x 480 width)
    
    int height = self.image.size.height;
    int width = self.image.size.width;
    
    //    int height = 1064;
    //    int width = 2048;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, width,
                                          height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata, width,
                                                 height, 8, 4*width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(_image),
                                           CGImageGetHeight(_image)), _image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (void) saveToCameraRoll:(NSURL *)srcURL
{
    //save question num for block
//    __block int questionNum = currentTab - 2;
    
    NSLog(@"srcURL: %@", srcURL);
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image with metadata to Photo Library %@", newURL.absoluteString);
            
            
            //save response
            if (!question) {
                return;
            }

            [question setQuestion_response:newURL];
            [question setResponseType:PhotoTextResponse];
            [[NSNotificationCenter defaultCenter] postNotificationName:NFREFRESHRESPONSELIST object:nil];
        }
    };
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:srcURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:srcURL
                                    completionBlock:videoWriteCompletionBlock];
    }
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView {
    // Change height of _tableView & messageInputBar to match textView's content height.
    CGFloat textViewContentHeight = textView.contentSize.height;
    CGFloat changeInHeight = textViewContentHeight - _previousTextViewContentHeight;
    
    if (textViewContentHeight+changeInHeight > kChatBarHeight4+2) {
        changeInHeight = kChatBarHeight4+2-_previousTextViewContentHeight;
    }
    
    if (changeInHeight) {
        [UIView animateWithDuration:0.2 animations:^{
            UIView *messageInputBar = _responseTextView.superview;
            messageInputBar.frame = CGRectMake(0, messageInputBar.frame.origin.y-changeInHeight, messageInputBar.frame.size.width, messageInputBar.frame.size.height+changeInHeight);
        } completion:^(BOOL finished) {
            [_responseTextView updateShouldDrawPlaceholder];
        }];
        _previousTextViewContentHeight = MIN(textViewContentHeight, kChatBarHeight4+2);
    }
}

- (BOOL)isAcceptableTextLength:(NSUInteger)length {
    return length <= MESSAGE_TEXT_LENGTH;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    return [self isAcceptableTextLength:self.responseTextView.text.length + string.length - range.length];
}

@end
