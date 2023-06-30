//
//  YZSearchView.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/23.
//

#import "YZSearchView.h"

@interface YZSearchView ()
<
    UITextFieldDelegate
>

@property (nonatomic,strong) UIImageView                                                        *markImageView;
@property (nonatomic,strong) UITextField                                                        *searchContentTF;

@property (nonatomic,copy) SearchContentCompletion                                              searchCompletion;
@property (nonatomic,strong) NSString                                                           *searchMark;
@property (nonatomic,strong) NSAttributedString                                                 *placeholder;
@property (nonatomic,assign) CGSize                                                             viewSize;

@end

@implementation YZSearchView

- (instancetype)initWithFrame:(CGRect)frame searchMark:(NSString *)mark placeHolder:(NSAttributedString *)placeholder searchCompletion:(SearchContentCompletion)completion {
    if (self = [super initWithFrame:frame]) {
        self.viewSize = frame.size;
        self.searchMark = mark;
        self.placeholder = placeholder;
        self.searchCompletion = completion;
        self.backgroundColor = kGrayColorByAlph(230);
        self.layer.cornerRadius = frame.size.height*0.5;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.markImageView];
        [self addSubview:self.searchContentTF];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame bgcolor:(UIColor*)color cornerRadius:(CGFloat)corner searchMark:(NSString *)mark placeHolder:(NSAttributedString *)placeholder searchCompletion:(SearchContentCompletion)completion {
    if (self = [super initWithFrame:frame]) {
        self.viewSize = frame.size;
        self.searchMark = mark;
        self.placeholder = placeholder;
        self.searchCompletion = completion;
        self.backgroundColor = color?:kGrayColorByAlph(230);
        self.layer.cornerRadius = corner;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.markImageView];
        [self addSubview:self.searchContentTF];
    }
    return self;
}


#pragma mark <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< UITextField Delegate Method  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self searchCompletionWithStatus:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchCompletionWithStatus:NO];
    return YES;
}

#pragma mark ----------------------------------------------------- Business event Method -----------------------------------------------------
- (void)searchCompletionWithStatus:(BOOL)isStart {
    !self.searchCompletion?:self.searchCompletion(kStringTransform(self.searchContentTF.text),isStart);
}

- (void)searchViewResignFirstResponder {
    [self.searchContentTF resignFirstResponder];
}

#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, self.viewSize.height)];
        _markImageView.contentMode = UIViewContentModeCenter;
        _markImageView.image = ImageByName((self.searchMark.length > 0?self.searchMark:@"main_search_mark"));
    }
    return _markImageView;
}

- (UITextField *)searchContentTF {
    if (!_searchContentTF) {
        _searchContentTF = [[UITextField alloc] initWithFrame:CGRectMake(self.markImageView.right, 0.0, self.viewSize.width - self.markImageView.right - self.viewSize.height*0.5, self.viewSize.height)];
        _searchContentTF.font = SystemFont(16);
        _searchContentTF.textColor = kBlackColor;
        _searchContentTF.delegate = self;
        _searchContentTF.keyboardType = UIKeyboardTypeDefault;
        _searchContentTF.returnKeyType = UIReturnKeySearch;
        _searchContentTF.attributedPlaceholder = self.placeholder;
    }
    return _searchContentTF;
}

@end
