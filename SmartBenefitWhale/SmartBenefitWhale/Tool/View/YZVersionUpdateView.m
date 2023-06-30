//
//  YZVersionUpdateView.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/23.
//

#import "YZVersionUpdateView.h"

@interface YZVersionUpdateView ()

@property (nonatomic,strong) UIView                                         *updateContentView;
@property (nonatomic,strong) NSString                                       *updateContent;
@property (nonatomic,strong) NSString                                       *updateURL;
@property (nonatomic,assign) BOOL                                           isMustUpdate;

@property (nonatomic,copy) UpdateCompletion                                 completion;

@end

@implementation YZVersionUpdateView

- (instancetype)initWithContent:(NSString *)contentstr updateSource:(NSString *)updatesource isMustUpdate:(BOOL)isMust completion:(UpdateCompletion)completion {
    if(self = [super initWithFrame:kWindowBounds]) {
        _updateContent = contentstr;
        _isMustUpdate = isMust;
        _updateURL = updatesource;
        _completion = completion;
        self.backgroundColor = kClearColor;
        [self addSubview:[UIView translucentViewWithFrame:kWindowBounds alpha:0.8 white:0]];
        [self addSubview:self.updateContentView];
    }
    return self;
}

- (void)updateVersonResponse {
    [SmartBWAuxiliaryMeansManager openByApplication:self.updateURL];
}

- (void)cancelResponse {
    !self.completion?:self.completion();
}

- (void)show {
    [AppMainWindow addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
- (UIView *)updateContentView {
    if(!_updateContentView) {
        _updateContentView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_X(0.5) - 130.0, 0.0, 260.0, 100.0)];
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260.0, 126.0)];
        topImageView.contentMode = UIViewContentModeScaleAspectFit;
        topImageView.image = ImageByName(@"wd_sj_img");
        
        
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, topImageView.bottom, 260.0, 40.0)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.attributedText = [[NSAttributedString alloc] initWithString:@"发现新版本" attributes:@{NSFontAttributeName:SystemBoldFont(18),NSFontAttributeName:kBlackColor}];
        
        NSMutableAttributedString *contentastr = [[NSMutableAttributedString alloc] initWithString:kStringTransform(self.updateContent) attributes:@{NSFontAttributeName:SystemFont(14),NSFontAttributeName:kGrayColorByAlph(102)}];
        NSMutableParagraphStyle *paragraph =  [NSMutableParagraphStyle new];
        //a、行间距(lineSpacing)
        paragraph.lineSpacing = 6;
        //b、段落间距(paragraphSpacing)
        paragraph.paragraphSpacing = 6;
        //c、对齐方式(alignment)
        paragraph.alignment = NSTextAlignmentLeft;
        //添加段落设置
        [contentastr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0,contentastr.length)];
        
        CGFloat h = [SmartBWAuxiliaryMeansManager computeAttributedStringHeightWithString:contentastr tvWidth:240.0];
        
        UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, titleLab.bottom, 240.0, MIN(kScreen_Y(0.5), MAX(40.0, h)))];
        contentTextView.backgroundColor = kClearColor; //设置背景色
        contentTextView.scrollEnabled = YES;    //设置当文字超过视图的边框时是否允许滑动，默认为“YES”
        contentTextView.editable = NO;        //设置是否允许编辑内容，默认为“YES”
        contentTextView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
        contentTextView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
        contentTextView.attributedText = contentastr;
        
        UIButton *updateButton = [[UIButton alloc] initWithFrame:CGRectMake(30.0, contentTextView.bottom + 30.0, 200.0, 40.0)];
        [updateButton addTarget:self action:@selector(updateVersonResponse) forControlEvents:UIControlEventTouchUpInside];
        [updateButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"立即升级" attributes:@{NSFontAttributeName:SystemBoldFont(16),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
        updateButton.backgroundColor = kRedColor;
        updateButton.layer.cornerRadius = 20.0;
        updateButton.layer.masksToBounds = YES;
        _updateContentView.height = updateButton.bottom + 70.0 - 40.0*self.isMustUpdate;
        _updateContentView.top = kScreen_Y(0.5) - _updateContentView.middleHeight;
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 32.0, 260.0, _updateContentView.height - 32.0)];
        whiteView.backgroundColor = kWhiteColor;
        whiteView.layer.cornerRadius = 10.0;
        whiteView.layer.masksToBounds = YES;
        
        [_updateContentView addSubview:whiteView];
        [_updateContentView addSubview:topImageView];
        [_updateContentView addSubview:titleLab];
        [_updateContentView addSubview:contentTextView];
        [_updateContentView addSubview:updateButton];
        
        if(!self.isMustUpdate) {
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(30.0, updateButton.bottom + 0.0, 200.0, 40.0)];
            [cancelButton addTarget:self action:@selector(cancelResponse) forControlEvents:UIControlEventTouchUpInside];
            [cancelButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"暂不升级" attributes:@{NSFontAttributeName:SystemFont(15),NSForegroundColorAttributeName:kGrayColor}] forState:UIControlStateNormal];
            
            [_updateContentView addSubview:cancelButton];
        }
    }
    return _updateContentView;
}

@end
