//
//  SecondQuestionPage.m
//  storyteller
//
//  Created by Alin Hila on 8/17/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

#import <Social/Social.h>

#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareVideo.h>
#import <FBSDKShareKit/FBSDKShareVideoContent.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>

#import "UploadPage.h"
#import "BubbleViewCell.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "SocialViewController.h"
#import "MainTabViewController.h"

@interface UploadPage() <SocialViewControllerDelegate, FBSDKSharingDelegate>

@property (nonatomic, assign) BOOL finishMerging;

@property (nonatomic, assign) float progressValue;
@property (nonatomic, assign) BOOL uploadingFailed;

@property (nonatomic, retain) SocialViewController *socialViewController;

@property (nonatomic, retain) NSString *publicVideoLink;
@property (nonatomic, retain) NSURL *localVideoURL;

- (void) startVideoMergeAndThenUpload;
- (AVAsset *) createAsset:(NSURL *)url;
-(void)exportDidFinish:(AVAssetExportSession*)session;
- (void) uploadFourthVideo:(NSURL *) url;
- (void) showPopupMessage:(NSString *) messag;

@end

@implementation UploadPage

@synthesize moviePlayer, finishMerging, progressValue, uploadingFailed, socialViewController;
@synthesize publicVideoLink, localVideoURL;

- (void) viewWillAppear:(BOOL)animated
{
    progressValue = 0.0f;
    
    uploadingFailed = NO;
    
    finishMerging = NO;
    
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    
    self.collectionView.backgroundColor = BrightWhiteBlue;
    
    self.senderId = kJSQDemoAvatarIdSquires;
    self.senderDisplayName = kJSQDemoAvatarDisplayNameSquires;
    
    //make up data to show
    self.demoData = [[DemoModelData alloc] initWithQuestion:UploadTabIndex - 1];
    
    [self finishSendingMessageAnimated:YES];
    
    //set current tab index
    currentTab = UploadTabIndex;
    
    self.navigationController.navigationBar.topItem.title = UploadViewTitle;
    
    //define notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(refreshResponseList:) name:NFREFRESHRESPONSELIST object:nil];
    
    passedUploadingPage = YES;
    self.tabBarItem.image = [[UIImage imageNamed:@"upload"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    //remove social page
    
    if (socialViewController) {
        // start animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                               forView:self.view cache:YES];
        
        [UIView commitAnimations];
        
        [socialViewController.view removeFromSuperview];
        
        self.navigationController.navigationBarHidden = false;
        self.navigationController.navigationBar.topItem.title = UploadViewTitle;
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.demoData.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.demoData.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.demoData.outgoingBubbleImageData;
    }
    
    return self.demoData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.demoData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
            cell.textView.font = [UIFont systemFontOfSize:12];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 1.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 1.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 1.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    Question *question = nil;
    
    if ([indexPath row] == 1) {
        question = [currentTopic.questions objectAtIndex:0];
    } else if ([indexPath row] == 3) {
        question = [currentTopic.questions objectAtIndex:1];
    } else if ([indexPath row] == 5) {
        question = [currentTopic.questions objectAtIndex:2];
    } else if ([indexPath row] == 6) {
        progressValue = 0.0f;
        uploadingFailed = NO;
        
        [SVProgressHUD showProgress:0.0f status:UPLOADING maskType:SVProgressHUDMaskTypeGradient];
        
        for (Question *question in currentTopic.questions) {
            HttpEngine *httpEngine = [[HttpEngine alloc] init];
            
            NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
            [dictParameters setValue:[NSString stringWithFormat:@"%@", logger.loginInfo[LOGIN_USER_ID]] forKey:LOGIN_USER_ID];
            [dictParameters setValue:[NSString stringWithFormat:@"%d", question.question_id] forKey:QUESTION_ID];
            
            httpEngine.dataSource = self;
            
            BOOL isPhoto = ([question.responseType isEqual:VideoResponse] ? NO:YES);
            
            [httpEngine uploadVideoData:Uploading_Request_URL file_url:question.question_response params:dictParameters isPhoto: isPhoto];
        }
        
        [self startVideoMergeAndThenUpload];

    }
    
    if (question && [question.responseType isEqualToString:VideoResponse]) {
        [self playVideo:question.question_response];
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - notification
- (void) refreshResponseList:(NSNotification *) note
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        JSQMessage *message = [self.demoData.messages objectAtIndex:5];
        
        JSQVideoMediaItem *videoMessage = (JSQVideoMediaItem *)message.media;
        videoMessage.fileURL = [[currentTopic.questions objectAtIndex:ThirdQuestionTabIndex - 1] question_response];
        videoMessage.isReadyToPlay = YES;
        videoMessage.photoType = YES;
        
        [self.collectionView reloadData];
    });    
}

#pragma mark - HttpEngine
- (void) recvHttpResponseSuccess:(id) _response
{
    if (uploadingFailed) {
        [SVProgressHUD dismiss];
        return;
    }
    
    NSMutableDictionary *response = (NSMutableDictionary *)_response;
    progressValue += 0.25;
    if (progressValue > 1.0) {
        progressValue = 1.0;
    }
    
    [SVProgressHUD showProgress:progressValue status:UPLOADING maskType:SVProgressHUDMaskTypeGradient];
    
    if (progressValue == 1.0) {
        [SVProgressHUD dismiss];
        if (uploadingFailed) {
            [self showPopupMessage:@"Uploading Failed"];
        } else {
            [self showPopupMessage:@"Uploading Success"];
            
            //parse response
            if (!publicVideoLink || [publicVideoLink isEqualToString:@""]) {
                publicVideoLink = [[NSString alloc] init];
            }
            publicVideoLink = (NSString *)[response valueForKey:PUBLIC_VIDEO_URL];
            
            //show social page
            [self showSocialPage];
        }
    }
}

- (void) recvHttpResponseFailure:(NSString *)response
{
    uploadingFailed = YES;
    
    if (uploadingFailed) {
        [SVProgressHUD dismiss];
        return;
    }
    
    progressValue += 0.25;
    if (progressValue > 1.0) {
        progressValue = 1.0;
    }
    
    [SVProgressHUD showProgress:progressValue status:UPLOADING maskType:SVProgressHUDMaskTypeGradient];
    
    [self showPopupMessage:response];
    
    if (progressValue == 1.0) {
        [SVProgressHUD dismiss];
        [self showPopupMessage:@"Uploading Failed"];
    }
}

- (void) showPopupMessage:(NSString *) message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

#pragma mark - social view controller
- (void) showSocialPage
{
    self.navigationController.navigationBar.topItem.title = ShareViewTitle;
    // start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
                           forView:self.view cache:YES];
    
    [UIView commitAnimations];
    
    if (socialViewController == nil) {
        socialViewController = (SocialViewController *)[[self storyboard] instantiateViewControllerWithIdentifier:@"SocialViewController"];
    }
    
    socialViewController.delegate = self;
    
    [self addChildViewController:socialViewController];
    socialViewController.view.frame = self.view.frame;
    [self.view addSubview:socialViewController.view];
}

#pragma mark - PlayVideo
- (void) playVideo:(NSURL *) _url
{
    moviePlayer =  [[MPMoviePlayerController alloc]
                    initWithContentURL:_url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

#pragma mark - Merge Videos
- (void) startVideoMergeAndThenUpload
{
    [self mergeVideo];
}

- (void) mergeVideo
{
    NSURL *first_url = ((Question *)[currentTopic.questions objectAtIndex:0]).question_response;
    NSURL *second_url = ((Question *)[currentTopic.questions objectAtIndex:1]).question_response;
    NSURL *third_url = ((Question *)[currentTopic.questions objectAtIndex:2]).question_response;
    
    AVAsset *firstAssetUrl = [[AVURLAsset alloc]initWithURL:first_url options:nil];
    AVAsset *secondAssetUrl = [[AVURLAsset alloc]initWithURL:second_url options:nil];
    AVAsset *thirdAssetUrl = [[AVURLAsset alloc]initWithURL:third_url options:nil];
    
    
    NSArray * arrayMovieUrl = [NSArray arrayWithObjects:firstAssetUrl, secondAssetUrl, thirdAssetUrl, nil];
    
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSError * error = nil;
    NSMutableArray * timeRanges = [NSMutableArray arrayWithCapacity:arrayMovieUrl.count];
    
    NSMutableArray * videoTracks = [NSMutableArray arrayWithCapacity:arrayMovieUrl.count];
//    NSMutableArray * audioTracks = [NSMutableArray arrayWithCapacity:arrayMovieUrl.count];
    
    //count total duration
    CMTime audioTrackPos = kCMTimeZero;
    
    for (int i=0; i<[arrayMovieUrl count]; i++) {
        AVURLAsset *assetClip = [arrayMovieUrl objectAtIndex:i];
        
        AVAssetTrack *clipVideoTrackB = [[assetClip tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        BOOL hasAudioTrack = [[assetClip tracksWithMediaType:AVMediaTypeAudio] count] > 0;
        if (hasAudioTrack) {
            AVAssetTrack *clipAudioTrackB = [[assetClip tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
            
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, assetClip.duration)
                                ofTrack:clipAudioTrackB atTime:audioTrackPos error:nil];
        }
        
        [timeRanges addObject:[NSValue valueWithCMTimeRange:CMTimeRangeMake(kCMTimeZero, assetClip.duration)]];
        
        [videoTracks addObject:clipVideoTrackB];

        //chagne audio track position
        audioTrackPos = CMTimeAdd( audioTrackPos, assetClip.duration );
    }
    [compositionVideoTrack insertTimeRanges:timeRanges ofTracks:videoTracks atTime:kCMTimeZero error:&error];
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset640x480];
    NSParameterAssert(exporter != nil);
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.outputURL = url;
    
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@";Export failed: %@", [exporter error]);
                [self showPopupMessage:@"Export failed"];
                
                uploadingFailed = YES;
                [SVProgressHUD dismiss];

                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@";Export canceled");
                [self showPopupMessage:@"Merged Video export canceled."];
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@";Export successfully");
                [self exportDidFinish:exporter];
                break;
            default:
                break;
        }
        if (exporter.status != AVAssetExportSessionStatusCompleted){
            NSLog(@";Retry export");
            [self showPopupMessage:@"Retry export"];
            
            //            [self loadMoviePlayer:outputFileUrl];
            
        }
    }];
}

- (AVAsset *) createAsset:(NSURL *)url
{
    return [AVAsset assetWithURL:url];
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
                        [self showPopupMessage:@"Video Saving Failed"];
                    } else {
                        NSLog(@"Saved merged video to album");
                        localVideoURL = assetURL;
                        [self uploadFourthVideo:assetURL];
//                        [self showSocialPage];
                    }
                });
            }]; //end writeVideo
        }//end if
    }
}

- (void) uploadFourthVideo:(NSURL *) url
{
    HttpEngine *httpEngine = [[HttpEngine alloc] init];
    
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    [dictParameters setValue:[NSString stringWithFormat:@"%@", logger.loginInfo[LOGIN_USER_ID]] forKey:LOGIN_USER_ID];
    [dictParameters setValue:[NSString stringWithFormat:@"%d", currentTopic.story_id] forKey:TOPIC_STORY_ID];
    
    httpEngine.dataSource = self;
    
    BOOL isPhoto = NO;
    
    [httpEngine uploadVideoData:MINISTRY_URL file_url:url params:dictParameters isPhoto: isPhoto];
}

#pragma mark - SocialViewControllerDelegate
- (void) finishThisQuestion
{
    [self.navigationController popViewControllerAnimated:YES];
    
    currentTopic = nil;
    currentTab = 0;
}

- (void) postVideoOnFacebook
{
    FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
    video.videoURL = localVideoURL;
    FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
    content.video = video;
    
    //show share dialog for facebook
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:self];
}

#pragma mark - facebook delegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"facebook sharing completed.");
}

/*!
 @abstract Sent to the delegate when the sharer encounters an error.
 @param sharer The FBSDKSharing that completed.
 @param error The error.
 */
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"facebook error : %@", error.localizedDescription);
    [self showPopupMessage:@"Facebook Error. Please try again."];
}

/*!
 @abstract Sent to the delegate when the sharer is cancelled.
 @param sharer The FBSDKSharing that completed.
 */
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"facebook sharing cancelled");
}

- (void) shareVideoLinkOnTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        @try {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            if (tweetSheet == nil) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Error" message:@"Please check twitter configuration." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                [alertView show];
                return;
            }

            if ([publicVideoLink isEqualToString:@""]) {
                [self showPopupMessage:@"video link is nil"];
                return;
            }

            [tweetSheet addURL:[NSURL URLWithString:publicVideoLink]];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"twitter Exception:%@",exception);
            [self showPopupMessage:@"Twitter Failed"];
        }
        @finally {
            //
        }
    }
}

@end