//
//  IETViewController.m
//  GamePluginBase
//
//  Created by gaoyang on 06/11/2016.
//  Copyright (c) 2016 gaoyang. All rights reserved.
//

#import "IETViewController.h"
#import "IOSSystemUtil.h"

@interface IETViewController ()

@end

@implementation IETViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getConfigValue:(id)sender {
    NSLog(@"%@", [[IOSSystemUtil getInstance] getConfigValueWithKey:@"MyKey"]);
}

- (IBAction)getAppVersion:(id)sender {
    NSLog(@"%@", [[IOSSystemUtil getInstance] getAppVersion]);
}

- (IBAction)getCountry:(id)sender {
    NSLog(@"%@", [[IOSSystemUtil getInstance] getCountryCode]);
}

- (IBAction)getLanguage:(id)sender {
    NSLog(@"%@", [[IOSSystemUtil getInstance] getLanguageCode]);
}

- (IBAction)getDeviceName:(id)sender {
    NSLog(@"%@", [[IOSSystemUtil getInstance] getDeviceName]);
}

- (IBAction)getSystemVersion:(id)sender {
    NSLog(@"%@", [[IOSSystemUtil getInstance] getSystemVersion]);
}

- (IBAction)getCpuTime:(id)sender {
    NSLog(@"%ld", [[IOSSystemUtil getInstance] getCpuTime]);
}

- (IBAction)getNetworkState:(id)sender {
    NSLog(@"%@", [[IOSSystemUtil getInstance] getNetworkState]);
}

- (IBAction)showChooseDialog:(id)sender {
    [[IOSSystemUtil getInstance] showChooseDialog:@"title"
                                                 :@"msg"
                                                 :@"ok"
                                                 :@"cancel"
                                                 :^(BOOL result) {
                                                     NSLog(@"%@", result?@"YES":@"NO");
                                                 }];
}

- (IBAction)showProgressDialog:(id)sender {
    [[IOSSystemUtil getInstance] showProgressDialog:@"Loading..." :50];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5), dispatch_get_main_queue(), ^{
        [[IOSSystemUtil getInstance] hideProgressDialog];
    });
}

- (IBAction)showLoading:(id)sender {
    [[IOSSystemUtil getInstance] showLoading:@"Loading..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5), dispatch_get_main_queue(), ^{
        [[IOSSystemUtil getInstance] hideLoading];
    });
}

- (IBAction)showMessage:(id)sender {
    NSString* message = [NSString stringWithFormat:@"%@", [NSDate date]];
    [[IOSSystemUtil getInstance] showMessage:message];
}

- (IBAction)vibrate:(id)sender {
    [[IOSSystemUtil getInstance] vibrate];
}

@end
