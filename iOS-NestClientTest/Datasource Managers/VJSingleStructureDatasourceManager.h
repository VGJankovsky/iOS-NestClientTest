//
//  VJSingleStructureDatasourceManager.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJTableViewDatasourceManager.h"

@class VJNestThermostatModel;

@interface VJSingleStructureDatasourceManager : VJTableViewDatasourceManager

@property (nonatomic, copy) void (^actionBlock)(VJNestThermostatModel* thermostat);

@end
