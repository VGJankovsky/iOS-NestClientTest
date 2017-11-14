//
//  VJRoundedView.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJRoundedView.h"

@implementation VJRoundedView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius  = self.bounds.size.height / 2;
    self.layer.masksToBounds = YES;
}

@end
