//
//  SecondQuestionPage.h
//  storyteller
//
//  Created by Alin Hila on 8/17/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "JSQMessages.h"
#import "DemoModelData.h"

@interface SecondQuestionPage : JSQMessagesViewController

@property (strong, nonatomic) DemoModelData *demoData;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

- (void) refreshResponseList:(NSNotification *) note;

@end
