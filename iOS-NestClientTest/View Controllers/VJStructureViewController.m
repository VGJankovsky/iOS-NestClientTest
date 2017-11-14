//
//  VJStructureViewController.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJStructureViewController.h"
#import "VJSingleStructureDatasourceManager.h"
#import "VJNestThermostatModel.h"
#import "VJThermostatControlsViewController.h"

static NSString *const VJShowThermostatViewControllerSegue = @"ShowThermostat";

@interface VJStructureViewController ()

@property (nonatomic, strong) IBOutlet VJSingleStructureDatasourceManager* datasourceManager;
@property (nonatomic, strong) VJNestThermostatModel* selectedThermostat;

@end

@implementation VJStructureViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.datasourceManager.modelObject = self.structureModel;
    
    __weak __typeof(self) wSelf = self;

    [self.datasourceManager setActionBlock:^(VJNestThermostatModel *thermostat) {
        __strong __typeof(self) sSelf = wSelf;
        sSelf.selectedThermostat = thermostat;
        [sSelf performSegueWithIdentifier:VJShowThermostatViewControllerSegue sender:sSelf];
    }];
    
    [self.datasourceManager loadData];
    self.title = self.structureModel.name;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:VJShowThermostatViewControllerSegue])
    {
        VJThermostatControlsViewController* vc = segue.destinationViewController;
        vc.thermostat = self.selectedThermostat;
        
        self.selectedThermostat = nil;
    }
}

@end
