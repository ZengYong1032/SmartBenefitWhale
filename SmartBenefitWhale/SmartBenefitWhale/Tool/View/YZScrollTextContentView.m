//
//  YZScrollTextContentView.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/23.
//

#import "YZScrollTextContentView.h"

@interface YZScrollTextContentView ()

@property (nonatomic,strong) UIImageView                                            *firstMarkImageView;
@property (nonatomic,strong) UILabel                                                *firstContentLab;

@property (nonatomic,strong) UIImageView                                            *nextMarkImageView;
@property (nonatomic,strong) UILabel                                                *nextContentLab;

@property (nonatomic,strong) NSArray                                                *list;
@property (nonatomic,strong) NSTimer                                                *scrollTimer;
@property (nonatomic,assign) NSInteger                                              duration;
@property (nonatomic,assign) CGSize                                                 viewSize;
@property (nonatomic,assign) NSInteger                                              index;
@property (nonatomic,assign) NSInteger                                              nextIndex;
@property (nonatomic,assign) YZTextContentType                                      type;
@property (nonatomic,assign) YZTextContentScrollDirection                           direction;
@property (nonatomic,assign) NSInteger                                              layoutmark;

@property (nonatomic,copy) YZTextContentScrollTouchCompletion                       completion;

@end

@implementation YZScrollTextContentView

- (instancetype)initWithFrame:(CGRect)frame direction:(YZTextContentScrollDirection)direction type:(YZTextContentType)type duration:(NSInteger)duration contents:(NSArray *)contents touchCompletion:(YZTextContentScrollTouchCompletion)completion {
    if(self = [super initWithFrame:frame]) {
        if(contents.count > 0) {
            self.layer.masksToBounds = YES;
            self.index = 0;
            self.nextIndex = MIN(1, (contents.count - 1));
            _list = [NSArray arrayWithArray:contents];
            _duration = duration;
            _viewSize = frame.size;
            _type = type;
            _completion = completion;
            
            switch (type) {
                case YZTextContentTypeCarryImage:{
                    [self addSubview:self.firstMarkImageView];
                    [self addSubview:self.nextMarkImageView];
                }
                    break;
                    
                case YZTextContentTypeFullCarryImage:{
                    [self addSubview:self.firstMarkImageView];
                    [self addSubview:self.nextMarkImageView];
                }
                    break;
                    
                case YZTextContentTypeWelfareCarryImage:{
                    [self addSubview:self.firstMarkImageView];
                    [self addSubview:self.nextMarkImageView];
                }
                    break;
                    
                default:
                    break;
            }
            [self addSubview:self.firstContentLab];
            [self addSubview:self.nextContentLab];
            [self startContentScroll];
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    !self.completion?:self.completion(self.list[self.index]);
}

- (void)stopContentScroll {
    if(_scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}

- (void)startContentScroll {
    if(!_scrollTimer) {
        [self.scrollTimer fire];
    }
}

- (void)updateScrollContent {
    kWeakConfig(self);
    [UIView animateWithDuration:0.8 animations:^{
        weakself.firstContentLab.top -= weakself.viewSize.height;
        weakself.nextContentLab.top -= weakself.viewSize.height;
        if(weakself.type == YZTextContentTypeCarryImage || YZTextContentTypeFullCarryImage) {
            weakself.firstMarkImageView.top -= weakself.viewSize.height;
            weakself.nextMarkImageView.top -= weakself.viewSize.height;
        }
    } completion:^(BOOL finished) {
        if(finished) {
            weakself.index = (weakself.index + 1)%weakself.list.count;
            weakself.nextIndex = (weakself.index + 1)%weakself.list.count;
            if(weakself.type == YZTextContentTypeFullCarryImage) {
                NSMutableParagraphStyle *paragraph =  [NSMutableParagraphStyle new];
                //a、行间距(lineSpacing)
                paragraph.lineSpacing = 6;
                //b、段落间距(paragraphSpacing)
                paragraph.paragraphSpacing = 0;
                //c、对齐方式(alignment)
                paragraph.alignment = NSTextAlignmentLeft;
                NSMutableAttributedString *astr = [SmartBWAuxiliaryMeansManager appendImgAtEndWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:NSStringFormat(@"%@充满了爱 ",kStringTransform(weakself.list[(weakself.index)][@"nickname"])) stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];//
                NSMutableAttributedString *astr0 = [SmartBWAuxiliaryMeansManager appendImgAtEndWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:@" " stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];
                NSMutableAttributedString *astr00 = [SmartBWAuxiliaryMeansManager appendImgAtHeadWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:NSStringFormat(@" \n为满座爱心善款总额增加了%@元",kStringTransform(weakself.list[(weakself.index)][@"money"])) stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];
                [astr appendAttributedString:astr0];
                [astr appendAttributedString:astr00];
                
                
                
                NSMutableAttributedString *astr1 = [SmartBWAuxiliaryMeansManager appendImgAtEndWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:NSStringFormat(@"%@充满了爱 ",kStringTransform(weakself.list[(weakself.nextIndex)][@"nickname"])) stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];//
                NSMutableAttributedString *astr10 = [SmartBWAuxiliaryMeansManager appendImgAtEndWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:@" " stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];
                NSMutableAttributedString *astr100 = [SmartBWAuxiliaryMeansManager appendImgAtHeadWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:NSStringFormat(@" \n为满座爱心善款总额增加了%@元",kStringTransform(weakself.list[(weakself.nextIndex)][@"money"])) stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];
                [astr1 appendAttributedString:astr10];
                [astr1 appendAttributedString:astr100];
                
                
                
                weakself.firstContentLab.attributedText = astr;
                weakself.nextContentLab.attributedText = astr1;
                
                [weakself.firstMarkImageView sd_setImageWithURL:kURL(weakself.list[(weakself.index)][@"avatar"]) placeholderImage:ImageByName(@"sy_znxx_logo")];
                [weakself.nextMarkImageView sd_setImageWithURL:kURL(weakself.list[(weakself.nextIndex)][@"avatar"]) placeholderImage:ImageByName(@"sy_znxx_logo")];
            }
            else {
                weakself.firstContentLab.text = kStringTransform(weakself.list[(weakself.index)][@"title"]);
                weakself.nextContentLab.text = kStringTransform(weakself.list[(weakself.nextIndex)][@"title"]);
            }
            
            weakself.firstContentLab.top += weakself.viewSize.height;
            weakself.nextContentLab.top += weakself.viewSize.height;
            if(weakself.type == YZTextContentTypeCarryImage || YZTextContentTypeFullCarryImage) {
                weakself.firstMarkImageView.top += weakself.viewSize.height;
                weakself.nextMarkImageView.top += weakself.viewSize.height;
            }
        }
    }];
}

#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
- (UIImageView *)firstMarkImageView {
    if(!_firstMarkImageView) {
        _firstMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, self.viewSize.height*0.5 - 10.0, 20.0, 20.0)];
        _firstMarkImageView.contentMode = UIViewContentModeScaleAspectFill;
        _firstMarkImageView.layer.cornerRadius = 10.0;
        _firstMarkImageView.layer.masksToBounds = YES;
        _firstMarkImageView.image = ImageByName(@"sy_znxx_logo");
    }
    return _firstMarkImageView;
}

- (UILabel *)firstContentLab {
    if(!_firstContentLab) {
        CGFloat x = MAX((_firstMarkImageView.right + 8.0), 14.0);
        _firstContentLab = [[UILabel alloc] initWithFrame:CGRectMake(x, 0.0, self.viewSize.width - x*2.0, self.viewSize.height)];
        _firstContentLab.textAlignment = NSTextAlignmentLeft;
        _firstContentLab.font = SystemFont(12);
        _firstContentLab.textColor = kBlackColor;
        _firstContentLab.layer.masksToBounds = YES;
        
        _firstContentLab.numberOfLines = 2;
        if(self.type == YZTextContentTypeFullCarryImage) {
            _firstContentLab.textColor = kWhiteColor;
            NSMutableParagraphStyle *paragraph =  [NSMutableParagraphStyle new];
            //a、行间距(lineSpacing)
            paragraph.lineSpacing = 6;
            //b、段落间距(paragraphSpacing)
            paragraph.paragraphSpacing = 0;
            //c、对齐方式(alignment)
            paragraph.alignment = NSTextAlignmentLeft;
            NSMutableAttributedString *astr = [SmartBWAuxiliaryMeansManager appendImgAtEndWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:NSStringFormat(@"%@充满了爱 ",kStringTransform(self.list[(self.index)][@"nickname"])) stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];//
            NSMutableAttributedString *astr0 = [SmartBWAuxiliaryMeansManager appendImgAtEndWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:@" " stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];
            NSMutableAttributedString *astr00 = [SmartBWAuxiliaryMeansManager appendImgAtHeadWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:NSStringFormat(@" \n为满座爱心善款总额增加了%@元",kStringTransform(self.list[(self.index)][@"money"])) stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];
            [astr appendAttributedString:astr0];
            [astr appendAttributedString:astr00];
            _firstContentLab.attributedText = astr;
        }
        else {
            _firstContentLab.text = kStringTransform(self.list[self.index][@"title"]);
        }
    }
    return _firstContentLab;
}

- (UIImageView *)nextMarkImageView {
    if(!_nextMarkImageView) {
        _nextMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, self.viewSize.height*1.5 - 10.0, 20.0, 20.0)];
        _nextMarkImageView.contentMode = UIViewContentModeScaleAspectFill;
        _nextMarkImageView.layer.cornerRadius = 10.0;
        _nextMarkImageView.layer.masksToBounds = YES;
        _nextMarkImageView.image = ImageByName(@"sy_znxx_logo");
    }
    return _nextMarkImageView;
}

- (UILabel *)nextContentLab {
    if(!_nextContentLab) {
        CGFloat x = MAX((_firstMarkImageView.right + 8.0), 14.0);
        _nextContentLab = [[UILabel alloc] initWithFrame:CGRectMake(x, self.viewSize.height, self.viewSize.width - x*2.0, self.viewSize.height)];
        _nextContentLab.textAlignment = NSTextAlignmentLeft;
        _nextContentLab.font = SystemFont(12);
        _nextContentLab.textColor = kBlackColor;
        _nextContentLab.numberOfLines = 2;
        _nextContentLab.layer.masksToBounds = YES;
        if(self.type == YZTextContentTypeFullCarryImage) {
            _nextContentLab.textColor = kWhiteColor;
            NSMutableParagraphStyle *paragraph =  [NSMutableParagraphStyle new];
            //a、行间距(lineSpacing)
            paragraph.lineSpacing = 6;
            //b、段落间距(paragraphSpacing)
            paragraph.paragraphSpacing = 0;
            //c、对齐方式(alignment)
            paragraph.alignment = NSTextAlignmentLeft;
            
            NSMutableAttributedString *astr1 = [SmartBWAuxiliaryMeansManager appendImgAtEndWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:NSStringFormat(@"%@充满了爱 ",kStringTransform(self.list[(self.nextIndex)][@"nickname"])) stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];//
            NSMutableAttributedString *astr10 = [SmartBWAuxiliaryMeansManager appendImgAtEndWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:@" " stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];
            NSMutableAttributedString *astr100 = [SmartBWAuxiliaryMeansManager appendImgAtHeadWithImgName:@"xax" imgrect:CGRectMake(0, 0, 13, 12) string:NSStringFormat(@" \n为满座爱心善款总额增加了%@元",kStringTransform(self.list[(self.nextIndex)][@"money"])) stringAttributes:@{NSParagraphStyleAttributeName:paragraph}];
            [astr1 appendAttributedString:astr10];
            [astr1 appendAttributedString:astr100];
            
            _nextContentLab.attributedText = astr1;
        }
        else {
            _nextContentLab.text = kStringTransform(self.list[(self.nextIndex)][@"title"]);
        }
    }
    return _nextContentLab;
}

- (NSTimer *)scrollTimer {
    if(!_scrollTimer) {
        kWeakConfig(self);
        _scrollTimer = [NSTimer safeScheduledTimerWithTimeInterval:self.duration block:^{
            [weakself updateScrollContent];
        } repeats:YES];
    }
    return _scrollTimer;
}

@end
