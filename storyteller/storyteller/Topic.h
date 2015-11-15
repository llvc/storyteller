//
//  Topic.h
//  storyteller
//
//  Created by Alin Hila on 8/18/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Question.h"

@interface Topic : NSObject

@property (nonatomic, retain) NSString *story_description;
@property (nonatomic) int story_id;
@property (nonatomic, retain) NSString *story_title;
@property (nonatomic, retain) NSMutableArray *questions;

@end
