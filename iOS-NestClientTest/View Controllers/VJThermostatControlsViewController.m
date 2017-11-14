//
//  VJThermostatControlsViewController.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/14/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJThermostatControlsViewController.h"
#import "VJNestThermostatModel.h"
#import "VJAPIManager.h"
#import "VJValueTransformingSlider.h"
#import "Constants.h"

static NSTimeInterval const VJThermostatUpdateTimeout = 10.f;

static NSInteger const VJCurrentTempMinF = -4;
static NSInteger const VJCurrentTempMaxF = 140;

static NSInteger const VJTargetTempMinF = 50;
static NSInteger const VJTargetTempMaxF = 90;

static NSInteger const VJHumidityMin = 0;
static NSInteger const VJHumidityMax = 100;

@interface VJThermostatControlsViewController ()
{
    __weak IBOutlet UILabel* _mainCurrentTempLabel;
    __weak IBOutlet UILabel* _currentTempLabel;
    __weak IBOutlet UILabel* _targetTempLabel;
    __weak IBOutlet UILabel* _whereLabel;
    __weak IBOutlet UILabel* _humidityLabel;
    __weak IBOutlet VJValueTransformingSlider* _humiditySlider;
    __weak IBOutlet VJValueTransformingSlider* _currentTempSlider;
    __weak IBOutlet VJValueTransformingSlider* _targetTempSlider;
    __weak IBOutlet UISwitch* _canHeatSwitch;
    __weak IBOutlet UISwitch* _canCoolSwitch;
    __weak IBOutlet UISwitch* _fanSwitch;
}

@property (nonatomic, strong) NSTimer* updateTimer;

@end

@implementation VJThermostatControlsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self subscribeToNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupSliders];
    [self setupFanSwitch];
    [self thermostatUpdated];
    [self restartTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.updateTimer invalidate];
}

- (void)subscribeToNotifications
{
    NSNotificationCenter* defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(didReceiveControlsStartedChangingDataNotification:) name:VJControlsStartedChangingDataNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(didReceiveControlChangingDataNotification:) name:VJControlsChangingDataNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(didReceiveControlsStoppedChangingDataNotification:) name:VJControlDidEndChangingDataNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)restartTimer
{
    [self.updateTimer invalidate];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:VJThermostatUpdateTimeout target:self selector:@selector(updateThermostatStats) userInfo:nil repeats:YES];
}

- (void)setThermostat:(VJNestThermostatModel *)thermostat
{
    _thermostat = thermostat;
    self.title = _thermostat.nameLong;
    [self thermostatUpdated];
}

- (void)thermostatUpdated
{
    _mainCurrentTempLabel.text = self.thermostat.targetTempF.stringValue;
    _currentTempLabel.text     = [NSString stringWithFormat:@"Current temp: %@ F", self.thermostat.ambientTempF];
    _targetTempLabel.text      = [NSString stringWithFormat:@"Target temp: %@ F", self.thermostat.targetTempF];
    _humidityLabel.text        = [NSString stringWithFormat:@"Humidity: %@ %%", self.thermostat.humidity];
    _canCoolSwitch.on          = self.thermostat.canCool;
    _canHeatSwitch.on          = self.thermostat.canHeat;
    _fanSwitch.on              = self.thermostat.fanTimerActive;
    _humiditySlider.currentModelValue = self.thermostat.humidity;
    _targetTempSlider.currentModelValue = self.thermostat.targetTempF;
    _currentTempSlider.currentModelValue = self.thermostat.ambientTempF;
    
    _whereLabel.text = self.thermostat.whereName;
}

- (void)setupSliders
{
    _humiditySlider.minModelValue = @(VJHumidityMin);
    _humiditySlider.maxModelValue = @(VJHumidityMax);
    _currentTempSlider.minModelValue = @(VJCurrentTempMinF);
    _currentTempSlider.maxModelValue = @(VJCurrentTempMaxF);
    _targetTempSlider.minModelValue = @(VJTargetTempMinF);
    _targetTempSlider.maxModelValue = @(VJTargetTempMaxF);
}

- (void)setupFanSwitch
{
    [_fanSwitch addTarget:self action:@selector(fanSwitchChangedValue) forControlEvents:UIControlEventValueChanged];
}

- (void)fanSwitchChangedValue
{
    [self gatherDataFromControls];
    [self sendUpdatedData];
}

- (void)didReceiveControlsStartedChangingDataNotification:(NSNotification *)notification
{
    [self.updateTimer invalidate];
}

- (void)didReceiveControlChangingDataNotification:(NSNotification *)notification
{
    [self gatherDataFromControls];
}

- (void)didReceiveControlsStoppedChangingDataNotification:(NSNotification *)notifcation
{
    [self sendUpdatedData];
}

- (void)gatherDataFromControls
{
    self.thermostat.targetTempF = _targetTempSlider.currentModelValue;
    self.thermostat.fanTimerActive = _fanSwitch.on;
    
    [self thermostatUpdated];
}

- (void)sendUpdatedData
{
    __weak __typeof(self) wSelf = self;
    [self.apiManager setThermostatDataWithThermostat:self.thermostat completion:^(NSError *error) {
        if (error) {
            return;
        }
        
        __strong __typeof(self) sSelf = wSelf;
        [sSelf restartTimer];
    }];
}

- (void)updateThermostatStats
{
    __weak __typeof(self) wSelf = self;
    [self.apiManager getThermostatWithID:self.thermostat.deviceID completion:^(VJNestThermostatModel *thermostat, NSError *error) {
        __strong __typeof(self) sSelf = wSelf;
        sSelf.thermostat = thermostat;
    }];
}

@end
