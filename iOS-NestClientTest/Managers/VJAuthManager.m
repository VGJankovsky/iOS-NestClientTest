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
        self.authToken = [self loadCustomObjectWithKey:VJAuthorizationTokenDefaultsKey];
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
        
        [sSelf saveCustomObject:token key:VJAuthorizationTokenDefaultsKey];
        
        sSelf.authToken = token;
        
        if (errorBlock) {
            errorBlock(nil);
        }
    }];
}

- (NSString *)tokenString
{
    return self.authToken.token;
}

#pragma mark Save/Load Token from User Defaults

- (void)saveCustomObject:(id)object key:(NSString *)key
{
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (id)loadCustomObjectWithKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    return object;
}

@end

@implementation NSObject(AuthManager)

- (VJAuthManager *)authManager
{
    //convenience method that lets us avoid calling 'shared' all the time AND potentially return a different manager based on some condition
    return [VJAuthManager shared];
}

@end
