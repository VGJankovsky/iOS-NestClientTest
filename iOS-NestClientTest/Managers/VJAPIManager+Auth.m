//
//  VJAPIManager+Auth.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJApiManager_Private.h"
#import "VJAPIManager+Auth.h"

static NSString *const VJNestOathPath = @"oauth2/access_token";
static NSString *const VJAuthCodeKey  = @"code";
static NSString *const VJClientIDKey  = @"client_id";
static NSString *const VJClientSecretKey = @"client_secret";
static NSString *const VJGrantTypeKey    = @"grant_type";
static NSString *const VJGrantTypeValue  = @"authorization_code";

@implementation VJAPIManager (Auth)

- (void)setupAuthSessionManagerIfNeeded
{
    if (!_authSessionManager) {
        NSURLSessionConfiguration* sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //    _sessionConfiguration.timeoutIntervalForRequest = STRequestTimeoutInterval;
        
        NSString* baseAPIURLString = [NSString stringWithFormat:@"https://api.%@/", VJNestCurrentAPIDomain];
        
        NSURL* baseAPIURL = [NSURL URLWithString:baseAPIURLString];
        
        _authSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseAPIURL sessionConfiguration:sessionConfiguration];
        _authSessionManager.requestSerializer = [AFHTTPRequestSerializer new];
        _authSessionManager.securityPolicy.allowInvalidCertificates = YES;
        _authSessionManager.securityPolicy.validatesDomainName = NO;
        [_authSessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSLog(@"Auth session manager started with server url: %@", _authSessionManager.baseURL.absoluteString);
    }
}


- (void)getAuthorizationTokenWithCode:(NSString *)code completion:(void (^)(VJAuthToken * token, NSError * error))completion
{
    [self setupAuthSessionManagerIfNeeded];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    
    [params setValue:code forKey:VJAuthCodeKey];
    [params setValue:VJNestProductID forKey:VJClientIDKey];
    [params setValue:VJNestProductSecret forKey:VJClientSecretKey];
    [params setValue:VJGrantTypeValue forKey:VJGrantTypeKey];
    
    
    [self postWithPath:VJNestOathPath sessionManager:_authSessionManager params:params completionHandler:^(id response, NSError *error, BOOL isRequestCanceled, BOOL isGoingOffline) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
            
            return;
        }
        if (completion) {
            completion([VJAuthToken objectWithDictionary:response], nil);
        }
    }];
}

#pragma mark - NestControlsViewControllerDelegate Methods

/**
 * Called from NestControlsViewControllerDelegate, lets
 * the AuthManager know to deauthorize the Works with Nest connection
 */
- (void)deauthorizeConnection
{
//    
//    NSLog(@"deauthorizeConnection");
//    
//    // Get the deauthorizationURL
//    NSString *deauthURL = [self deauthorizationURL];
//    
//    // Create the DELETE request
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:deauthURL]];
//    [request setHTTPMethod:@"DELETE"];
//    
//    // Assign the session to the main queue so the call happens immediately
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
//                                                          delegate:nil
//                                                     delegateQueue:[NSOperationQueue mainQueue]];
//    
//    [[session dataTaskWithRequest:request completionHandler:
//      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//          
//          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//          NSLog(@"AuthManager Delete Response Status Code: %ld", (long)[httpResponse statusCode]);
//          
//      }] resume];
//    
//    // Delete the access token and authorization code from storage
//    [self removeAuthorizationData];
    
}

@end
