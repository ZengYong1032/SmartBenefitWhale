//
//  SmartBWMainChooseTableViewCell.m
//  SmartBenefitWhale
//
//  Created by Yong Zeng on 2023/6/28.
//

#import "SmartBWMainChooseTableViewCell.h"

@interface SmartBWMainChooseTableViewCell ()

@property (nonatomic,strong) UIImageView                                *goodsImageView;

@property (nonatomic,strong) UILabel                                    *themeLab;

@property (nonatomic,strong) UILabel                                    *priceLab;

@property (nonatomic,strong) UILabel                                    *saleCountLab;

@end

@implementation SmartBWMainChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark **************************************************** Business Event Method ****************************************************
- (void)setInfo:(NSDictionary *)info {
    _info = info;
    
    [self.goodsImageView sd_setImageWithURL:kURL(info[@"thumb"])];
    self.priceLab.text = NSStringFormat(@"%@ CT",kIntegerStringTransform(info[@"wallet"]));
    self.saleCountLab.text = NSStringFormat(@"%@ 已售",kIntegerStringTransform(info[@"maichu_num"]));
    CGFloat h = [SmartBWAuxiliaryMeansManager computeAttributedStringHeightWithString:[[NSAttributedString alloc] initWithString:kStringTransform(info[@"name"]) attributes:@{NSFontAttributeName:SystemFont(15)}] tvWidth:self.themeLab.width];
    self.themeLab.height = MIN(60.0, MAX(24.0, h));
    self.themeLab.text = kStringTransform(info[@"name"]);
}

#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
- (UIImageView *)goodsImageView {
    if(!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, 0.0, 88.0, 88.0)];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.layer.cornerRadius = 10.0;
        _goodsImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_goodsImageView];
    }
    return _goodsImageView;
}

- (UILabel *)themeLab {
    if(!_themeLab) {
        _themeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageView.right + 12.0, 0.0, kWindowWidth - (self.goodsImageView.right + 28.0), 24.0)];
        _themeLab.textAlignment = NSTextAlignmentLeft;
        _themeLab.font = SystemFont(15);
        _themeLab.textColor = kBlackColor;
        _themeLab.numberOfLines = 2;
        
        [self.contentView addSubview:_themeLab];
    }
    return _themeLab;
}

- (UILabel *)priceLab {
    if(!_priceLab) {
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(self.themeLab.left, 62.0, self.goodsImageView.width - 70.0, 20.0)];
        _priceLab.textAlignment = NSTextAlignmentLeft;
        _priceLab.font = SystemBoldFont(16);
        _priceLab.textColor = kColorByHexString(@"#ED3D44");
        
        [self.contentView addSubview:_priceLab];
    }
    return _priceLab;
}

- (UILabel *)saleCountLab {
    if(!_saleCountLab) {
        _saleCountLab = [[UILabel alloc] initWithFrame:CGRectMake(self.themeLab.right + 4.0, self.themeLab.top, 66.0, 20.0)];
        _saleCountLab.textAlignment = NSTextAlignmentRight;
        _saleCountLab.font = SystemFont(13);
        _saleCountLab.textColor = kColorByHexString(@"#999999");
        _saleCountLab.adjustsFontSizeToFitWidth = YES;
        
        [self.contentView addSubview:_saleCountLab];
    }
    return _saleCountLab;
}

@end
