//
//  SmartBWYoutHeadView.m
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import "SmartBWYoutHeadView.h"
#import "SmartBWYoutHeadViewCell.h"


@implementation SmartBWYoutHeadView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImg];
        [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(187);
        }];
        [self addSubview:self.headImg];
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
            make.width.height.mas_equalTo(38);
        }];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.mas_right).offset(5);
            make.centerY.equalTo(self.headImg);
            make.height.mas_equalTo(20);
        }];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(62);
            make.height.mas_equalTo(200);
        }];
        [self.contentView addSubview:self.timeLab];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(18);
            make.height.mas_equalTo(15);
        }];
        [self.contentView addSubview:self.accBtn];
        [self.accBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.equalTo(self.timeLab);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        [self.contentView addSubview:self.mCollectionView];
        [self.mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.equalTo(self.timeLab.mas_bottom).offset(18);
            make.height.mas_equalTo(68);
        }];
        [self.contentView addSubview:self.submitBtn];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-18);
            make.height.mas_equalTo(44);
        }];
        
        [self.contentView addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.timeLab.mas_bottom).offset(18);
            make.bottom.mas_equalTo(-18-50);
        }];
    }
    return self;
}

- (UIImageView *)bgImg {
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"qd_bg"];
    }
    return _bgImg;
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.backgroundColor = [UIColor blueColor];
        _headImg.layer.cornerRadius = 38/2;
        _headImg.layer.masksToBounds = YES;
    }
    return _headImg;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.text = @"已连续签到3天";
    }
    return _titleLab;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = true;
    }
    return _contentView;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.textColor = [UIColor blackColor];
        _timeLab.text = @"2023年6月";
    }
    return _timeLab;
}

- (UIButton *)accBtn {
    if (!_accBtn) {
        _accBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accBtn setImage:[UIImage imageNamed:@"qd_zkrl"] forState:UIControlStateNormal];
        [_accBtn setImage:[UIImage imageNamed:@"qd_sqrl"] forState:UIControlStateSelected];
        [_accBtn setTitle:@"展开日历" forState:UIControlStateNormal];
        [_accBtn setTitle:@"收起日历" forState:UIControlStateSelected];
        _accBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_accBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _accBtn.transform = CGAffineTransformMakeScale(-1, 1);//将按钮文字和图片位置进行调换位置（图片并不会倒置）
        _accBtn.titleLabel.transform = CGAffineTransformMakeScale(-1, 1); //将倒转的文字再次倒置（显示正常）
        _accBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10); //调整按钮内图片和文字之间的间隔
        
    }
    return _accBtn;
}

- (UICollectionView *)mCollectionView {
    if (!_mCollectionView) {
        UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionLayout.minimumInteritemSpacing = 8;
        collectionLayout.itemSize = CGSizeMake((kWindowWidth-24*2-8*6)/7, 68);
        
        _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
        [_mCollectionView registerClass:[SmartBWYoutHeadViewCell class] forCellWithReuseIdentifier:@"SmartBWYoutHeadViewCell"];
    }
    return _mCollectionView;
}
-(UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"立即签到0/6" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#FF4949"];
        _submitBtn.layer.cornerRadius = 10;
        _submitBtn.layer.masksToBounds = true;
    }
    return _submitBtn;
}

- (SmartBWYoutHeadCalendarView *)titleView {
    if (!_titleView) {
        _titleView = [[SmartBWYoutHeadCalendarView alloc]init];
        _titleView.hidden = true;
    }
    return _titleView;
}


//代理方法
#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SmartBWYoutHeadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmartBWYoutHeadViewCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[SmartBWYoutHeadViewCell alloc] init];
    }
    cell.backgroundColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#FFF9ED"];
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = true;
    
    return cell;
}
@end
