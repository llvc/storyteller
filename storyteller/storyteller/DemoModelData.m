//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "DemoModelData.h"
#import "Config.h"

#import <AssetsLibrary/AssetsLibrary.h>

/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

@implementation DemoModelData

- (instancetype)initWithQuestion:(int) __questionNum
{
    self = [super init];
    if (self) {
        self.questionNum = __questionNum;
        
        [self loadFakeMessages];
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        
        self.users = @{ kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz,
                        kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires };
        
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:DarkBlue_Background_Color];
    }
    
    return self;
}

- (void)loadFakeMessages
{
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
    self.messages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= self.questionNum; i++) {
        if (i == UploadTabIndex - 1) {
            [self addUploadMediaMessage];
            return;
        }
        [self addQuestionMessage:i];
        [self addResponseQuestion:i];
    }
}

- (void) addQuestionMessage:(int)num
{
    [self.messages addObject:[[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdWoz
                                                senderDisplayName:kJSQDemoAvatarDisplayNameWoz
                                                             date:[NSDate distantPast]
                                                             text:[[currentTopic.questions objectAtIndex:num] question_description]]];
}

- (void) addResponseQuestion:(int)num
{
    if (num == self.questionNum) {
        [self addRecordMediaMessage];
        return;
    }
    
    NSString *responseType = [[currentTopic.questions objectAtIndex:num] responseType];
    NSURL *responseUrl = [[currentTopic.questions objectAtIndex:num] question_response];
    
    if ([responseType isEqualToString:VideoResponse]) {
        [self addVideoMediaMessage:responseUrl];
    } else if ( [responseType isEqualToString:PhotoTextResponse] ) {
        [self addPhotoMediaMessage:responseUrl];
    } else {
        [self addRecordMediaMessage];
    }
}

- (void)addUploadMediaMessage
{
    JSQRawImageItem *photoItem = [[JSQRawImageItem alloc] initWithImage:[UIImage imageNamed:@"upload_bubble"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addRecordMediaMessage
{
    JSQRawImageItem *photoItem = [[JSQRawImageItem alloc] initWithImage:[UIImage imageNamed:@"record_bubble"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addPhotoMediaMessage:(NSURL *) _url
{
    NSURL *videoURL = _url;
    
    JSQVideoMediaItem *videoItem;

    if ([videoURL.path isEqualToString:@"/file:"]) {
        videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:nil isReadyToPlay:NO];
    } else {
        videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    }
    
    videoItem.photoType = YES;
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
//    UIImage *image = [[currentTopic.questions objectAtIndex:num] photo_response];
//    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];
//    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
//                                                   displayName:kJSQDemoAvatarDisplayNameSquires
//                                                         media:photoItem];
//    [self.messages addObject:photoMessage];
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    //    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    //
    //    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    //    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    //
    //    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
    //                                                      displayName:kJSQDemoAvatarDisplayNameSquires
    //                                                            media:locationItem];
    //    [self.messages addObject:locationMessage];
    JSQRawImageItem *photoItem = [[JSQRawImageItem alloc] initWithImage:[UIImage imageNamed:@"record_bubble"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addVideoMediaMessage:(NSURL *) _url
{
    // don't have a real video, just pretending
    NSURL *videoURL = _url;
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}

@end
