//
//  AnalyticDelegate.h
//  Pods
//
//  Created by geekgy on 15-4-17.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol AnalyticDelegate <UIApplicationDelegate>

@optional

/**
 *  设置账户信息
 *
 *  @param dict 账户信息
 */
- (void)setAccoutInfo:(NSDictionary*)dict;

/**
 *  发送事件
 *
 *  @param eventId 事件id
 */
- (void)onEvent:(NSString*)eventId;

/**
 *  发送事件
 *
 *  @param eventId 事件id
 *  @param label   事件内容
 */
- (void)onEvent:(NSString*)eventId Label:(NSString*)label;

/**
 *  自定义事件
 *
 *  @param eventId  事件ID
 *  @param userInfo 事件内容
 */
- (void)onEvent:(NSString*)eventId eventData:(NSDictionary*)userInfo;

/**
 *  设置等级
 *
 *  @param level 等级
 */
- (void)setLevel:(int)level;

/**
 *  充值: charge(@"coin1", 10, 1000, 1)->10元购买了1000金币，渠道是1
 *
 *  @param name 计费点名称, eg.coin1
 *  @param cash 花费多少人民币, eg.10
 *  @param coin 得到多少虚拟币, eg.1000
 *  @param type 充值渠道名称, eg.1
 */
- (void)charge:(NSString*)name :(double)cash :(double)coin :(int)type;


/**
 *  充值：
 *
 *  @param transaction 订单
 */
- (void)charge:(SKPaymentTransaction*)transaction;

/**
 *  奖励: reward(1000, 1)->奖励了1000金币，原因是1
 *
 *  @param coin 虚拟币数量
 *  @param type 奖励原因
 */
- (void)reward:(double)coin :(int)type;

/**
 *  购买: purchase("helmet", 1, 1000)->1000金币购买了1个头盔
 *
 *  @param name   道具名称
 *  @param amount 道具数量
 *  @param coin   消耗多少虚拟币
 */
- (void)purchase:(NSString*)name :(int)amount :(double)coin;

/**
 *  消耗: use("helmet", 1, 1000)->头盔使用掉一个，每个头盔价值1000金币
 *
 *  @param name   道具名称
 *  @param amount 道具数量
 *  @param coin   消耗的道具的价值（虚拟币）
 */
- (void)use:(NSString*)name :(int)amount :(double)coin;

/**
 *  任务开启
 *
 *  @param missionId 任务ID
 */
- (void)missionStart:(NSString*)missionId;

/**
 *  任务达成
 *
 *  @param missionId 任务ID
 */
- (void)missionSuccess:(NSString*)missionId;

/**
 *  任务失败
 *
 *  @param missionId 任务ID
 *  @param reason    失败原因
 */
- (void)missionFailed:(NSString*)missionId because:(NSString*)reason;

/**
 获取名字
 
 @return 名字
 */
- (NSString*)getName;

@end
