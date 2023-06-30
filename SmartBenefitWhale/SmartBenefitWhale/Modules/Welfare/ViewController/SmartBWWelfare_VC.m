//
//  SmartBWWelfare_VC.m
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/18.
//

#import "SmartBWWelfare_VC.h"

@interface SmartBWWelfare_VC ()
@property(strong,nonatomic)UIView *colorView;
@property(strong,nonatomic)UIImageView *bgImg;
@property(strong,nonatomic)UIImageView *iconImg;
@property(strong,nonatomic)UIView *bgView;
@end

@implementation SmartBWWelfare_VC

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
    [self.view addSubview:self.colorView];
    [self.view addSubview:self.bgView];
    
}

-(UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 250)];
        _colorView.backgroundColor = [SmartBWAuxiliaryMeansManager colorByHexString:@"#FF4949"];
        [_colorView addSubview:self.bgImg];
        [_colorView addSubview:self.iconImg];
    }
    return _colorView;
}
- (UIImageView *)bgImg {
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"qc_gxbg"];
        _bgImg.frame = CGRectMake(0, 0, kWindowWidth, 250);
    }
    return _bgImg;
}
- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.image = [UIImage imageNamed:@"qc_jinbi"];
        _iconImg.frame = CGRectMake(0, 78, kWindowWidth, 109);
    }
    return _iconImg;
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 173, kWindowWidth, kWindowHeight-kTabBarHeight-173)];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

@end
