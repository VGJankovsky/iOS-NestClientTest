//
//  VJModelObject.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJModelObject.h"

@implementation VJModelObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    return [[self.class alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        [self fillWithDicitonary:dictionary];
    }
    
    return self;
}

- (void)fillWithDicitonary:(NSDictionary *)dictionary
{
    //Implement in subclass
}

- (NSDictionary *)modelDictionary
{
    // implement in subclass if needed
    return nil;
}

@end
