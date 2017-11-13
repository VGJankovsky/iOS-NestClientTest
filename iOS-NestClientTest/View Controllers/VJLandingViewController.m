//
//  VJLandingViewController.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJLandingViewController.h"
#import "VJAuthManager.h"

static NSString *const VJAuthenticateSegueName = @"Authentication";

@interface VJLandingViewController ()
{
    __weak IBOutlet UIView* _needAuthView;
    __weak IBOutlet UIButton* _authenticateBtn;
    
}

@end

@implementation VJLandingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _needAuthView.hidden = self.authManager.isLoggedIn;
}

@end
