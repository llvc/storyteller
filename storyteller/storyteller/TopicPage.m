//
//  TopicPage.m
//  storyteller
//
//  Created by Alin Hila on 8/17/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TopicPage.h"
#import "Config.h"
#import "MainTabViewController.h"

@interface TopicPage()

@end

@implementation TopicPage

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = TopicViewTitle;
    
    //set current tab
    currentTab = TopicTabIndex;
    
    self.tabBarItem.image = [[UIImage imageNamed:@"topic"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    passedTopicPage = YES;
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [topicList.topicArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *story = [topicList.topicArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = story[TOPIC_STORY_TITLE];
    
    //set font & color
    UIFont *cellFont = [UIFont fontWithName:TopicFontFamily size:TopicFontSize];
    [cell.textLabel setFont:cellFont];
    [cell.textLabel setTextColor:TopicFontColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *story = [topicList.topicArray objectAtIndex:[indexPath row]];
    
    currentTopic = [[Topic alloc] init];
    
    //get current topic info
    currentTopic.story_description = story[TOPIC_STORY_DESCRIPTION];
    currentTopic.story_id = [story[TOPIC_STORY_ID] intValue];
    currentTopic.story_title = story[TOPIC_STORY_TITLE];

    for (NSDictionary *_question in story[TOPIC_QUESTION_DESCRIPTION]) {
        Question *question = [[Question alloc] init];
        question.question_id = [_question[TOPIC_QUESTION_ID] intValue];
        question.question_description = _question[TOPIC_QUESTION_DESCRIPTION];
        
        [currentTopic.questions addObject:question];
    }
    
    passedFirstQuestionPage = NO;
    passedSecondQuestionPage = NO;
    passedThirdQuestionPage = NO;
    passedUploadingPage = NO;
    
    //enable first question tab
    MainTabViewController *mainTabViewController = (MainTabViewController *)self.tabBarController;
    [mainTabViewController setTabbarItemImage];
    [mainTabViewController setTabbarItemStatus];
    [mainTabViewController setSelectedIndex:1];
}

@end