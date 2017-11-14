//
//  VJBaseTableViewCell.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJBaseTableViewCell.h"

@implementation VJBaseTableViewCell

@synthesize modelObject = _modelObject;

#pragma mark Initialiation

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
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
    //perfrom any setup here
}

#pragma mark Model object protocol

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
    //This is where you fill the cell
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

@end
