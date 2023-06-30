//
//  YZBannerView.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/23.
//

#import "YZBannerView.h"
#import <SDWebImage/SDWebImage.h>

@interface YZBannerView ()
<
    UIScrollViewDelegate
>

@property (nonatomic,strong) UIScrollView                               *bannerScrollView;
@property (nonatomic,strong) UIView                                     *bottomPageView;
@property (nonatomic,strong) NSTimer                                    *bannerTimer;
@property (nonatomic,strong) NSMutableArray                             *banners;
@property (nonatomic,assign) NSInteger                                  currentIndex;
@property (nonatomic,assign) CGFloat                                    duration;
@property (nonatomic,assign) CGFloat                                    cornerWidth;
@property (nonatomic,assign) BOOL                                       isStart;
@property (nonatomic,copy) BannerViewResponse                           respond;
@property (nonatomic,assign) CGSize                                     viewsize;

@end

@implementation YZBannerView

- (instancetype)initWithFrame:(CGRect)frame banners:(NSArray *)banners cornerWidth:(CGFloat)cornerWidth duration:(CGFloat)duration response:(BannerViewResponse)response {
    if (self = [super initWithFrame:frame]) {
        _viewsize = frame.size;
        _banners = [NSMutableArray arrayWithArray:banners];
        _respond = response;
        _duration = duration;
        _cornerWidth = cornerWidth;
        
        [self addSubview:self.bannerScrollView];
        [self addSubview:self.bottomPageView];
        [self startBannerTimer];
    }
    return self;
}

#pragma mark <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Scroll View Delegate Method  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopBannerTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        [self startBannerTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = floor(scrollView.contentOffset.x/scrollView.width);
    [self refreshBottomPageView];
}

#pragma mark ----------------------------------------------------- Business Event Method -----------------------------------------------------
/// 开始banner动画
- (void)startBannerTimer {
    if (!_bannerTimer && self.banners.count > 1) {
        self.isStart = YES;
        [self.bannerTimer fire];
    }
}

/// 关闭banner动画
- (void)stopBannerTimer {
    if (_bannerTimer) {
        self.isStart = NO;
        [self.bannerTimer invalidate];
        self.bannerTimer = nil;
    }
}

- (void)bannerAnimationResponse {
    if (self.banners.count > 1 && ![self.bannerScrollView isFirstResponder]) {
        if (self.isStart) {
            self.isStart = NO;
        }
        else {
            self.currentIndex++;
            if (self.currentIndex <= self.banners.count) {
                [self.bannerScrollView setContentOffset:CGPointMake(self.bannerScrollView.width*self.currentIndex, 0) animated:YES];
                if (self.currentIndex == self.banners.count) {
                    self.currentIndex = 0;
                    [self.bannerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                }
                [self refreshBottomPageView];
            }
            else {
                [self stopBannerTimer];
            }
        }
    }
    else if (![self.bannerScrollView isFirstResponder]) {
        [self stopBannerTimer];
    }
}

- (void)bannerTouchResponse:(UIButton *)sender {
    if (_respond) {
        NSInteger tag = sender.tag - 2021050500;
        kWeakConfig(self);
        self.respond(weakself.banners[tag], tag);
    }
}

#pragma mark *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* Views Refresh Method *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
- (void)refreshBottomPageView {
    [self.bottomPageView removeFromSuperview];
    self.bottomPageView = nil;
    [self addSubview:self.bottomPageView];
}

#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
- (UIScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        CGFloat width = self.viewsize.width;
        CGFloat height = self.viewsize.height;
        _bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height)];
        _bannerScrollView.delegate = self;
        _bannerScrollView.showsVerticalScrollIndicator = NO;
        _bannerScrollView.showsHorizontalScrollIndicator = NO;
        _bannerScrollView.pagingEnabled = YES;
        _bannerScrollView.backgroundColor = kClearColor;
        kWeakConfig(self);
        [self.banners enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *tapButton = [[UIButton alloc] initWithFrame:CGRectMake(idx*width, 0.0, width, height)];
            tapButton.tag = (2021050500 + idx);
            [tapButton addTarget:weakself action:@selector(bannerTouchResponse:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *bannerIV = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height)];
            bannerIV.contentMode = UIViewContentModeScaleAspectFill;
            bannerIV.layer.cornerRadius = self.cornerWidth;
            bannerIV.layer.masksToBounds = YES;
//            bannerIV.backgroundColor = kGrayColorByAlph(230);
            NSString *image = @"";
            if (kClassJudgeByName(obj, NSString)) {
                image = obj;
                [bannerIV sd_setImageWithURL:kURL(image)];
            }
            else if (kClassJudgeByName(obj, NSDictionary)) {
                image = obj[@"img"];
                [bannerIV sd_setImageWithURL:kURL(image)];
            }
            else if (kClassJudgeByName(obj, UIImage)) {
                bannerIV.image = obj;
            }
            else {
                bannerIV.backgroundColor = kRandomColor;
            }
            
            [tapButton addSubview:bannerIV];
            [_bannerScrollView addSubview:tapButton];
        }];
        
        _bannerScrollView.contentSize = CGSizeMake(width*self.banners.count, 0);
    }
    return _bannerScrollView;
}

- (UIView *)bottomPageView {
    if (!_bottomPageView) {
        _bottomPageView = [[UIView alloc] initWithFrame:CGRectMake(self.bannerScrollView.left, self.bannerScrollView.bottom - 20.0, self.bannerScrollView.width, 20.0)];
        CGFloat normalWidth = 6.0;
        CGFloat highWidth = 12.0;
        CGFloat height = 4.0;
        CGFloat space = 6.0;
        CGFloat x = (self.viewsize.width - self.banners.count*(normalWidth + space) - normalWidth)*0.5;
        
        for (int i=0; i<self.banners.count; i++) {
            BOOL isHigh = i == self.currentIndex;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x + i*(normalWidth + space) + (i > self.currentIndex)*normalWidth, 6.0, (isHigh ? highWidth:normalWidth), height)];
            line.backgroundColor = isHigh?kWhiteColor:kGrayColorByAlph(220);
            line.layer.cornerRadius = height*0.5;
            [_bottomPageView addSubview:line];
        }
    }
    return _bottomPageView;
}

- (NSTimer *)bannerTimer {
    if (!_bannerTimer) {
        kWeakConfig(self);
        _bannerTimer = [NSTimer safeScheduledTimerWithTimeInterval:self.duration block:^{
            [weakself bannerAnimationResponse];
        } repeats:YES];
    }
    return _bannerTimer;
}

@end
