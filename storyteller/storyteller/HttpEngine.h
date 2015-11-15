//
//  HttpEngine.h
//  storyteller
//
//  Created by Alin Hila on 8/18/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HttpEngineDelegate <NSObject>

@optional
- (void) recvHttpResponseSuccess:(id) response;
- (void) recvHttpResponseFailure:(NSString *) response;

@end

@interface HttpEngine : NSObject

@property (weak) id <HttpEngineDelegate> dataSource;

- (void) sndHttpRequest:(NSString *)url params:(NSMutableDictionary *)params;
- (void) uploadVideoData:(NSString *)server_url file_url:(NSURL *)file_url params:(NSMutableDictionary *)params isPhoto:(BOOL) isPhoto;

@end

