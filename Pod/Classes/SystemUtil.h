//
//  SystemUtil.h
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

@interface SystemUtil : NSObject

@property(nonatomic, retain)UIWindow* window;
@property(nonatomic, retain)UIViewController* controller;

SINGLETON_DECLARE(SystemUtil)

/**
 *  获取info.plist中的配置信息
 *
 *  @param key
 *
 *  @return
 */
- (NSString*)getConfigValueWithKey:(NSString*)key;

@end
