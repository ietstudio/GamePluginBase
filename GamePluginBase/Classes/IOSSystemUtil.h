//
//  IOSSystemUtil.h
//  Pods
//
//  Created by geekgy on 15-4-15.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "Macros.h"

#if DEBUG
#define NSLog(s, ...) NSLog( @"<%@:%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], [NSString stringWithUTF8String:__FUNCTION__], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#import <NSLogger/NSLogger.h>
#endif

// 配置信息
#define IETCONFIGS_KEY                      @"IETConfigs"

// 网络状态变化通知
#define IETNetworkStateChangedNtf           @"IETNetworkStateChangedNtf"

@interface IOSSystemUtil : NSObject <MFMailComposeViewControllerDelegate>

@property(nonatomic, retain)UIWindow* window;
@property(nonatomic, retain)UIViewController* controller;

SINGLETON_DECLARE(IOSSystemUtil)

/**
 *  获取info.plist中的配置信息
 *
 *  @param key key
 *
 *  @return value
 */
- (NSString*)getConfigValueWithKey:(NSString*)key;

/**
 *  获取bundleId
 *
 *  @return bundleId
 */
- (NSString*)getAppBundleId;

/**
 *  获取App名字
 *
 *  @return 名字
 */
- (NSString*)getAppName;

/**
 *  获取App的version
 *
 *  @return version
 */
- (NSString*)getAppVersion;

/**
 获取App的build

 @return build
 */
- (NSString*)getAppBuild;

/**
 获取设置的本机名称

 @return 本机名称
 */
- (NSString*)getDeviceName;

/**
 获取设备种类

 @return 设备种类
 */
- (NSString*)getDeviceModel;

/**
 *  获取设备型号
 *
 *  @return 设备型号
 */
- (NSString*)getDeviceType;

/**
 获取系统名称

 @return 系统名称
 */
- (NSString*)getSystemName;

/**
 获取系统版本

 @return 系统版本
 */
- (NSString*)getSystemVersion;

/**
 获取idfv标识符

 @return idfv标识符
 */
- (NSString*)getIDFV;

/**
 获取idfa标识符

 @return idfa标识符
 */
- (NSString*)getIDFA;

/**
 获取uuid标识符

 @return uuid标识符
 */
- (NSString*)getUUID;

/**
 *  获取国家代码
 *
 *  @return 国家代码
 */
- (NSString*)getCountryCode;

/**
 *  获取语言代码
 *
 *  @return 语言代码
 */
- (NSString*)getLanguageCode;

/**
 *  获取CPU时间
 *
 *  @return cpu时间
 */
- (time_t)getCpuTime;

/**
 *  获取当前的网络状态
 *
 *  @return 网络状态
 */
- (NSString*)getNetworkState;

/**
 *  显示弹框
 *
 *  @param title          标题
 *  @param message        内容
 *  @param cancelBtnTitle 关闭按钮
 *  @param otherBtnTitles 其它按钮
 *  @param callback       选择回调
 */
- (void)showAlertDialogWithTitle:(NSString *)title
                         message:(NSString *)message
                  cancelBtnTitle:(NSString *)cancelBtnTitle
                  otherBtnTitles:(NSArray *)otherBtnTitles
                        callback:(void (^)(int))callback;

/**
 *  显示进度弹框
 *
 *  @param message  消息
 *  @param percent  百分比
 */
- (void)showProgressDialogWithMessage:(NSString*)message percent:(int)percent;

/**
 *  隐藏进度弹框
 */
- (void)hideProgressDialog;

/**
 *  显示loading
 *
 *  @param message      消息
 */
- (void)showLoadingWithMessage:(NSString*)message;

/**
 *  隐藏loading
 */
- (void)hideLoading;

/**
 *  显示通知
 *
 *  @param message      消息
 */
- (void)showMessage:(NSString*)message;

/**
 *  震动
 */
- (void)vibrate;

/**
 *  保存图片到相册
 *
 *  @param imgPath 图片路径
 *  @param album   相册名称
 *  @param block   回调
 */
- (void)saveImage:(NSString*)imgPath toAlbum:(NSString*)album handler:(void(^)(BOOL, NSString*))block;

/**
 *  发送邮件
 *
 *  @param subject      主题
 *  @param toRecipients 收件人数组
 *  @param emailBody    内容，HTML
 *  @param handler      回调
 *
 *  @return 是否可以发送
 */
- (BOOL)sendEmailWithSubject:(NSString*)subject toRecipients:(NSArray*)toRecipients emailBody:(NSString*)emailBody handler:(void(^)(BOOL, NSString*))handler;

/**
 *  通知开关
 *
 *  @param enable   开关
 */
- (void)setNotificationState:(BOOL)enable;

/**
 *  发送通知
 *
 *  @param userInfo     通知参数
 */
- (void)postNotification:(NSDictionary *)userInfo;

/**
 设置图标角标

 @param num 角标数字
 */
- (void)setBadgeNum:(NSInteger)num;

/**
 *  分享
 *
 *  @param items 分享内容
 */
- (void)share:(NSArray*)items;

/**
 存储key-value到keychain

 @param key         key
 @param value       value
 */
- (void)keychainSet:(NSString*)key withValue:(NSString*)value;


/**
 从keychain获取key对应的value

 @param key         key
 @return value
 */
- (NSString*)keychainGetValueForKey:(NSString*)key;

/**
 检测设备是否是越狱设备

 @return 是否越狱
 */
- (BOOL)isJailbroken;

/**
 保存字符串到剪切板

 @param content 字符串内容
 */
- (void)saveToPasteboard:(NSString*)content;


/**
 发送http请求

 @param type get/post
 @param url url
 @param data 数据
 @param handler 回调
 */
- (void)sendRequest:(NSString*)type url:(NSString*)url data:(NSDictionary*)data handler:(void(^)(BOOL,NSString*))handler;

@end
