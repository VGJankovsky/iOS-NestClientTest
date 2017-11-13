//
//  VJAPIManager.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJAPIManager_Private.h"



@implementation VJAPIManager

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    __strong static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[super alloc] initUniqueInstance];
    });
    
    return _sharedObject;
}

- (id)copy
{
    return self;
}

- (id)init
{
    return nil;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

#pragma mark - Private

#pragma mark - Private: Setters

- (void)setAuthorizationToken:(NSString *)authorizationToken
{
//    _authorizationToken = [authorizationToken copy];
//
//    [_httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Token token=%@",_authorizationToken] forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Private: Setup

- (void)setup
{
    _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    _sessionConfiguration.timeoutIntervalForRequest = STRequestTimeoutInterval;
    
    NSString* baseAPIURLString = [NSString stringWithFormat:@"%@://%@", VJCommProtocol, VJNestAPIPath];
    
    _baseAPIURL = [NSURL URLWithString:baseAPIURLString];
    
    _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseAPIURL sessionConfiguration:_sessionConfiguration];
    _httpSessionManager.requestSerializer = [AFJSONRequestSerializer new];
    _httpSessionManager.securityPolicy.allowInvalidCertificates = YES;
    
//    self.authorizationToken = [STConfigurationStorage authToken];
    
    self.processingQueue = dispatch_queue_create("apimanager.response.processing.queue", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"API manager started with server url: %@", _httpSessionManager.baseURL.absoluteString);
}

#pragma mark - Private: API



#pragma mark - Public

- (void)getAuthorizationTokenWithCode:(NSString *)code completion:(void (^)(VJAuthToken *, NSError *))completion
{
    
}

- (BOOL)isThereInternetConnection
{
    return _reachabilityManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

- (void)startMonitoringReachability
{
    NSLog(@"API manager started monitoring reachability");
    
    _reachabilityManager = [AFNetworkReachabilityManager managerForDomain:VJReachabilityReferenceDomain];
    
    [_reachabilityManager setReachabilityStatusChangeBlock:nil];
    
    [_reachabilityManager startMonitoring];
}

- (void)clearCredentials
{
    [self setAuthorizationToken:nil];
}

#pragma mark - Private

- (void)putWithPath:(NSString *)path params:(NSDictionary *)params completionHandler:(APIRequestGenericHandler)completion
{
    if ([self handleConnectionAbsenceWithRequestCompletion:completion]) {
        return;
    }
    
    NSLog(@"Started PUT request with path: %@ with params: %@", path, params);
    
    __weak typeof(self) wSelf = self;
    
    [_httpSessionManager PUT:[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Successed PUT request URL: %@", [task.originalRequest.URL absoluteString]);
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf requestSuccessHandlerWithTask:task responseObject:responseObject completion:completion];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Failed PUT request URL: %@", [task.originalRequest.URL absoluteString]);
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf requestFailureHandlerWithTask:task error:error completion:completion];
    }];
}

- (void)postWithPath:(NSString *)path params:(NSDictionary *)params completionHandler:(APIRequestGenericHandler)completion
{
    if ([self handleConnectionAbsenceWithRequestCompletion:completion]) {
        return;
    }
    
    NSLog(@"Started POST request with path: %@ with params: %@", path, params);
    
    __weak typeof(self) wSelf = self;
    
    [_httpSessionManager POST:[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"Successed POST request URL: %@", [task.originalRequest.URL absoluteString]);
                          __strong typeof(wSelf) sSelf = wSelf;
                          [sSelf requestSuccessHandlerWithTask:task responseObject:responseObject completion:completion];
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Failed POST request URL: %@", [task.originalRequest.URL absoluteString]);
                          __strong typeof(wSelf) sSelf = wSelf;
                          [sSelf requestFailureHandlerWithTask:task error:error completion:completion];
                      }];
}

- (void)getWithPath:(NSString *)path params:(NSDictionary *)params completionHandler:(APIRequestGenericHandler)completion
{
    if ([self handleConnectionAbsenceWithRequestCompletion:completion]) {
        return;
    }
    
    NSLog(@"Started GET request with path: %@ with params: %@", path, params);
    
    __weak typeof(self) wSelf = self;
    
    [_httpSessionManager GET:[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"Successed GET request URL: %@", [task.originalRequest.URL absoluteString]);
                         __strong typeof(wSelf) sSelf = wSelf;
                         [sSelf requestSuccessHandlerWithTask:task responseObject:responseObject completion:completion];
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Failed GET request URL: %@", [task.originalRequest.URL absoluteString]);
                         __strong typeof(wSelf) sSelf = wSelf;
                         [sSelf requestFailureHandlerWithTask:task error:error completion:completion];
                     }];
}

- (void)deleteWithPath:(NSString *)path params:(NSDictionary *)params completionHandler:(APIRequestGenericHandler)completion
{
    if ([self handleConnectionAbsenceWithRequestCompletion:completion]) {
        return;
    }
    
    NSLog(@"Started DELETE request with path: %@ with params: %@", path, params);
    
    __weak typeof(self) wSelf = self;
    
    [_httpSessionManager DELETE:[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                     parameters:params
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            NSLog(@"Successed DELETE request URL: %@", [task.originalRequest.URL absoluteString]);
                            __strong typeof(wSelf) sSelf = wSelf;
                            [sSelf requestSuccessHandlerWithTask:task responseObject:responseObject completion:completion];
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            NSLog(@"Failed DELETE request URL: %@", [task.originalRequest.URL absoluteString]);
                            __strong typeof(wSelf) sSelf = wSelf;
                            [sSelf requestFailureHandlerWithTask:task error:error completion:completion];
                        }];
}

- (BOOL)handleConnectionAbsenceWithRequestCompletion:(APIRequestGenericHandler)completion
{
    if (self.isThereInternetConnection)
        return NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, [NSError new], NO, YES);
    });
    
    
    return YES;
}

#pragma mark - Private: Response handling

- (void)requestSuccessHandlerWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject completion:(APIRequestGenericHandler)completion
{
    NSLog(@"Response: %@", responseObject);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion)
            completion(responseObject, nil, NO, NO);
    });
}

- (void)requestFailureHandlerWithTask:(NSURLSessionDataTask *)task error:(NSError *)error completion:(APIRequestGenericHandler)completion
{
    
    NSLog(@"Error description: %@", [error localizedDescription]);
    
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    
    if (errorData)
    {
        NSString* errorDataString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSLog(@"Error response data: %@", errorDataString);
    }
    

    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion)
            completion(nil, error, error.code == NSURLErrorCancelled, NO);
    });
}

@end
