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
}

- (NSDictionary *)modelDictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    
    [dictionary setValue:self.deviceID forKey:VJThermostatDeviceIDKey];
    [dictionary setValue:self.name forKey:VJThermostatNameKey];
    [dictionary setValue:self.nameLong forKey:VJThermostatNameLongKey];
    [dictionary setValue:self.humidity forKey:VJThermostatHumidityKey];
    [dictionary setValue:@(self.canCool) forKey:VJThermostatCanCoolKey];
    [dictionary setValue:@(self.canHeat) forKey:VJThermostatCanHeatKey];
    [dictionary setValue:self.lockedTempMaxF forKey:VJThermostatLockedTempMaxFKey];
    [dictionary setValue:self.lockedTempMinF forKey:VJThermostatLockedTempMinFKey];
    [dictionary setValue:self.ecoTempHighF forKey:VJThermostatEcoTempHighFKey];
    [dictionary setValue:self.ecoTempLowF forKey:VJThermostatEcoTempLowFKey];
    [dictionary setValue:self.awayTempLowF forKey:VJThermostatAwayTempLowFKey];
    [dictionary setValue:self.awayTempHighF forKey:VJThermostatAwayTempHighFKey];
    [dictionary setValue:self.ambientTempF forKey:VJThermostatAmbientTempFKey];
    [dictionary setValue:self.targetTempF forKey:VJThermostatTargetTempFKey];
    [dictionary setValue:self.structureID forKey:VJThermostatStructureIDKey];
    [dictionary setValue:self.whereID forKey:VJThermostatWhereIDKey];
    [dictionary setValue:self.whereName forKey:VJThermostatWhereNameKey];
    [dictionary setValue:self.hvacState forKey:VJThermostatHVACStateKey];
    [dictionary setValue:@(self.isLocked) forKey:VJThermostatIsLockedKey];
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
