//
//  VJAuthManager.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VJGenericBlockTypes.h"

@interface VJAuthManager : NSObject

@property (nonatomic, readonly) NSString* authorizationURLString;
@property (nonatomic, readonly) NSString* tokenString;
@property (nonatomic, readonly) BOOL isLoggedIn;

- (void)authorizationCodeRetrieved:(NSString *)authCode errorBlock:(VJGenericErrorBlock)errorBlock;

@end

@interface NSObject (AuthManger)

@property (nonatomic, readonly) VJAuthManager* authManager;

@end
