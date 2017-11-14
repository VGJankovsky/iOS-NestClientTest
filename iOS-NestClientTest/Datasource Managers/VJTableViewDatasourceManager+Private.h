//
//  VJTableViewDatasourceManager+Private.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJTableViewDatasourceManager.h"

@interface VJTableViewDatasourceManager ()

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL shouldDeselectAfterPerformingAction;

- (void)commonInit;

- (NSArray *)supportedCellClasses;
- (NSArray *)supportedCellNibs;
- (void)setupTableView;

- (void)performActionForIndexPath:(NSIndexPath *)indexPath;
- (id)modelForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForModel:(id)model;
- (NSInteger)numberOfsections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (CGFloat)heightForHeaderInSection:(NSInteger)section;
- (CGFloat)heightForFooterInSection:(NSInteger)section;
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (NSString *)identifierForViewForHeaderInSection:(NSInteger)section;
- (NSString *)identifierForViewForFooterInSection:(NSInteger)section;
- (NSArray *)supportedHeaderFooterViewNibs;
- (NSArray *)supportedHeaderFooterViewClasses;

@end
