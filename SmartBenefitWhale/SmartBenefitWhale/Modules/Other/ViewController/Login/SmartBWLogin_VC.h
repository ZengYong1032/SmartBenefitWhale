//
//  SmartBWLogin_VC.h
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SmartBWLoginContentType) {
    SmartBWLoginContentTypeDefault = 0,
    SmartBWLoginContentTypeLoginByPassword,
    SmartBWLoginContentTypeLoginByCode,
    SmartBWLoginContentTypeRegisterByCode,
    SmartBWLoginContentTypePasswordForgot,
    SmartBWLoginContentTypePasswordEdit
};

@interface SmartBWLogin_VC : UIViewController

@property (nonatomic,assign) SmartBWLoginContentType                                enterType;

@end

NS_ASSUME_NONNULL_END
