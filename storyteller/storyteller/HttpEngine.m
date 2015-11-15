//
//  HttpEngine.m
//  storyteller
//
//  Created by Alin Hila on 8/18/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import "HttpEngine.h"
#import "AFNetworking.h"
#import "Config.h"

#import <AssetsLibrary/AssetsLibrary.h>

@implementation HttpEngine

@synthesize dataSource;

- (void) sndHttpRequest:(NSString *)url params:(NSMutableDictionary *)params
{
    NSLog(@"client  -->  server:");
    NSLog(@"%@", url);
    
    NSURL *serverURL =[NSURL URLWithString:url];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:serverURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    [manager POST:@"" parameters:params success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"server  -->  client(success):");
         NSLog(@"%@", responseObject);
         
         if (!self.dataSource) {
             NSLog(@"datasource is null");
             return;
         }
         
         if ([self.dataSource respondsToSelector:@selector(recvHttpResponseSuccess:)]) {
             [self.dataSource recvHttpResponseSuccess:responseObject];
         } else {
             NSLog(@"Not implemented recvHttpResponseSuccess method");
         }
         
         self.dataSource = nil;
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"server  -->  client(failure):");
         NSLog(@"%@", [error description]);
         
         if (!self.dataSource) {
             NSLog(@"datasource is null");
             return;
         }
         
         if ([self.dataSource respondsToSelector:@selector(recvHttpResponseFailure:)]) {
             [self.dataSource recvHttpResponseFailure:[error description]];
         } else {
             NSLog(@"Not implemented recvHttpResponseFailure method");
         }
         
         self.dataSource = nil;
     }];
}

- (void) uploadVideoData:(NSString *)server_url file_url:(NSURL *)_file_url params:(NSMutableDictionary *)params isPhoto:(BOOL) isPhoto
{
    NSLog(@"client --> server(uploading photo/video) : %@", _file_url);
    
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:_file_url resultBlock:^(ALAsset *asset) // substitute YOURURL with your url of video
     {
         ALAssetRepresentation *rep = [asset defaultRepresentation];

         NSData *movie;
         
         if (isPhoto) { //photo
             CGImageRef iref = [rep fullScreenImage];
             if (iref) {
                 UIImage *image_bg = [UIImage imageWithCGImage:iref];
                 movie = UIImagePNGRepresentation(image_bg);
             } else {
                 NSLog(@"Error getting photo");
                 
                 if (!self.dataSource) {
                     NSLog(@"datasource is null");
                     return;
                 }
                 
                 if ([self.dataSource respondsToSelector:@selector(recvHttpResponseFailure:)]) {
                     [self.dataSource recvHttpResponseFailure:@"Error getting photo"];
                 } else {
                     NSLog(@"Not implemented recvHttpResponseFailure method");
                 }
                 
                 self.dataSource = nil;
                 
                 return;
             }
         } else { //video
             Byte *buffer = (Byte*)malloc(rep.size);
             NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
             if (buffered > 0) {
                 movie = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
             } else {
                 movie = [NSData dataWithContentsOfURL:_file_url];
             }
         }
         
         if (movie == nil) {
             NSLog(@"movie is null");
             
             if (!self.dataSource) {
                 NSLog(@"datasource is null");
                 return;
             }
             
             if ([self.dataSource respondsToSelector:@selector(recvHttpResponseFailure:)]) {
                 [self.dataSource recvHttpResponseFailure:@"movie is null"];
             } else {
                 NSLog(@"Not implemented recvHttpResponseFailure method");
             }
             
             self.dataSource = nil;
             
             return;
         }
       
         NSURL *mainURL =[NSURL URLWithString:server_url];
         
         AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:mainURL];
         manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
         manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
         manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
         
         
         [manager POST:@"" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
          {
              if (isPhoto) {
                  [formData appendPartWithFileData:movie
                                              name:@"video"
                                          fileName:[NSString stringWithFormat:@"photo_%@.png",params[QUESTION_ID]]
                                          mimeType:@"image/png"];
              } else {
                  [formData appendPartWithFileData:movie
                                              name:@"video"
                                          fileName:[NSString stringWithFormat:@"video_%@.mp4",params[QUESTION_ID]]
                                          mimeType:@"video"];
              }
              
          }
               success:^(NSURLSessionDataTask *task, id responseObject)
          {
              
              NSDictionary *scoresData = responseObject;
              NSDictionary *json = [NSDictionary dictionaryWithDictionary:responseObject];
              
              if (!json)
              {
                  NSLog(@"Error parsing JSON:ProfileUser");
              }
              else
              {
                  scoresData  = [NSDictionary dictionaryWithDictionary:json];
              }
              
              if ([[scoresData valueForKey:@"message"]isEqualToString:@"successful"])
              {
                  NSLog(@"Video uploaded successfully.");
                  
                  if (!self.dataSource) {
                      NSLog(@"datasource is null");
                      return;
                  }
                  
                  NSLog(@"server --> client (uploading success) : %@", responseObject);
                  
                  if ([self.dataSource respondsToSelector:@selector(recvHttpResponseSuccess:)]) {
                      [self.dataSource recvHttpResponseSuccess:responseObject];
                  } else {
                      NSLog(@"Not implemented recvHttpResponseSuccess method");
                  }
              } else {
                  NSLog(@"server --> client (Uploading error): %@", scoresData);
                  
                  if (!self.dataSource) {
                      NSLog(@"datasource is null");
                      return;
                  }
                  
                  if ([self.dataSource respondsToSelector:@selector(recvHttpResponseFailure:)]) {
                      [self.dataSource recvHttpResponseFailure:[scoresData valueForKey:@"message"]];
                  } else {
                      NSLog(@"Not implemented recvHttpResponseFailure method");
                  }
                  
                  self.dataSource = nil;
              }
          }
               failure:^(NSURLSessionDataTask *task, NSError *error)
          {
              NSLog(@"server --> client (uploading error)");
              
              NSLog(@"Request Code: %@", task.response.debugDescription);
              NSLog(@"Request URL: %@", [[task.originalRequest URL] absoluteString]);
              NSLog(@"Request Body: %@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
              NSLog(@"Error: %@", error.description);
              
              if (!self.dataSource) {
                  NSLog(@"datasource is null");
                  return;
              }
              
              if ([self.dataSource respondsToSelector:@selector(recvHttpResponseFailure:)]) {
                  [self.dataSource recvHttpResponseFailure:[error description]];
              } else {
                  NSLog(@"Not implemented recvHttpResponseFailure method");
              }
              
              self.dataSource = nil;
          }];
         
     }
     failureBlock:^(NSError *err) {
         NSLog(@"Error: %@",[err localizedDescription]);
         
         if (!self.dataSource) {
             NSLog(@"datasource is null");
             return;
         }
         
         if ([self.dataSource respondsToSelector:@selector(recvHttpResponseFailure:)]) {
             [self.dataSource recvHttpResponseFailure:[err description]];
         } else {
             NSLog(@"Not implemented recvHttpResponseFailure method");
         }
         
         self.dataSource = nil;
     }];
}

@end
