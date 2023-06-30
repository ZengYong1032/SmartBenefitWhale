//
//  YZTextHorizontalScrollView.h
//  SweetAgenda
//
//  Created by Yong Zeng on 2021/7/26.
//  Copyright © 2021 GreekMythology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 描述字符串滚动前端起始位置：
 */
typedef enum {
    YZTextScrollContinuous,     // 从控件内开始连续滚动
    YZTextScrollIntermittent,   // 从控件内开始间断滚动
    YZTextScrollFromOutside,    // 从控件外开始滚动
    YZTextScrollWandering       // 在控件中往返滚动（不受设置方向影响）
}YZTextScrollMode;

/**
 描述字符串移动的方向
 */
typedef enum {
    YZTextScrollMoveLeft,
    YZTextScrollMoveRight
}YZTextScrollMoveDirection;

@interface YZTextHorizontalScrollView : UIView

@property (nonatomic,copy)   NSString                                   *text;
@property (nonatomic,copy)   UIFont                                     *textFont;
@property (nonatomic,copy)   UIColor                                    *textColor;

@property (nonatomic,assign) CGFloat                                    speed;

@property (nonatomic,assign) YZTextScrollMode                           moveMode;
@property (nonatomic,assign) YZTextScrollMoveDirection                  moveDirection;

- (void)move;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
