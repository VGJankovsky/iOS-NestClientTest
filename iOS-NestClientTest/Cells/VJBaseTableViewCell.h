//
//  VJBaseTableViewCell.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VJModelProtocol.h"

@interface VJBaseTableViewCell : UITableViewCell <VJModelProtocol>

- (void)commonInit;

@end
