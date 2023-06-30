//
//  DSDoubleTxtView.m
//  Test
//
//  Created by Mac on 2023/6/29.
//

#import "DSDoubleTxtView.h"

@interface DSDoubleTxtView()

@end

@implementation DSDoubleTxtView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化本类配置
        self.axis = UILayoutConstraintAxisVertical;
        self.spacing = 8;
        // 加载控件
        [self addSubviews];
    }
    return self;
}

#pragma mark -- 懒加载控件

- (UILabel *)topLabel {
    if (!_topLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        _topLabel = label;
    }
    return _topLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        _bottomLabel = label;
    }
    return _bottomLabel;
}

#pragma mark -- 添加控件到视图

/// 添加子视图内容
- (void)addSubviews {
    [self addArrangedSubview:self.topLabel];
    [self addArrangedSubview:self.bottomLabel];
}

@end
