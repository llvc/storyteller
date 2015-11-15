//
//  Logger.h
//  storyteller
//
//  Created by Alin Hila on 8/18/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logger : NSObject

@property (nonatomic, retain) NSMutableDictionary *loginInfo;
@property (nonatomic) BOOL haveData;

- (void) downloadLoginInfo:(NSString *)userName;
- (void) clearLoginInfo;

@end
