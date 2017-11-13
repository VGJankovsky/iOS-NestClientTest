//
//  VJAuthToken.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJAuthToken.h"

static NSString *const VJAuthTokenStringKey     = @"token";
static NSString *const VJAuthTokenExpiresInKey  = @"expires_in";
static NSString *const VJAuthTokenExpiresOnKey  = @"expiresOn";

@interface VJAuthToken()<NSCoding>

@property (nonatomic, copy, readwrite)      NSString* token;
@property (nonatomic, strong, readwrite)    NSDate* expiresOn;

@end

@implementation VJAuthToken

#pragma mark Init and Parse methods

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
    self.token      = [dictionary valueForKey:VJAuthTokenStringKey];
#warning Check for more proper double value extration
    
    NSTimeInterval expiresInInterval =  [[dictionary valueForKey:VJAuthTokenExpiresInKey] longValue];
    self.expiresOn = [[NSDate date] dateByAddingTimeInterval:expiresInInterval];
}

- (BOOL)isValid
{
    return [[NSDate date] compare:self.expiresOn] == NSOrderedAscending;
}

#pragma mark NSCoding to store in user defaults

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.token forKey:VJAuthTokenStringKey];
    [aCoder encodeObject:self.expiresOn forKey:VJAuthTokenExpiresOnKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.token       = [aDecoder decodeObjectForKey:VJAuthTokenStringKey];
        self.expiresOn   = [aDecoder decodeObjectForKey:VJAuthTokenExpiresOnKey];
    }
    
    return self;
}

@end
