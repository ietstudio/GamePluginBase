//
//  AdvertiseDelegate.h
//  Pods
//
//  Created by geekgy on 15-4-17.
//
//

#import <Foundation/Foundation.h>

#define ADVERTISE_RETRY_INTERVAL 15

@protocol AdvertiseDelegate <UIApplicationDelegate>

@optional

/**
 *  显示Banner广告
 *
 *  @param portrait 竖屏
 *  @param bottom   底部
 *
 *  @return 广告条高度
 */
- (int)showBannerAd:(BOOL)portrait :(BOOL)bottom;

/**
 *  隐藏Banner广告
 */
- (void)hideBannerAd;

/**
 *  插屏广告是否准备就绪
 *
 *  @return 
 */
- (BOOL)isSpotAdReady;

/**
 *  显示插屏广告
 *
 *  @param func 插屏广告是否被点击的回调
 *
 *  @return 插屏广告是否成功显示
 */
- (BOOL)showSpotAd:(void(^)(BOOL))func;

/**
 *  视频广告准备就绪
 *
 *  @return 是否就绪
 */
- (BOOL)isVedioAdReady;

/**
 *  显示视频广告
 *
 *  @param func 视频广告是否播放完毕的回调
 *
 *  @return 视频广告是否成功显示
 */
- (BOOL)showVedioAd:(void(^)(BOOL))viewFunc :(void(^)(BOOL))clickFunc;

/**
 *  返回名称
 *
 *  @return 名称
 */
- (NSString*)getName;

@end
