//
//  VJThermostatControlsViewController.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VJNestThermostatModel;

@interface VJThermostatControlsViewController : UIViewController

@property (nonatomic, strong) VJNestThermostatModel* thermostat;

@end
