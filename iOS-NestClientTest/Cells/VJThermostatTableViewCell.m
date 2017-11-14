//
//  VJThermostatTableViewCell.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJThermostatTableViewCell.h"
#import "VJNestThermostatModel.h"

@interface VJThermostatTableViewCell()
{
    __weak IBOutlet UILabel* _nameLabel;
    __weak IBOutlet UILabel* _tempLabel;
}

@property (nonatomic, readonly) VJNestThermostatModel* castedModel;

@end

@implementation VJThermostatTableViewCell

- (BOOL)modelObjectIsValid:(id)modelObject
{
    return [modelObject isKindOfClass:[VJNestThermostatModel class]];
}

- (void)modelObjectUpdated
{
    _nameLabel.text = self.castedModel.name;
    _tempLabel.text = [NSString stringWithFormat:@"Current temp: %@ F", self.castedModel.ambientTempF];
}

- (VJNestThermostatModel *)castedModel
{
    return self.modelObject;
}

@end
