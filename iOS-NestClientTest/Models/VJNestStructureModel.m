//
//  VJNestStructureModel.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJNestStructureModel.h"
#import "VJWhereModel.h"

static NSString *const VJStructureIDKey             = @"structure_id";
static NSString *const VJStructureNameKey           = @"name";
static NSString *const VJStructureCountryCodeKey    = @"country_code";
static NSString *const VJStructureTimezoneKey       = @"time_zone";
static NSString *const VJStructureThermostatsKey    = @"thermostats";
static NSString *const VJStructureCamerasKey        = @"cameras";
static NSString *const VJStructureAwayKey           = @"away";
static NSString *const VJStructureWheresKey         = @"wheres";

@implementation VJNestStructureModel

- (void)fillWithDicitonary:(NSDictionary *)dictionary
{
    self.structureID    = [dictionary valueForKey:VJStructureIDKey];
    self.name           = [dictionary valueForKey:VJStructureNameKey];
    self.countryCode    = [dictionary valueForKey:VJStructureCountryCodeKey];
    self.timeZone       = [dictionary valueForKey:VJStructureTimezoneKey];
    self.thermostatIDs  = [dictionary valueForKey:VJStructureThermostatsKey];
    self.cameraIDs      = [dictionary valueForKey:VJStructureCamerasKey];
    self.away           = [dictionary valueForKey:VJStructureAwayKey];
    self.wheres         = [self parseWheresWithDictionary:[dictionary valueForKey:VJStructureWheresKey]];    
}

- (NSArray *)parseWheresWithDictionary:(NSDictionary *)dictionary
{
    __block NSMutableArray* mutableWheres = [NSMutableArray new];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mutableWheres addObject:[VJWhereModel objectWithDictionary:obj]];
    }];
    
    return [NSArray arrayWithArray:mutableWheres];
}

@end
