//
//  YZTipsView.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/9.
//

#import "YZTipsView.h"

@interface YZTipsView ()

@property (nonatomic,copy) CommonCompletion                                                  leftCompletion;
@property (nonatomic,copy) CommonCompletion                                                  rightCompletion;
@property (nonatomic,strong) UIButton                                                               *sureButton;
@property (nonatomic,strong) UIColor                                                                *sureButtonBGColor;
@property (nonatomic,strong) NSAttributedString                                                     *sureButtonTitle;
@property (nonatomic,strong) NSTimer                                                                *tipsTimer;
@property (nonatomic,assign) NSInteger                                                              tipsDuration;

@end

@implementation YZTipsView

+ (void)showTipsAlertViewByTitle:(NSString *)title content:(NSString *)content leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftAction:(CommonCompletion)leftAction  rightAction:(CommonCompletion)rightAction {
    YZTipsView *tipsView = [[YZTipsView alloc] initWithFrame:kWindowBounds];
    if(tipsView) {
        tipsView.leftCompletion = leftAction;
        tipsView.rightCompletion = rightAction;
        UIView *tanslucentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kWindowWidth, kWindowHeight)];
        [tanslucentView setBackgroundColor:kGrayCustomColor(0.0, 0.8)];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_X(0.5) - 140.0, kScreen_Y(0.5) - 92.0, 280.0, 184.0)];
        whiteView.backgroundColor = kWhiteColor;
        whiteView.layer.cornerRadius = 20.0;
        whiteView.layer.masksToBounds = YES;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 280.0, 45.0)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = SystemBoldFont(20);
        titleLab.textColor = kBlackColor;
        titleLab.text = title?:@"温馨提示";
        
        UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(20.0, titleLab.bottom, 240.0, 70.0)];
        contentLab.textAlignment = NSTextAlignmentCenter;
        contentLab.font = SystemFont(17);
        contentLab.textColor = kBlackColor;
        contentLab.text = content?:@"";
        contentLab.numberOfLines = 0;
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0, contentLab.bottom + 10.0, 110.0, 40.0)];
        leftButton.backgroundColor = kGrayColorByAlph(235);
        leftButton.layer.cornerRadius = 20.0;
        leftButton.layer.masksToBounds = YES;
        [leftButton addTarget:tipsView action:@selector(leftButtonResponse) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setAttributedTitle:[[NSAttributedString alloc] initWithString:(leftTitle?:@"取消") attributes:@{NSFontAttributeName:SystemFont(17),NSForegroundColorAttributeName:kGrayColorByAlph(102)}] forState:UIControlStateNormal];
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0 + leftButton.right, contentLab.bottom + 10.0, 110.0, 40.0)];
        rightButton.backgroundColor = kRedColor;
        rightButton.layer.cornerRadius = 20.0;
        rightButton.layer.masksToBounds = YES;
        [rightButton addTarget:tipsView action:@selector(rightButtonResponse) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setAttributedTitle:[[NSAttributedString alloc] initWithString:(rightTitle?:@"确定") attributes:@{NSFontAttributeName:SystemFont(17),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
        
        [whiteView addSubview:titleLab];
        [whiteView addSubview:contentLab];
        [whiteView addSubview:leftButton];
        [whiteView addSubview:rightButton];
        
        [tipsView addSubview:tanslucentView];
        [tipsView addSubview:whiteView];
        
        [AppMainWindow addSubview:tipsView];
    }
}

+ (void)showTipsAlertViewByTitle:(NSString *)title content:(NSAttributedString *)content buttonBGColor:(UIColor *)color sureTitle:(NSAttributedString *)sureTitle sureAction:(CommonCompletion)sureAction x:(CGFloat)x contentX:(CGFloat)contentX duration:(NSInteger)duration {
    YZTipsView *tipsView = [[YZTipsView alloc] initWithFrame:kWindowBounds];
    if(tipsView) {
        tipsView.tipsDuration = duration;
        tipsView.leftCompletion = sureAction;
        
        UIView *tanslucentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kWindowWidth, kWindowHeight)];
        [tanslucentView setBackgroundColor:kGrayCustomColor(0.0, 0.8)];
        
        CGFloat w = kWindowWidth - x*2.0;
        CGFloat contentW = w - contentX*2.0;
        CGFloat h = [SmartBWAuxiliaryMeansManager computeAttributedStringHeightWithString:content tvWidth:contentW] + 10.0;
        BOOL isTextView = YES;  
        CGFloat contentH = MAX(40.0, MIN(kScreen_Y(0.6), h));
        CGFloat whiteH = contentH + 45.0 + 100.0;
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(x, kScreen_Y(0.5) - whiteH*0.5, w, whiteH)];
        whiteView.backgroundColor = kWhiteColor;
        whiteView.layer.cornerRadius = 16.0;
        whiteView.layer.masksToBounds = YES;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, w, 45.0)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = SystemBoldFont(20);
        titleLab.textColor = kBlackColor;
        titleLab.text = title?:@"温馨提示";
        
        if (isTextView) {
            UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(contentX, titleLab.bottom, contentW, contentH)];
            contentTextView.backgroundColor = kClearColor; //设置背景色
            contentTextView.scrollEnabled = YES;    //设置当文字超过视图的边框时是否允许滑动，默认为“YES”
            contentTextView.editable = NO;        //设置是否允许编辑内容，默认为“YES”
            contentTextView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
            contentTextView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
            contentTextView.attributedText = content;
            [whiteView addSubview:contentTextView];
        }
        else {
            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(contentX, titleLab.bottom, contentW, contentH)];
            contentLab.textAlignment = NSTextAlignmentLeft;
            contentLab.font = SystemFont(17);
            contentLab.textColor = kBlackColor;
            contentLab.attributedText = content;
            contentLab.numberOfLines = 0;
            [whiteView addSubview:contentLab];
        }
        
        if(duration > 0) {
            kWeakConfig(tipsView);
            tipsView.tipsTimer = [NSTimer safeScheduledTimerWithTimeInterval:1 block:^{
                [weaktipsView updateSureButtonContent];
            } repeats:YES];
            tipsView.sureButtonTitle = sureTitle;
            tipsView.sureButtonBGColor = color;
            tipsView.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(w*0.5 - 120.0, titleLab.bottom + contentH + 30.0, 240.0, 40.0)];
            tipsView.sureButton.backgroundColor = kGrayColorByAlph(235);
            tipsView.sureButton.layer.cornerRadius = 20.0;
            tipsView.sureButton.layer.masksToBounds = YES;
            [tipsView.sureButton addTarget:weaktipsView action:@selector(sureButtonResponse) forControlEvents:UIControlEventTouchUpInside];
            [tipsView.sureButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSStringFormat(@"%lds",duration) attributes:@{NSFontAttributeName:SystemBoldFont(16),NSForegroundColorAttributeName:kColorByHexString(@"#999999")}] forState:UIControlStateNormal];
            tipsView.sureButton.userInteractionEnabled = duration <= 0;
            
            [whiteView addSubview:tipsView.sureButton];
        }
        else {
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(w*0.5 - 120.0, titleLab.bottom + contentH + 30.0, 240.0, 40.0)];
            sureButton.backgroundColor = color;
            sureButton.layer.cornerRadius = 20.0;
            sureButton.layer.masksToBounds = YES;
            [sureButton addTarget:tipsView action:@selector(sureButtonResponse) forControlEvents:UIControlEventTouchUpInside];
            [sureButton setAttributedTitle:sureTitle forState:UIControlStateNormal];
            
            [whiteView addSubview:sureButton];
        }
        
        [whiteView addSubview:titleLab];
        
        [tipsView addSubview:tanslucentView];
        [tipsView addSubview:whiteView];
        
        [AppMainWindow addSubview:tipsView];
        if(duration > 0) {
            [tipsView startTimer];
        }
        [SmartBWCacheManager sharedCacheTool].tipsView = tipsView;
    }
}

+ (void)showTipsAlertViewByTitle:(NSString *)title content:(NSAttributedString *)content buttonBGColor:(UIColor *)color sureTitle:(NSAttributedString *)sureTitle sureAction:(CommonCompletion)sureAction x:(CGFloat)x contentX:(CGFloat)contentX duration:(NSInteger)duration textAlignment:(NSTextAlignment)textAlignment {
    YZTipsView *tipsView = [[YZTipsView alloc] initWithFrame:kWindowBounds];
    if(tipsView) {
        tipsView.tipsDuration = duration;
        tipsView.leftCompletion = sureAction;
        
        UIView *tanslucentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kWindowWidth, kWindowHeight)];
        [tanslucentView setBackgroundColor:kGrayCustomColor(0.0, 0.8)];
        
        CGFloat w = kWindowWidth - x*2.0;
        CGFloat contentW = w - contentX*2.0;
        CGFloat h = [SmartBWAuxiliaryMeansManager computeAttributedStringHeightWithString:content tvWidth:contentW];
        BOOL isTextView = h > kScreen_Y(0.5);
        CGFloat contentH = MAX(70.0, MIN(kScreen_Y(0.6), h));
        CGFloat whiteH = contentH + 45.0 + 100.0;
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(x, kScreen_Y(0.5) - whiteH*0.5, w, whiteH)];
        whiteView.backgroundColor = kWhiteColor;
        whiteView.layer.cornerRadius = 16.0;
        whiteView.layer.masksToBounds = YES;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, w, 45.0)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = SystemBoldFont(20);
        titleLab.textColor = kBlackColor;
        titleLab.text = title?:@"温馨提示";
        
        if (isTextView) {
            UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(contentX, titleLab.bottom, contentW, contentH)];
            contentTextView.backgroundColor = kClearColor; //设置背景色
            contentTextView.scrollEnabled = YES;    //设置当文字超过视图的边框时是否允许滑动，默认为“YES”
            contentTextView.editable = NO;        //设置是否允许编辑内容，默认为“YES”
            contentTextView.layer.masksToBounds = YES;
            contentTextView.textAlignment = textAlignment; //文本显示的位置默认为居左
            contentTextView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
            contentTextView.attributedText = content;
            [whiteView addSubview:contentTextView];
        }
        else {
            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(contentX, titleLab.bottom, contentW, contentH)];
            contentLab.textAlignment = textAlignment;
            contentLab.font = SystemFont(17);
            contentLab.textColor = kBlackColor;
            contentLab.attributedText = content;
            contentLab.numberOfLines = 0;
            [whiteView addSubview:contentLab];
        }
        
        if(duration > 0) {
            kWeakConfig(tipsView);
            tipsView.tipsTimer = [NSTimer safeScheduledTimerWithTimeInterval:1 block:^{
                [weaktipsView updateSureButtonContent];
            } repeats:YES];
            tipsView.sureButtonTitle = sureTitle;
            tipsView.sureButtonBGColor = color;
            tipsView.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(w*0.5 - 120.0, titleLab.bottom + contentH + 30.0, 240.0, 40.0)];
            tipsView.sureButton.backgroundColor = kGrayColorByAlph(235);
            tipsView.sureButton.layer.cornerRadius = 20.0;
            tipsView.sureButton.layer.masksToBounds = YES;
            [tipsView.sureButton addTarget:tipsView action:@selector(sureButtonResponse) forControlEvents:UIControlEventTouchUpInside];
            [tipsView.sureButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSStringFormat(@"%lds",duration) attributes:@{NSFontAttributeName:SystemBoldFont(16),NSForegroundColorAttributeName:kColorByHexString(@"#999999")}] forState:UIControlStateNormal];
            tipsView.sureButton.userInteractionEnabled = duration <= 0;
            
            [whiteView addSubview:tipsView.sureButton];
        }
        else {
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(w*0.5 - 120.0, titleLab.bottom + contentH + 30.0, 240.0, 40.0)];
            sureButton.backgroundColor = color;
            sureButton.layer.cornerRadius = 20.0;
            sureButton.layer.masksToBounds = YES;
            [sureButton addTarget:tipsView action:@selector(sureButtonResponse) forControlEvents:UIControlEventTouchUpInside];
            [sureButton setAttributedTitle:sureTitle forState:UIControlStateNormal];
            
            [whiteView addSubview:sureButton];
        }
        
        [whiteView addSubview:titleLab];
        
        [tipsView addSubview:tanslucentView];
        [tipsView addSubview:whiteView];
        
        [AppMainWindow addSubview:tipsView];
        if(duration > 0) {
            [tipsView startTimer];
        }
        [SmartBWCacheManager sharedCacheTool].tipsView = tipsView;
    }
}


+ (void)showImageTipsAlertViewByTopImage:(NSString *)topImageNmae title:(NSString *)title content:(NSAttributedString *)content buttonBGColor:(UIColor *)color sureTitle:(NSAttributedString *)sureTitle sureAction:(CommonCompletion)sureAction cancelBGColor:(UIColor *)cancelcolor cancelTitle:(NSAttributedString *)cancelTitle cancelAction:(CommonCompletion)cancelAction {
    YZTipsView *tipsView = [[YZTipsView alloc] initWithFrame:kWindowBounds];
    if(tipsView) {
        kWeakConfig(tipsView);
        tipsView.tipsDuration = 0;
        tipsView.leftCompletion = sureAction;
        tipsView.rightCompletion = cancelAction;
        
        UIView *tanslucentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kWindowWidth, kWindowHeight)];
        [tanslucentView setBackgroundColor:kGrayCustomColor(0.0, 0.8)];
        
        CGFloat w = 320.0;
        CGFloat contentW = w - 32.0;
        CGFloat ivH = w*80.0/300.0;
        CGFloat h = [SmartBWAuxiliaryMeansManager computeAttributedStringHeightWithString:content tvWidth:contentW];
        BOOL isTextView = h > kScreen_Y(0.5);
        CGFloat contentH = MAX(70.0, MIN(kScreen_Y(0.6), h));
        CGFloat whiteH = contentH + ivH + 150.0;
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_X(0.5) - w*0.5, kScreen_Y(0.5) - whiteH*0.5, w, whiteH)];
        whiteView.backgroundColor = kWhiteColor;
        whiteView.layer.cornerRadius = 16.0;
        whiteView.layer.masksToBounds = YES;
        
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, ivH)];
        topImageView.contentMode = UIViewContentModeScaleAspectFit;
        topImageView.image = ImageByName(topImageNmae);
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, topImageView.bottom, w, 36.0)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = SystemBoldFont(20);
        titleLab.textColor = kBlackColor;
        titleLab.text = title?:@"温馨提示";
        
        if (isTextView) {
            UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(16.0, titleLab.bottom, contentW, contentH)];
            contentTextView.backgroundColor = kClearColor; //设置背景色
            contentTextView.scrollEnabled = YES;    //设置当文字超过视图的边框时是否允许滑动，默认为“YES”
            contentTextView.editable = NO;        //设置是否允许编辑内容，默认为“YES”
            contentTextView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
            contentTextView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
            contentTextView.attributedText = content;
            [whiteView addSubview:contentTextView];
        }
        else {
            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(16.0, titleLab.bottom, contentW, contentH)];
            contentLab.textAlignment = NSTextAlignmentLeft;
            contentLab.font = SystemFont(17);
            contentLab.textColor = kBlackColor;
            contentLab.attributedText = content;
            contentLab.numberOfLines = 0;
            [whiteView addSubview:contentLab];
        }
        
        UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(w*0.5 - 120.0, titleLab.bottom + contentH + 10.0, 240.0, 40.0)];
        sureButton.backgroundColor = color;
        sureButton.layer.cornerRadius = 20.0;
        sureButton.layer.masksToBounds = YES;
        [sureButton addTarget:weaktipsView action:@selector(sureButtonResponse) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setAttributedTitle:sureTitle forState:UIControlStateNormal];
        
        UIButton *canccelButton = [[UIButton alloc] initWithFrame:CGRectMake(w*0.5 - 120.0, sureButton.bottom + 16.0, 240.0, 40.0)];
        canccelButton.backgroundColor = cancelcolor;
        canccelButton.layer.cornerRadius = 20.0;
        canccelButton.layer.masksToBounds = YES;
        [canccelButton addTarget:weaktipsView action:@selector(cancelButtonResponse) forControlEvents:UIControlEventTouchUpInside];
        [canccelButton setAttributedTitle:cancelTitle forState:UIControlStateNormal];
        
        
        [whiteView addSubview:topImageView];
        [whiteView addSubview:titleLab];
        [whiteView addSubview:sureButton];
        [whiteView addSubview:canccelButton];
    
        [tipsView addSubview:tanslucentView];
        [tipsView addSubview:whiteView];
        
        [AppMainWindow addSubview:tipsView];
        [SmartBWCacheManager sharedCacheTool].tipsView = tipsView;
    }
}

- (void)leftButtonResponse {
    [self removeFromSuperview];
    !self.leftCompletion?:self.leftCompletion();
}

- (void)rightButtonResponse {
    [self removeFromSuperview];
    !self.rightCompletion?:self.rightCompletion();
}

- (void)sureButtonResponse {
    [self removeFromSuperview];
    !self.leftCompletion?:self.leftCompletion();
}

- (void)cancelButtonResponse {
    [self removeFromSuperview];
    !self.rightCompletion?:self.rightCompletion();
}

- (void)updateSureButtonContent {
    self.sureButton.userInteractionEnabled = self.tipsDuration <= 0;
    if(self.tipsDuration > 0) {
        [self.sureButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSStringFormat(@"%lds",self.tipsDuration) attributes:@{NSFontAttributeName:SystemBoldFont(16),NSForegroundColorAttributeName:kColorByHexString(@"#999999")}] forState:UIControlStateNormal];
    }
    else {
        self.sureButton.backgroundColor = self.sureButtonBGColor;
        [self.sureButton setAttributedTitle:self.sureButtonTitle forState:UIControlStateNormal];
        [self.tipsTimer invalidate];
    }
    self.tipsDuration--;
}

- (void)stopTimer {
    if(_tipsTimer) {
        [self.tipsTimer invalidate];
    }
}

- (void)startTimer {
    if(_tipsTimer) {
        [self.tipsTimer fire];
    }
}

@end
