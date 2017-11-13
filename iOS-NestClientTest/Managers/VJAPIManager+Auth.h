//
//  VJAPIManager+Auth.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJAPIManager.h"
#import "VJGenericBlockTypes.h"

@interface VJAPIManager (Auth)

- (void)getAuthorizationTokenWithCode:(NSString *)code completion:(void (^)(VJAuthToken* token, NSError* error))completion;
- (void)deauthorizeWithCompletion:(VJGenericErrorBlock)errorBlock;

@end
