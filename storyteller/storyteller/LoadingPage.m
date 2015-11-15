//
//  LoadingPage.m
//  storyteller
//
//  Created by Alin Hila on 8/16/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadingPage.h"
#import "Config.h"

@interface LoadingPage()
@end

@implementation LoadingPage

@synthesize loadingSpin;

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

    [self runSpinAnimationOnView:loadingSpin duration:SPIN_SPEED rotations:360 repeat:MAXFLOAT];
}

- (void) viewDidAppear:(BOOL)animated
{
    [NSTimer scheduledTimerWithTimeInterval:LoadingPage_Last_Time
                                     target:self
                                   selector:@selector(moveToLandingPage:)
                                   userInfo:nil
                                    repeats:NO ];
}

- (void) runSpinAnimationOnView:(UIImageView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0  * rotations ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    rotationAnimation.speed = 0.2f;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

//move to landing page
- (void) moveToLandingPage:(id)sender
{
    UIViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginPage"];
    [self.navigationController pushViewController:mainView animated:YES];
}

@end