//
//  VJNestThermostatModel.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJNestThermostatModel.h"

static NSString *const VJThermostatDeviceIDKey = @"device_id";
static NSString *const VJThermostatNameKey = @"name";
static NSString *const VJThermostatNameLongKey = @"name_long";

static NSString *const VJThermostatHumidityKey = @"humidity";

static NSString *const VJThermostatCanHeatKey = @"can_heat";
static NSString *const VJThermostatCanCoolKey = @"can_cool";

static NSString *const VJThermostatLockedTempMinFKey = @"locked_temp_min_f";
static NSString *const VJThermostatLockedTempMaxFKey = @"locked_temp_max_f";

static NSString *const VJThermostatEcoTempHighFKey = @"eco_temperature_high_f";
static NSString *const VJThermostatEcoTempLowFKey = @"eco_temperature_low_f";

static NSString *const VJThermostatAwayTempLowFKey = @"away_temperature_low_f";
static NSString *const VJThermostatAwayTempHighFKey = @"away_temperature_high_f";

static NSString *const VJThermostatAmbientTempFKey = @"ambient_temperature_f";

static NSString *const VJThermostatTargetTempFKey = @"target_temperature_f";

static NSString *const VJThermostatStructureIDKey = @"structure_id";

static NSString *const VJThermostatWhereIDKey = @"where_id";
static NSString *const VJThermostatWhereNameKey = @"where_name";

static NSString *const VJThermostatHVACStateKey = @"hvac_state";
static NSString *const VJThermostatIsLockedKey = @"is_locked";

static NSString *const VJFanTimerActiveKey  = @"fan_timer_active";

@implementation VJNestThermostatModel

- (void)fillWithDicitonary:(NSDictionary *)dictionary
{
    self.deviceID = [dictionary valueForKey:VJThermostatDeviceIDKey];
    self.name = [dictionary valueForKey:VJThermostatNameKey];
    self.nameLong = [dictionary valueForKey:VJThermostatNameLongKey];
    self.humidity = [dictionary valueForKey:VJThermostatHumidityKey];
    self.canCool  = [[dictionary valueForKey:VJThermostatCanCoolKey] boolValue];
    self.canHeat = [[dictionary valueForKey:VJThermostatCanHeatKey] boolValue];
    self.lockedTempMaxF = [dictionary valueForKey:VJThermostatLockedTempMaxFKey];
    self.lockedTempMinF = [dictionary valueForKey:VJThermostatLockedTempMinFKey];
    self.ecoTempHighF = [dictionary valueForKey:VJThermostatEcoTempHighFKey];
    self.ecoTempLowF = [dictionary valueForKey:VJThermostatEcoTempLowFKey];
    self.awayTempLowF = [dictionary valueForKey:VJThermostatAwayTempLowFKey];
    self.awayTempHighF = [dictionary valueForKey:VJThermostatAwayTempHighFKey];
    self.ambientTempF = [dictionary valueForKey:VJThermostatAmbientTempFKey];
    self.targetTempF = [dictionary valueForKey:VJThermostatTargetTempFKey];
    self.structureID = [dictionary valueForKey:VJThermostatStructureIDKey];
    self.whereID = [dictionary valueForKey:VJThermostatWhereIDKey];
    self.whereName = [dictionary valueForKey:VJThermostatWhereNameKey];
    self.hvacState = [dictionary valueForKey:VJThermostatHVACStateKey];
    self.isLocked = [[dictionary valueForKey:VJThermostatIsLockedKey] boolValue];
    self.fanTimerActive = [[dictionary valueForKey:VJFanTimerActiveKey] boolValue];
}

- (NSDictionary *)modelDictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    
    [dictionary setValue:self.targetTempF forKey:VJThermostatTargetTempFKey];
    [dictionary setValue:@(self.fanTimerActive) forKey:VJFanTimerActiveKey];
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
