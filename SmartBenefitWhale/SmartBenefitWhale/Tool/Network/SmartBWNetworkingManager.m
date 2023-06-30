//
//  SmartBWNetworkingManager.m
//  SmartBenefitWhale
//
//  Created by Yong Zeng on 2023/6/7.
//

#import "SmartBWNetworkingManager.h"

/// 200 success
/// 1001 需要登录
/// 1004 被限制
/// 1005 其他设备登录
#define BasalURL                                @"http://api.junengq.cn"
//#define BasalURL                                @"http://192.168.110.4:9510"
//#define BasalURL                                @"http://api-test.junengq.cn"
#define RequestByApi(api)                       [BasalURL stringByAppendingString:api]

@implementation SmartBWNetworkingManager

#pragma mark ----------------------------------------------------- App About Method -----------------------------------------------------
/// 版本信息 /v1/common/version
/// - Parameters:
///   - success: 成功响应
///   - failure: 失败响应
+ (void)appVersionInformationRequestSuccess:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:@{} headers:[self configHeaderByParam:@{}] url:RequestByApi(@"/v1/common/version") success:success failure:failure];
}


#pragma mark ----------------------------------------------------- User Info Method -----------------------------------------------------
/// 发送验证码  /v1/common/code"
/// - Parameters:
///   - param: mobile、codetype（register【注册】、login【登录】、forget_password【忘记密码】、edit_mobile【换绑时原手机号】、edit_mobile2【换绑时新手机号】）、token
///   - success: 成功响应
///   - failure: 失败响应
+ (void)verifyCodeSendRequestByTelephone:(NSString *)phoneNumber codeType:(VerifyCodeType)type success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"yd_validate"] = [CAFNOCacheTool slideVerifyToken];
    param[@"captcha_id"] = @"3";
    switch (type) {
        case VerifyCodeTypeRegister:{
            param[@"mobile"] = kStringTransform(phoneNumber);
            param[@"codetype"] = @"register";
        }
            break;
            
        case VerifyCodeTypeLogin:{
            param[@"mobile"] = kStringTransform(phoneNumber);
            param[@"codetype"] = @"login";
        }
            break;
            
        case VerifyCodeTypeForgetPWD:{
            param[@"mobile"] = kStringTransform(phoneNumber);
            param[@"codetype"] = @"forget_password";
        }
            break;
            
        case VerifyCodeTypeSetPyPWD:{
            param[@"mobile"] = kStringTransform(phoneNumber);
            param[@"codetype"] = @"set_pay_info";
        }
            break;
            
        case VerifyCodeTypeEditPyPWD:{
            param[@"mobile"] = kStringTransform(phoneNumber);
            param[@"codetype"] = @"edit_pay_password";
        }
            break;
            
        case VerifyCodeTypeMobileEditeOriginal:{
            param[@"codetype"] = @"edit_mobile";
        }
            break;
            
        case VerifyCodeTypeMobileEditeNew:{
            param[@"mobile"] = kStringTransform(phoneNumber);
            param[@"codetype"] = @"edit_mobile2";
        }
            break;
            
        case VerifyCodeTypeExtract:{
            param[@"token"] = kStringTransform(phoneNumber);
            param[@"codetype"] = @"edit_mobile2";
        }
            break;
            
        case VerifyCodeTypeEditPWD:{
            param[@"token"] = kStringTransform(phoneNumber);
            param[@"codetype"] = @"edit_passwords";
        }
            break;
            
        case VerifyCodeTypePhonePay:{
            param[@"codetype"] = @"hf_order";
        }
            break;
            
        case VerifyCodeTypeFMPay:{
            param[@"codetype"] = @"dy_order";
        }
            break;
            
        case VerifyCodeTypeDataExchange:{
            param[@"codetype"] = @"rent";
        }
            break;
            
        case VerifyCodeTypeTZRecycle:{
            param[@"codetype"] = @"tz_hs_do";
        }
            break;
            
        case VerifyCodeTypeTZExchangeFM:{
            param[@"codetype"] = @"tz_to_yp";
        }
            break;
            
        case VerifyCodeTypeFMExchangeTZ:{
            param[@"codetype"] = @"yp_to_tz";
        }
            break;
            
        case VerifyCodeTypeRedwrap:{
            param[@"codetype"] = @"redwrap_out";
        }
            break;
            
        case VerifyCodeTypeMerchant:{
            param[@"codetype"] = @"offline_add";
        }
            break;
            
        case VerifyCodeTypeMerchantRebuy:{
            param[@"codetype"] = @"offline_xufei";
        }
            break;
            
        case VerifyCodeTypeHelper:{
            param[@"codetype"] = @"bang_add";
        }
            break;
            
        case VerifyCodeTypeHelperRebuy:{
            param[@"codetype"] = @"bang_xufei";
        }
            break;
            
        case VerifyCodeTypeVIP:{
            param[@"codetype"] = @"vip_pay";
        }
            break;
            
        case VerifyCodeTypeVIPRebuy:{
            param[@"codetype"] = @"vip_xufei";
        }
            break;
            
        case VerifyCodeTypePMRedeem:{
            param[@"codetype"] = @"puman_sh_do";
        }
            break;
            
        case VerifyCodeTypeGroupAbout:{
            param[@"codetype"] = @"room_pay";
        }
            break;
            
            
            
        default:
            break;
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:@{@"signature":[SmartBWNetworkingManager transformParamtersObjectByParam:param]}];
//    if([CAFNOCacheTool sharedCacheTool].isLogined) {
//        info[@"token"] = [CAFNOCacheTool sharedCacheTool].token;
//    }
    [SmartBWNetworkingManager POSTRequestWithParameters:param headers:[self configHeaderByParam:param] url:RequestByApi(@"/v1/common/code") success:success failure:failure];
}

/// 手机号注册 /v1/common/register
/// - Parameters:
///   - param: mobile、code、parent、password
///   - success: 成功响应
///   - failure: 失败响应
+ (void)registerRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:param headers:[self configHeaderByParam:param] url:RequestByApi(@"/v1/common/register") success:success failure:failure];
}

/// 手机号登录 /v1/common/login_password
/// - Parameters:
///   - param: mobile、password、wy_token、wy_token_type=2
///   - success: 成功响应
///   - failure: 失败响应
+ (void)loginByPwdRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:param headers:[self configHeaderByParam:param] url:RequestByApi(@"/v1/common/login_password") success:success failure:failure];
}

/// 验证码登录 /v1/common/login_code
/// - Parameters:
///   - param: mobile、code、wy_token、wy_token_type=2
///   - success: 成功响应
///   - failure: 失败响应
+ (void)loginByCodeRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:param headers:[self configHeaderByParam:param] url:RequestByApi(@"/v1/common/login_code") success:success failure:failure];
}

/// 更新用户信息 /v1/user/set_info
/// - Parameters:
///   - param: type(1修改头像 2修改昵称 3修改性别[0保密、1男、2女] 4生日[19920506])、value、token
///   - success: 成功响应
///   - failure: 失败响应
+ (void)userInformationUpdateRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:param headers:[self configHeaderByParam:param] url:RequestByApi(@"/v1/user/set_info") success:success failure:failure];
}

/// 用户信息 /v1/user/get_info
/// - Parameters:
///   - success: 成功响应
///   - failure: 失败响应
+ (void)userInformationRequestSuccess:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:@{} headers:[self configHeaderByParam:@{}] url:RequestByApi(@"/v1/user/get_info") success:success failure:failure];
}

/// 退出登录 /v1/user/logout
/// - Parameters:
///   - success: 成功响应
///   - failure: 失败响应
+ (void)logoutRequestSuccess:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:@{} headers:[self configHeaderByParam:@{}] url:RequestByApi(@"/v1/user/logout") success:success failure:failure];
}

/// 忘记密码情况重置密码 /v1/common/forget_password
/// - Parameters:
///   - param: mobile、code、password
///   - success: 成功响应
///   - failure: 失败响应
+ (void)resetPwdByCodeRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:param headers:[self configHeaderByParam:param] url:RequestByApi(@"/v1/common/forget_password") success:success failure:failure];
}

/// 更改登录密码 /v1/user/edit_password
/// - Parameters:
///   - param: token、old_password、new_password、new_password2
///   - success: 成功响应
///   - failure: 失败响应
+ (void)passwordOfLoginEditRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:param headers:[self configHeaderByParam:param] url:RequestByApi(@"/v1/user/edit_password") success:success failure:failure];
}

/// 更改其他密码 /v1/user/edit_pay_password
/// - Parameters:
///   - param: token、code、new_password、new_password2
///   - success: 成功响应
///   - failure: 失败响应
+ (void)passwordOfPyEditRequestWithParamters:(NSDictionary *)param success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:param headers:[self configHeaderByParam:param] url:RequestByApi(@"/v1/user/edit_pay_password") success:success failure:failure];
}





#pragma mark **************************************************** Main Method ****************************************************
/// 首页顶部数据 /v1/index/get_info
/// - Parameters:
///   - success: 成功响应
///   - failure: 失败响应
+ (void)mainHeaderInformationRequestSuccess:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    [SmartBWNetworkingManager POSTRequestWithParameters:@{} headers:[self configHeaderByParam:@{}] url:RequestByApi(@"/v1/index/get_info") success:success failure:failure];
}



#pragma mark **************************************************** Otehr Method ****************************************************
+ (NSString *)transformParamtersObjectByParam:(NSDictionary *)param {
    NSString __block *sortstring = @"";
    if (kClassJudgeByName(param, NSDictionary)) {
        NSArray *sortedkeys = [SmartBWAuxiliaryMeansManager arrayNormalSortWithDatas:[param allKeys] isNormal:YES];
        [sortedkeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (param[obj]) {
                sortstring = [sortstring stringByAppendingFormat:@"%@%@",obj,param[obj]];
            }
        }];
    }
    sortstring = [sortstring stringByAppendingString:@"G5D*Y2$FDdf4gf1576SD"];
    MyCustomLog(@"\nsortstring = %@\n",sortstring);
    sortstring = [SmartBWAuxiliaryMeansManager configSecurityWithString:sortstring isSHA256:NO];
    MyCustomLog(@"\nsecuritySortstring = %@\n",sortstring);
    return sortstring;
}

+ (NSDictionary *)configHeaderByParam:(NSDictionary *)param {
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:@{@"signature":[SmartBWNetworkingManager transformParamtersObjectByParam:param]}];
    if([SmartBWCacheManager isLogined]) {
        info[@"token"] = [SmartBWCacheManager token];
    }
    return info;
}

#pragma mark ----------------------------------------------------- Request Basal Method -----------------------------------------------------
/// 解析
+ (NSMutableDictionary *)responseDataAnalysisByObject:(id)responseObject {
    id object;
    NSError *error;
    if (kClassJudgeByName(responseObject, NSDictionary) || kClassJudgeByName(responseObject, NSArray)) {
        object = responseObject;
    }
    else if (kClassJudgeByName(responseObject, NSData)) {
        NSDictionary *responseDatas = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingFragmentsAllowed error:&error];
        object = responseDatas;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:object,@"Data",error,@"Error", nil];
    return dic;
}

/// GET
/// @param param Body
/// @param headers Header
/// @param url 请求地址
/// @param success 请求成功响应
/// @param failure 请求失败响应
+ (void)GETRequestWithParameters:(NSDictionary *)param headers:(NSDictionary *)headers url:(NSString *)url success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    AFHTTPSessionManager * sessionMgr = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:@""]];
    sessionMgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionMgr.requestSerializer.timeoutInterval = 20;
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    if (headers && [headers isKindOfClass:[NSDictionary class]]) {
        [headerDic setValuesForKeysWithDictionary:headers];
    }
    
    if (!url || url.length <= 0) {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:404 userInfo:@{NSLocalizedDescriptionKey:@""}];
        !failure?:failure(error);
        return;
    }
    
    [sessionMgr GET:url parameters:param headers:headerDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *rspObject = [SmartBWNetworkingManager responseDataAnalysisByObject:responseObject];
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:rspObject[@"Data"]];
            NSError *error = rspObject[@"Error"];
            if (error) {
                NSError *error = [[NSError alloc] initWithDomain:@"" code:[(data[@"code"]?:@"500") integerValue] userInfo:@{NSLocalizedDescriptionKey:(data[@"message"]?:data[@"msg"])}];
                !failure?:failure(error);
            }
            else {
                MyCustomLog(@"\nparam = %@,data = %@,url = %@",param,data,url);
                if ([(data[@"code"]?:@"500") integerValue] == 200) {
                    !success?:success(data[@"result"],[(data[@"code"]?:@"500") integerValue],(data[@"message"] ?:kStringTransform(data[@"msg"])));
                }
                else if ([(data[@"code"]?:@"500") integerValue] == 1001) {
//                    [CAFNOUserInformation accountExitCompletion:^(BOOL success) {
//                        ;
//                    }];
//                    [SmartBWCacheManager clinkToLoginAfterOverdue];
                    NSError *error = [[NSError alloc] initWithDomain:@"" code:[kStringTransform(data[@"code"]) integerValue] userInfo:@{NSLocalizedDescriptionKey:(data[@"message"] ?:kStringTransform(data[@"msg"]))}];
                    !failure?:failure(error);
                }
                else {
                    NSError *error = [[NSError alloc] initWithDomain:@"" code:[kStringTransform(data[@"code"]) integerValue] userInfo:@{NSLocalizedDescriptionKey:(data[@"message"] ?:kStringTransform(data[@"msg"]))}];
                    !failure?:failure(error);
                }
            }
        }
        else {
            NSError *error = [[NSError alloc] initWithDomain:@"" code:500 userInfo:@{NSLocalizedDescriptionKey:@"网络请求失败"}];
            !failure?:failure(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyCustomLog(@"error = %@ \n URL = %@",error,url);
        NSData *respose = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSError *newError;
        if (respose) {
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:respose options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *userinfo = error.userInfo.mutableCopy;
            if (data) {
                [userinfo setObject:data forKey:@"response"];
                newError = [NSError errorWithDomain:error.domain code:error.code userInfo:userinfo];
            }
        }
        !failure?:failure(newError?:error);
    }];
}


/// POST
/// @param param Body
/// @param headers Header
/// @param url 请求地址
/// @param success 请求成功响应
/// @param failure 请求失败响应
+ (void)POSTRequestWithParameters:(NSDictionary *)param headers:(NSDictionary *)headers url:(NSString *)url success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    AFHTTPSessionManager * sessionMgr = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:@""]];
    sessionMgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionMgr.requestSerializer.timeoutInterval = 20;
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    if (headers && [headers isKindOfClass:[NSDictionary class]]) {
        [headerDic setValuesForKeysWithDictionary:headers];
    }
    
    if (!url || url.length <= 0) {
        NSError *error = [[NSError alloc] initWithDomain:@"" code:404 userInfo:@{NSLocalizedDescriptionKey:@""}];
        !failure?:failure(error);
        return;
    }
    MyCustomLog(@"\npara = %@ \nURL = %@\nheaders = %@\n",param,url,headers);
    [sessionMgr POST:url parameters:param headers:headerDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        MyCustomLog(@"\nresponseObject = %@ \n URL = %@",responseObject,url);
        if (responseObject) {
            NSDictionary *rspObject = [SmartBWNetworkingManager responseDataAnalysisByObject:responseObject];
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:rspObject[@"Data"]];
            NSError *error = rspObject[@"Error"];
            if (error) {
                NSError *error = [[NSError alloc] initWithDomain:@"" code:[kStringTransform(data[@"code"]) integerValue] userInfo:@{NSLocalizedDescriptionKey:(data[@"message"]?:kStringTransform(data[@"msg"]))}];
                !failure?:failure(error);
            }
            else {
//                MyCustomLog(@"success Data = %@",data);
                if ([kStringTransform(data[@"code"]) integerValue] == 200) {
                    !success?:success(data[@"result"],[kStringTransform(data[@"code"]) integerValue],(data[@"message"] ?:kStringTransform(data[@"msg"])));
                }
                else if ([(data[@"code"]?:@"500") integerValue] == 1001) {
                    MyCustomLog(@"\nError ResponseObject = %@ \n URL = %@",responseObject,url);
//                    [CAFNOUserInformation accountExitCompletion:^(BOOL success) {
//                        ;
//                    }];
//                    [SmartBWCacheManager clinkToLoginAfterOverdue];
                    NSError *error = [[NSError alloc] initWithDomain:@"" code:[kStringTransform(data[@"code"]) integerValue] userInfo:@{NSLocalizedDescriptionKey:(data[@"message"] ?:kStringTransform(data[@"msg"]))}];
                    !failure?:failure(error);
                }
                else {
                    MyCustomLog(@"\nError ResponseObject = %@ \n URL = %@\nError = %@\n",responseObject,url,error);
                    NSError *error = [[NSError alloc] initWithDomain:@"" code:[kStringTransform(data[@"code"]) integerValue] userInfo:@{NSLocalizedDescriptionKey:(data[@"message"] ?:kStringTransform(data[@"msg"]))}];
                    !failure?:failure(error);
                }
            }
        }
        else {
            NSError *error = [[NSError alloc] initWithDomain:@"" code:500 userInfo:@{NSLocalizedDescriptionKey:@"网络请求失败"}];
            !failure?:failure(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyCustomLog(@"error = %@ \n URL = %@",error,url);
        NSData *respose = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSError *newError;
        if (respose) {
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:respose options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *userinfo = error.userInfo.mutableCopy;
            if (data) {
                [userinfo setObject:data forKey:@"response"];
                newError = [NSError errorWithDomain:error.domain code:error.code userInfo:userinfo];
            }
        }
        !failure?:failure(newError?:error);
    }];
}

/// 上传文件
/// @param fileData 文件数据
/// @param para 参数 name、token
/// @param headers header参数
/// @param url 接口
/// @param success 成功响应
/// @param failure 失败响应
+ (void)uploadFileWithFileData:(UIImage *)fileData parameters:(NSDictionary *)para headers:(NSDictionary *)headers url:(NSString *)url success:(NetworkRequestSuccessCompletion)success failure:(NetworkRequestFailedCompletion)failure {
    AFHTTPSessionManager *sessionMgr = [AFHTTPSessionManager manager];
    
    [sessionMgr POST:url parameters:@{} headers:[self configHeaderByParam:@{}] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *itype = [self typeForImageData:UIImagePNGRepresentation(fileData)];
        NSString *typestr = NSStringFormat(@"image/%@",itype);
        NSString *namestr = NSStringFormat(@"fullhouse%.f.%@",[SmartBWAuxiliaryMeansManager currentTimeStampIntervalSince1970],itype);
        [formData appendPartWithFileData:UIImagePNGRepresentation(fileData) name:@"file" fileName:namestr mimeType:typestr];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *rspObject = [SmartBWNetworkingManager responseDataAnalysisByObject:responseObject];
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:rspObject[@"Data"]];
            NSError *error = rspObject[@"Error"];
            if (error) {
                NSError *error = [[NSError alloc] initWithDomain:@"" code:[kStringTransform(data[@"code"]) integerValue] userInfo:@{NSLocalizedDescriptionKey:(data[@"message"]?:kStringTransform(data[@"msg"]))}];
                !failure?:failure(error);
            }
            else {
                MyCustomLog(@"success Data = %@",data);
                if ([kStringTransform(data[@"code"]) integerValue] == 200) {
                    !success?:success(data[@"result"],[kStringTransform(data[@"code"]) integerValue],(data[@"message"] ?:kStringTransform(data[@"msg"])));
                }
                else if ([(data[@"code"]?:@"500") integerValue] == 1001) {
                    MyCustomLog(@"\nError ResponseObject = %@ \n URL = %@",responseObject,url);
//                    [CAFNOUserInformation accountExitCompletion:^(BOOL success) {
//                        ;
//                    }];
//                    [SmartBWCacheManager clinkToLoginAfterOverdue];
                    NSError *error = [[NSError alloc] initWithDomain:@"" code:[kStringTransform(data[@"code"]) integerValue] userInfo:@{NSLocalizedDescriptionKey:(data[@"message"] ?:kStringTransform(data[@"msg"]))}];
                    !failure?:failure(error);
                }
                else {
                    MyCustomLog(@"\nError ResponseObject = %@ \n URL = %@\nError = %@\n",responseObject,url,error);
                    NSError *error = [[NSError alloc] initWithDomain:@"" code:[kStringTransform(data[@"code"]) integerValue] userInfo:@{NSLocalizedDescriptionKey:(data[@"message"] ?:kStringTransform(data[@"msg"]))}];
                    !failure?:failure(error);
                }
            }
        }
        else {
            NSError *error = [[NSError alloc] initWithDomain:@"" code:500 userInfo:@{NSLocalizedDescriptionKey:@"网络请求失败"}];
            !failure?:failure(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyCustomLog(@"error = %@ \n URL = %@",error,url);
        NSData *respose = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSError *newError;
        if (respose) {
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:respose options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *userinfo = error.userInfo.mutableCopy;
            if (data) {
                [userinfo setObject:data forKey:@"response"];
                newError = [NSError errorWithDomain:error.domain code:error.code userInfo:userinfo];
            }
        }
        !failure?:failure(newError?:error);
    }];
}

+ (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
            
        case 0x89:
            return @"png";
            
        case 0x47:
            return @"gif";
            
        case 0x49:
        case 0x4D:
            return @"tiff";
    }
    return nil;
}

@end
