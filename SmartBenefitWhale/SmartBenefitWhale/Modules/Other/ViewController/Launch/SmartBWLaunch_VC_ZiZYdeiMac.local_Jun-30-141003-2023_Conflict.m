//
//  SmartBWLaunch_VC.m
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/13.
//

#import "SmartBWLaunch_VC.h"

@interface SmartBWLaunch_VC ()

@property (nonatomic,strong) YZVersionUpdateView                            *updateView;

@property (nonatomic,assign) NSInteger                                      count;

@end

@implementation SmartBWLaunch_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    [self configBackgroundImageViewWithImage:@"login_bg_image" rect:kWindowBounds];
    
    if([AFNetworkReachabilityManager sharedManager].reachable) {
        [self enterAppLaunch];
    }
    else {
        [AppNotificationCenter addObserver:self selector:@selector(enterAppLaunch) name:DeviceNetworkStatusNotification object:nil];
        [self performSelector:@selector(showDeviceNetworkStatusAlertTips) withObject:nil afterDelay:5];
    }
}

#pragma mark **************************************************** Business Event Method ****************************************************
- (void)showDeviceNetworkStatusAlertTips {
    if(![SmartBWCacheManager sharedCacheTool].deviceNetworkStatusNormal) {
        UIAlertController *networkTips = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"网络不可用,请检查网络." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [networkTips addAction:cancelAction];
    }
}

- (void)enterAppLaunch {
    [SmartBWCacheManager sharedCacheTool].deviceNetworkStatusNormal = YES;
    [self requestVersionInfo];
}

- (void)configAppInformation {
    if(self.count < 1) {
        return;
    }
//    [CAFNOQuickManager deviceNetworkMonitorRemoveNotification];
//    [CAFNOQuickManager configUniversalNavigationBarAndTabBar];
//    [CAFNOUserInformation configUserInformationFromCache];
//    [YZLocationManager configLocationSetting];
//    [YZCityManager configCityInformation];
//    [CAFNODataManager configDataManagerBasalSetting];
    
    NSMutableArray *labs = [NSMutableArray arrayWithObjects:@{@"vc":[SmartBWMain_VC new],@"title":@"首页",@"image_n":@"tab_0_n_mark",@"image_s":@"tab_0_s_mark"},@{@"vc":[SmartBWWelfare_VC new],@"title":@"福利",@"image_n":@"tab_1_n_mark",@"image_s":@"tab_1_s_mark"},@{@"vc":[SmartBWYouth_VC new],@"title":@"青创",@"image_n":@"tab_2_n_mark",@"image_s":@"tab_2_s_mark"},@{@"vc":[SmartBWShoppingCentre_VC new],@"title":@"商城",@"image_n":@"tab_3_n_mark",@"image_s":@"tab_3_s_mark"},@{@"vc":[SmartBWMine_VC new],@"title":@"我的",@"image_n":@"tab_4_n_mark",@"image_s":@"tab_4_s_mark"}, nil];
//    if(DoubleStringCompare(@"1", IMStatus)) {
//        [labs insertObject:@{@"vc":[EMConversationsViewController new],@"title":@"聊天",@"image_n":@"tab_lt_g",@"image_s":@"tab_lt_r"} atIndex:3];
//    }
//    else {
//        [labs insertObject:@{@"vc":[CAFNOChat_VC new],@"title":@"聊天",@"image_n":@"tab_lt_g",@"image_s":@"tab_lt_r"} atIndex:3];
//    }
    
    AppMainWindow.rootViewController = [SmartBWAuxiliaryMeansManager configTabBarControllerWithRootViewControllereInfos:labs];
}

- (void)checkAppVersionWithInfo:(NSDictionary *)info {
    MyCustomLog(@"\n Info = %@\n",info);
    if(kClassJudgeByName(info, NSDictionary) && info[@"ios"] && kClassJudgeByName(info[@"ios"], NSDictionary)) {
        NSDictionary *iosInfo = [NSDictionary dictionaryWithDictionary:info[@"ios"]];
        [SmartBWCacheManager sharedCacheTool].subArray = [NSArray arrayWithArray:info[@"arr"]];
//        [SmartBWCacheManager sharedCacheTool].subArray = @[@"weixin",@"alipay://alipayclient",@"weixin://wap/pay",@"alipays://platformapi"];
        BOOL isUpdate = [SmartBWAuxiliaryMeansManager judgeAppVersionShouldUpdateWithDataFromAppStore:kIntegerStringTransform(iosInfo[@"version_code"]) minimumOsVersion:@"13.0"];
        if(isUpdate) {
            kWeakConfig(self);
            self.updateView = [[YZVersionUpdateView alloc] initWithContent:kStringTransform(iosInfo[@"version_desc"]) updateSource:kStringTransform(iosInfo[@"version_name"]) isMustUpdate:DoubleStringCompare(@"1", iosInfo[@"version_upgrade"]) completion:^{
                [weakself dismissUpdateView];
            }];
            [self.updateView show];
        }
        else {
            [self dismissUpdateView];
        }
    }
    else {
        [self dismissUpdateView];
    }
}

- (void)dismissUpdateView {
    if(_updateView) {
        [self.updateView dismiss];
        self.updateView = nil;
    }
    self.count++;
    [self configAppInformation];
}

#pragma mark **************************************************** Request Method ****************************************************

- (void)requestVersionInfo {
//    [AppMainWindow showHudWithText:@""];
    kWeakConfig(self);
//    [CAFNONetworkRequestManager appVersionInformationRequestSuccess:^(id  _Nonnull data, NSInteger code, NSString * _Nonnull msg) {
//        [kAppCurrentWindow dismissHud];
//        [weakself checkAppVersionWithInfo:data];
//    } failure:^(NSError * _Nonnull error) {
//        [AppMainWindow dismissHud];
        weakself.count++;
        [weakself configAppInformation];
//    }];
}

@end
