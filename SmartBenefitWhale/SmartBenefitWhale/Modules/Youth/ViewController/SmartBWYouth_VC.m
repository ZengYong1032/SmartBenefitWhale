//
//  SmartBWYouth_VC.m
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/18.
//

#import "SmartBWYouth_VC.h"
#import "SmartBWYoutTopView.h"
#import "SmartBWYoutHeadView.h"
#import "SmartBWYouthSginCell.h"

@interface SmartBWYouth_VC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) SmartBWYoutTopView *topView;
@property (nonatomic, strong) SmartBWYoutHeadView *headView;

@end

@implementation SmartBWYouth_VC

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
    [self.view addSubview:self.mTableView];
}

#pragma mark -- 懒加载控件
- (SmartBWYoutTopView *)topView {
    if (!_topView) {
        _topView = [[SmartBWYoutTopView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kNavigationBarHeight)];
    }
    return _topView;
}
- (SmartBWYoutHeadView *)headView {
    if (!_headView) {
        _headView = [[SmartBWYoutHeadView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 280)];
        _headView.backgroundColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#F7F8F9"];
        [_headView.accBtn addTarget:self action:@selector(accBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kWindowWidth, kWindowHeight-kNavigationBarHeight-kTabBarHeight) style:(UITableViewStyleGrouped)];
        _mTableView.backgroundColor = [UIColor clearColor];
        _mTableView.showsVerticalScrollIndicator = NO;
        _mTableView.showsHorizontalScrollIndicator = NO;
        _mTableView.separatorStyle = NO;
        //ios11 适配
        if (@available(iOS 15.0, *)) {
            _mTableView.sectionHeaderTopPadding = 0;
        }
        //ios11 适配
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mTableView.estimatedRowHeight = 0;
            _mTableView.estimatedSectionHeaderHeight = 0;
            _mTableView.estimatedSectionFooterHeight = 0;
        }
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        [_mTableView registerClass:[SmartBWYouthSginCell class] forCellReuseIdentifier:@"SmartBWYouthSginCell"];
        _mTableView.tableHeaderView = self.headView;
        _mTableView.tableFooterView = [[UIView alloc] init];
    }
    return _mTableView;
}

#pragma mark - 方法
-(void)accBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.headView.frame = CGRectMake(0, 0, kWindowWidth, 280+187);
        [self.headView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(387);
        }];
        self.headView.mCollectionView.hidden = true;
        self.headView.titleView.hidden = false;
    }
    else {
        self.headView.frame = CGRectMake(0, 0, kWindowWidth, 280);
        [self.headView.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
        }];
        self.headView.mCollectionView.hidden = false;
        self.headView.titleView.hidden = true;
    }
    self.mTableView.tableHeaderView = self.headView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmartBWYouthSginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SmartBWYouthSginCell"];
    if (!cell) {
        cell = [[SmartBWYouthSginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SmartBWYouthSginCell"];
    }
//    DSGiftBagTableModel *model = self.mainModel.list[indexPath.row];
//    cell.nameLabel.text = model.name;
//    [cell.have_min_button setTitle:[NSString stringWithFormat:@"持有：%ld", model.have_min] forState:(UIControlStateNormal)];
//    [cell.img_imageView setImageWithURL:[NSURL URLWithString:model.img]];
//    cell.have_max_view.topLabel.text = [NSString stringWithFormat:@"%ld/%ld", model.have_min, model.have_max];
//    cell.all_day_label.topLabel.text = [NSString stringWithFormat:@"%ld天", model.all_day];
//    cell.get_all_label.topLabel.text = [NSString stringWithFormat:@"%ld CT", model.get_all];
//    cell.xian_max_label.text = [NSString stringWithFormat:@"平台限量(个)：%ld/%ld", model.xian_min, model.xian_max];
//    cell.num_label.text = [NSString stringWithFormat:@"%ldCT兑换", model.num];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 179 + 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
    headView.backgroundColor = [UIColor clearColor];
    UIImageView * iconImg = [[UIImageView alloc] init];
    iconImg.image = [UIImage imageNamed:@"qd_dhgc"];
    iconImg.frame = CGRectMake(12, 5, 78, 23);
    [headView addSubview:iconImg];
    return headView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.001, 0.001)];
}

@end
