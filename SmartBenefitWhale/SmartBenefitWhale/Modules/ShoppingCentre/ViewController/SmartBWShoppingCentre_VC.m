//
//  SmartBWShoppingCentre_VC.m
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/18.
//

#import "SmartBWShoppingCentre_VC.h"
#import "SmartBWShoppingCentreTopView.h"
#import "SmartBWShoppingCentreHeadView.h"
#import "SmartBWShoppingCentreCell.h"

@interface SmartBWShoppingCentre_VC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(strong,nonatomic)SmartBWShoppingCentreTopView *topView;
@property(nonatomic,strong)UICollectionView *mCollectionView;
@end

@implementation SmartBWShoppingCentre_VC

#pragma mark ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Life Cycle Method ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = YES;
    [SmartBWTabBar showTabBarView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = YES;
    [SmartBWTabBar showTabBarView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [SmartBWTabBar hidenTabBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#F7F8F9"];
    [self.view addSubview:self.topView];
    UIImageView *headerBGIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, kWindowWidth, IP6SW(200))];
    headerBGIV.contentMode = UIViewContentModeScaleAspectFit;
    headerBGIV.image = ImageByName(@"sy_jbbj");
    [self.view addSubview:headerBGIV];
    [self.view addSubview:self.mCollectionView];
    
}

#pragma mark 懒加载控件
- (SmartBWShoppingCentreTopView *)topView {
    if (!_topView) {
        _topView = [[SmartBWShoppingCentreTopView alloc]initWithFrame:CGRectMake(0, 0, kWindowWidth, kNavigationBarHeight)];
    }
    return _topView;
}
- (UICollectionView *)mCollectionView {
    if (!_mCollectionView) {
        UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionLayout.minimumInteritemSpacing = 0;
        collectionLayout.minimumLineSpacing = 10;
        collectionLayout.sectionInset = UIEdgeInsetsMake(0, 12, 10, 12);
        collectionLayout.itemSize = CGSizeMake((kWindowWidth-24-10)/2, 262);
        collectionLayout.headerReferenceSize = CGSizeMake(kWindowWidth, 110);
        
        _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kWindowWidth, kWindowHeight-kNavigationBarHeight-kTabBarHeight) collectionViewLayout:collectionLayout];
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
        _mCollectionView.backgroundColor = UIColor.clearColor;
        [_mCollectionView registerClass:[SmartBWShoppingCentreCell class] forCellWithReuseIdentifier:@"SmartBWShoppingCentreCell"];
        [_mCollectionView registerClass:[SmartBWShoppingCentreHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SmartBWShoppingCentreHeadView"];
    }
    return _mCollectionView;
}

//代理方法
#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SmartBWShoppingCentreHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SmartBWShoppingCentreHeadView" forIndexPath:indexPath];
        
        return headerView;
    }
    return  nil;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SmartBWShoppingCentreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmartBWShoppingCentreCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[SmartBWShoppingCentreCell alloc] init];
    }
    cell.backgroundColor = UIColor.whiteColor;
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = true;
    
    return cell;
}

@end
