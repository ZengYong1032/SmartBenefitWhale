//
//  SmartBWShoppingCentreCell.m
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import "SmartBWShoppingCentreCell.h"

@implementation SmartBWShoppingCentreCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.iconImg];
        [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(170);
        }];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.iconImg.mas_bottom).offset(10);
        }];
        [self addSubview:self.ctLab];
        [self.ctLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.equalTo(self.titleLab.mas_bottom).offset(8);
            make.height.mas_equalTo(12);
        }];
        [self addSubview:self.originalLab];
        [self.originalLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.equalTo(self.ctLab.mas_bottom).offset(9);
            make.height.mas_equalTo(10);
        }];
        [self addSubview:self.soldlLab];
        [self.soldlLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(self.originalLab);
            make.height.mas_equalTo(10);
        }];
    }
    return self;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.backgroundColor = UIColor.redColor;
    }
    return _iconImg;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = @"牧原纯牛奶200ml*12盒 一箱";
        _titleLab.numberOfLines = 2;
    }
    return _titleLab;
}

- (UILabel *)ctLab {
    if (!_ctLab) {
        _ctLab = [[UILabel alloc] init];
        _ctLab.font = [UIFont boldSystemFontOfSize:16];
        _ctLab.textColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#FF3333"];
        _ctLab.text = @"245.21CT";
    }
    return _ctLab;
}

- (UILabel *)originalLab {
    if (!_originalLab) {
        _originalLab = [[UILabel alloc] init];
        _originalLab.font = [UIFont systemFontOfSize:12];
        _originalLab.textColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#999999"];
        _originalLab.text = @"￥80.00";
    }
    return _originalLab;
}

- (UILabel *)soldlLab {
    if (!_soldlLab) {
        _soldlLab = [[UILabel alloc] init];
        _soldlLab.font = [UIFont systemFontOfSize:12];
        _soldlLab.textColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#999999"];
        _soldlLab.text = @"已售：567";
    }
    return _soldlLab;
}

@end
