//
//  SecondQuestionPage.m
//  storyteller
//
//  Created by Alin Hila on 8/17/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ThirdQuestionPage.h"
#import "BubbleViewCell.h"
#import "Config.h"

@interface ThirdQuestionPage()

@property (nonatomic, retain) UICollectionViewCell *topCell;
@property (nonatomic, assign) BOOL displayTopCell;
@property (nonatomic, assign) NSInteger offsetHeight;

@end

@implementation ThirdQuestionPage

@synthesize topCell, displayTopCell, offsetHeight, moviePlayer;

- (void) viewWillAppear:(BOOL)animated
{
    offsetHeight = 0;
    
    displayTopCell = YES;
    
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    
    self.collectionView.backgroundColor = BrightWhiteBlue;
    
    self.senderId = kJSQDemoAvatarIdSquires;
    self.senderDisplayName = kJSQDemoAvatarDisplayNameSquires;
    
    //make up data to show
    self.demoData = [[DemoModelData alloc] initWithQuestion:ThirdQuestionTabIndex - 1];
    
    [self finishSendingMessageAnimated:YES];
    
    //set current tab index
    currentTab = ThirdQuestionTabIndex;
    
    self.navigationController.navigationBar.topItem.title = ThirdQuestionViewTitle;
    
    //define notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(refreshResponseList:) name:NFREFRESHRESPONSELIST object:nil];
    
    passedThirdQuestionPage = YES;
    self.tabBarItem.image = [[UIImage imageNamed:@"third_question"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
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
    offsetHeight = 0;
    
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
    
    if ([indexPath row] == 4) {
        //        [collectionView setContentOffset:CGPointMake(cell.center.x - collectionView.frame.size.width * 0.5, cell.frame.origin.y) animated:YES];
        offsetHeight = cell.frame.origin.y - 7;
    } else if ([indexPath row] == 5) {
        [collectionView setContentOffset:CGPointMake(cell.center.x - collectionView.frame.size.width * 0.5, offsetHeight) animated:YES];
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
        UIViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier:@"ResponseTypeViewController"];
        [self.navigationController pushViewController:mainView animated:YES];
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
        JSQMessage *message = [self.demoData.messages objectAtIndex:3];
        
        JSQVideoMediaItem *videoMessage = (JSQVideoMediaItem *)message.media;
        videoMessage.fileURL = [[currentTopic.questions objectAtIndex:SecondQuestionTabIndex - 1] question_response];
        videoMessage.isReadyToPlay = YES;
        videoMessage.photoType = YES;
        
        //initialize offset
        offsetHeight = 0;
        
        [self.collectionView reloadData];
    });    
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
@end