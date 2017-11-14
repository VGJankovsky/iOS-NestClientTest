//
//  VJTableViewDatasourceManager.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VJModelProtocol.h"

@interface VJTableViewDatasourceManager : NSObject<UITableViewDataSource, UITableViewDelegate, VJModelProtocol>

@property (nonatomic, weak) IBOutlet UITableView* tableView;

- (void)loadData;
- (void)clearData;
- (void)refreshData;
- (void)reloadData;

@end
