//
//  HelpfulCategories.m
//  SchoolTherapists
//
//  Created by Vadim Yankovskiy on 3/3/16.
//  Copyright © 2016 Provectus. All rights reserved.
//

#import "HelpfulCategories.h"
#import <objc/runtime.h>

@implementation NSObject (helpful)

+ (NSString *)className
{
    return NSStringFromClass(self.class);
}

- (NSString *)className
{
    return [self.class className];
}

@end

@implementation NSString (helpful)

- (NSString *)firstCharacterCapitalized
{
    return [[self substringToIndex:1] uppercaseString];
}

@end

@implementation UIView (helpful)

+ (UINib *)viewNib
{
    return [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
}

@end


@implementation UITableView (helpful)

- (void)registerNibWithCellClass:(Class)cellClass
{
    [self registerNib:[cellClass viewNib] forCellReuseIdentifier:[cellClass className]];
}

- (void)registerCellWithClass:(Class)cellClass
{
    [self registerClass:cellClass forCellReuseIdentifier:[cellClass className]];
}

- (void)registerNibWithHeaderFooterViewClass:(Class)viewClass
{
    [self registerNib:[viewClass viewNib] forHeaderFooterViewReuseIdentifier:[viewClass className]];
}

- (void)registerHeaderFooterViewWithClass:(Class)cellClass
{
    [self registerClass:cellClass forHeaderFooterViewReuseIdentifier:[cellClass className]];
}

- (id)dequeueReusableCellWithClass:(Class)cellClass
{
    return [self dequeueReusableCellWithIdentifier:[cellClass className]];
}

- (id)dequeueReusableCellWithClass:(Class)cellClass indexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithIdentifier:[cellClass className] forIndexPath:indexPath];
}

- (id)dequeueReusableHeaderFooterViewWithClass:(Class)headerFooterViewClass
{
    return [self dequeueReusableHeaderFooterViewWithIdentifier:[headerFooterViewClass className]];
}

- (void)hideExtraBottomSeparators
{
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end

@implementation UICollectionView (helpful)

- (void)registerNibWithCellClass:(Class)cellClass
{
    [self registerNib:[cellClass viewNib] forCellWithReuseIdentifier:[cellClass className]];
}

- (UICollectionViewCell *)dequeueReusableCellOfClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithReuseIdentifier:[cellClass className] forIndexPath:indexPath];
}

@end

static char const *PVEnableScrollingProperty = "PVEnableScrollingProperty";
static char const *PVPageItemsControllersProperty = "PVPageItemsControllersProperty";
static NSString *const PVDefaultViewControllerIdentifier = @"PVDefaultViewControllerIdentifier";


@interface UIPageViewController (PVPrivate)
@property (nonatomic, strong) NSMutableDictionary *pageItemsControllers;
@end

@implementation UIPageViewController (PVPrivate)

- (NSMutableDictionary *)pageItemsControllers
{
    return objc_getAssociatedObject(self, PVPageItemsControllersProperty);
}

- (void)setPageItemsControllers:(NSMutableArray *)pageItemsControllers
{
    objc_setAssociatedObject(self, PVPageItemsControllersProperty, pageItemsControllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIPageViewController (pv)

//- (void)setEnableScrolling:(BOOL)enableScrolling
//{
//    objc_setAssociatedObject(self, PVEnableScrollingProperty, @(enableScrolling), OBJC_ASSOCIATION_ASSIGN);
//    [self updateScrollingState:enableScrolling];
//}
//
//- (BOOL)isScrollingEnabled
//{
//    NSNumber *value = objc_getAssociatedObject(self, PVEnableScrollingProperty);
//    
//    if (![value isKindOfClass:[NSNumber class]])
//        return NO;
//    
//    return [value boolValue];
//}

/*- (void)safeSetViewControllers:(NSArray *)viewControllers forward:(BOOL)forward animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    //http://stackoverflow.com/questions/14220289/removing-a-view-controller-from-uipageviewcontroller. 09/02/2015 - Dmitriy Mazurenko
    UIPageViewControllerNavigationDirection direction = forward? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    onMainThread(
                 
                 if ( !animated )
                 {
                     
                     [self setViewControllers:viewControllers direction:direction animated:animated completion:^(BOOL finished) {
                         
                         if ( completion )
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completion(finished);
                             });
                         }
                     }];
                 }
                 else
                 {
                     __weak typeof(self) wSelf = self;
                     
                     [self setViewControllers:viewControllers direction:direction animated:animated completion:^(BOOL finished) {
                         
                         if(finished)
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 [wSelf setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];// bug fix for uipageview controller
                                 
                                 if ( completion )
                                 {
                                     completion(YES);
                                 }
                             });
                         }
                         else
                         {
                             if ( completion )
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     completion(NO);
                                 });
                             }
                         }
                     }];
                 }
                 );
}
*/
#pragma mark - Private methods

//- (void)updateScrollingState:(BOOL)enabled
//{
//    for(UIView* view in self.view.subviews)
//    {
//        if(![view isKindOfClass:[UIScrollView class]])
//            continue;
//        
//        UIScrollView* scrollView=(UIScrollView*)view;
//        [scrollView setScrollEnabled:enabled];
//        return;
//    }
//}
//
//- (id)dequeueReusableViewControllerWithIndex:(NSInteger)index forward:(BOOL)forward
//{
//    return [self dequeueReusableViewControllerWithIdentifier:nil index:index forward:forward];
//}

/*- (id)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier index:(NSInteger)index forward:(BOOL)forward
{
    NSString *_identifier = identifier.length? identifier : PVDefaultViewControllerIdentifier;
    
    id <PVPageViewControllerItemProtocol> controller = [self tryToGetExistsControllerWithIdentifier:_identifier index:index];
    
    if ( controller )
    {
        return controller;
    }
    
    controller = [self tryToReuseControllerWithIdentifier:_identifier index:index forward:forward];
    
    if (controller == [self.viewControllers firstObject])
        controller = nil;
    
    if (!controller)
        controller = [self prepareNewControllerWithIdentifier:_identifier index:index];
    
    controller.index = index;
    
    return controller;
}*/


#pragma mark - Private methods

- (NSMutableArray *)viewControllersForIdentifier:(NSString *)identifier
{
    if ( !identifier )
    {
        return [self viewControllersForIdentifier:PVDefaultViewControllerIdentifier];
    }
    
    return self.pageItemsControllers[identifier];
}

- (id <PVPageViewControllerItemProtocol>)tryToGetExistsControllerWithIdentifier:(NSString *)identifier index:(NSInteger)index
{
    if (![self.pageItemsControllers count] )
        return nil;
    
    NSArray *viewControllers = [self viewControllersForIdentifier:identifier];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.index == %lu", index];
    return [[viewControllers filteredArrayUsingPredicate:predicate] firstObject];
}

/*- (id <PVPageViewControllerItemProtocol>)tryToReuseControllerWithIdentifier:(NSString *)identifier index:(NSInteger)index forward:(BOOL)forward
{
    NSInteger future_index = (!forward) ? (index + STSparePageOffset) : ((index < STSparePageOffset) ? 0 : (index - STSparePageOffset));
    NSPredicate *predicate = (forward) ? [NSPredicate predicateWithFormat:@"SELF.index < %lu", future_index] :
    [NSPredicate predicateWithFormat:@"SELF.index > %lu", future_index];
    
    NSArray *viewControllers = [self viewControllersForIdentifier:identifier];
    
    return [[viewControllers filteredArrayUsingPredicate:predicate] firstObject];
}*/

- (id <PVPageViewControllerItemProtocol>)prepareNewControllerWithIdentifier:(NSString *)identifier index:(NSInteger)index
{
    id <PVPageViewControllerItemProtocol> controller = nil;
    
    if ([self.dataSource respondsToSelector:@selector(createItemWithIdentifier:index:)])
    {
        controller = [(id <PVPageViewControllerDataSource>)self.dataSource createItemWithIdentifier:identifier index:index];
    }
    else if ([self.delegate respondsToSelector:@selector(createItemWithIdentifier:index:)])
    {
        controller = [(id <PVPageViewControllerDataSource>)self.delegate createItemWithIdentifier:identifier index:index];
    }
    
    if (!controller)
        return nil;
    
    controller.index = index;
    controller.identifier = identifier;
    
    if (!self.pageItemsControllers)
        self.pageItemsControllers = [NSMutableDictionary new];
    
    NSMutableArray *viewControllers = [self viewControllersForIdentifier:identifier];
    
    if ( !viewControllers )
    {
        viewControllers = [NSMutableArray arrayWithObject:controller];
    }
    else
    {
        [viewControllers addObject:controller];
    }
    
    [self.pageItemsControllers setValue:viewControllers forKey:identifier];
    
    return controller;
}

@end

@implementation NSDate(Components)

- (NSDate *)dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    addComponents.year = years;
    
    return [calendar dateByAddingComponents:addComponents toDate:self options:0];
}

- (NSDate *)dateBySubstractingYears:(NSInteger)years
{
    return [self dateByAddingYears:-years];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    addComponents.day = days;
    
    return [calendar dateByAddingComponents:addComponents toDate:self options:0];
}

- (NSDate *)dateBySubstractingDays:(NSInteger)days
{
    return [self dateByAddingDays:-days];
}

- (NSDate *)dateByAddingHours:(NSInteger)hours
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    addComponents.hour = hours;
    
    return [calendar dateByAddingComponents:addComponents toDate:self options:0];
}

- (NSDate *)dateBySubstractingHours:(NSInteger)hours
{
    return [self dateByAddingHours:-hours];
}

+ (NSDate *)yesterday
{
    return [[NSDate date] dateBySubstractingDays:1];
}

@end
