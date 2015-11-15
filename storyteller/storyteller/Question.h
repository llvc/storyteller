//
//  Question.h
//  storyteller
//
//  Created by Alin Hila on 8/18/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Question : NSObject

@property (nonatomic) int question_id;
@property (nonatomic, retain) NSString *question_description;
@property (nonatomic, retain) NSURL *question_response;
@property (nonatomic) NSString *responseType;

@end
