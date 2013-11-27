//
//  ViewController.m
//  GoogleAuth
//
//  Created by Wade Wegner on 11/27/13.
//  Copyright (c) 2013 Wade Wegner. All rights reserved.
//

#import "ViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2SignIn.h"

#define ClientID            @"GOOGLE_CLIENT_ID"
#define ClientSecret        @"GOOGLE_CLIENT_SECRET"
#define AuthURL             @"https://accounts.google.com/o/oauth2/auth"
#define TokenURL            @"https://accounts.google.com/o/oauth2/token"
#define KeychainName        @"GoogleKeychainName"
#define ServiceProvicer     @"InstrumentationApp"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loginInToGoogle];
}

- (void)loginInToGoogle
{
    GTMOAuth2Authentication * auth = nil;
    
    NSURL * tokenURL = [NSURL URLWithString:TokenURL];
    NSString * redirectURI = @"urn:ietf:wg:oauth:2.0:oob";

    auth = [GTMOAuth2Authentication
            authenticationWithServiceProvider:ServiceProvicer
            tokenURL:tokenURL
            redirectURI:redirectURI
            clientID:ClientID
            clientSecret:ClientSecret];
    
    auth.scope = @"https://www.googleapis.com/auth/plus.me";

    GTMOAuth2ViewControllerTouch * viewController =
        [[GTMOAuth2ViewControllerTouch alloc]
         initWithAuthentication:auth
         authorizationURL:[NSURL URLWithString:AuthURL]
         keychainItemName:KeychainName
         delegate:self
         finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch * )viewController
      finishedWithAuth:(GTMOAuth2Authentication * )auth
                 error:(NSError * )error
{
    NSString * accessToken = auth.accessToken;
    
    NSLog(@"auth access token: %@", accessToken);
    self.TokenLabel.Text = accessToken;
    
    [self.navigationController popToViewController:self animated:NO];
    if (error != nil) {
        
        UIAlertView * alert =
            [[UIAlertView alloc]
             initWithTitle:@"Error"
             message:[error localizedDescription]
             delegate:nil
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
        
        [alert show];
    } else {
        
        UIAlertView * alert =
            [[UIAlertView alloc]
             initWithTitle:@"Successfully logged in!"
             message:[error localizedDescription]
             delegate:nil
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end