//
//  SocialViewController.m
//  storyteller
//
//  Created by Alin Hila on 9/11/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import "SocialViewController.h"

@implementation SocialViewController

- (IBAction) pressedFacebookBtn:(id)sender
{
    if (self.delegate != nil && [(id)self.delegate respondsToSelector:@selector(postVideoOnFacebook)]){
        [(id)self.delegate performSelector:@selector(postVideoOnFacebook) withObject:nil];
    }
}

- (IBAction) pressedTwitterBtn:(id)sender
{
    if (self.delegate != nil && [(id)self.delegate respondsToSelector:@selector(shareVideoLinkOnTwitter)]){
        [(id)self.delegate performSelector:@selector(shareVideoLinkOnTwitter) withObject:nil];
    }
}

- (IBAction) pressedFinishBtn:(id)sender
{
    if (self.delegate != nil && [(id)self.delegate respondsToSelector:@selector(finishThisQuestion)]){
        [(id)self.delegate performSelector:@selector(finishThisQuestion) withObject:nil];
    }
}

@end
