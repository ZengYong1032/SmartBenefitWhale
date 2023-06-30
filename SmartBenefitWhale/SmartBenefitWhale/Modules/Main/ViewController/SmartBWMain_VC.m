//
//  SmartBWMain_VC.m
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/18.
//

#import "SmartBWMain_VC.h"

@interface SmartBWMain_VC ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic,strong) UIView                                         *topView;
@property (nonatomic,strong) YZLocationView                                 *locationView;

@property (nonatomic,strong) UITableView                                    *basalTableView;
@property (nonatomic,strong) UIView                                         *headerView;
@property (nonatomic,strong) YZBannerView                                   *topBannerView;
@property (nonatomic,strong) UIView                                         *functionView;
@property (nonatomic,strong) UIImageView                                    *functionImageView;

@property (nonatomic,strong) UIImageView                                    *nullImageView;
@property (nonatomic,strong) UILabel                                        *moreLab;

@property (nonatomic,strong) NSMutableArray                                 *choicenessGoodsList;
@property (nonatomic,assign) NSInteger                                      page;
@property (nonatomic,assign) BOOL                                           scrollReturn;
@property (nonatomic,assign) BOOL                                           haveMore;

@property (nonatomic,strong) NSMutableArray                                 *topBanners;

@end

@implementation SmartBWMain_VC

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    
    [self setupViews];
}

#pragma mark ------------------------------------------------ UITableView Data Source & Delegate Method  ------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.choicenessGoodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmartBWMainChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SmartBWMainChooseTableViewCellID];
    if(!cell) {
        cell = [[SmartBWMainChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SmartBWMainChooseTableViewCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.info = self.choicenessGoodsList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark **************************************************** Business Event Method ****************************************************
/// 配置页面视图
- (void)setupViews {
    UIImageView *headerBGIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, kWindowWidth, IP6SW(200))];
    headerBGIV.contentMode = UIViewContentModeScaleAspectFit;
    headerBGIV.image = ImageByName(@"sy_jbbj");
    [self.view addSubview:self.topView];
    [self.view addSubview:headerBGIV];
    [self.view addSubview:self.basalTableView];
}


/// 跳转城市选择
- (void)showCityListView {
    
}


/// Banner 响应
/// - Parameters:
///   - info: Banner 数据
///   - index: 索引
- (void)topBannerComposeByInfo:(NSDictionary *)info index:(NSInteger)index {
    
}

/// 中部功能按钮响应
/// - Parameter sender: 功能按钮 2023062800、2023062810
- (void)functionButtonCompose:(UIButton *)sender {
    
}

/// 中部广告位响应
- (void)functionImageButtonCompose {
    
}


#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
- (UIView *)topView {
    if(!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kStatusBarHeight + 50.0)];
        _topView.backgroundColor = kColorByHexString(@"#FF4949");
        UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, 8.0 + kStatusBarHeight, 104.0, 32.0)];
        logoIV.image = ImageByName(@"sy_logo");
        logoIV.contentMode = UIViewContentModeLeft;
        
        [_topView addSubview:logoIV];
        [_topView addSubview:self.locationView];
    }
    return _topView;
}

- (YZLocationView *)locationView {
    if (!_locationView) {
        kWeakConfig(self);
        _locationView = [[YZLocationView alloc] initWithFrame:CGRectMake(kWindowWidth - 126.0, 2.0 + kStatusBarHeight, 110.0, 46.0) location:@"成都市" locationMark:@"" nextMark:@"" response:^(NSString * _Nonnull locationCity) {
            [weakself showCityListView];
        }];
    }
    return _locationView;
}

- (UITableView *)basalTableView {
    if(!_basalTableView) {
        _basalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, kWindowWidth, kWindowHeight - self.topView.bottom - SmartTabBarHeight) style:UITableViewStylePlain];
        _basalTableView.showsVerticalScrollIndicator = NO;
        _basalTableView.showsHorizontalScrollIndicator = NO;
        _basalTableView.delegate = self;
        _basalTableView.dataSource = self;
        _basalTableView.rowHeight = 102.0;
        _basalTableView.backgroundColor = kClearColor;
        _basalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _basalTableView.tableHeaderView = self.headerView;
        [_basalTableView registerClass:[SmartBWMainChooseTableViewCell class] forCellReuseIdentifier:SmartBWMainChooseTableViewCellID];
    }
    return _basalTableView;
}

- (UIView *)headerView {
    if(!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, self.functionView.bottom)];
        [_headerView addSubview:self.topBannerView];
        [_headerView addSubview:self.functionView];
    }
    return _headerView;
}

- (YZBannerView *)topBannerView {
    if(!_topBannerView) {
        CGFloat w = kWindowWidth - 32.0;
        CGFloat h = (w/351.0)*160.0;
        kWeakConfig(self);
        _topBannerView = [[YZBannerView alloc] initWithFrame:CGRectMake(16.0, 0.0, w, h) banners:self.topBanners cornerWidth:10.0 duration:5 response:^(id  _Nonnull bannerInfo, NSInteger index) {
            [weakself topBannerComposeByInfo:bannerInfo index:index];
        }];
    }
    return _topBannerView;
}

- (UIView *)functionView {
    if(!_functionView) {
        kWeakConfig(self);
        CGFloat x = 16.0;
        CGFloat x0 = 16.0;
        CGFloat y0 = 12.0;
        CGFloat w0 = (kWindowWidth - x*2.0 + x0)*0.5;
        CGFloat h0 = (w0/171.0)*64.0;
        CGFloat Y = 0;
        CGFloat funcY = 0;
        CGFloat w1 = (kWindowWidth - x*2.0)*0.25;
        CGFloat h1 = 66.0;
        
        _functionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topBannerView.bottom, kWindowWidth, 0.0)];

        for (int i=0; i<4; i++) {
            UIButton *funcButton = [[UIButton alloc] initWithFrame:CGRectMake(x + (i%2)*(w0 + x0), y0 + (i/2)*(h0 + y0), w0, h0)];
            [funcButton addTarget:weakself action:@selector(functionButtonCompose:) forControlEvents:UIControlEventTouchUpInside];
            funcButton.tag = (2023062800 + i);
            UIImageView *funcBGIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w0, h0)];
            funcBGIV.contentMode = UIViewContentModeScaleAspectFit;
            funcBGIV.image = ImageByName(NSStringFormat(@"sy_jg_%d",i));
            [funcButton addSubview:funcBGIV];
            
            [_functionView addSubview:funcButton];
            Y = funcButton.bottom;
        }
        
        funcY = Y;
        Y += 84.0;
        [@[@"会议申请",@"官网链接",@"油卡",@"城市合伙人"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *funcButton = [[UIButton alloc] initWithFrame:CGRectMake(x + idx*(w0 + x0), funcY + 16.0, w1, h1)];
            [funcButton addTarget:weakself action:@selector(functionButtonCompose:) forControlEvents:UIControlEventTouchUpInside];
            funcButton.tag = (2023062810 + idx);
            UIImageView *funcBGIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w1, 38.0)];
            funcBGIV.contentMode = UIViewContentModeCenter;
            funcBGIV.image = ImageByName(NSStringFormat(@"sy_func_%ld",idx));
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 38.0, w1, 28.0)];
            titleLab.adjustsFontSizeToFitWidth = YES;
            titleLab.textAlignment = NSTextAlignmentCenter;
            titleLab.font = SystemFont(12);
            titleLab.textColor = kBlackColor;
            titleLab.text = obj;
            
            [funcButton addSubview:funcBGIV];
            [funcButton addSubview:titleLab];
            
            [_functionView addSubview:funcButton];
        }];
        
        self.functionImageView.frame = CGRectMake(0, 0.0, kWindowWidth - x*2.0, (kWindowWidth - x*2.0)*98.0/350.0);
        
        UIButton *funcImageButton = [[UIButton alloc] initWithFrame:CGRectMake(x, Y + 8.0, kWindowWidth - x*2.0, (kWindowWidth - x*2.0)*98.0/350.0)];
        [funcImageButton addTarget:self action:@selector(functionImageButtonCompose) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *funcMarkIV = [[UIImageView alloc] initWithFrame:CGRectMake(x, funcImageButton.bottom, kWindowWidth - 2.0*x, 40.0)];
        funcMarkIV.contentMode = UIViewContentModeCenter;
        funcMarkIV.image = ImageByName(@"sy_zhjx");
        
        _functionView.height = funcMarkIV.bottom;
        
        [funcImageButton addSubview:self.functionImageView];
        [_functionView addSubview:funcImageButton];
        [_functionView addSubview:funcMarkIV];
    }
    return _functionView;
}

- (UIImageView *)functionImageView {
    if(!_functionImageView) {
        _functionImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _functionImageView.contentMode = UIViewContentModeScaleAspectFit;
        _functionImageView.image = ImageByName(@"sy_jn_dzlv");
    }
    return _functionImageView;
}

#pragma mark **************************************************** Resource Lazy Load Method ****************************************************
- (NSMutableArray *)topBanners {
    if(!_topBanners) {
        _topBanners = [NSMutableArray arrayWithArray:@[ImageByName(@"banner_default"),ImageByName(@"banner_default"),ImageByName(@"banner_default"),ImageByName(@"banner_default"),ImageByName(@"banner_default")]];
    }
    return _topBanners;
}

@end
