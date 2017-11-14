//
//  VJAPIManager.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"
#import "VJGenericBlockTypes.h"

@class VJAuthToken, VJNestThermostatModel;

@interface VJAPIManager : NSObject

- (void)getThermostatWithID:(NSString *)thermostatID completion:(void (^)(VJNestThermostatModel* thermostat, NSError* error))completion;
- (void)setThermostatDataWithThermostat:(VJNestThermostatModel *)thermostat completion:(VJGenericErrorBlock)completion;
- (void)getCameraWithID:(NSString *)cameraID completion:(void (^)(VJNestCameraModel* camera, NSError* error))completion;
- (void)getStructuresWithComepletion:(void (^)(NSArray<VJNestStructureModel*>* structures, NSError* error))completion;


@end

@interface NSObject(APIManager)

@property (nonatomic, readonly) VJAPIManager* apiManager;

@end
