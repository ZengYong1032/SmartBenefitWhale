//
//  YZTipsView.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZTipsView : UIView

+ (void)showTipsAlertViewByTitle:(NSString *)title content:(NSString *)content leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftAction:(CommonCompletion)leftAction  rightAction:(CommonCompletion)rightAction;

+ (void)showTipsAlertViewByTitle:(NSString *)title content:(NSAttributedString *)content buttonBGColor:(UIColor *)color sureTitle:(NSAttributedString *)sureTitle sureAction:(CommonCompletion)sureAction x:(CGFloat)x contentX:(CGFloat)contentX duration:(NSInteger)duration;

+ (void)showTipsAlertViewByTitle:(NSString *)title content:(NSAttributedString *)content buttonBGColor:(UIColor *)color sureTitle:(NSAttributedString *)sureTitle sureAction:(CommonCompletion)sureAction x:(CGFloat)x contentX:(CGFloat)contentX duration:(NSInteger)duration textAlignment:(NSTextAlignment)textAlignment;

+ (void)showImageTipsAlertViewByTopImage:(NSString *)topImageNmae title:(NSString *)title content:(NSAttributedString *)content buttonBGColor:(UIColor *)color sureTitle:(NSAttributedString *)sureTitle sureAction:(CommonCompletion)sureAction cancelBGColor:(UIColor *)cancelcolor cancelTitle:(NSAttributedString *)cancelTitle cancelAction:(CommonCompletion)cancelAction;

- (void)stopTimer;

- (void)startTimer;

@end

NS_ASSUME_NONNULL_END
