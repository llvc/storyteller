//
//  Topic.m
//  storyteller
//
//  Created by Alin Hila on 8/18/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import "TopicList.h"
#import "HttpEngine.h"
#import "Config.h"

@interface TopicList() <HttpEngineDelegate>

@end

@implementation TopicList

@synthesize topicArray, haveData;

- (TopicList *) init
{
    self = [super init];
    
    if (self) {
        topicArray = [[NSMutableArray alloc] init];
        haveData = NO;
    }
    
    return self;
}

- (void) downloadTopicList
{
    //get topics from server
    HttpEngine *httpEngine = [[HttpEngine alloc] init];
    
    httpEngine.dataSource = self;
    [httpEngine sndHttpRequest:Topic_Download_Request params:nil];
}

- (void) clearTopicList
{
//    [self.topicArray removeAllObjects];
    self.haveData = NO;
}

#pragma mark -- HttpEngineDelegate
- (void) recvHttpResponseSuccess:(id) _response
{
    NSMutableDictionary *response = (NSMutableDictionary *)_response;
    
    if ([response[SUCCESS] boolValue]) {
        self.topicArray = response[TOPIC_STORY_DATA];
        self.haveData = YES;
        
        //show tab view
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:NFGOTOTABVIEW object:nil];
    }

}

- (void) recvHttpResponseFailure:(NSString *) response
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Topic download Error" message:response delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alertView show];
}

@end