//
//  IOSSystemUtil.h
//  Pods
//
//  Created by geekgy on 15-4-15.
//
//

#import <Foundation/Foundation.h>
#import "Macros.h"

// 配置信息
#define IETCONFIGS_KEY                      @"IETConfigs"
// Apple ID
#define APPLE_ID                            @"Apple_ID"

@interface IOSSystemUtil : NSObject

@property(nonatomic, retain)UIWindow* window;
@property(nonatomic, retain)UIViewController* controller;
@property(nonatomic, retain)NSString* buildNum;

SINGLETON_DECLARE(IOSSystemUtil)

/**
 *  获取info.plist中的配置信息
 *
 *  @param key
 *
 *  @return
 */
- (NSString*)getConfigValueWithKey:(NSString*)key;

/**
 *  获取App的版本号，build
 *
 *  @return
 */
- (NSString*)getAppVersion;

/**
 *  获取国家代码
 *
 *  @return
 */
- (NSString*)getCountryCode;

/**
 *  获取语言代码
 *
 *  @return
 */
- (NSString*)getLanguageCode;

/**
 *  获取设备名称
 *
 *  @return
 */
- (NSString*)getDeviceName;

/**
 *  获取系统版本
 *
 *  @return
 */
- (NSString*)getSystemVersion;

/**
 *  获取CPU时间
 *
 *  @return
 */
- (time_t)getCpuTime;

/**
 *  获取当前的网络状态
 *
 *  @return
 */
- (NSString*)getNetworkState;

/**
 *  显示选择框
 *
 *  @param title    标题
 *  @param content  内容
 *  @param ok       确定文本
 *  @param cancel   取消文本
 *  @param callback 回调函数
 */
- (void)showChooseDialog:(NSString*)title :(NSString*)content :(NSString*)ok :(NSString*)cancel :(void(^)(BOOL))callback;

/**
 *  显示进度弹框
 *
 *  @param msg
 *  @param percent
 */
- (void)showProgressDialog:(NSString*)msg :(int)percent;

/**
 *  隐藏进度弹框
 */
- (void)hideProgressDialog;

/**
 *  显示loading
 *
 *  @param msg
 */
- (void)showLoading:(NSString*)msg;

/**
 *  隐藏loading
 */
- (void)hideLoading;

/**
 *  显示通知
 *
 *  @param message
 */
- (void)showMessage:(NSString*)message;

/**
 *  震动
 */
- (void)vibrate;

@end
