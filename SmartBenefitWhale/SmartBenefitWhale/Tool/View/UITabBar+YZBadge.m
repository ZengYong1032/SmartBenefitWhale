//
//  UITabBar+YZBadge.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/29.
//

#import "UITabBar+YZBadge.h"

#define TabbarItemNums 5.0

@implementation UITabBar (YZBadge)

// 显示红点
- (void)showBadgeOnItemIndex:(NSInteger)index withCount:(NSInteger)count {
 
    [self removeBadgeOnItemIndex:index];
    // 新建小红点
    UILabel *bview = [[UILabel alloc]init];
    bview.tag = 888 + index;
    bview.layer.cornerRadius = 8.0;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    bview.textColor = kWhiteColor;
    bview.font = SystemFont(14);
    bview.textAlignment = NSTextAlignmentCenter;
    bview.adjustsFontSizeToFitWidth = YES;
    if(count > 10) {
        bview.text = @"10+";
    }
    else {
        bview.text = kTransformStringWithInteger(count);
    }
    CGRect tabFram = self.frame;
 
    float percentX = (index+0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFram.size.width);
    CGFloat y = ceilf(0 * tabFram.size.height);
    bview.frame = CGRectMake(x, y, 16.0, 16.0);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}
 
// 隐藏红点
- (void)dismissBadgeOnItemIndex:(NSInteger)index {
 
    [self removeBadgeOnItemIndex:index];
}
// 移除控件
- (void)removeBadgeOnItemIndex:(NSInteger)index {
 
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
