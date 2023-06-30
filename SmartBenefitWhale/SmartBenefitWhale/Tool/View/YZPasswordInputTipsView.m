//
//  YZPasswordInputTipsView.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/11.
//

#import "YZPasswordInputTipsView.h"

#define TipsWidth                                   340

@interface YZPasswordInputTipsView ()
<
    UITextFieldDelegate,
    KeyTputTextFiledDelegate
>

@property (nonatomic,strong) UIView                                                     *tipsView;
@property (nonatomic,strong) UILabel                                                    *titleLab;
@property (nonatomic,strong) UILabel                                                    *tipsLab;
@property (nonatomic,strong) UILabel                                                    *detailLab;

@property (nonatomic,strong) YZDeleteNotificationTextFiled                              *pwdIndexFirstTF;
@property (nonatomic,strong) YZDeleteNotificationTextFiled                              *pwdIndexSubTF;
@property (nonatomic,strong) YZDeleteNotificationTextFiled                              *pwdIndexThirdTF;
@property (nonatomic,strong) YZDeleteNotificationTextFiled                              *pwdIndexFourTF;
@property (nonatomic,strong) YZDeleteNotificationTextFiled                              *pwdIndexFiveTF;
@property (nonatomic,strong) YZDeleteNotificationTextFiled                              *pwdIndexLastTF;

@property (nonatomic,copy) TipsPasswordInputCompletion                                  completion;
@property (nonatomic,strong) NSString                                                   *passwordStr;
@property (nonatomic,strong) NSMutableArray                                             *tfs;

@property (nonatomic,assign) CGFloat                                                    popBottom;
@property (nonatomic,assign) NSInteger                                                  tfIndex;
@property (nonatomic,assign) BOOL                                                       isDelete;
@property (nonatomic,assign) BOOL                                                       isForbiddenTouchDismiss;

@end

@implementation YZPasswordInputTipsView

- (instancetype)initWithTitle:(NSAttributedString *)title content:(NSAttributedString *)content detail:(NSAttributedString *)detail completion:(TipsPasswordInputCompletion)completion {
    if(self = [super initWithFrame:kWindowBounds]) {
        _completion = completion;
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:kWindowBounds];
        cancelButton.backgroundColor = kGrayCustomColor(0, 0.8);
        [cancelButton addTarget:self action:@selector(autoDismiss) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleLab.attributedText = title;
        self.tipsLab.attributedText = content;
        self.detailLab.attributedText = detail;
        
        [self addSubview:cancelButton];
        [self addSubview:self.tipsView];
    }
    return self;
}

- (void)show {
    [self addKeyBoardNotifications];
    kWeakConfig(self);
    [SmartBWAuxiliaryMeansManager mainThreadComposeCompletion:^{
        [AppMainWindow addSubview:weakself];
        weakself.tfIndex = 0;
        [weakself.pwdIndexFirstTF becomeFirstResponder];
    }];
}

- (void)dismiss {
    [self endEditing:YES];
    [self releaseKeyboardNotifications];
    [self removeFromSuperview];
}

- (void)forbiddenTouchDismiss {
//    self.isForbiddenTouchDismiss = YES;
}

- (void)finishInput {
    [self dismiss];
    self.passwordStr = NSStringFormat(@"%@%@%@%@%@%@",self.pwdIndexFirstTF.text,self.pwdIndexSubTF.text,self.pwdIndexThirdTF.text,self.pwdIndexFourTF.text,self.pwdIndexFiveTF.text,self.pwdIndexLastTF.text);
    [self composeCompletionByStatus:YES];
}

- (void)autoDismiss {
    if(self.isForbiddenTouchDismiss) {
        return;
    }
    [self dismiss];
    [self composeCompletionByStatus:NO];
}

- (void)composeCompletionByStatus:(BOOL)isFinish {
    if(isFinish) {
        !self.completion?:self.completion(self.passwordStr);
    }
    else {
        !self.completion?:self.completion(@"");
    }
}

#pragma mark ----------------------------------------- KeyBoard Notification Methods -----------------------------------------
/// 添加键盘事件监听
- (void)addKeyBoardNotifications {
    [AppNotificationCenter addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [AppNotificationCenter addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
}

/// 移除键盘事件监听
- (void)releaseKeyboardNotifications {
    [AppNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [AppNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/// 键盘事件监听通知
/// @param notification 通知
- (void)keyboardNotification:(NSNotification *)notification {
    BOOL isShow = notification.name == UIKeyboardWillShowNotification;
    //获取键盘弹起时的动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //获取键盘弹起时的动画选项
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    kWeakConfig(self);
    if (isShow) {
        //获取键盘弹起后的 frame
        CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat dta = keyboardFrame.origin.y - self.popBottom;
        if (dta < 0) {
            [UIView animateWithDuration:duration delay:0 options:option animations:^{
                weakself.tipsView.top += dta;
            } completion:nil];
            [self layoutIfNeeded];
        }
    }
    else {
        if (self.tipsView.top != (kScreen_Y(0.5) - self.tipsView.middleHeight)) {
            [UIView animateWithDuration:duration delay:0 options:option animations:^{
                weakself.tipsView.top = (kScreen_Y(0.5) - weakself.tipsView.middleHeight);
            } completion:nil];
            [self layoutIfNeeded];
        }
    }
}

#pragma mark ------------------------------------------------ UITextFiled Delegate Method  ------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.popBottom = self.tipsView.bottom;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = textField.text;
    if (str.length == 0 && string.length == 6) {
        [self composeCodeInputByCode:string];
        return NO;
    }
    str = [str stringByReplacingCharactersInRange:range withString:string];
    return (textField.text.length == 0 || str.length == 0);
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if(textField.text > 0 && !self.isDelete) {
        if(self.tfIndex < (self.tfs.count - 1)) {
            self.tfIndex++;
            [((UITextField *)self.tfs[self.tfIndex]) becomeFirstResponder];
        }
        else {
            [self finishInput];
        }
    }
    else if (self.isDelete) {
        self.isDelete = NO;
    }
}

- (void)deleteBackward:(UITextField *)textField {
    if(self.tfIndex > 0) {
        self.tfIndex--;
        self.isDelete = YES;
        ((UITextField *)self.tfs[self.tfIndex]).text = @"";
        [((UITextField *)self.tfs[self.tfIndex]) becomeFirstResponder];
    }
}

- (void)composeCodeInputByCode:(NSString *)code {
    [self endEditing:YES];
    [self.tfs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *tf = (UITextField *)obj;
        tf.text = [code substringWithRange:NSMakeRange(idx, 1)];
    }];
    [self finishInput];
}

#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
- (UIView *)tipsView {
    if(!_tipsView) {
        _tipsView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_X(0.5) - 170.0, kScreen_Y(0.5) - 123.0, TipsWidth, 246.0)];
        _tipsView.backgroundColor = kWhiteColor;
        _tipsView.layer.cornerRadius = 10.0;
        _tipsView.layer.masksToBounds = YES;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16.0, 155.0, TipsWidth - 32.0, 1.0)];
        line.backgroundColor = kColorByHexString(@"#DDDDDD");
        
        [_tipsView addSubview:self.titleLab];
        [_tipsView addSubview:self.tipsLab];
        [_tipsView addSubview:self.detailLab];
        [_tipsView addSubview:line];
        [_tipsView addSubview:self.pwdIndexFirstTF];
        [_tipsView addSubview:self.pwdIndexSubTF];
        [_tipsView addSubview:self.pwdIndexThirdTF];
        [_tipsView addSubview:self.pwdIndexFourTF];
        [_tipsView addSubview:self.pwdIndexFiveTF];
        [_tipsView addSubview:self.pwdIndexLastTF];
        
        [_tipsView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0.0, 175.0, TipsWidth, 46.0)]];
    }
    return _tipsView;
}

- (UILabel *)titleLab {
    if(!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16.0, 0.0, TipsWidth - 32.0, 40.0)];
        _titleLab.adjustsFontSizeToFitWidth = YES;
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)tipsLab {
    if(!_tipsLab) {
        _tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(16.0, self.titleLab.bottom, TipsWidth - 32.0, 50.0)];
        _tipsLab.adjustsFontSizeToFitWidth = YES;
        _tipsLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLab;
}

- (UILabel *)detailLab {
    if(!_detailLab) {
        _detailLab = [[UILabel alloc] initWithFrame:CGRectMake(16.0, self.tipsLab.bottom, TipsWidth - 32.0, 50.0)];
        _detailLab.adjustsFontSizeToFitWidth = YES;
        _detailLab.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLab;
}

- (UITextField *)pwdIndexFirstTF {
    if(!_pwdIndexFirstTF) {
        _pwdIndexFirstTF = [[YZDeleteNotificationTextFiled alloc] initWithFrame:CGRectMake(30.0, 178.0, 40.0, 40.0)];
        _pwdIndexFirstTF.delegate = self;
        _pwdIndexFirstTF.keyInputDelegate = self;
        _pwdIndexFirstTF.keyboardType = UIKeyboardTypeNumberPad;
        _pwdIndexFirstTF.textColor = kBlackColor;
        _pwdIndexFirstTF.font = SystemFont(18);
        _pwdIndexFirstTF.backgroundColor = kGrayColorByAlph(235);
        _pwdIndexFirstTF.textAlignment = NSTextAlignmentCenter;
        _pwdIndexFirstTF.layer.cornerRadius = 10.0;
        _pwdIndexFirstTF.layer.masksToBounds = YES;
        _pwdIndexFirstTF.tag = 2023031400;
    }
    return _pwdIndexFirstTF;
}

- (UITextField *)pwdIndexSubTF {
    if(!_pwdIndexSubTF) {
        _pwdIndexSubTF = [[YZDeleteNotificationTextFiled alloc] initWithFrame:CGRectMake(self.pwdIndexFirstTF.right + 10.0, self.pwdIndexFirstTF.top, 40.0, 40.0)];
        _pwdIndexSubTF.delegate = self;
        _pwdIndexSubTF.keyInputDelegate = self;
        _pwdIndexSubTF.keyboardType = UIKeyboardTypeNumberPad;
        _pwdIndexSubTF.textColor = kBlackColor;
        _pwdIndexSubTF.font = SystemFont(18);
        _pwdIndexSubTF.backgroundColor = kGrayColorByAlph(235);
        _pwdIndexSubTF.textAlignment = NSTextAlignmentCenter;
        _pwdIndexSubTF.layer.cornerRadius = 10.0;
        _pwdIndexSubTF.layer.masksToBounds = YES;
        _pwdIndexSubTF.tag = 2023031401;
    }
    return _pwdIndexSubTF;
}

- (UITextField *)pwdIndexThirdTF {
    if(!_pwdIndexThirdTF) {
        _pwdIndexThirdTF = [[YZDeleteNotificationTextFiled alloc] initWithFrame:CGRectMake(self.pwdIndexSubTF.right + 10.0, self.pwdIndexFirstTF.top, 40.0, 40.0)];
        _pwdIndexThirdTF.delegate = self;
        _pwdIndexThirdTF.keyInputDelegate = self;
        _pwdIndexThirdTF.keyboardType = UIKeyboardTypeNumberPad;
        _pwdIndexThirdTF.textColor = kBlackColor;
        _pwdIndexThirdTF.font = SystemFont(18);
        _pwdIndexThirdTF.backgroundColor = kGrayColorByAlph(235);
        _pwdIndexThirdTF.textAlignment = NSTextAlignmentCenter;
        _pwdIndexThirdTF.layer.cornerRadius = 10.0;
        _pwdIndexThirdTF.layer.masksToBounds = YES;
        _pwdIndexThirdTF.tag = 2023031402;
    }
    return _pwdIndexThirdTF;
}

- (UITextField *)pwdIndexFourTF {
    if(!_pwdIndexFourTF) {
        _pwdIndexFourTF = [[YZDeleteNotificationTextFiled alloc] initWithFrame:CGRectMake(self.pwdIndexThirdTF.right + 10.0, self.pwdIndexFirstTF.top, 40.0, 40.0)];
        _pwdIndexFourTF.delegate = self;
        _pwdIndexFourTF.keyInputDelegate = self;
        _pwdIndexFourTF.keyboardType = UIKeyboardTypeNumberPad;
        _pwdIndexFourTF.textColor = kBlackColor;
        _pwdIndexFourTF.font = SystemFont(18);
        _pwdIndexFourTF.backgroundColor = kGrayColorByAlph(235);
        _pwdIndexFourTF.textAlignment = NSTextAlignmentCenter;
        _pwdIndexFourTF.layer.cornerRadius = 10.0;
        _pwdIndexFourTF.layer.masksToBounds = YES;
        _pwdIndexFourTF.tag = 2023031403;
    }
    return _pwdIndexFourTF;
}

- (UITextField *)pwdIndexFiveTF{
    if(!_pwdIndexFiveTF) {
        _pwdIndexFiveTF = [[YZDeleteNotificationTextFiled alloc] initWithFrame:CGRectMake(self.pwdIndexFourTF.right + 10.0, self.pwdIndexFirstTF.top, 40.0, 40.0)];
        _pwdIndexFiveTF.delegate = self;
        _pwdIndexFiveTF.keyInputDelegate = self;
        _pwdIndexFiveTF.keyboardType = UIKeyboardTypeNumberPad;
        _pwdIndexFiveTF.textColor = kBlackColor;
        _pwdIndexFiveTF.font = SystemFont(18);
        _pwdIndexFiveTF.backgroundColor = kGrayColorByAlph(235);
        _pwdIndexFiveTF.textAlignment = NSTextAlignmentCenter;
        _pwdIndexFiveTF.layer.cornerRadius = 10.0;
        _pwdIndexFiveTF.layer.masksToBounds = YES;
        _pwdIndexFiveTF.tag = 2023031404;
    }
    return _pwdIndexFiveTF;
}

- (UITextField *)pwdIndexLastTF {
    if(!_pwdIndexLastTF) {
        _pwdIndexLastTF = [[YZDeleteNotificationTextFiled alloc] initWithFrame:CGRectMake(self.pwdIndexFiveTF.right + 10.0, self.pwdIndexFirstTF.top, 40.0, 40.0)];
        _pwdIndexLastTF.delegate = self;
        _pwdIndexLastTF.keyInputDelegate = self;
        _pwdIndexLastTF.keyboardType = UIKeyboardTypeNumberPad;
        _pwdIndexLastTF.textColor = kBlackColor;
        _pwdIndexLastTF.font = SystemFont(18);
        _pwdIndexLastTF.backgroundColor = kGrayColorByAlph(235);
        _pwdIndexLastTF.textAlignment = NSTextAlignmentCenter;
        _pwdIndexLastTF.layer.cornerRadius = 10.0;
        _pwdIndexLastTF.layer.masksToBounds = YES;
        _pwdIndexLastTF.tag = 2023031405;
    }
    return _pwdIndexLastTF;
}

#pragma mark **************************************************** Resource Lazy Load Method ****************************************************
- (NSMutableArray *)tfs {
    if(!_tfs) {
        kWeakConfig(self);
        _tfs = [NSMutableArray arrayWithObjects:weakself.pwdIndexFirstTF,weakself.pwdIndexSubTF,weakself.pwdIndexThirdTF,weakself.pwdIndexFourTF,weakself.pwdIndexFiveTF,weakself.pwdIndexLastTF, nil];
    }
    return _tfs;
}

@end
