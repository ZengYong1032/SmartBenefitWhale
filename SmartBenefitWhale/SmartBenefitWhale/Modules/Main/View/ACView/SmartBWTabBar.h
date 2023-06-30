//
//  SmartBWTabBar.h
//  SmartBenefitWhale
//
//  Created by Yong Zeng on 2023/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmartBWTabBar : UIView

/// 配置导航栏视图
/// - Parameter titles: item title数组
/// - Parameter firstIndex: 首次进入item索引
+ (void)configTabBarViewByItemTitles:(NSArray *)titles firstIndex:(NSInteger)firstIndex;

/// 根据索引切换导航视图
/// - Parameter index: 索引
+ (void)changeTabBarItemByIndex:(NSInteger)index;

/// 渲染导航视图
+ (void)showTabBarView;

/// 隐藏导航视图
+ (void)hidenTabBarView;

+ (CGFloat)tabBarViewHeight;

@end

NS_ASSUME_NONNULL_END
