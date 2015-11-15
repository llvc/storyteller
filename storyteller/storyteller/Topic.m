//
//  Topic.m
//  storyteller
//
//  Created by Alin Hila on 8/18/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Topic.h"

@implementation Topic

@synthesize story_description, story_id, story_title, questions;

- (Topic *) init
{
    self = [super init];
    
    if (self) {
        questions = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end