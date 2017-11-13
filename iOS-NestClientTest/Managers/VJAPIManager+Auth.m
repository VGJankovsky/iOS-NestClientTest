//
//  VJAPIManager+Auth.m
//  iOS-NestClientTest
//
//  Created by Vadym Yankovskiy on 11/13/17.
//  Copyright © 2017 Vadym Yankovskiy. All rights reserved.
//

#import "VJApiManager_Private.h"
#import "VJAPIManager+Auth.h"

static NSString *const VJDeauthFormattedURLString = @"https://api.%@/oauth2/access_tokens/%@";

@implementation VJAPIManager (Auth)

/**
 * Get the URL to deauthorize the connection.
 * @return The URL to deauthorize the connection.
 */
- (NSString *)deauthorizationURL
{
    return [NSString stringWithFormat:VJDeauthFormattedURLString, VJNestCurrentAPIDomain, self.authManager.tokenString];
}

/**
 * Get the URL for to get the access key.
 * @return The URL to get the access token from Nest.
 */
- (NSString *)accessURLWithAuthCode:(NSString *)authCode
{

    
    if (clientId && clientSecret && authorizationCode) {
        return [NSString stringWithFormat:@"https://api.%@/oauth2/access_token?code=%@&client_id=%@&client_secret=%@&grant_type=authorization_code", NestCurrentAPIDomain, authorizationCode, clientId, clientSecret];
    } else {
        if (!clientSecret) {
            NSLog(@"Missing Client Secret");
        }
        if (!clientId) {
            NSLog(@"Missing Client ID");
        }
        if (!authorizationCode) {
            NSLog(@"Missing authorization code");
        }
        return nil;
    }
}

- (void)exchangeCodeForToken
{
    // Create the response data
    self.responseData = [[NSMutableData alloc] init];
    
    // Get the accessURL
    NSString *accessURL = [self accessURL];
    
    // For the POST request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:accessURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"form-data" forHTTPHeaderField:@"Content-Type"];
    
    // Assign the session to the main queue so the call happens immediately
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
          NSLog(@"AuthManager Token Response Status Code: %ld", (long)[httpResponse statusCode]);
          
          [self.responseData appendData:data];
          
          // The request is complete and data has been received
          // You can parse the stuff in your instance variable now
          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                               options:kNilOptions
                                                                 error:&error];
          
          // Store the access key
          long expiresIn = [[json objectForKey:@"expires_in"] longValue];
          NSString *accessToken = [json objectForKey:@"access_token"];
          [self setAccessToken:accessToken withExpiration:expiresIn];
          
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          
      }] resume];
    
}

#pragma mark - NestControlsViewControllerDelegate Methods

/**
 * Called from NestControlsViewControllerDelegate, lets
 * the AuthManager know to deauthorize the Works with Nest connection
 */
- (void)deauthorizeConnection
{
    
    NSLog(@"deauthorizeConnection");
    
    // Get the deauthorizationURL
    NSString *deauthURL = [self deauthorizationURL];
    
    // Create the DELETE request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:deauthURL]];
    [request setHTTPMethod:@"DELETE"];
    
    // Assign the session to the main queue so the call happens immediately
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          
          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
          NSLog(@"AuthManager Delete Response Status Code: %ld", (long)[httpResponse statusCode]);
          
      }] resume];
    
    // Delete the access token and authorization code from storage
    [self removeAuthorizationData];
    
}

@end
