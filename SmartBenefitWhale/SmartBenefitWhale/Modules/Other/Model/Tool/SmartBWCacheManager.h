//
//  SmartBWCacheManager.h
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/14.
//

#import <Foundation/Foundation.h>
#import "YZTipsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmartBWCacheManager : NSObject

@property (nonatomic,assign) BOOL                                                       deviceNetworkStatusNormal;

@property (nonatomic,assign) BOOL                                                       statusNormal;

@property (nonatomic,assign) BOOL                                                       isLogined;

@property (nonatomic,assign) BOOL                                                       isLoginBack;

@property (nonatomic,assign) BOOL                                                       isLocationed;

@property (nonatomic,assign) NSInteger                                                  tabIndex;

@property (nonatomic,strong) NSString                                                   *token;

@property (nonatomic,strong) NSString                                                   *orderID;

@property (nonatomic,strong) SmartBWUserInformation                                     *userInfoModel;

@property (nonatomic,strong) NSArray                                                    *subArray;

@property (nonatomic,strong, nullable) YZTipsView                                       *tipsView;

@property (nonatomic, assign) NSInteger                                                 hubcount;





+ (instancetype)sharedCacheTool;

+ (BOOL)isLogined;

+ (BOOL)isLoginBack;

+ (SmartBWUserInformation *)userInfoModel;

+ (NSString *)token;

+ (NSString *)nickName;//昵称

+ (NSString *)userID;//id

+ (NSString *)headIcon;//头像

+ (NSString *)mobileNumber;//手机号

+ (NSString *)tmLevel;//等级

+ (NSString *)specEndDate;//到期时间

+ (NSString *)specTipsContent;//提示用语

+ (NSString *)authName;//认证姓名

+ (NSString *)authID;//身份证号

+ (NSString *)authDetail;//认证说明

+ (NSString *)userName;//

+ (UserAuthStatus)authStatus;//认证状态



+ (NSInteger)hubcount;

+ (void)setHubcount:(NSInteger)hubcount;

+ (void)hubcountAdd:(NSInteger)count;

+ (void)hubcountSubtraction:(NSInteger)count;


@end

NS_ASSUME_NONNULL_END
