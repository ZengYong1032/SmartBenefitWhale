//
//  SmartBWNetworkingManager.h
//  SmartBenefitWhale
//
//  Created by Yong Zeng on 2023/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define BasalFileURL                                @"http://h5.junengq.cn/"
#define FilePathByName(name)                        [BasalFileURL stringByAppendingString:name]

typedef void(^NetworkRequestSuccessCompletion)(id data,NSInteger code,NSString *msg);
typedef void(^NetworkRequestFailedCompletion)(NSError *error);

typedef NS_ENUM(NSInteger,VerifyCodeType) {
    VerifyCodeTypeRegister = 0,
    VerifyCodeTypeLogin,
    VerifyCodeTypeSetPyPWD,
    VerifyCodeTypeEditPyPWD,
    VerifyCodeTypeForgetPWD,
    VerifyCodeTypeMobileEditeOriginal,
    VerifyCodeTypeMobileEditeNew,
    VerifyCodeTypeExtract,
    VerifyCodeTypeLogoff,
    VerifyCodeTypeEditPWD,
    
    VerifyCodeTypeRedwrap,//发送红包 redwrap_out
    VerifyCodeTypeMerchant,//商家入驻 offline_add
    VerifyCodeTypeMerchantRebuy,//商家续费 offline_xufei
    VerifyCodeTypeHelper,//帮帮入驻 bang_add
    VerifyCodeTypeHelperRebuy,//帮帮续费 bang_xufei
    VerifyCodeTypeVIP,//VIP入驻 vip_pay
    VerifyCodeTypeVIPRebuy,//VIP续费 vip_xufei
    VerifyCodeTypePMRedeem,//扑满赎回 puman_sh_do
    VerifyCodeTypeFMExchangeTZ,//影票兑通证 yp_to_tz
    VerifyCodeTypeTZExchangeFM,//影票兑通证 tz_to_yp
    VerifyCodeTypeTZRecycle,//通证数据回收 tz_hs_do
    VerifyCodeTypeDataExchange,//兑换流量 rent
    VerifyCodeTypeFMPay,//电影票支付  dy_order
    VerifyCodeTypePhonePay,//话费支付  hf_order
    VerifyCodeTypeReward,
    VerifyCodeTypeGroupAbout
};

@interface SmartBWNetworkingManager : NSObject

/// 版本信息 /v1/common/version
/// - Parameters:
///   - success: 成功响应
///   - failure: 失败相应
+ (void)appVersionInformationRequestSuccess:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;


#pragma mark ----------------------------------------------------- User Info Method -----------------------------------------------------
/// 发送验证码 /v1/common/code
/// - Parameters:
///   - param: mobile、codetype（register【注册】、login【登录】、forget_password【忘记密码】、edit_mobile【换绑时原手机号】、edit_mobile2【换绑时新手机号】）、token
///   - success: 成功响应
///   - failure: 失败相应
+ (void)verifyCodeSendRequestByTelephone:(NSString *)phoneNumber codeType:(VerifyCodeType)type success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;

/// 手机号注册 /v1/common/register`
/// - Parameters:
///   - param: mobile、code、parent、password
///   - success: 成功响应
///   - failure: 失败相应
+ (void)registerRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;

/// 手机号登录 /v2/common/login_password
/// - Parameters:
///   - param: mobile、password
///   - success: 成功响应
///   - failure: 失败相应
+ (void)loginByPwdRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;

/// 验证码登录 /v1/common/login_code
/// - Parameters:
///   - param: mobile、code
///   - success: 成功响应
///   - failure: 失败相应
+ (void)loginByCodeRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;

/// 更新用户信息 /v1/user/set_info
/// - Parameters:
///   - param: type(1修改头像 2修改昵称 3修改微信 4换绑手机[value为新手机号、code为原手机验证码、code_new为新手机验证码])、value
///   - success: 成功响应
///   - failure: 失败相应
+ (void)userInformationUpdateRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;

/// 用户信息 /v1/user/get_info
/// - Parameters:
///   - success: 成功响应
///   - failure: 失败相应
+ (void)userInformationRequestSuccess:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;


/// 退出登录 /v1/user/logout
/// - Parameters:
///   - success: 成功响应
///   - failure: 失败相应
+ (void)logoutRequestSuccess:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;

/// 忘记密码情况重置密码 /v1/common/forget_password
/// - Parameters:
///   - param: mobile、code、password
///   - success: 成功响应
///   - failure: 失败相应
+ (void)resetPwdByCodeRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;

/// 更改登录密码 /v1/user/edit_password
/// - Parameters:
///   - param: token、old_password、new_password、new_password2
///   - success: 成功响应
///   - failure: 失败相应
+ (void)passwordOfLoginEditRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;

/// 更改其他密码 /v1/user/edit_pay_password
/// - Parameters:
///   - param: token、code、new_password、new_password2
///   - success: 成功响应
///   - failure: 失败相应
+ (void)passwordOfPyEditRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;


#pragma mark **************************************************** Main Method ****************************************************
/// 首页顶部数据 /v1/index/get_info
/// - Parameters:
///   - success: 成功响应
///   - failure: 失败响应
+ (void)mainHeaderInformationRequestSuccess:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure;

@end

NS_ASSUME_NONNULL_END
