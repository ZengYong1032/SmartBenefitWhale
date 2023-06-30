//
//  YZBannerView.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BannerViewResponse)(id bannerInfo , NSInteger index);

@interface YZBannerView : UIView

- (instancetype)initWithFrame:(CGRect)frame banners:(NSArray *)banners cornerWidth:(CGFloat)cornerWidth duration:(CGFloat)duration response:(BannerViewResponse)response;

/// 开始banner动画
- (void)startBannerTimer;

/// 关闭banner动画
- (void)stopBannerTimer;

@end

NS_ASSUME_NONNULL_END
