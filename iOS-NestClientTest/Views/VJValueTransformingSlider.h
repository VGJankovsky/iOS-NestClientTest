//
//  VJValueTransformingSlider.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VJValueTransformingSlider : UISlider

@property (nonatomic, strong) NSNumber* minModelValue;
@property (nonatomic, strong) NSNumber* maxModelValue;
@property (nonatomic, strong) NSNumber* currentModelValue;

@end
