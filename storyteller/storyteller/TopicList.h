//
//  Topic.h
//  storyteller
//
//  Created by Alin Hila on 8/18/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicList : NSObject

@property (nonatomic, retain) NSMutableArray *topicArray;
@property (nonatomic) BOOL haveData;

- (void) downloadTopicList;
- (void) clearTopicList;

@end
