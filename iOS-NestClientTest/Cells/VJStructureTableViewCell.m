//
//  VJStructureTableViewCell.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJStructureTableViewCell.h"
#import "VJNestStructureModel.h"

@interface VJStructureTableViewCell()
{
    __weak IBOutlet UILabel* _nameLabel;
}

@property (nonatomic, readonly) VJNestStructureModel* castedModel;

@end

@implementation VJStructureTableViewCell

- (void)commonInit
{
    
}

- (BOOL)modelObjectIsValid:(id)modelObject
{
    return [modelObject isKindOfClass:[VJNestStructureModel class]];
}

- (void)modelObjectUpdated
{
    _nameLabel.text = self.castedModel.name;
}

- (VJNestStructureModel *)castedModel
{
    return self.modelObject;
}

@end
