//
//  IOSSystemUtil.m
//  Pods
//
//  Created by geekgy on 15-4-15.
//
//

#import "IOSSystemUtil.h"

#import <AudioToolbox/AudioToolbox.h>

#include <sys/sysctl.h>
#include <sys/utsname.h>

#import <BlocksKit/BlocksKit+UIKit.h>

#import "MBProgressHUD.h"
#import "Reachability.h"

@implementation IOSSystemUtil
{
    Reachability* _reachability;
    MBProgressHUD* _progressHud;
    MBProgressHUD* _loadingHud;
    MBProgressHUD* _messageHud;
}

SINGLETON_DEFINITION(IOSSystemUtil)

- (instancetype)init {
    if (self = [super init]) {
        // 网络状态变化
        __block IOSSystemUtil *systemUtil = self;
        NSString* hostName;
        if ([[self getCountryCode] isEqualToString:@"CN"]) {
            hostName = @"www.baidu.com";
        } else {
            hostName = @"www.google.com";
        }
        _reachability = [Reachability reachabilityWithHostName:hostName];
        _reachability.reachableBlock = ^(Reachability*reach) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [systemUtil networkConnect];
            });
        };
        _reachability.unreachableBlock = ^(Reachability*reach) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [systemUtil networkDisconnect];
            });
        };
        [_reachability startNotifier];
        return self;
    }
    return nil;
}

- (void)networkDisconnect {
    NSLog(@"access internet failed");
}

- (void)networkConnect {
    NSLog(@"access internet success");
}

- (NSString *)getConfigValueWithKey:(NSString *)key {
    NSDictionary* configs = [[NSBundle mainBundle] objectForInfoDictionaryKey:IETCONFIGS_KEY];
    return [configs objectForKey:key];
}

- (NSString *)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *)getCountryCode {
    NSString *country = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    if(!country) {
        country = [[NSLocale systemLocale] objectForKey:NSLocaleCountryCode];
    }
    return country;
}

- (NSString *)getLanguageCode {
    NSString* language = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    if(!language) {
        language = [[NSLocale systemLocale] objectForKey:NSLocaleLanguageCode];
    }
    return language;
}

- (NSString *)getDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *)getSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (time_t)getCpuTime {
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    (void)time(&now);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        uptime = now - boottime.tv_sec;
    }
    return uptime;
}

- (NSString *)getNetworkState {
    NetworkStatus state = [_reachability currentReachabilityStatus];
    NSString* ret = @"NotReachable";
    if (state == ReachableViaWWAN) {
        ret = @"ReachableViaWWAN";
    } else if (state == ReachableViaWiFi) {
        ret = @"ReachableViaWiFi";
    }
    return ret;
}

- (void)showChooseDialog:(NSString *)title :(NSString *)content :(NSString *)ok :(NSString *)cancel :(void (^)(BOOL))callback {
    [UIAlertView bk_showAlertViewWithTitle:title
                                   message:content
                         cancelButtonTitle:cancel
                         otherButtonTitles:@[ok]
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       if (callback != nil) {
                                           if (buttonIndex == 0) {
                                               callback(NO);
                                           } else if (buttonIndex == 1) {
                                               callback(YES);
                                           }
                                       }
                                   }];
}

- (void)showProgressDialog:(NSString*)msg :(int)percent {
    if (_progressHud == nil) {
        _progressHud = [MBProgressHUD showHUDAddedTo:_window animated:YES];
    }
    _progressHud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _progressHud.dimBackground = YES;
    _progressHud.progress = percent/100.0f;
    _progressHud.labelText = msg;
}

- (void)hideProgressDialog {
    if (_progressHud == nil) {
        return;
    }
    [MBProgressHUD hideHUDForView:_window animated:YES];
    _progressHud = nil;
}

- (void)showLoading:(NSString *)msg {
    if (_loadingHud == nil) {
        _loadingHud = [MBProgressHUD showHUDAddedTo:_window animated:YES];
    }
    _loadingHud.mode = MBProgressHUDModeIndeterminate;
    _loadingHud.dimBackground = YES;
    _loadingHud.labelText = msg;
}

- (void)hideLoading {
    if (_loadingHud == nil) {
        return;
    }
    [MBProgressHUD hideHUDForView:_window animated:YES];
    _loadingHud = nil;
}

- (void)showMessage:(NSString *)message {
    MBProgressHUD* messageHud = [MBProgressHUD showHUDAddedTo:_controller.view animated:YES];
    messageHud.mode = MBProgressHUDModeText;
    messageHud.labelText = message;
    messageHud.userInteractionEnabled = NO;
    messageHud.margin = 15.0f;
    messageHud.yOffset = UA_SCREEN_HEIGHT/2-UA_SCREEN_HEIGHT/10;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*2), dispatch_get_main_queue(), ^{
        messageHud.removeFromSuperViewOnHide = YES;
        [messageHud hide:YES];
    });
}

- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
