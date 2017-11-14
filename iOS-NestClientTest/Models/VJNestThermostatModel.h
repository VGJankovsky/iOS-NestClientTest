//
//  VJNestThermostatModel.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VJModelObject.h"




@interface VJNestThermostatModel : VJModelObject

@property (nonatomic, copy)     NSString* deviceID;
@property (nonatomic, copy)     NSString* name;
@property (nonatomic, copy)     NSString* nameLong;
@property (nonatomic, strong)   NSNumber* humidity;
@property (nonatomic, assign)   BOOL canHeat;
@property (nonatomic, assign)   BOOL canCool;
@property (nonatomic, strong) NSNumber* lockedTempMinF;
@property (nonatomic, strong) NSNumber* lockedTempMaxF;
@property (nonatomic, strong) NSNumber* ecoTempLowF;
@property (nonatomic, strong) NSNumber* ecoTempHighF;
@property (nonatomic, strong) NSNumber* awayTempLowF;
@property (nonatomic, strong) NSNumber* awayTempHighF;
@property (nonatomic, strong) NSNumber* ambientTempF;
@property (nonatomic, strong) NSNumber* targetTempF;
@property (nonatomic, copy) NSString* structureID;
@property (nonatomic, copy) NSString* whereID;
@property (nonatomic, copy) NSString* whereName;
@property (nonatomic, copy) NSString* hvacState;
@property (nonatomic, assign) BOOL isLocked;

@end
