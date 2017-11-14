//
//  VJValueTransformingSlider.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJValueTransformingSlider.h"
#import "Constants.h"

@implementation VJValueTransformingSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (void)setCurrentModelValue:(NSNumber *)currentModelValue
{
    double range = self.maxModelValue.integerValue - self.minModelValue.integerValue;
    
    double relativeValue = currentModelValue.integerValue - self.minModelValue.integerValue;
    
    double value = relativeValue/range;
    
    [UIView animateWithDuration:.5f animations:^{
        self.value = value;
    }];
 
}

- (NSNumber *)currentModelValue
{
    float percent = self.value;
    NSInteger range = self.maxModelValue.integerValue - self.minModelValue.integerValue;
    
    return @(round(percent * range) + self.minModelValue.integerValue);
}

- (void)commonInit
{
    [self addTarget:self action:@selector(startedChangingValue) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(changingValue) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(didEndChangingValue) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startedChangingValue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VJControlsStartedChangingDataNotification object:self];
}

- (void)changingValue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VJControlsChangingDataNotification object:self];
}

- (void)didEndChangingValue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VJControlDidEndChangingDataNotification object:self];
}

@end
