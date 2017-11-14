//
//  VJSingleStructureDatasourceManager.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJSingleStructureDatasourceManager.h"
#import "VJNestStructureModel.h"
#import "VJNestThermostatModel.h"
#import "VJNestCameraModel.h"
#import "VJAPIManager.h"
#import "VJThermostatTableViewCell.h"
#import "HelpfulCategories.h"

@interface VJSingleStructureDatasourceManager()

@property (nonatomic, readonly) VJNestStructureModel* castedModel;
@property (nonatomic, strong) NSMutableArray<VJNestThermostatModel *>* thermostats;
@property (nonatomic, assign) NSInteger nextThermostatIndex;

@end

@implementation VJSingleStructureDatasourceManager

- (BOOL)modelObjectIsValid:(id)modelObject
{
    return [modelObject isKindOfClass:[VJNestStructureModel class]];
}

- (VJNestStructureModel *)castedModel
{
    return self.modelObject;
}

- (void)loadData
{
    self.thermostats = [NSMutableArray new];
    [self loadThermostats];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)loadThermostats
{
    self.nextThermostatIndex = NSNotFound;
    
    if ([self.castedModel.thermostatIDs count]) {
        self.nextThermostatIndex = 0;
    }
    
    [self loadThermostatStep];
}

- (void)loadThermostatStep
{
    if (self.nextThermostatIndex != NSNotFound)
    {
        __weak __typeof(self) wSelf = self;
        
        [self.apiManager getThermostatWithID:[self.castedModel.thermostatIDs objectAtIndex:self.nextThermostatIndex] completion:^(VJNestThermostatModel *thermostat, NSError *error) {
            __strong __typeof(self) sSelf = wSelf;
            [sSelf.thermostats addObject:thermostat];
            [sSelf reloadData];
            [sSelf loadThermostatStep];
        }];
        
        self.nextThermostatIndex++;
        if (self.nextThermostatIndex >= self.castedModel.thermostatIDs.count) {
            self.nextThermostatIndex = NSNotFound;
        }
    }
}

- (NSArray *)supportedCellNibs
{
    return @[[VJThermostatTableViewCell class]];
}

- (void)performActionForIndexPath:(NSIndexPath *)indexPath
{
    
}

- (id)modelForIndexPath:(NSIndexPath *)indexPath
{
    return [self.thermostats objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfsections
{
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.thermostats count];
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    return [VJThermostatTableViewCell className];
}
- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    return @"Thermostats";
}

@end
