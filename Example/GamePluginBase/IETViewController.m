//
//  IETViewController.m
//  GamePluginBase
//
//  Created by gaoyang on 06/11/2016.
//  Copyright (c) 2016 gaoyang. All rights reserved.
//

#import "IETViewController.h"
#import "IOSSystemUtil.h"
#import "AdvertiseDelegate.h"
#import "AnalyticDelegate.h"

@interface IETViewController () <UITableViewDataSource, UITableViewDelegate, AdvertiseDelegate, AnalyticDelegate>

@property (retain, nonatomic) NSArray* dataList;

@end

@implementation IETViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDataList];
    [self initNotify];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDataList {
    NSMutableArray* dataList = [NSMutableArray array];
    [dataList addObject:@{@"name":@"getConfigValueWithKey", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getConfigValueWithKey:@"MyKey"]);
    }}];
    [dataList addObject:@{@"name":@"getAppBundleId", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getAppBundleId]);
    }}];
    [dataList addObject:@{@"name":@"getAppName", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getAppName]);
    }}];
    [dataList addObject:@{@"name":@"getAppVersion", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getAppVersion]);
    }}];
    [dataList addObject:@{@"name":@"getAppBuild", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getAppBuild]);
    }}];
    [dataList addObject:@{@"name":@"getDeviceName", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getDeviceName]);
    }}];
    [dataList addObject:@{@"name":@"getDeviceModel", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getDeviceModel]);
    }}];
    [dataList addObject:@{@"name":@"getDeviceType", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getDeviceType]);
    }}];
    [dataList addObject:@{@"name":@"getSystemName", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getSystemName]);
    }}];
    [dataList addObject:@{@"name":@"getSystemVersion", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getSystemVersion]);
    }}];
    [dataList addObject:@{@"name":@"getIDFV", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getIDFV]);
    }}];
    [dataList addObject:@{@"name":@"getIDFA", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getIDFA]);
    }}];
    [dataList addObject:@{@"name":@"getUUID", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getUUID]);
    }}];
    [dataList addObject:@{@"name":@"getCountryCode", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getCountryCode]);
    }}];
    [dataList addObject:@{@"name":@"getLanguageCode", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getLanguageCode]);
    }}];
    [dataList addObject:@{@"name":@"getCpuTime", @"func":^(){
        NSLog(@"%ld", [[IOSSystemUtil getInstance] getCpuTime]);
    }}];
    [dataList addObject:@{@"name":@"getNetworkState", @"func":^(){
        NSLog(@"%@", [[IOSSystemUtil getInstance] getNetworkState]);
    }}];
    [dataList addObject:@{@"name":@"showAlertDialog", @"func":^(){
        [[IOSSystemUtil getInstance] showAlertDialogWithTitle:@"title"
                                                      message:@"message"
                                               cancelBtnTitle:@"cancel"
                                               otherBtnTitles:@[@"ok"]
                                                     callback:^(int buttonIdx) {
                                                         NSLog(@"buttonIdx = %d", buttonIdx);
                                                     }];
    }}];
    [dataList addObject:@{@"name":@"showProgressDialog", @"func":^(){
        [[IOSSystemUtil getInstance] showProgressDialogWithMessage:@"Loading..." percent:50];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5), dispatch_get_main_queue(), ^{
            [[IOSSystemUtil getInstance] hideProgressDialog];
        });
    }}];
    [dataList addObject:@{@"name":@"showLoading", @"func":^(){
        [[IOSSystemUtil getInstance] showLoadingWithMessage:@"Loading..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5), dispatch_get_main_queue(), ^{
            [[IOSSystemUtil getInstance] hideLoading];
        });
    }}];
    [dataList addObject:@{@"name":@"showMessage", @"func":^(){
        NSString* message = [NSString stringWithFormat:@"%@", [NSDate date]];
        [[IOSSystemUtil getInstance] showMessage:message];
    }}];
    [dataList addObject:@{@"name":@"vibrate", @"func":^(){
        [[IOSSystemUtil getInstance] vibrate];
    }}];
    [dataList addObject:@{@"name":@"saveImage", @"func":^(){
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"close" ofType:@"png"];
        [[IOSSystemUtil getInstance] saveImage:imagePath
                                       toAlbum:@"test"
                                       handler:^(BOOL result, NSString *message) {
                                           NSLog(@"result = %@, message = %@", NSStringFromBool(result), message);
                                       }];
    }}];
    [dataList addObject:@{@"name":@"sendEmail", @"func":^(){
        [[IOSSystemUtil getInstance] sendEmailWithSubject:@"subject"
                                             toRecipients:@[@"xx@xx.com"]
                                                emailBody:@"emailBody"
                                                  handler:^(BOOL result, NSString *message) {
                                                      NSLog(@"result = %@, message = %@", NSStringFromBool(result), message);
                                                  }];
    }}];
    [dataList addObject:@{@"name":@"setNotificationState", @"func":^(){
        [[IOSSystemUtil getInstance] setNotificationState:YES];
    }}];
    [dataList addObject:@{@"name":@"postNotification", @"func":^(){
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@"message" forKey:@"message"];
        [userInfo setObject:@(5) forKey:@"delay"];
        [[IOSSystemUtil getInstance] postNotification:userInfo];
    }}];
    [dataList addObject:@{@"name":@"share", @"func":^(){
        NSMutableArray* items = [NSMutableArray array];
        [items addObject:@"test message"];
        [[IOSSystemUtil getInstance] share:items];
    }}];
    [dataList addObject:@{@"name":@"keychainSet", @"func":^(){
        [[IOSSystemUtil getInstance] keychainSet:@"key" withValue:@"value"];
    }}];
    [dataList addObject:@{@"name":@"keychainGet", @"func":^(){
        NSString* value = [[IOSSystemUtil getInstance] keychainGetValueForKey:@"key"];
        if (value == nil) {
            NSLog(@"nil");
        } else {
            NSLog(value);
        }
    }}];
    [dataList addObject:@{@"name":@"isJailbroken", @"func":^(){
        NSLog(@"%@", NSStringFromBool([[IOSSystemUtil getInstance] isJailbroken]));
    }}];
    self.dataList = dataList;
}

- (void)initNotify {
    [[NSNotificationCenter defaultCenter] addObserverForName:IETNetworkStateChangedNtf
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      NSLog(@"%@", note.userInfo);
                                                      NSString* message = [NSString stringWithFormat:@"%@", [note.userInfo objectForKey:@"state"]];
                                                      [[IOSSystemUtil getInstance] showMessage:message];
                                                  }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellWithIdentifier];
    }
    NSDictionary* data = [self.dataList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [data objectForKey:@"name"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* data = [self.dataList objectAtIndex:[indexPath row]];
    ((void(^)())[data objectForKey:@"func"])();
}


@end
