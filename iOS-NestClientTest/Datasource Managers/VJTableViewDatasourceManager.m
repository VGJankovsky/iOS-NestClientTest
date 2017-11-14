//
//  VJTableViewDatasourceManager.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJTableViewDatasourceManager.h"
#import "VJTableViewDatasourceManager+Private.h"
#import "VJModelProtocol.h"
#import "HelpfulCategories.h"

@interface VJTableViewDatasourceManager()



@end

@implementation VJTableViewDatasourceManager

@synthesize modelObject = _modelObject;
@synthesize shouldDeselectAfterPerformingAction = _shouldDeselectAfterPerformingAction;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commonInit];
}

- (void)commonInit
{
    self.shouldDeselectAfterPerformingAction = YES;
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    [self setupTableView];
}

- (void)setupTableView
{
    [self registerCellClasses];
    [self registerCellNibs];
    [self registerHeaderFooterViewClasses];
    [self registerHeaderFooterViewNibs];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)registerCellClasses
{
    for (Class cellClass in [self supportedCellClasses])
    {
        [_tableView registerCellWithClass:cellClass];
    }
}

- (void)registerCellNibs
{
    for (Class nibCellClass in [self supportedCellNibs])
    {
        [_tableView registerNibWithCellClass:nibCellClass];
    }
}

- (void)registerHeaderFooterViewNibs
{
    for (Class nibViewClass in [self supportedHeaderFooterViewNibs])
    {
        [_tableView registerNibWithHeaderFooterViewClass:nibViewClass];
    }
}

- (void)registerHeaderFooterViewClasses
{
    for (Class viewClass in [self supportedHeaderFooterViewClasses])
    {
        [_tableView registerHeaderFooterViewWithClass:viewClass];
    }
}

- (void)refreshData
{
    // implement in subclass
}

- (void)loadData
{
    // implement in subclass
}

- (void)reloadData
{
    // implement in subclass
}

- (void)clearData
{
    // implement in subclass
}

#pragma mark - Internal

- (NSArray *)supportedCellClasses
{
    // implement in subclass
    return nil;
}

- (NSArray *)supportedCellNibs
{
    // implement in subclass
    return nil;
}

- (NSArray *)supportedHeaderFooterViewNibs
{
    return nil;
}

- (NSArray *)supportedHeaderFooterViewClasses
{
    return nil;
}

- (id)modelForIndexPath:(NSIndexPath *)indexPath
{
    // implement in subclass
    
    return nil;
}

- (NSIndexPath *)indexPathForModel:(id)model
{
    //implement in subclass
    
    return nil;
}

- (void)performActionForIndexPath:(NSIndexPath *)indexPath
{
    // implement in subclass
}

- (NSInteger)numberOfsections
{
    // implement in subclass
    
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    // implement in subclass
    
    return 0;
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath
{
    // implement in subclass
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    // implement in subclass
    
    return 1.0f;
}

- (CGFloat)heightForFooterInSection:(NSInteger)section
{
    // implement in subclass
    
    return 1.f;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    // implement in subclass
    
    return nil;
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    // implement in subclass
    return nil;
}

- (NSString *)identifierForViewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)identifierForViewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - STModelObjectProtocol

- (void)setModelObject:(id)modelObject
{
    if ([self modelObjectIsValid:modelObject])
    {
        _modelObject = modelObject;
        [self modelObjectUpdated];
    }else
    {
        [self modelObjectDidTurnToFault];
        NSLog(@"%@: %@: model object is of wrong class: %@", [self class], NSStringFromSelector(_cmd), [modelObject class]);
    }
}

- (void)modelObjectUpdated
{
    //Implement in subclass
}

- (void)modelObjectDidTurnToFault
{
    //Peform actions if something is wrong with the model object
    //Implement in subclass
}

- (BOOL)modelObjectIsValid:(id)modelObject
{
    //Check if modelObject is of appropriate class/conforms to a right protocol here
    //Implement in subclass
    
    return NO;
}

#pragma mark - UITableViewDatasource/Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (![self identifierForViewForHeaderInSection:section]) {
        return [UIView new];
    }
    
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:[self identifierForViewForHeaderInSection:section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self identifierForViewForFooterInSection:section]) {
        return [UIView new];
    }
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:[self identifierForViewForFooterInSection:section]];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfsections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell<VJModelProtocol>* cell = (id)[tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath] forIndexPath:indexPath];
    
    NSAssert([cell conformsToProtocol:@protocol(VJModelProtocol)], @"Inherit cells form STBaseTableViewCell, or have them conformed to STModelProtocol");
    
    cell.modelObject = [self modelForIndexPath:indexPath];
    
    NSLog(@"Cell of class = %@ at indexPath = %@, setting model object = %@", cell.class, indexPath, cell.modelObject);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self heightForFooterInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performActionForIndexPath:indexPath];
    
    if (self.shouldDeselectAfterPerformingAction)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self titleForHeaderInSection:section];
}


@end
