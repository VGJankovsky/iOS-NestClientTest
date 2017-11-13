//
//  VJAuthToken.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VJModelObject.h"

@interface VJAuthToken : NSObject<VJModelObject>

@property (nonatomic, readonly) NSString*   token;
@property (nonatomic, readonly) NSDate*     expiresOn;
@property (nonatomic, readonly) BOOL        isValid;

@end
