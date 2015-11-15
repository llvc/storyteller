//
//  Logger.m
//  storyteller
//
//  Created by Alin Hila on 8/18/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Logger.h"
#import "HttpEngine.h"
#import "Config.h"

#import "SVProgressHUD.h"

@interface Logger() <HttpEngineDelegate>



@end

@implementation Logger 

@synthesize loginInfo, haveData;

- (Logger *) init
{
    self = [super init];
    
    if (self) {
        loginInfo = [[NSMutableDictionary alloc] init];
        haveData = NO;
    }
    
    return self;
}

- (void) downloadLoginInfo:(NSString *)userName
{
    HttpEngine *httpEngine = [[HttpEngine alloc] init];
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    [dictParameters setValue:userName forKey:@"name"];
    httpEngine.dataSource = self;
    [httpEngine sndHttpRequest:Login_Request params:dictParameters];
}


- (void) clearLoginInfo
{
//    [self.loginInfo removeAllObjects];
    self.haveData = NO;
}

#pragma mark -- HttpEngineDelegate
- (void) recvHttpResponseSuccess:(id) _response
{
    NSMutableDictionary *response = (NSMutableDictionary *)_response;
    
    if ([response[SUCCESS] boolValue]) {
        self.haveData = YES;
        self.loginInfo = response;
        
        //download topic list
        [topicList downloadTopicList];
    }
}

- (void) recvHttpResponseFailure:(NSString *) response
{
    [SVProgressHUD dismiss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Login failed." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alertView show];
}


@end