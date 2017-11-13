//
//  VJApiManager_Private.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#ifndef VJApiManager_Private_h
#define VJApiManager_Private_h

#import "VJAPIManager.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "VJAuthToken.h"
#import "VJAuthManager.h"

static NSString *const VJCommProtocol = @"https";



typedef void (^APIRequestGenericHandler)(id response, NSError* error, BOOL isRequestCanceled, BOOL isGoingOffline);

@interface VJAPIManager()
{
    NSURLSessionConfiguration*      _sessionConfiguration;
    AFNetworkReachabilityManager*   _reachabilityManager;
    AFHTTPSessionManager*           _httpSessionManager;
    NSURL*                          _baseAPIURL;
}

@property (nonatomic, copy) NSString* authorizationToken;
@property (nonatomic, strong) dispatch_queue_t processingQueue;


- (void)putWithPath:(NSString *)path
             params:(NSDictionary *)params
  completionHandler:(APIRequestGenericHandler)completion;

- (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
   completionHandler:(APIRequestGenericHandler)completion;

- (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
  completionHandler:(APIRequestGenericHandler)completion;

- (void)deleteWithPath:(NSString *)path
                params:(NSDictionary *)params
     completionHandler:(APIRequestGenericHandler)completion;

@end


#endif /* VJApiManager_Private_h */
