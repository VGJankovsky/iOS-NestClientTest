//
//  VJLandingViewController.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJLandingViewController.h"
#import "VJAuthManager.h"
#import "Constants.h"
#import "VJStructuresDatasourceManager.h"
#import "VJStructureViewController.h"

static NSString *const VJAuthenticateSegueName = @"Authentication";
static NSString *const VJShowStructureViewControllerSegue = @"ShowStructure";

@interface VJLandingViewController ()
{
    __weak IBOutlet UIView* _needAuthView;
    __weak IBOutlet UIButton* _authenticateBtn;
    
}

@property (nonatomic, strong) IBOutlet VJStructuresDatasourceManager* datasourceManager;
@property (nonatomic, strong) VJNestStructureModel* selectedStructure;

@end

@implementation VJLandingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self subscribeToNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Your Nest";
    
    _needAuthView.hidden = self.authManager.isLoggedIn;
    
    if (self.authManager.isLoggedIn) {
        [self.datasourceManager loadData];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)subscribeToNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAccessTokenNotification:) name:VJReceivedAccessTokenNotification object:nil];
}

- (void)setDatasourceManager:(VJStructuresDatasourceManager *)datasourceManager
{
    _datasourceManager = datasourceManager;
    
    __weak __typeof (self) wSelf = self;
    
    [_datasourceManager setActionBlock:^(VJNestStructureModel *model) {
        __strong __typeof (self) sSelf = wSelf;
        sSelf.selectedStructure = model;
        [sSelf performSegueWithIdentifier:VJShowStructureViewControllerSegue sender:sSelf];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:VJShowStructureViewControllerSegue]) {
        VJStructureViewController* destinationVC = segue.destinationViewController;
        destinationVC.structureModel = self.selectedStructure;
        self.selectedStructure = nil;
    }
}

#pragma mark Notification observation

- (void)didReceiveAccessTokenNotification:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
