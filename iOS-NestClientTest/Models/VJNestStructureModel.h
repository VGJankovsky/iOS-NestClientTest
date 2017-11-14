//
//  VJNestStructureModel.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VJModelObject.h"

@class VJWhereModel;

@interface VJNestStructureModel : VJModelObject

@property (nonatomic, copy) NSString* structureID;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* countryCode;
@property (nonatomic, copy) NSString* timeZone;
@property (nonatomic, copy) NSString* away;
@property (nonatomic, strong) NSArray<NSString *>* cameraIDs;
@property (nonatomic, strong) NSArray<NSString *>* thermostatIDs;
@property (nonatomic, strong) NSArray<VJWhereModel *>* wheres;

@end
