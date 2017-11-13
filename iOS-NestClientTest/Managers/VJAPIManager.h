//
//  VJAPIManager.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"

@class VJAuthToken;

@interface VJAPIManager : NSObject

- (void)getThermostatWithID:(NSString *)thermostatID completion:(void (^)(VJNestThermostatModel* thermostat, NSError* error))completion;
- (void)getCameraWithID:(NSString *)cameraID completion:(void (^)(VJNestCameraModel* camera, NSError* error))completion;
- (void)getStructureWithID:(NSString *)structureID comepletion:(void (^)(VJNestStructureModel* structure, NSError* error))completion;


@end

@interface NSObject(APIManager)

@property (nonatomic, readonly) VJAPIManager* apiManager;

@end
