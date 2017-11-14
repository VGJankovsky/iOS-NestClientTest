//
//  VJWhereModel.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJWhereModel.h"

static NSString *const VJWhereIDKey = @"where_id";
static NSString *const VJWhereNameKey = @"name";

@implementation VJWhereModel

- (void)fillWithDicitonary:(NSDictionary *)dictionary
{
    self.whereID    = [dictionary valueForKey:VJWhereIDKey];
    self.name       = [dictionary valueForKey:VJWhereNameKey];
}

@end
