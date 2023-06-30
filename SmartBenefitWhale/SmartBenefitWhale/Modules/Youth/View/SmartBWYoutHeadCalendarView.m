//
//  SmartBWYoutHeadTitleView.m
//  SmartBenefitWhale
//
//  Created by Mac on 2023/6/30.
//

#import "SmartBWYoutHeadCalendarView.h"

@implementation SmartBWYoutHeadCalendarView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat itemWidth = (kWindowWidth-24)/7;
        NSArray * titleArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int index = 0; index < titleArr.count; index ++) {
            UILabel * titleLab = [[UILabel alloc] init];
            titleLab.font = [UIFont systemFontOfSize:14];
            titleLab.textColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#999999"];
            titleLab.text = titleArr[index];
            titleLab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:titleLab];
            
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(itemWidth*index);
                make.top.equalTo(self);
                make.height.mas_equalTo(40);
                make.width.mas_equalTo(itemWidth);
            }];
        }
        
        [self addSubview:self.mCollectionView];
        [self.mCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.mas_equalTo(35);
        }];
    }
    return self;
}

- (UICollectionView *)mCollectionView {
    if (!_mCollectionView) {
        UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionLayout.minimumInteritemSpacing = 0;
        collectionLayout.minimumLineSpacing = 0;
        collectionLayout.itemSize = CGSizeMake((kWindowWidth-24)/7, 40);
        
        _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
        [_mCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _mCollectionView.scrollEnabled = false;
    }
    return _mCollectionView;
}

//代理方法
#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7*6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if(!cell){
        cell = [[UICollectionViewCell alloc] init];
    }
    UILabel * titlelab = [[UILabel alloc] init];
    titlelab.text = @"26";
    titlelab.font = [UIFont boldSystemFontOfSize:14];
    titlelab.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:titlelab];
    [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView);
        make.centerY.equalTo(cell.contentView);
        make.height.mas_equalTo(10);
    }];
    
    return cell;
}


@end
