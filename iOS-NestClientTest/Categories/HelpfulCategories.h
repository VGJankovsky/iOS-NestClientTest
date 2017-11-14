//
//  HelpfulCategories.h
//  SchoolTherapists
//
//  Created by Vadim Yankovskiy on 3/3/16.
//  Copyright © 2016 Provectus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (helpful)

+ (NSString *)className;

@end

@interface NSString (helpful)

- (NSString *)firstCharacterCapitalized;

@end

@interface UIView (helpful)

+ (UINib *)viewNib;

@end

@interface UITableView (helpful)
/**
 *  Registers a nib object containing a cell with the table view with a specified cell class.
 *  Cell's class name is used as a identifier
 *
 *  @param cellClass Cell object's class
 */
- (void)registerNibWithCellClass:(Class)cellClass;

/**
 *  Registers a class for use in creating new table cells.
 *  Cell's class name is used as a identifier
 *
 *  @param cellClass Cell object's class
 */
- (void)registerCellWithClass:(Class)cellClass;

/**
 *  Registers a nib object containing a header or footer with the table view with a specified class.
 *  View's class name is used as a identifier
 *
 *  @param viewClass View object's class
 */
- (void)registerNibWithHeaderFooterViewClass:(Class)viewClass;

- (void)registerHeaderFooterViewWithClass:(Class)cellClass;

- (id)dequeueReusableCellWithClass:(Class)cellClass;
- (id)dequeueReusableCellWithClass:(Class)cellClass indexPath:(NSIndexPath *)indexPath;
- (id)dequeueReusableHeaderFooterViewWithClass:(Class)headerFooterViewClass;
- (void)hideExtraBottomSeparators;
@end

@interface UICollectionView (helpful)

- (void)registerNibWithCellClass:(Class)cellClass;
- (UICollectionViewCell *)dequeueReusableCellOfClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;

@end


@protocol PVPageViewControllerItemProtocol <NSObject>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *identifier;
@end

@protocol PVPageViewControllerDataSource <UIPageViewControllerDataSource>
- (id <PVPageViewControllerItemProtocol>)createItemWithIdentifier:(NSString *)identifier index:(NSInteger)index;
@end

@interface UIPageViewController (pv)
//
//@property (nonatomic, assign, getter=isScrollingEnabled) BOOL enableScrolling;
//
//- (id)dequeueReusableViewControllerWithIndex:(NSInteger)index forward:(BOOL)forward;
//- (id)dequeueReusableViewControllerWithIdentifier:(NSString *)identifier index:(NSInteger)index forward:(BOOL)forward;

//- (void)safeSetViewControllers:(NSArray *)viewControllers forward:(BOOL)forward animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end

@interface NSDate(Components)

- (NSDate *)dateByAddingYears:(NSInteger)years;
- (NSDate *)dateBySubstractingYears:(NSInteger)years;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateBySubstractingDays:(NSInteger)days;
- (NSDate *)dateByAddingHours:(NSInteger)hours;
- (NSDate *)dateBySubstractingHours:(NSInteger)hours;
+ (NSDate *)yesterday;

@end

