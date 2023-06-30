//
//  SmartBWUserInformation.h
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,UserAuthStatus) {
    UserAuthStatusDefault = 0,
    UserAuthStatusPassed,
    UserAuthStatusFailed,
    UserAuthStatusInfoUpdate,
    UserAuthStatusScan,
    UserAuthStatusComposeing
};

@interface SmartBWUserInformation : NSObject

@property (nonatomic,strong) NSString                                                   *token;

@property (nonatomic,strong) NSString                                                   *nickName;

@property (nonatomic,strong) NSString                                                   *userID;

@property (nonatomic,strong) NSString                                                   *headIcon;

@property (nonatomic,strong) NSString                                                   *mobileNumber;

@property (nonatomic,strong) NSString                                                   *tmLevel;

@property (nonatomic,strong) NSString                                                   *specEndDate;

@property (nonatomic,strong) NSString                                                   *specTipsContent;

@property (nonatomic,strong) NSString                                                   *authName;

@property (nonatomic,strong) NSString                                                   *authID;

@property (nonatomic,strong) NSString                                                   *authDetail;

@property (nonatomic,strong) NSString                                                   *userName;

@property (nonatomic,assign) UserAuthStatus                                             authStatus;

@end

NS_ASSUME_NONNULL_END
