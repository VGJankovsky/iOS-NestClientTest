//
//  VJAuthManager.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJAuthManager.h"
#import "Constants.h"
#import "VJAPIManager+Auth.h"
#import "VJAuthToken.h"

static NSString *const VJAuthorizationTokenDefaultsKey = @"authTokenKey";

@interface VJAuthManager()

@property (nonatomic, strong) VJAuthToken* authToken;

@end

@implementation VJAuthManager

#pragma main - Singleton

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[VJAuthManager alloc] initUniqueInstance];
    });
    
    return _sharedObject;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self)
    {
        self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:VJAuthorizationTokenDefaultsKey];
    }
    
    return self;
}

#pragma mark - Public

- (BOOL)isLoggedIn
{
    return self.authToken.isValid;
}

- (NSString *)authorizationURLString
{
    return [NSString stringWithFormat:VJNestAuthFormattedString, VJNestProductID, VJNestState];
}

- (void)authorizationCodeRetrieved:(NSString *)authCode errorBlock:(VJGenericErrorBlock)errorBlock
{
    __weak __typeof(self) wSelf = self;
    
    [self.apiManager getAuthorizationTokenWithCode:authCode completion:^(VJAuthToken *token, NSError *error) {
        
        if (error) {
            if (errorBlock)
            {
                errorBlock(error);
            }
            return;
        }
        
        __strong __typeof(self) sSelf = wSelf;
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:token forKey:VJAuthorizationTokenDefaultsKey];
        
        sSelf.authToken = token;
    }];
}

- (NSString *)tokenString
{
    return self.authToken.token;
}

@end

@implementation NSObject(AuthManager)

- (VJAuthManager *)authManager
{
    //convenience method that lets us avoid calling 'shared' all the time AND potentially return a different manager based on some condition
    return [VJAuthManager shared];
}

@end
