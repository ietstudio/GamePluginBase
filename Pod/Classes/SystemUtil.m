//
//  SystemUtil.m
//  Pods
//
//  Created by geekgy on 15-4-15.
//
//

#import "SystemUtil.h"

@implementation SystemUtil

SINGLETON_DEFINITION(SystemUtil)

#pragma mark - public

- (NSString *)getConfigValueWithKey:(NSString *)key {
    NSDictionary* configs = [[NSBundle mainBundle] objectForInfoDictionaryKey:IETCONFIGS_KEY];
    return [configs objectForKey:key];
}

@end
