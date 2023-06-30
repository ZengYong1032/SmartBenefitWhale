//
//  SmartBWLogin_VC.h
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SmartBWContentType) {
    SmartBWContentTypeLoginByPassword = 0,
    SmartBWContentTypeLoginByCode,
    SmartBWContentTypePasswordForgot,
    SmartBWContentTypePasswordEdit
};

@interface SmartBWLogin_VC : UIViewController



@end

NS_ASSUME_NONNULL_END
