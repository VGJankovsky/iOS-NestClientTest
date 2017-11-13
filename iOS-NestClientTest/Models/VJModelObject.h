//
//  VJModelObject.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VJModelObject <NSObject>

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)fillWithDicitonary:(NSDictionary *)dictionary;

@optional
@property (nonatomic, readonly) NSDictionary* modelDictionary;

@end
