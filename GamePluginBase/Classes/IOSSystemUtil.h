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
 *  获取bundleId
 *
 *  @return
 */
- (NSString*)getBundleId;

/**
 *  获取App名字
 *
 *  @return 
 */
- (NSString*)getAppName;

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
 *  @param msg
 *  @param percent
 */
- (void)showProgressDialogWithMessage:(NSString*)message percent:(int)percent;

/**
 *  隐藏进度弹框
 */
- (void)hideProgressDialog;

/**
 *  显示loading
 *
 *  @param msg
 */
- (void)showLoadingWithMessage:(NSString*)message;

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
 *  @param callback     回调
 *
 *  @return 是否可以发送
 */
- (BOOL)sendEmailWithSubject:(NSString*)subject toRecipients:(NSArray*)toRecipients emailBody:(NSString*)emailBody handler:(void(^)(BOOL, NSString*))callback;

/**
 *  通知开关
 *
 *  @param enable
 */
- (void)setNotificationState:(BOOL)enable;

/**
 *  发送通知
 *
 *  @param userInfo
 */
- (void)postNotification:(NSDictionary *)userInfo;

/**
 *  分享
 *
 *  @param items 分享内容
 */
- (void)share:(NSArray*)items;


@end
