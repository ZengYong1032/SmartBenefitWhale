//
//  SmartBWYoutTopView.m
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import "SmartBWYoutTopView.h"

@implementation SmartBWYoutTopView

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#FF4949"];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(kStatusBarHeight+10);
            make.height.mas_equalTo(20);
        }];
        [self addSubview:self.rightBtn];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.centerY.equalTo(self.titleLab);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
        }];
    }
    return  self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.text = @"签到";
    }
    return _titleLab;
}

-(UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_rightBtn setTitle:@"我的任务包" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _rightBtn;
}

@end
