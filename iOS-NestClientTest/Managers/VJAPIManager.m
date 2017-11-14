//
//  VJAPIManager.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJAPIManager_Private.h"

static NSTimeInterval const VJRequestTimeoutInterval = 30.0;
static NSString *const VJStructuresAPIPath  = @"structures";
static NSString *const VJCameraAPIPath     = @"devices/cameras/%@/";
static NSString *const VJThermostatAPIPath = @"devices/thermostats/%@/";

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

#pragma mark - Private: Setters

- (void)didReceiveAuthorizationTokenUpdatedNotification:(NSNotification *)notification
{
    [self setAccessTokenIfNeeded];
}

- (void)setAccessTokenIfNeeded
{
    _authorizationToken = self.authManager.tokenString;
    [_httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",_authorizationToken] forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Private: Setup

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAuthorizationTokenUpdatedNotification:)
                                                 name:VJReceivedAccessTokenNotification
                                               object:nil];
    
    _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _sessionConfiguration.timeoutIntervalForRequest = VJRequestTimeoutInterval;
    
    NSString* baseAPIURLString = [NSString stringWithFormat:@"%@://%@", VJCommProtocol, VJNestAPIPath];
    
    _baseAPIURL = [NSURL URLWithString:baseAPIURLString];
    
    _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseAPIURL sessionConfiguration:_sessionConfiguration];
    _httpSessionManager.requestSerializer = [AFJSONRequestSerializer new];
    _httpSessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet set];
    _httpSessionManager.securityPolicy.allowInvalidCertificates = YES;
    _httpSessionManager.securityPolicy.validatesDomainName = NO;
    
    __weak __typeof(self) wSelf = self;
    
    [_httpSessionManager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        NSLog(@"Handling redirect to %@", request.URL);
        
        __strong __typeof(self) sSelf = wSelf;
        NSMutableURLRequest* mutableRequest = [request mutableCopy];
        if (sSelf) {
            [mutableRequest setValue:[NSString stringWithFormat:@"Bearer %@",sSelf->_authorizationToken] forHTTPHeaderField:@"Authorization"];
        }
        
        return mutableRequest; // return request to follow the redirect, or return nil to stop the redirect
    }];
    
    [self setAccessTokenIfNeeded];
    [self startMonitoringReachability];
    NSLog(@"API manager started with server url: %@", _httpSessionManager.baseURL.absoluteString);
}

#pragma mark - Public

- (void)getStructuresWithComepletion:(void (^)(NSArray<VJNestStructureModel*>* structures, NSError* error))completion
{
    [self getWithPath:VJStructuresAPIPath params:nil completionHandler:^(id response, NSError *error, BOOL isRequestCanceled, BOOL isGoingOffline) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSDictionary* responseDict = (NSDictionary *)response;
        
        __block NSMutableArray<VJNestStructureModel*>* structuresMutable = [NSMutableArray new];
        
        [responseDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [structuresMutable addObject:[VJNestStructureModel objectWithDictionary:obj]];
        }];
        
        completion(structuresMutable, nil);
    }];
}

- (void)getThermostatWithID:(NSString *)thermostatID completion:(void (^)(VJNestThermostatModel *, NSError *))completion
{
    NSString* thermostatPath = [NSString stringWithFormat:VJThermostatAPIPath, thermostatID];
    [self getWithPath:thermostatPath params:nil completionHandler:^(id response, NSError *error, BOOL isRequestCanceled, BOOL isGoingOffline) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        completion([VJNestThermostatModel objectWithDictionary:response], nil);
    }];
}

- (void)setThermostatDataWithThermostat:(VJNestThermostatModel *)thermostat completion:(VJGenericErrorBlock)completion
{
    NSString* thermostatPath = [NSString stringWithFormat:VJThermostatAPIPath, thermostat.deviceID];
    [self putWithPath:thermostatPath params:thermostat.modelDictionary completionHandler:^(id response, NSError *error, BOOL isRequestCanceled, BOOL isGoingOffline) {
        completion(error);
    }];
}

- (void)getCameraWithID:(NSString *)cameraID completion:(void (^)(VJNestCameraModel *, NSError *))completion
{
    NSString* cameraPath = [NSString stringWithFormat:VJCameraAPIPath, cameraID];
    
    [self getWithPath:cameraPath params:nil completionHandler:^(id response, NSError *error, BOOL isRequestCanceled, BOOL isGoingOffline) {
        
    }];
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
    [self postWithPath:path sessionManager:_httpSessionManager params:params completionHandler:completion];
}

- (void)postWithPath:(NSString *)path
      sessionManager:(AFHTTPSessionManager *)sessionManager
              params:(NSDictionary *)params
   completionHandler:(APIRequestGenericHandler)completion
{
    if ([self handleConnectionAbsenceWithRequestCompletion:completion]) {
        return;
    }
    
    NSLog(@"Started POST request with path: %@ with params: %@", path, params);
    
    __weak typeof(self) wSelf = self;
    
    [sessionManager POST:[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
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

@implementation NSObject(APIManager)

- (VJAPIManager *)apiManager
{
    return [VJAPIManager sharedInstance];
}

@end
