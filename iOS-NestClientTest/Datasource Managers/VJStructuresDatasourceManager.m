//
//  VJStructuresDatasourceManager.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJStructuresDatasourceManager.h"
#import "VJTableViewDatasourceManager+Private.h"
#import "VJNestStructureModel.h"
#import "VJAPIManager.h"
#import "VJStructureTableViewCell.h"
#import "HelpfulCategories.h"

@interface VJStructuresDatasourceManager()

@property (nonatomic, strong) NSArray<VJNestStructureModel *>* structures;

@end

@implementation VJStructuresDatasourceManager

- (void)loadData
{
    __weak __typeof (self) wSelf = self;
    [self.apiManager getStructuresWithComepletion:^(NSArray<VJNestStructureModel *> *structures, NSError *error) {
        __strong __typeof(self) sSelf = wSelf;
        sSelf.structures = structures;
        [sSelf reloadData];
    }];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)clearData
{
    self.structures = nil;
}

- (NSArray *)supportedCellNibs
{
    return @[[VJStructureTableViewCell class]];
}

- (void)performActionForIndexPath:(NSIndexPath *)indexPath
{
    if (self.actionBlock)
    {
        self.actionBlock([self modelForIndexPath:indexPath]);
    }
}

- (NSInteger)numberOfsections
{
    return self.structures != nil;
}

- (id)modelForIndexPath:(NSIndexPath *)indexPath
{
    return [self.structures objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.structures count];
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    return [VJStructureTableViewCell className];
}

@end
