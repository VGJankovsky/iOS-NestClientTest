//
//  VJWebAuthViewController.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/12/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJWebAuthViewController.h"
#import "VJAuthManager.h"
#import "Constants.h"

static NSString *const VJAuthCodeKey = @"code";

@interface VJWebAuthViewController ()<UIWebViewDelegate>
{
    __weak IBOutlet UIWebView* _webView;
}

@end

@implementation VJWebAuthViewController

#pragma mark LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadAuthorizationURL];
}

#pragma mark Private

- (void)loadAuthorizationURL
{
    NSURL* authorizationURL = [NSURL URLWithString:self.authManager.authorizationURLString];
    
    NSURLRequest* authRequest = [NSURLRequest requestWithURL:authorizationURL];
    
    [_webView loadRequest:authRequest];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSURL *redirectURL = [[NSURL alloc] initWithString:VJRedirectURL];
    
    if ([[url host] isEqualToString:[redirectURL host]]) {
        
        NSURLComponents* components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:YES];
        
        NSArray<NSURLQueryItem *>* queryItems = components.queryItems;
        
        __block NSString* code = nil;
        
        [queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:VJAuthCodeKey]) {
                code = obj.value;
                *stop = YES;
            }
        }];
        
        if(code.length)
        {
            [self.authManager authorizationCodeRetrieved:code errorBlock:^(NSError *error) {
                if (error) {
                    NSLog(@"Error retrieving the authorization code.");
                    return;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:VJReceivedAccessTokenNotification object:nil];
            }];
            
        } else {
            NSLog(@"Error retrieving the authorization code.");
        }
        
        return NO;
    }
    
    return YES;
}

@end
