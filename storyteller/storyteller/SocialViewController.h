//
//  SocialViewController.h
//  storyteller
//
//  Created by Alin Hila on 9/11/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SocialViewControllerDelegate <NSObject>

- (void) finishThisQuestion;

@optional
- (void) postVideoOnFacebook;
- (void) shareVideoLinkOnTwitter;

@end

@interface SocialViewController : UIViewController

@property (nonatomic, weak) id<SocialViewControllerDelegate> delegate;

- (IBAction) pressedFacebookBtn:(id)sender;
- (IBAction) pressedTwitterBtn:(id)sender;
- (IBAction) pressedFinishBtn:(id)sender;

@end

