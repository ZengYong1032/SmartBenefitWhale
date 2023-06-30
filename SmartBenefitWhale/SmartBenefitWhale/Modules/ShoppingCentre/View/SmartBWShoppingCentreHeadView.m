//
//  SmartBWShoppingCentreHeadView.m
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import "SmartBWShoppingCentreHeadView.h"

@implementation SmartBWShoppingCentreHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.leftBtn];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo((kWindowWidth-24-10)/2);
            make.height.mas_equalTo(90);
        }];
        [self addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo((kWindowWidth-24-10)/2);
            make.height.mas_equalTo(90);
        }];
    }
    return self;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"sc_zhjx"] forState:UIControlStateNormal];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"sc_gylsc"] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

@end
