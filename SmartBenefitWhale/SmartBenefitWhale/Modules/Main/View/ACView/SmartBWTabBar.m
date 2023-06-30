//
//  SmartBWTabBar.m
//  SmartBenefitWhale
//
//  Created by Yong Zeng on 2023/6/27.
//

#import "SmartBWTabBar.h"

static SmartBWTabBar *sharedTabBar = nil;

@interface SmartBWTabBar ()

@property (nonatomic,strong) UIImageView                                            *tabBarBackgroundImageView;

@property (nonatomic,assign) NSInteger                                              itemCount;

@property (nonatomic,assign) NSInteger                                              index;

@end

@implementation SmartBWTabBar

+ (instancetype)sharedTabBar {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTabBar = [[super allocWithZone:NULL] initWithFrame:CGRectMake(0, kWindowHeight - IP6SW(69) - DeviceBottomSafeHeight, kWindowWidth, IP6SW(69) + DeviceBottomSafeHeight)];
    });
    return sharedTabBar;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [SmartBWTabBar sharedTabBar];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [SmartBWTabBar sharedTabBar];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [SmartBWTabBar sharedTabBar];
}

+ (CGFloat)tabBarViewHeight {
    return IP6SW(47) + DeviceBottomSafeHeight;
}


#pragma mark **************************************************** Business Event Method ****************************************************
/// 配置导航栏视图
/// - Parameter titles: item title数组
/// - Parameter firstIndex: 首次进入item索引
+ (void)configTabBarViewByItemTitles:(NSArray *)titles firstIndex:(NSInteger)firstIndex {
    if(![SmartBWTabBar sharedTabBar].tabBarBackgroundImageView) {
        NSInteger itemCount = titles.count;
        CGFloat y = IP6SW(22.0);
        CGFloat centerItemY = IP6SW(4.0);
        CGFloat itemW = kScreen_X(1.0/itemCount*1.0);
        CGFloat itemH = IP6SW(69) - y;
        CGFloat itemTitleH = IP6SW(15.0);
        CGFloat centerItemH = IP6SW(69) - centerItemY;
        CGFloat centerItemIVH = centerItemH - itemTitleH;
        CGFloat itemIVH = itemH - itemTitleH;
        
        [SmartBWTabBar sharedTabBar].itemCount = itemCount;
        [SmartBWTabBar sharedTabBar].index = firstIndex;
        [SmartBWTabBar sharedTabBar].tabBarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, IP6SW(69))];
        [SmartBWTabBar sharedTabBar].tabBarBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [SmartBWTabBar sharedTabBar].tabBarBackgroundImageView.image = ImageByName(@"tab_bg");
        [SmartBWTabBar sharedTabBar].tabBarBackgroundImageView.layer.masksToBounds = YES;
        [SmartBWTabBar sharedTabBar].tabBarBackgroundImageView.userInteractionEnabled = YES;
        
        [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isCenter = idx == 2;
            BOOL isIndex = (firstIndex == idx);
            CGFloat iy = isCenter?centerItemY:y;
            CGFloat ih = isCenter?itemH:centerItemH;
            CGFloat ivh = isCenter?centerItemIVH:itemIVH;
            
            UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(idx*itemW, iy, itemW, ih)];
            [itemButton addTarget:[SmartBWTabBar sharedTabBar] action:@selector(changeTabBarItemByItemButton:) forControlEvents:UIControlEventTouchUpInside];
            itemButton.tag = (2023062700 + idx);
            
            UIImageView *itemIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemW, ivh)];
            itemIV.contentMode = UIViewContentModeCenter;
            itemIV.tag = (2023062710 + idx);
            itemIV.image = ImageByName(NSStringFormat(@"tab_%ld_%@_mark",idx,(isIndex?@"s":@"n")));
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, itemIV.bottom, itemW, itemTitleH)];
            titleLab.adjustsFontSizeToFitWidth = YES;
            titleLab.textAlignment = NSTextAlignmentCenter;
            titleLab.font = SystemFont(11);
            titleLab.textColor = (isIndex?kBlackColor:kGrayColorByAlph(180));
            titleLab.text = obj;
            titleLab.tag = (2023062720 + idx);
            
            [itemButton addSubview:itemIV];
            [itemButton addSubview:titleLab];
            [[SmartBWTabBar sharedTabBar].tabBarBackgroundImageView addSubview:itemButton];
        }];
        
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [SmartBWTabBar sharedTabBar].tabBarBackgroundImageView.bottom, kWindowWidth, DeviceBottomSafeHeight)];
        bottomView.backgroundColor = kWhiteColor;
        [[SmartBWTabBar sharedTabBar] addSubview:[SmartBWTabBar sharedTabBar].tabBarBackgroundImageView];
        [[SmartBWTabBar sharedTabBar] addSubview:bottomView];
    }
}

/// 主动切换导航视图
/// - Parameter sender: item tag：2023062700、iv：2023062710、title：2023062720
- (void)changeTabBarItemByItemButton:(UIButton *)sender {
    NSInteger index = sender.tag - 2023062700;
    if(index != [SmartBWTabBar sharedTabBar].index) {
        UIImageView *itemIV = [[SmartBWTabBar sharedTabBar].tabBarBackgroundImageView viewWithTag:([SmartBWTabBar sharedTabBar].index + 2023062710)];
        UILabel *itemTitleLab = [[SmartBWTabBar sharedTabBar].tabBarBackgroundImageView viewWithTag:([SmartBWTabBar sharedTabBar].index + 2023062720)];
        if(itemIV) {
            itemIV.image = ImageByName(NSStringFormat(@"tab_%ld_n_mark",[SmartBWTabBar sharedTabBar].index));
        }
        if(itemTitleLab) {
            itemTitleLab.textColor = kGrayColorByAlph(180);
        }
        
        UIImageView *itemIV0 = [[SmartBWTabBar sharedTabBar].tabBarBackgroundImageView viewWithTag:(index + 2023062710)];
        UILabel *itemTitleLab0 = [[SmartBWTabBar sharedTabBar].tabBarBackgroundImageView viewWithTag:(index + 2023062720)];
        if(itemIV0) {
            itemIV0.image = ImageByName(NSStringFormat(@"tab_%ld_s_mark",index));
        }
        if(itemTitleLab0) {
            itemTitleLab0.textColor = kBlackColor;
        }
        [SmartBWTabBar sharedTabBar].index = index;
        if(kClassJudgeByName(AppMainWindow.rootViewController, UITabBarController)) {
            [((UITabBarController *)AppMainWindow.rootViewController) setSelectedIndex:index];
        }
    }
}

/// 根据索引切换导航视图
/// - Parameter index: 索引
+ (void)changeTabBarItemByIndex:(NSInteger)index {
    if(index != [SmartBWTabBar sharedTabBar].index) {
        UIButton *itemButton = [[SmartBWTabBar sharedTabBar].tabBarBackgroundImageView viewWithTag:(index + 2023062700)];
        if(itemButton) {
            [[SmartBWTabBar sharedTabBar] changeTabBarItemByItemButton:itemButton];
        }
    }
}

/// 渲染导航视图
+ (void)showTabBarView {
    if([SmartBWTabBar sharedTabBar].hidden) {
        [SmartBWTabBar sharedTabBar].hidden = NO;
    }
    else {
        [AppMainWindow addSubview:[SmartBWTabBar sharedTabBar]];
    }
}

/// 隐藏导航视图
+ (void)hidenTabBarView {
    [SmartBWTabBar sharedTabBar].hidden = YES;
}



@end
