//
//  YZPasswordInputTipsView.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TipsPasswordInputCompletion)(NSString *passwordstr);

@interface YZPasswordInputTipsView : UIView

- (instancetype)initWithTitle:(NSAttributedString *)title content:(NSAttributedString *)content detail:(NSAttributedString *)detaile completion:(TipsPasswordInputCompletion)completion;

- (void)forbiddenTouchDismiss;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
