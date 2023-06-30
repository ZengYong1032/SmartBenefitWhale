//
//  SmartBWYoutHeadView.h
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import <UIKit/UIKit.h>
#import "SmartBWYoutHeadCalendarView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SmartBWYoutHeadView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UIImageView *bgImg;
@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UIButton *accBtn;
@property(nonatomic,strong)UICollectionView *mCollectionView;
@property(nonatomic,strong)UIButton *submitBtn;

@property(nonatomic,strong)SmartBWYoutHeadCalendarView *titleView;
@end

NS_ASSUME_NONNULL_END
