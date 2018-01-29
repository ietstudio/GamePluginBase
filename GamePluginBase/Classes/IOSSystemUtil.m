//
//  IOSSystemUtil.m
//  Pods
//
//  Created by geekgy on 15-4-15.
//
//

#import "IOSSystemUtil.h"

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import <AdSupport/ASIdentifierManager.h>
#import <AFNetworking/AFNetworking.h>

#include <sys/sysctl.h>
#include <sys/utsname.h>

#import "BlocksKit/BlocksKit+UIKit.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "UIDevice+FCUUID.h"

#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UICKeyChainStore.h"
#import "JailbrokenDetector.h"

@implementation IOSSystemUtil
{
    Reachability* _reachability;
    MBProgressHUD* _progressHud;
    MBProgressHUD* _loadingHud;
    MBProgressHUD* _messageHud;
    void (^_emailHandler)(BOOL, NSString*);
}

SINGLETON_DEFINITION(IOSSystemUtil)

- (instancetype)init {
    if (self = [super init]) {
        // 网络状态变化
        NSString* hostName = [[self getCountryCode] isEqualToString:@"CN"] ? @"www.baidu.com" : @"www.google.com";
        _reachability = [Reachability reachabilityWithHostName:hostName];
        [[NSNotificationCenter defaultCenter] addObserverForName:kReachabilityChangedNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          NetworkStatus state = [_reachability currentReachabilityStatus];
                                                          NSDictionary* userInfo = @{@"state": @(state)};
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:IETNetworkStateChangedNtf object:nil userInfo:userInfo];
                                                      }];
        [_reachability startNotifier];
        return self;
    }
    return nil;
}

- (NSString *)getConfigValueWithKey:(NSString *)key {
    NSDictionary* configs = [[NSBundle mainBundle] objectForInfoDictionaryKey:IETCONFIGS_KEY];
    return [configs objectForKey:key];
}

- (NSString *)getAppBundleId {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

- (NSString *)getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

- (NSString *)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)getAppBuild {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *)getDeviceName {
    return [[UIDevice currentDevice] name];
}

- (NSString *)getDeviceModel {
    return [[UIDevice currentDevice] localizedModel];
}

- (NSString *)getDeviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *)getSystemName {
    return [[UIDevice currentDevice] systemName];
}

- (NSString *)getSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)getIDFV {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)getIDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

- (NSString *)getUUID {
    return [[UIDevice currentDevice] uuid];
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

- (void)showAlertDialogWithTitle:(NSString *)title
                         message:(NSString *)message
                  cancelBtnTitle:(NSString *)cancelBtnTitle
                  otherBtnTitles:(NSArray *)otherBtnTitles
                        callback:(void (^)(int))callback {
    [UIAlertView bk_showAlertViewWithTitle:title
                                   message:message
                         cancelButtonTitle:cancelBtnTitle
                         otherButtonTitles:otherBtnTitles
                                   handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       if (callback != nil) {
                                           callback((int)buttonIndex);
                                       }
                                   }];
}

- (void)showProgressDialogWithMessage:(NSString *)message percent:(int)percent {
    if (_progressHud == nil) {
        _progressHud = [MBProgressHUD showHUDAddedTo:_window animated:YES];
    }
    _progressHud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _progressHud.dimBackground = YES;
    _progressHud.progress = percent/100.0f;
    _progressHud.labelText = message;
}

- (void)hideProgressDialog {
    if (_progressHud == nil) {
        return;
    }
    [MBProgressHUD hideHUDForView:_window animated:YES];
    _progressHud = nil;
}

- (void)showLoadingWithMessage:(NSString *)message {
    if (_loadingHud == nil) {
        _loadingHud = [MBProgressHUD showHUDAddedTo:_window animated:YES];
    }
    _loadingHud.mode = MBProgressHUDModeIndeterminate;
    _loadingHud.dimBackground = YES;
    _loadingHud.labelText = message;
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

- (void)saveImage:(NSString *)imgPath toAlbum:(NSString *)album handler:(void (^)(BOOL, NSString *))block {
    UIImage* imageToSave = [UIImage imageWithContentsOfFile:imgPath];
    [[[ALAssetsLibrary alloc] init] saveImage:imageToSave
                                      toAlbum:album
                                   completion:^(NSURL *assetURL, NSError *error) {
                                       block(YES, [assetURL absoluteString]);
                                   } failure:^(NSError *error) {
                                       NSLog(@"%@", error);
                                       block(NO, [error localizedDescription]);
                                   }];
}

- (BOOL)sendEmailWithSubject:(NSString *)subject
                toRecipients:(NSArray *)toRecipients
                   emailBody:(NSString *)emailBody
                     handler:(void (^)(BOOL, NSString *))handler {
    if (![MFMailComposeViewController canSendMail]) {
        return NO;
    };
    if (_emailHandler == nil) {
        _emailHandler = handler;
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject: subject];//设置主题
        [controller setToRecipients: toRecipients];//添加收件人
        [controller setMessageBody:emailBody isHTML:YES];//添加正文
        [[[IOSSystemUtil getInstance] controller] presentViewController:controller animated:YES completion:^{
            NSLog(@"email controller present");
        }];
    }
    return YES;
}

- (void)setNotificationState:(BOOL)enable {
    if (enable) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
            // Configures the appearance
            [UINavigationBar appearance].barTintColor = [UIColor blackColor];
            [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            
            // Sets up Mobile Push Notification
            UIMutableUserNotificationAction *readAction = [UIMutableUserNotificationAction new];
            readAction.identifier = @"READ_IDENTIFIER";
            readAction.title = @"Read";
            readAction.activationMode = UIUserNotificationActivationModeForeground;
            readAction.destructive = NO;
            readAction.authenticationRequired = YES;
            
            UIMutableUserNotificationAction *deleteAction = [UIMutableUserNotificationAction new];
            deleteAction.identifier = @"DELETE_IDENTIFIER";
            deleteAction.title = @"Delete";
            deleteAction.activationMode = UIUserNotificationActivationModeForeground;
            deleteAction.destructive = YES;
            deleteAction.authenticationRequired = YES;
            
            UIMutableUserNotificationAction *ignoreAction = [UIMutableUserNotificationAction new];
            ignoreAction.identifier = @"IGNORE_IDENTIFIER";
            ignoreAction.title = @"Ignore";
            ignoreAction.activationMode = UIUserNotificationActivationModeForeground;
            ignoreAction.destructive = NO;
            ignoreAction.authenticationRequired = NO;
            
            UIMutableUserNotificationCategory *messageCategory = [UIMutableUserNotificationCategory new];
            messageCategory.identifier = @"MESSAGE_CATEGORY";
            [messageCategory setActions:@[readAction, deleteAction] forContext:UIUserNotificationActionContextMinimal];
            [messageCategory setActions:@[readAction, deleteAction, ignoreAction] forContext:UIUserNotificationActionContextDefault];
            
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:[NSSet setWithArray:@[messageCategory]]];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
        }
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        }
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (void)postNotification:(NSDictionary *)userInfo {
    NSString* message = [userInfo objectForKey:@"message"];
    NSTimeInterval delay = [[userInfo objectForKey:@"delay"] doubleValue];
    NSString* sound = [userInfo objectForKey:@"sound"];
    NSNumber* badgeNumber = [userInfo objectForKey:@"badge"];
    sound = sound==nil?UILocalNotificationDefaultSoundName:sound;
    int badge = badgeNumber==nil?1:[badgeNumber intValue];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    [localNotification setAlertBody:message];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:delay]];
    [localNotification setSoundName:sound];
    [localNotification setApplicationIconBadgeNumber:badge];
    [localNotification setUserInfo:userInfo];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)cancelNotification:(UILocalNotification *)notification {
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

- (void)calcelAllNotifications {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification * notification in notifications) {
        [self cancelNotification:notification];
    }
}

- (void)setBadgeNum:(NSInteger)num {
    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
}

- (void)share:(NSArray *)items {
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    [self.controller presentViewController:activityController animated:YES completion:nil];
}

- (void)keychainSet:(NSString *)key withValue:(NSString *)value {
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:[self getAppBundleId]];
    keychain[key] = value;
}

- (NSString *)keychainGetValueForKey:(NSString *)key {
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:[self getAppBundleId]];
    return keychain[key];
}

- (BOOL)isJailbroken {
    return [JailbrokenDetector isDeviceJailbroken];
}

- (void)saveToPasteboard:(NSString *)content {
    [UIPasteboard generalPasteboard].string = content;
}

- (void)sendRequest:(NSString *)type url:(NSString *)url data:(NSDictionary *)data handler:(void (^)(BOOL, NSDictionary *))handler {
    void(^success)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        handler(true, responseObject);
    };
    void(^failure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handler(false, @{@"error": error.localizedDescription});
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:10];
    
    if ([type isEqualToString:@"get"]) {
        [manager GET:url parameters:nil progress:nil success:success failure:failure];
    } else {
        [manager POST:url parameters:data progress:nil success:success failure:failure];
    }
}

- (void)setObject:(NSObject *)object forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}

- (NSObject *)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    //关闭邮件发送窗口
    [controller dismissViewControllerAnimated:YES completion:^{
        NSLog(@"email controller dismiss");
    }];
    BOOL success = NO;
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            success = YES;
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
    }
    NSLog(@"%@", msg);
    _emailHandler(success, msg);
    _emailHandler = nil;
}

@end
