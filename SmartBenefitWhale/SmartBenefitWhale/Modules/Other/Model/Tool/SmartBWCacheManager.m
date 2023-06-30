//
//  SmartBWCacheManager.m
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/14.
//

#import "SmartBWCacheManager.h"

static SmartBWCacheManager *sharedCacheTool = nil;

@implementation SmartBWCacheManager


+ (instancetype)sharedCacheTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCacheTool = [[super allocWithZone:NULL] init];
    });
    return sharedCacheTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [SmartBWCacheManager sharedCacheTool];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [SmartBWCacheManager sharedCacheTool];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [SmartBWCacheManager sharedCacheTool];
}

+ (BOOL)isLogined {
    return [SmartBWCacheManager sharedCacheTool].isLogined;
}

+ (BOOL)isLoginBack {
    return [SmartBWCacheManager sharedCacheTool].isLoginBack;
}

+ (NSString *)token {
    return [SmartBWCacheManager sharedCacheTool].userInfoModel.token?:kStringTransform([SmartBWCacheManager sharedCacheTool].token);
}

+ (SmartBWUserInformation *)userInfoModel {
    return [SmartBWCacheManager sharedCacheTool].userInfoModel?:[SmartBWUserInformation new];
}

// 昵称
+ (NSString *)nickName {
    return kStringTransform([SmartBWCacheManager userInfoModel].nickName);
}

/// id
+ (NSString *)userID {
    return kStringTransform([SmartBWCacheManager userInfoModel].userID);
}

/// 头像
+ (NSString *)headIcon {
    return kStringTransform([SmartBWCacheManager userInfoModel].headIcon);
}

/// 手机号
+ (NSString *)mobileNumber {
    return kStringTransform([SmartBWCacheManager userInfoModel].mobileNumber);
}

/// 等级
+ (NSString *)tmLevel {
    return kStringTransform([SmartBWCacheManager userInfoModel].tmLevel);
}

/// 到期时间
+ (NSString *)specEndDate {
    return kStringTransform([SmartBWCacheManager userInfoModel].specEndDate);
}

/// 提示用语
+ (NSString *)specTipsContent {
    return kStringTransform([SmartBWCacheManager userInfoModel].specTipsContent);
}

/// 认证姓名
+ (NSString *)authName {
    return kStringTransform([SmartBWCacheManager userInfoModel].authName);
}

/// 身份证号
+ (NSString *)authID {
    return kStringTransform([SmartBWCacheManager userInfoModel].authID);
}

/// 认证说明
+ (NSString *)authDetail {
    return kStringTransform([SmartBWCacheManager userInfoModel].authDetail);
}

/// 用户名
+ (NSString *)userName {
    return kStringTransform([SmartBWCacheManager userInfoModel].userName);
}

/// 认证状态
+ (UserAuthStatus)authStatus {
    return [SmartBWCacheManager userInfoModel].authStatus;
}






+ (NSInteger)hubcount {
    return [SmartBWCacheManager sharedCacheTool].hubcount;
}

+ (void)setHubcount:(NSInteger)hubcount {
    [SmartBWCacheManager sharedCacheTool].hubcount = hubcount;
}

+ (void)hubcountAdd:(NSInteger)count {
    [SmartBWCacheManager sharedCacheTool].hubcount += count;
}

+ (void)hubcountSubtraction:(NSInteger)count {
    [SmartBWCacheManager sharedCacheTool].hubcount -= count;
}


@end
