//
//  LoginPage.m
//  storyteller
//
//  Created by Alin Hila on 8/16/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginPage.h"
#import "Config.h"
#import "IQKeyboardManager.h"

#import "SVProgressHUD.h"

@interface LoginPage() <UITextFieldDelegate>

- (void) clearAllStory;

@end

@implementation LoginPage

@synthesize userName;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:self.class];
    [IQKeyboardManager sharedManager].enable = FALSE;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [userName setDelegate:self];
    
    //define notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(gotoMainTabView:) name:NFGOTOTABVIEW object:nil];
    
    [self clearAllStory];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:self.class];
    [IQKeyboardManager sharedManager].enableAutoToolbar = FALSE;
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:NFGOTOTABVIEW object:nil];
}

//dismiss keyboard
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userName resignFirstResponder];
}

- (void) clearAllStory
{
    [logger clearLoginInfo];
    [topicList clearTopicList];
}

#pragma mark -- textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [SVProgressHUD showWithStatus:@"Login..." maskType:SVProgressHUDMaskTypeGradient];
    [logger downloadLoginInfo: self.userName.text];
    
    return true;
}

#pragma mark -- notification
- (void) gotoMainTabView:(NSNotification*) note
{
    [SVProgressHUD dismiss];
    
    UIViewController *mainView = [[self storyboard] instantiateViewControllerWithIdentifier:@"MainTabViewController"];
    [self.navigationController pushViewController:mainView animated:YES];
}

@end