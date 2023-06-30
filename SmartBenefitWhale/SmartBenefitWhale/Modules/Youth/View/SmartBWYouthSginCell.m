//
//  SmartBWYouthSginCell.m
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import "SmartBWYouthSginCell.h"

@implementation SmartBWYouthSginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
        self.contentView.backgroundColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#F7F8F9"];
    }
    return self;
}
#pragma mark -- 添加控件到视图

/// 添加子视图内容
- (void)addSubviews {
    [self.contentView addSubview:self.unitView];
    [self.unitView addSubview:self.nameLabel];
    [self.unitView addSubview:self.have_min_button];
    [self.unitView addSubview:self.img_imageView];
    [self.unitView addSubview:self.attr_view];
    [self.attr_view addArrangedSubview:self.have_max_view];
    [self.attr_view addArrangedSubview:self.all_day_label];
    [self.attr_view addArrangedSubview:self.get_all_label];
    [self.unitView addSubview:self.xian_max_label];
    [self.unitView addSubview:self.num_label];
    [self.unitView addSubview:self.conversion_button];
}
#pragma mark -- 懒加载控件

- (UIView *)unitView {
    if (!_unitView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12.0, 0, UIScreen.mainScreen.bounds.size.width - 12.0 * 2, 179.0)];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = true;
        _unitView = view;
    }
    return _unitView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 18.0, UIScreen.mainScreen.bounds.size.width / 2, 16.0)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"新手任务包";
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UIButton *)have_min_button {
    if (!_have_min_button) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.unitView.frame) / 2, 20, CGRectGetWidth(self.unitView.frame) / 2 - 12.0, 13)];
        [button setImage:UIColor.getRedImageFromGiftBagSignIn forState:(UIControlStateNormal)];
        [button setTitle:@"持有：1" forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        button.imageView.frame = CGRectMake(0, 0, 10, 10);
        button.imageView.backgroundColor = UIColor.redColor;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _have_min_button = button;
    }
    return _have_min_button;
}

- (UIImageView *)img_imageView {
    if (!_img_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 47.0, 74, 74)];
        imageView.backgroundColor = UIColor.redColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _img_imageView = imageView;
    }
    return _img_imageView;
}

- (UIStackView *)attr_view {
    if (!_attr_view) {
        UIStackView *view = [[UIStackView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.img_imageView.frame) + 12, CGRectGetMinY(self.img_imageView.frame)+2, CGRectGetWidth(self.unitView.frame) - CGRectGetMaxX(self.img_imageView.frame) - 12 * 2, 40)];
        view.distribution = UIStackViewDistributionFillEqually;
        _attr_view = view;
    }
    return _attr_view;
}

- (DSDoubleTxtView *)have_max_view {
    if (!_have_max_view) {
        DSDoubleTxtView *view = [[DSDoubleTxtView alloc] initWithFrame:CGRectZero];
        view.topLabel.text = @"1/1";
        view.bottomLabel.text = @"持有上限";
        _have_max_view = view;
    }
    return _have_max_view;
}

- (DSDoubleTxtView *)all_day_label {
    if (!_all_day_label) {
        DSDoubleTxtView *view = [[DSDoubleTxtView alloc] initWithFrame:CGRectZero];
        view.topLabel.text = @"30天";
        view.bottomLabel.text = @"释放周期";
        _all_day_label = view;
    }
    return _all_day_label;
}

- (DSDoubleTxtView *)get_all_label {
    if (!_get_all_label) {
        DSDoubleTxtView *view = [[DSDoubleTxtView alloc] initWithFrame:CGRectZero];
        view.topLabel.textColor = UIColor.redColor;
        view.topLabel.text = @"12 CT";
        view.bottomLabel.text = @"累计收益";
        _get_all_label = view;
    }
    return _get_all_label;
}

- (UILabel *)xian_max_label {
    if (!_xian_max_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.img_imageView.frame) + 12*2, 104, CGRectGetWidth(self.attr_view.frame), 15.0)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"平台限量(个)：50000/50000";
        _xian_max_label = label;
    }
    return _xian_max_label;
}

- (UILabel *)num_label {
    if (!_num_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(self.img_imageView.frame) + 20.0, CGRectGetWidth(self.unitView.frame) - 12.0 * 2 - 100, 15.0)];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor redColor];
        label.text = @"免费体验";
        _num_label = label;
    }
    return _num_label;
}

- (UIButton *)conversion_button {
    if (!_conversion_button) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.unitView.frame) - 12.0 - 100.0, CGRectGetMaxY(self.img_imageView.frame) + 10.0, 100, 34.0)];
        [button setTitle:@"立即兑换" forState:(UIControlStateNormal)];
        button.backgroundColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#FF4949"];
        button.layer.cornerRadius = 17;
        button.layer.masksToBounds = true;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        _conversion_button = button;
    }
    return _conversion_button;
}



@end
