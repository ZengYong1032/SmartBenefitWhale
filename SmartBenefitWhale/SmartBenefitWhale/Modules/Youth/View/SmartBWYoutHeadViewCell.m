//
//  SmartBWYoutHeadViewCell.m
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import "SmartBWYoutHeadViewCell.h"

@implementation SmartBWYoutHeadViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconImg];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(30);
        }];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.iconImg.mas_bottom).offset(10);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.image = [UIImage imageNamed:@"qd_yiqian"];
    }
    return _iconImg;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:11];
        _titleLab.textColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#FFB716"];
        _titleLab.text = @"已签";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

@end
