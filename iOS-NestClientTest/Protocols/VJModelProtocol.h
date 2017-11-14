//
//  VJModelProtocol.h
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VJModelProtocol <NSObject>

@property (nonatomic, strong) id modelObject;

- (void)modelObjectUpdated;
- (void)modelObjectDidTurnToFault;
- (BOOL)modelObjectIsValid:(id)modelObject;

@end
