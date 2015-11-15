//
//  LandingPage.m
//  storyteller
//
//  Created by Alin Hila on 8/16/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LandingPage.h"
#import "Config.h"

@interface LandingPage()

@end

@implementation LandingPage

@synthesize landingSpin, subtitle;

- (void) viewWillAppear:(BOOL)animated
{
    //spin landing image
    [self.navigationController setNavigationBarHidden:YES];

    [self runSpinAnimationOnView:landingSpin duration:SPIN_SPEED rotations:360 repeat:MAXFLOAT];
}

- (IBAction)gotoLoginPage:(id)sender
{
    UIViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginPage"];
    [self.navigationController pushViewController:mainView animated:YES];
}

//spin landing image
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

@end