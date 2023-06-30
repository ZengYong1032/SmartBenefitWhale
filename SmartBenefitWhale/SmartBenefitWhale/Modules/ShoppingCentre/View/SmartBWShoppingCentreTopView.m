//
//  SmartBWShoppingCentreTopView.m
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import "SmartBWShoppingCentreTopView.h"

@interface SmartBWShoppingCentreTopView ()
@property(strong,nonatomic)UIView *leftView;
@property(strong,nonatomic)UIImageView *iconImg;
@end

@implementation SmartBWShoppingCentreTopView

-(instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#FF4949"];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(kStatusBarHeight+10);
            make.height.mas_equalTo(20);
        }];
        [self addSubview:self.searchText];
        [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(128);
            make.right.mas_equalTo(-12);
            make.centerY.equalTo(self.titleLab);
            make.height.mas_equalTo(36);
        }];
    }
    return self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:20];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.text = @"智惠鲸商城";
    }
    return _titleLab;
}

- (UITextField *)searchText {
    if (!_searchText) {
        _searchText = [[UITextField alloc] init];
        _searchText.backgroundColor = UIColor.whiteColor;
        _searchText.layer.cornerRadius = 18;
        _searchText.layer.masksToBounds = true;
        _searchText.font = [UIFont systemFontOfSize:16];
        _searchText.placeholder = @"请输入商品名称";
        _searchText.leftView = self.leftView;
        _searchText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchText;
}

-(UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 36)];
        [_leftView addSubview:self.iconImg];
    }
    return _leftView;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.frame = CGRectMake(12, 10, 16, 16);
        _iconImg.image = [UIImage imageNamed:@"sc_ss"];
    }
    return _iconImg;
}

@end
