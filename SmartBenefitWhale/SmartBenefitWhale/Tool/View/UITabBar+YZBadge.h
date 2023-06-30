//
//  UITabBar+YZBadge.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (YZBadge)

- (void)showBadgeOnItemIndex:(NSInteger)index withCount:(NSInteger)count;
- (void)dismissBadgeOnItemIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
