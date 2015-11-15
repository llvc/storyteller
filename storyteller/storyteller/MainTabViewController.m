//
//  MainTabViewController.m
//  storyteller
//
//  Created by Alin Hila on 8/17/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MainTabViewController.h"
#import "Config.h"
#import "FirstQuestionPage.h"

@interface MainTabViewController()


@end

@implementation MainTabViewController

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor = DarkBlue_Background_Color;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setHidesBackButton:YES];
    
//    UITabBarItem *item = [self.tabBar.items objectAtIndex:2];
//    item.image = [[UIImage imageNamed:@"first_question"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    item.selectedImage = [[UIImage imageNamed:@"first_question_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self setTabbarItemImage];
    [self setTabbarItemStatus];
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)backToLoginPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    currentTopic = nil;
    currentTab = 0;
}

- (void) setTabbarItemImage
{
    UITabBarItem *item;
    
    //topic tab
    item = [self.tabBar.items objectAtIndex:TopicTabIndex];
    if (passedTopicPage) {
        item.image = [[UIImage imageNamed:@"topic"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        item.image = [[UIImage imageNamed:@"topic_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    item.selectedImage = [[UIImage imageNamed:@"topic_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //first tab
    item = [self.tabBar.items objectAtIndex:FirstQuestionTabIndex];
    if (passedFirstQuestionPage) {
        item.image = [[UIImage imageNamed:@"first_question"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        item.image = [[UIImage imageNamed:@"first_question_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    item.selectedImage = [[UIImage imageNamed:@"first_question_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //second tab
    item = [self.tabBar.items objectAtIndex:SecondQuestionTabIndex];
    if (passedSecondQuestionPage) {
        item.image = [[UIImage imageNamed:@"second_question"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        item.image = [[UIImage imageNamed:@"second_question_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    item.selectedImage = [[UIImage imageNamed:@"second_question_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //third tab
    item = [self.tabBar.items objectAtIndex:ThirdQuestionTabIndex];
    if (passedThirdQuestionPage) {
        item.image = [[UIImage imageNamed:@"third_question"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        item.image = [[UIImage imageNamed:@"third_question_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    item.selectedImage = [[UIImage imageNamed:@"third_question_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //upload tab
    item = [self.tabBar.items objectAtIndex:UploadTabIndex];
    if (passedUploadingPage) {
        item.image = [[UIImage imageNamed:@"upload"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        item.image = [[UIImage imageNamed:@"upload_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    item.selectedImage = [[UIImage imageNamed:@"upload_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void) setTabbarItemStatus
{
    UITabBarItem *item;
    
    //topic tab
    item = [self.tabBar.items objectAtIndex:TopicTabIndex];
    [item setEnabled:YES];
    
    if (currentTopic == nil) {
        [[self.tabBar.items objectAtIndex:FirstQuestionTabIndex] setEnabled:NO];
        [[self.tabBar.items objectAtIndex:SecondQuestionTabIndex] setEnabled:NO];
        [[self.tabBar.items objectAtIndex:ThirdQuestionTabIndex] setEnabled:NO];
        [[self.tabBar.items objectAtIndex:UploadTabIndex] setEnabled:NO];
        return;
    }
    
    //first tab
    item = [self.tabBar.items objectAtIndex:FirstQuestionTabIndex];
    if (currentTopic.story_id) {
        [item setEnabled:YES];
    } else {
        [item setEnabled:NO];
    }
    
    //second tab
    item = [self.tabBar.items objectAtIndex:SecondQuestionTabIndex];
    if ( [[currentTopic.questions objectAtIndex:0] question_response]) {
        [item setEnabled:YES];
    } else {
        [item setEnabled:NO];
    }
    
    //third tab
    item = [self.tabBar.items objectAtIndex:ThirdQuestionTabIndex];
    if ( [[currentTopic.questions objectAtIndex:1] question_response] ) {
        [item setEnabled:YES];
    } else {
        [item setEnabled:NO];
    }
    
    //upload tab
    item = [self.tabBar.items objectAtIndex:UploadTabIndex];
    if ( [[currentTopic.questions objectAtIndex:2] question_response] ) {
        [item setEnabled:YES];
    } else {
        [item setEnabled:NO];
    }
}

@end