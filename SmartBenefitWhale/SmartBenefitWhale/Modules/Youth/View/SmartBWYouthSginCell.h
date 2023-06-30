//
//  SmartBWYouthSginCell.h
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import <UIKit/UIKit.h>
#import "DSDoubleTxtView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SmartBWYouthSginCell : UITableViewCell
/// 名称
@property (nonatomic, strong) UILabel *nameLabel;

/// 持有
@property (nonatomic, strong) UIButton *have_min_button;

/// 图片
@property (nonatomic, strong) UIImageView *img_imageView;

/// 上限
@property (nonatomic, strong) DSDoubleTxtView *have_max_view;

/// 需要天数
@property (nonatomic, strong) DSDoubleTxtView *all_day_label;

/// 总共获得
@property (nonatomic, strong) DSDoubleTxtView *get_all_label;

/// 平台上限
@property (nonatomic, strong) UILabel *xian_max_label;

/// 数量
@property (nonatomic, strong) UILabel *num_label;

/// 内容视图
@property (nonatomic, strong) UIView *unitView;

/// 属性栏目
@property (nonatomic, strong) UIStackView *attr_view;

/// 立即兑换
@property (nonatomic, strong) UIButton *conversion_button;
@end

NS_ASSUME_NONNULL_END
