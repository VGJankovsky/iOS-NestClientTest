//
//  VJStructureViewController.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJStructureViewController.h"
#import "VJSingleStructureDatasourceManager.h"

@interface VJStructureViewController ()

@property (nonatomic, strong) IBOutlet VJSingleStructureDatasourceManager* datasourceManager;

@end

@implementation VJStructureViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.datasourceManager.modelObject = self.structureModel;
    [self.datasourceManager loadData];
    self.title = self.structureModel.name;
}

@end
