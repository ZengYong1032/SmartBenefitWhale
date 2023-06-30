//
//  SmartBWLogin_VC.m
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/13.
//

#import "SmartBWLogin_VC.h"

@interface SmartBWLogin_VC ()
<
    UITextFieldDelegate,
    UIScrollViewDelegate
>

@property (nonatomic,strong) UIView                                             *navigationViews;
@property (nonatomic,strong) UIImageView                                        *logoImageView;

@property (nonatomic,strong) UIScrollView                                       *basalScrollView;

@property (nonatomic,strong) UIView                                             *optionView;

@property (nonatomic,strong) UIView                                             *loginInputView;
@property (nonatomic,strong) UITextField                                        *phoneTF;
@property (nonatomic,strong) UITextField                                        *passwordTF;
@property (nonatomic,strong) UIButton                                           *securityButton;
@property (nonatomic,strong) UITextField                                        *codeTF;
@property (nonatomic,strong) UIButton                                           *codeButton;
@property (nonatomic,strong) UITextField                                        *inviteTF;

@property (nonatomic,strong) UIButton                                           *sureButton;

@property (nonatomic,strong) UILabel                                            *infoLab;

@property (nonatomic,assign) BOOL                                               isAgreed;
@property (nonatomic,assign) BOOL                                               isSecurity;
@property (nonatomic,assign) BOOL                                               isFirstLevel;

@property (nonatomic,strong) NSTimer                                            *codeTimer;
@property (nonatomic,assign) NSTimeInterval                                     refreshTime;

@property (nonatomic,assign) CGFloat                                            tfBottom;

@end

@implementation SmartBWLogin_VC

#pragma mark ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Life Cycle Method ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self addKeyBoardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self releaseKeyboardNotifications];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = kWhiteColor;
    [self.view addSubview:self.navigationViews];
    [self.view addSubview:self.basalScrollView];
    [self refreshSureButtonStatus];
}

#pragma mark ------------------------------------------------ Touch Delegate Method  ------------------------------------------------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignInputResponder];
}

#pragma mark ------------------------------------------------ UITextField Delegate Method  ------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.tfBottom = [textField convertPoint:CGPointMake(0, textField.height) toView:AppMainWindow].y + textField.height;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.codeTF) {
        if(self.enterType == SmartBWLoginContentTypeLoginByCode) {
            [self sureButtonResponse];
        }
        else if (self.enterType == SmartBWLoginContentTypeRegisterByCode) {
            [self.passwordTF becomeFirstResponder];
        }
    }
    else if (textField == self.passwordTF) {
        if(self.enterType == SmartBWLoginContentTypeLoginByPassword) {
            [self sureButtonResponse];
        }
        else if (self.enterType == SmartBWLoginContentTypeRegisterByCode) {
            [self.inviteTF becomeFirstResponder];
        }
        else if (self.enterType == SmartBWLoginContentTypePasswordForgot) {
            [self sureButtonResponse];
        }
    }
    else if (textField == self.inviteTF) {
        [self sureButtonResponse];
    }
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    [self refreshSureButtonStatus];
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
        CGFloat dta = keyboardFrame.origin.y - self.tfBottom;
        if (dta < 0) {
            [UIView animateWithDuration:duration delay:0 options:option animations:^{
                weakself.basalScrollView.top += dta;
            } completion:nil];
            [self.view layoutIfNeeded];
        }
    }
    else {
        if (self.basalScrollView.top < kStatusBarHeight) {
            [UIView animateWithDuration:duration delay:0 options:option animations:^{
                weakself.basalScrollView.top = kStatusBarHeight;
            } completion:nil];
            [self.view layoutIfNeeded];
        }
    }
}

#pragma mark **************************************************** Business Event Method ****************************************************
/// 切换响应
/// - Parameter sender: 2023022500
- (void)optionButtonResponse:(UIButton *)sender {
    NSInteger index = sender.tag - 2023022500;
    if(index != self.enterType) {
        self.enterType = (index + 1);
        BOOL isPwd = (self.enterType == SmartBWLoginContentTypeLoginByPassword);
        UIButton *leftButton = [self.optionView viewWithTag:2023022500];
        UIButton *rightButton = [self.optionView viewWithTag:2023022501];
        if(leftButton) {
            leftButton.backgroundColor = isPwd?kRedColor:kClearColor;
            [leftButton setAttributedTitle:(isPwd?[SmartBWAuxiliaryMeansManager appendImgAtHeadWithImgName:@"login_pwd_mark" imgrect:CGRectMake(0, 0, 20.0, 20.0) string:@"  密码登录" stringAttributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:SystemBoldFont(16)}]:[[NSAttributedString alloc] initWithString:@"密码登录" attributes:@{NSForegroundColorAttributeName:kColorByHexString(@"#666666"),NSFontAttributeName:SystemFont(16)}]) forState:UIControlStateNormal];
        }
        
        if(rightButton) {
            rightButton.backgroundColor = !isPwd?kRedColor:kClearColor;
            [rightButton setAttributedTitle:(!isPwd?[SmartBWAuxiliaryMeansManager appendImgAtHeadWithImgName:@"login_code_mark" imgrect:CGRectMake(0, 0, 20.0, 20.0) string:@"  验证码登录" stringAttributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:SystemBoldFont(16)}]:[[NSAttributedString alloc] initWithString:@"验证码登录" attributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:SystemFont(16)}]) forState:UIControlStateNormal];
        }
        
        [self refreshViews];
    }
}

/// 协议阅读响应
/// - Parameter sender: <#sender description#>
- (void)agreeButtonResponse:(UIButton *)sender {
    self.isAgreed = !self.isAgreed;
    [sender setImage:ImageByName(NSStringFormat(@"agree_%d_mark",self.isAgreed*1)) forState:UIControlStateNormal];
    [self refreshSureButtonStatus];
}

/// 渲染协议选项
- (void)showAgreementTips {
    kWeakConfig(self);
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择协议" message:@"对于App的使用、注意事项等重要信息均在协议中有详细说明,请仔细阅读相关协议." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"用户协议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself skipToAgreementWithTitle:@"用户协议" otherInfo:FilePathByName(@"user.html")];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"隐私条款" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself skipToAgreementWithTitle:@"隐私条款" otherInfo:FilePathByName(@"yinsi.html")];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action0];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

/// 跳转相关协议
/// @param title title
/// @param otherinfo otherinfo
- (void)skipToAgreementWithTitle:(NSString *)title otherInfo:(NSString *)otherinfo {
    SmartBWAgreement_VC *agreementVC = [SmartBWAgreement_VC new];
    agreementVC.titlestring = title;
    agreementVC.agreementstring = otherinfo;
    [self.navigationController pushViewController:agreementVC animated:YES];
}

/// 忘记密码响应
- (void)forgetPasswordResponse {
    self.enterType = SmartBWLoginContentTypePasswordForgot;
    [self refreshViews];
}

/// 切换注册
- (void)registerResponse {
    self.enterType = SmartBWLoginContentTypeRegisterByCode;
    [self refreshViews];
}

/// 切换密码登录
- (void)loginExchangeToPassword {
    self.enterType = SmartBWLoginContentTypeLoginByPassword;
    [self refreshViews];
}

/// 切换验证码登录
- (void)loginExchangeToCode {
    self.enterType = SmartBWLoginContentTypeLoginByCode;
    [self refreshViews];
}

/// 发送验证码
- (void)codeButtonResponse {
    if([SmartBWAuxiliaryMeansManager isPhoneNumberWithNumber:self.phoneTF.text]) {
        [self resignInputResponder];
        kWeakConfig(self);
//        [CAFNODataManager showCodeVerifyCompletion:^(BOOL isSuccess, NSString * _Nonnull verifyCodeValidate) {
//            if(isSuccess) {
//                [weakself verityCodeRequest];
//            }
//        }];
    }
    else {
        [AppMainWindow showAutoHudWithText:@"手机号码不正确"];
        [self.phoneTF becomeFirstResponder];
    }
}

/// 开启倒计时
- (void)startCodeTimer {
    if(!_codeTimer) {
        self.codeButton.userInteractionEnabled = NO;
        [self.codeTimer fire];
    }
}

/// 关闭倒计时
- (void)stopCodeTimer {
    if(_codeTimer) {
        [self.codeTimer invalidate];
        self.codeTimer = nil;
    }
}

/// 倒计时响应
- (void)codeTimerSelector {
    NSInteger time = self.refreshTime - [SmartBWAuxiliaryMeansManager currentTimeStampIntervalSince1970];
    self.codeButton.userInteractionEnabled = time <= 0;
    if(time >= 0) {
        [self.codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:NSStringFormat(@"%lds",time) attributes:@{NSForegroundColorAttributeName:kGrayColor}] forState:UIControlStateNormal];
        if(time == 0) {
            [self.codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"获取验证码" attributes:@{NSForegroundColorAttributeName:kColorByHexString(@"#ED1C24")}] forState:UIControlStateNormal];
            [self stopCodeTimer];
        }
    }
    else {
        [self.codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"获取验证码" attributes:@{NSForegroundColorAttributeName:kColorByHexString(@"#ED1C24")}] forState:UIControlStateNormal];
    }
}

/// 切换安全输入状态
- (void)securityButtonResponse {
    self.isSecurity = !self.isSecurity;
    [self.securityButton setImage:ImageByName(NSStringFormat(@"security_%d_mark",self.isSecurity*1)) forState:UIControlStateNormal];
    self.passwordTF.secureTextEntry = self.isSecurity;
}

/// 确认按钮响应
- (void)sureButtonResponse {
    [self.view endEditing:YES];
    if(self.sureButton.alpha < 1) {
        [self checkUserInputInfo];
    }
    else {
        if(self.enterType == SmartBWLoginContentTypeDefault) {
            self.enterType = SmartBWLoginContentTypeLoginByPassword;
            [self refreshViews];
        }
        else if(self.enterType == SmartBWLoginContentTypePasswordForgot) {
            [self resetLoginPassword];
        }
        else {
//            [CAFNODataManager riskControlWithType:CAFNORiskControlSceneTypeResigerAndLogin completion:^(BOOL isFinished) {
//                if(isFinished) {
//                    switch (self.enterType) {
//                        case SmartBWLoginContentTypeLoginByPassword:{
//                            [self loginByPassword];
//                        }
//                            break;
//
//                        case SmartBWLoginContentTypeLoginByCode:{
//                            [self loginByCode];
//                        }
//                            break;
//
//                        case SmartBWLoginContentTypeRegisterByCode:{
//                            [self registerByPhoneCode];
//                        }
//                            break;
//
//                        default:
//                            break;
//                    }
//                }
//            }];
        }
    }
}

/// 处理登录信息
/// - Parameter info: 登录信息
- (void)composeLoginInformation:(NSDictionary *)info {
    if(kClassJudgeByName(info, NSDictionary)) {
//        [CAFNOCacheTool sharedCacheTool].userInfoModel = [CAFNOUserInformation transluteUserInformationModelWithInfo:info];
//        [CAFNOCacheTool sharedCacheTool].token = [CAFNOCacheTool sharedCacheTool].userInfoModel.token;
//        [CAFNOCacheTool sharedCacheTool].isLogined = [CAFNOCacheTool token].length > 0;
        
        
        
//        [CAFNOUserInformation storeUserInformationToCache:nil completion:^(BOOL success) {
//            if(success) {
//                MyCustomLog(@"storeUserInformationToCacheSuccess");
//            }
//        }];
//        [CAFNOCacheTool recieveUserInformationCompletion:^(BOOL finish) {
//            ;
//        }];
        MyCustomLog(@"\ntoken = %@\n",info);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [AppMainWindow showAutoHudWithText:@"登录失败,请稍后重试."];
    }
}

/// 根据输入信息提示引导
- (void)checkUserInputInfo {
    if(self.enterType == SmartBWLoginContentTypeDefault) {
        if(!self.isAgreed) {
            [AppMainWindow showAutoHudWithText:@"请阅读并同意相关协议"];
        }
        return;
    }
    if(![SmartBWAuxiliaryMeansManager isPhoneNumberWithNumber:self.phoneTF.text]) {
        [AppMainWindow showAutoHudWithText:@"手机号码不正确"];
        [self.phoneTF becomeFirstResponder];
    }
    else {
        switch (self.enterType) {
            case SmartBWLoginContentTypeLoginByPassword:{
                if(self.passwordTF.text.length < 6 || self.passwordTF.text.length > 18) {
                    [AppMainWindow showAutoHudWithText:@"密码必须6-18位"];
                    [self.phoneTF becomeFirstResponder];
                }
                else if (!self.isAgreed) {
                    [AppMainWindow showAutoHudWithText:@"请阅读并同意相关协议"];
                    [self resignInputResponder];
                }
            }
                break;
                
            case SmartBWLoginContentTypeLoginByCode:{
                if(self.codeTF.text.length <= 0) {
                    [AppMainWindow showAutoHudWithText:@"验证码不能为空"];
                    [self.codeTF becomeFirstResponder];
                }
                else if (!self.isAgreed) {
                    [AppMainWindow showAutoHudWithText:@"请阅读并同意相关协议"];
                    [self resignInputResponder];
                }
            }
                break;
                
            case SmartBWLoginContentTypeRegisterByCode:{
                if(self.passwordTF.text.length < 6 || self.passwordTF.text.length > 18) {
                    [AppMainWindow showAutoHudWithText:@"密码必须6-18位"];
                    [self.phoneTF becomeFirstResponder];
                }
                else if(self.codeTF.text.length <= 0) {
                    [AppMainWindow showAutoHudWithText:@"验证码不能为空"];
                    [self.codeTF becomeFirstResponder];
                }
                else if(self.inviteTF.text.length <= 0) {
                    [AppMainWindow showAutoHudWithText:@"邀请码不能为空"];
                    [self.inviteTF becomeFirstResponder];
                }
            }
                break;
                
            case SmartBWLoginContentTypePasswordForgot:{
                if(self.passwordTF.text.length < 6 || self.passwordTF.text.length > 18) {
                    [AppMainWindow showAutoHudWithText:@"密码必须6-18位"];
                    [self.phoneTF becomeFirstResponder];
                }
                else if(self.codeTF.text.length <= 0) {
                    [AppMainWindow showAutoHudWithText:@"验证码不能为空"];
                    [self.codeTF becomeFirstResponder];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

/// 移除第一响应
- (void)resignInputResponder {
    [self.view endEditing:YES];
}

- (void)wxButtonCompose {
    [AppMainWindow showAutoHudWithText:@"暂未开放,敬请期待."];
}

#pragma mark **************************************************** Request Method ****************************************************
/// 发送验证码
- (void)verityCodeRequest {
    [AppMainWindow showHudWithText:@""];
    kWeakConfig(self);
//    [SmartBWNetworkingManager verifyCodeSendRequestByTelephone:self.phoneTF.text codeType:(self.enterType == SmartBWLoginContentTypeLoginByCode?VerifyCodeTypeLogin:(self.enterType == SmartBWLoginContentTypeRegisterByCode?VerifyCodeTypeRegister:VerifyCodeTypeForgetPWD)) success:^(id  _Nonnull data, NSInteger code, NSString * _Nonnull msg) {
//        [AppMainWindow dismissHud];
//        [AppMainWindow showAutoHudWithText:@"验证码发送成功"];
//        weakself.refreshTime = [SmartBWAuxiliaryMeansManager currentTimeStampIntervalSince1970] + 60;
//        [weakself startCodeTimer];
//        [weakself.codeTF becomeFirstResponder];
//    } failure:^(NSError * _Nonnull error) {
//        [AppMainWindow dismissHud];
//        [AppMainWindow showAutoHudWithText:error.localizedDescription];
//    }];
}

/// 密码登录
- (void)loginByPassword {
//    [AppMainWindow showHudWithText:@""];
//    kWeakConfig(self);
//    [SmartBWNetworkingManager loginByPwdRequestWithParamters:@{@"mobile":self.phoneTF.text,@"password":self.passwordTF.text,@"wy_token":[CAFNOCacheTool riskControlToken],@"wy_token_type":@"2"} success:^(id  _Nonnull data, NSInteger code, NSString * _Nonnull msg) {
//        [AppMainWindow dismissHud];
//        [weakself composeLoginInformation:data];
//    } failure:^(NSError * _Nonnull error) {
//        [AppMainWindow dismissHud];
//        [AppMainWindow showAutoHudWithText:error.localizedDescription];
//    }];
}

/// 重置登录密码
- (void)resetLoginPassword {
//    [AppMainWindow showHudWithText:@""];
//    kWeakConfig(self);
//    [SmartBWNetworkingManager resetPwdByCodeRequestWithParamters:@{@"mobile":self.phoneTF.text,@"password":self.passwordTF.text,@"code":self.codeTF.text} success:^(id  _Nonnull data, NSInteger code, NSString * _Nonnull msg) {
//        [AppMainWindow dismissHud];
//        [AppMainWindow showAutoHudWithText:@"密码已重置,请重新登录"];
//        [weakself loginExchangeToPassword];
//    } failure:^(NSError * _Nonnull error) {
//        [AppMainWindow dismissHud];
//        [AppMainWindow showAutoHudWithText:error.localizedDescription];
//    }];
}

/// 验证码登录
- (void)loginByCode {
//    [AppMainWindow showHudWithText:@""];
//    kWeakConfig(self);
//    [SmartBWNetworkingManager loginByCodeRequestWithParamters:@{@"mobile":self.phoneTF.text,@"code":self.codeTF.text,@"wy_token":[CAFNOCacheTool riskControlToken],@"wy_token_type":@"2"} success:^(id  _Nonnull data, NSInteger code, NSString * _Nonnull msg) {
//        [AppMainWindow dismissHud];
//        [weakself composeLoginInformation:data];
//    } failure:^(NSError * _Nonnull error) {
//        MyCustomLog(@"");
//        [AppMainWindow dismissHud];
//        [AppMainWindow showAutoHudWithText:error.localizedDescription];
//    }];
}

/// 注册
- (void)registerByPhoneCode {
//    [AppMainWindow showHudWithText:@""];
//    kWeakConfig(self);
//    [SmartBWNetworkingManager registerRequestWithParamters:@{@"mobile":self.phoneTF.text,@"code":self.codeTF.text,@"password":self.passwordTF.text,@"parent":self.inviteTF.text,@"wy_token":[CAFNOCacheTool riskControlToken],@"wy_token_type":@"2"} success:^(id  _Nonnull data, NSInteger code, NSString * _Nonnull msg) {
//        [AppMainWindow dismissHud];
//        [weakself composeLoginInformation:data];
//    } failure:^(NSError * _Nonnull error) {
//        [AppMainWindow dismissHud];
//        [AppMainWindow showAutoHudWithText:error.localizedDescription];
//    }];
}

#pragma mark **************************************************** Refresh Views Method ****************************************************
- (void)refreshViews {
    [self.navigationViews removeFromSuperview];
    [self.logoImageView removeFromSuperview];
    [self.optionView removeFromSuperview];
    self.optionView = nil;
    self.logoImageView = nil;
    self.navigationViews = nil;
    
    NSString *titleStr = @"登录";
    switch (self.enterType) {
        case SmartBWLoginContentTypeRegisterByCode:{
            titleStr = @"注册";
            if(_optionView) {
                [self.optionView removeFromSuperview];
                self.optionView = nil;
            }
        }
            break;
            
        case SmartBWLoginContentTypePasswordForgot:{
            if(_optionView) {
                [self.optionView removeFromSuperview];
                self.optionView = nil;
            }
            titleStr = @"忘记密码";
        }
            break;
            
        case SmartBWLoginContentTypeLoginByPassword:
        case SmartBWLoginContentTypeLoginByCode:{
            if(_optionView) {
                [self.optionView removeFromSuperview];
                self.optionView = nil;
            }
            [self.basalScrollView addSubview:self.optionView];
        }
            break;
            
        default:
            break;
    }
    
    [self.infoLab removeFromSuperview];
    self.infoLab = nil;
    [self removeLoginInputViews];
    
    self.basalScrollView.frame = CGRectMake(0.0, self.navigationViews.bottom, kWindowWidth, kWindowHeight - self.navigationViews.bottom);
    self.basalScrollView.contentSize = CGSizeMake(0, MAX((kWindowHeight - self.navigationViews.bottom + 1), self.infoLab.bottom));
    
    [self.basalScrollView addSubview:self.loginInputView];
    [self.basalScrollView addSubview:self.infoLab];
    
    [self refreshSureButtonStatus];
    
    [self.view addSubview:self.navigationViews];
}

/// 刷新确认按钮状态
- (void)refreshSureButtonStatus {
    BOOL isable = NO;
    BOOL isPhone = [SmartBWAuxiliaryMeansManager isPhoneNumberWithNumber:self.phoneTF.text];
    switch (self.enterType) {
        case SmartBWLoginContentTypeDefault:{
            isable = self.isAgreed;
        }
            break;
            
        case SmartBWLoginContentTypeLoginByPassword:{
            isable = self.isAgreed && isPhone && self.passwordTF.text.length >= 6 && self.passwordTF.text.length <= 18;
        }
            break;
            
        case SmartBWLoginContentTypeLoginByCode:{
            isable = self.isAgreed && isPhone && self.codeTF.text.length == 6;
        }
            break;
            
        case SmartBWLoginContentTypeRegisterByCode:{
            isable = isPhone && self.passwordTF.text.length >= 6 && self.passwordTF.text.length <= 18 && self.codeTF.text.length == 6 && self.inviteTF.text.length > 0;
        }
            break;
            
        case SmartBWLoginContentTypePasswordForgot:{
            isable = isPhone && self.passwordTF.text.length >= 6 && self.passwordTF.text.length <= 18 && self.codeTF.text.length == 6;
        }
            break;
            
        default:
            break;
    }
    self.sureButton.alpha = 0.5 + 0.5*isable;
}

- (void)removeLoginInputViews {
    [self.loginInputView removeFromSuperview];
    [self.phoneTF removeFromSuperview];
    if(_inviteTF) {
        [self.inviteTF removeFromSuperview];
        self.inviteTF = nil;
    }
    if(_codeTF) {
        [self.codeTF removeFromSuperview];
        self.codeTF = nil;
    }
    if(_passwordTF) {
        [self.passwordTF removeFromSuperview];
        self.passwordTF = nil;
    }
    self.phoneTF = nil;
    self.loginInputView = nil;
}

#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
- (UIView *)navigationViews {
    if (!_navigationViews) {
        _navigationViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, kWindowWidth, kNavigationBarHeight)];
        
        NSString *backname = @"back_login_mark";
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, kStatusBarHeight, 40.0, kNavigationBarContentHeight)];
        [backButton setImage:ImageByName(@"back_login_mark") forState:UIControlStateNormal];
        [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60.0, kStatusBarHeight, kWindowWidth - 120.0, kNavigationBarContentHeight)];
        titleLab.adjustsFontSizeToFitWidth = YES;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = SystemBoldFont(18);
        titleLab.textColor = kBlackColor;
        
        
        switch (self.enterType) {
            case SmartBWLoginContentTypeDefault:{
                self.view.backgroundColor = kWhiteColor;
                _navigationViews.backgroundColor = kWhiteColor;
                self.logoImageView.frame = CGRectMake(0.0, 106.0, kWindowWidth, 183.0);
                self.logoImageView.image = ImageByName(@"login_logo_mark");
                
            }
                break;
                
            case SmartBWLoginContentTypeLoginByPassword:{
                self.view.backgroundColor = kGrayColorByAlph(235);
                _navigationViews.backgroundColor = kClearColor;
                titleLab.text = @"手机号登录";
                self.logoImageView.frame = CGRectMake(0.0, kNavigationBarHeight + 30.0, kWindowWidth, 44.0);
                self.logoImageView.image = ImageByName(@"login_logo_mark");
                
                [_navigationViews addSubview:backButton];
                [_navigationViews addSubview:titleLab];
            }
                break;
                
            case SmartBWLoginContentTypeLoginByCode:{
                self.view.backgroundColor = kGrayColorByAlph(235);
                _navigationViews.backgroundColor = kClearColor;
                titleLab.text = @"验证码登录";
                self.logoImageView.frame = CGRectMake(0.0, kNavigationBarHeight + 30.0, kWindowWidth, 44.0);
                self.logoImageView.image = ImageByName(@"login_logo_mark");
                
                [_navigationViews addSubview:backButton];
                [_navigationViews addSubview:titleLab];
            }
                break;
                
            case SmartBWLoginContentTypeRegisterByCode:{
                
            }
                break;
                
            case SmartBWLoginContentTypePasswordEdit:{
                
            }
                break;
                
            case SmartBWLoginContentTypePasswordForgot:{
                
            }
                break;
                
            default:
                break;
        }
                
        [backButton setImage:ImageByName(backname) forState:UIControlStateNormal];
        
        _navigationViews.height = self.logoImageView.bottom;
        [_navigationViews addSubview:self.logoImageView];
    }
    return _navigationViews;
}

- (UIImageView *)logoImageView {
    if(!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.image = ImageByName(@"login_logo_image");
    }
    return _logoImageView;
}

- (UIScrollView *)basalScrollView {
    if (!_basalScrollView) {
        _basalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, self.navigationViews.bottom, kWindowWidth, kWindowHeight - self.navigationViews.bottom)];
        _basalScrollView.bounces = YES;
        _basalScrollView.pagingEnabled = NO;
        _basalScrollView.scrollEnabled = YES;
        _basalScrollView.scrollsToTop = YES;
        _basalScrollView.contentInset = UIEdgeInsetsZero;
        _basalScrollView.showsVerticalScrollIndicator = NO;
        _basalScrollView.showsHorizontalScrollIndicator = NO;
        _basalScrollView.autoresizingMask  = UIViewAutoresizingFlexibleHeight;
        _basalScrollView.delaysContentTouches = YES;
        _basalScrollView.delegate = self;
        [_basalScrollView setBackgroundColor:kClearColor];
        
        _basalScrollView.contentSize = CGSizeMake(0, MAX((kWindowHeight - self.navigationViews.bottom + 1), self.infoLab.bottom));
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _basalScrollView.width, _basalScrollView.contentSize.height)];
        [cancelButton addTarget:self action:@selector(resignInputResponder) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, IP6SW(812))];
        bgIV.contentMode = UIViewContentModeScaleAspectFit;
        bgIV.image = ImageByName(@"dlzc_bg");
        
        [_basalScrollView addSubview:bgIV];
        [_basalScrollView addSubview:cancelButton];
        [_basalScrollView addSubview:self.optionView];
        [_basalScrollView addSubview:self.loginInputView];
        [_basalScrollView addSubview:self.infoLab];
    }
    return _basalScrollView;
}

- (UIView *)optionView {
    if(!_optionView) {
        _optionView = [[UIView alloc] initWithFrame:CGRectZero];
        
        switch (self.enterType) {
            case SmartBWLoginContentTypeLoginByPassword:{
                _optionView.frame = CGRectMake(22.0, 20.0, kWindowWidth - 44.0, 50.0);
                _optionView.backgroundColor = kWhiteColor;
                _optionView.layer.cornerRadius = 15.0;
                _optionView.layer.masksToBounds = YES;
                
                UIButton *pwdButton = [[UIButton alloc] initWithFrame:CGRectMake(3.0, 3.0, _optionView.middleWidth - 3.0, 44.0)];
                pwdButton.backgroundColor = kRedColor;
                pwdButton.layer.cornerRadius = 22.0;
                pwdButton.layer.masksToBounds = YES;
                pwdButton.tag = 2023022500;
                [pwdButton setAttributedTitle:[SmartBWAuxiliaryMeansManager appendImgAtHeadWithImgName:@"login_pwd_mark" imgrect:CGRectMake(0, -4.0, 20.0, 20.0) string:@"  密码登录" stringAttributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:SystemBoldFont(14)}] forState:UIControlStateNormal];
                [pwdButton addTarget:self action:@selector(optionButtonResponse:) forControlEvents:UIControlEventTouchUpInside];

                UIButton *codeButton = [[UIButton alloc] initWithFrame:CGRectMake(pwdButton.right, pwdButton.top, pwdButton.width, pwdButton.height)];
                codeButton.backgroundColor = kClearColor;
                codeButton.layer.cornerRadius = 22.0;
                codeButton.layer.masksToBounds = YES;
                codeButton.tag = 2023022501;
                [codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"验证码登录" attributes:@{NSForegroundColorAttributeName:kColorByHexString(@"#666666"),NSFontAttributeName:SystemFont(14)}] forState:UIControlStateNormal];
                [codeButton addTarget:self action:@selector(optionButtonResponse:) forControlEvents:UIControlEventTouchUpInside];
                
                
                [_optionView addSubview:pwdButton];
                [_optionView addSubview:codeButton];
            }
                break;
                
            case SmartBWLoginContentTypeLoginByCode:{
                _optionView.frame = CGRectMake(26.0, IP6SW(194.0), kWindowWidth - 52.0, 50.0);
                _optionView.backgroundColor = kWhiteColor;
                _optionView.layer.cornerRadius = 25.0;
                _optionView.layer.masksToBounds = YES;
                
                UIButton *pwdButton = [[UIButton alloc] initWithFrame:CGRectMake(3.0, 3.0, _optionView.middleWidth - 3.0, 44.0)];
                pwdButton.backgroundColor = kClearColor;
                pwdButton.layer.cornerRadius = 22.0;
                pwdButton.layer.masksToBounds = YES;
                pwdButton.tag = 2023022500;
                [pwdButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"密码登录" attributes:@{NSForegroundColorAttributeName:kColorByHexString(@"#666666"),NSFontAttributeName:SystemFont(14)}] forState:UIControlStateNormal];
                [pwdButton addTarget:self action:@selector(optionButtonResponse:) forControlEvents:UIControlEventTouchUpInside];

                UIButton *codeButton = [[UIButton alloc] initWithFrame:CGRectMake(pwdButton.right, pwdButton.top, pwdButton.width, pwdButton.height)];
                codeButton.backgroundColor = kRedColor;
                codeButton.layer.cornerRadius = 22.0;
                codeButton.layer.masksToBounds = YES;
                codeButton.tag = 2023022501;
                [codeButton setAttributedTitle:[SmartBWAuxiliaryMeansManager appendImgAtHeadWithImgName:@"login_code_mark" imgrect:CGRectMake(0, -4.0, 20.0, 20.0) string:@"  验证码登录" stringAttributes:@{NSForegroundColorAttributeName:kWhiteColor,NSFontAttributeName:SystemFont(14)}] forState:UIControlStateNormal];
                [codeButton addTarget:self action:@selector(optionButtonResponse:) forControlEvents:UIControlEventTouchUpInside];
                
                
                [_optionView addSubview:pwdButton];
                [_optionView addSubview:codeButton];
            }
                break;
                
            default:
                break;
        }
    }
    return _optionView;
}

- (UIView *)loginInputView {
    if(!_loginInputView) {
        _loginInputView = [[UIView alloc] initWithFrame:CGRectMake(22.0, self.optionView.bottom + 26.0, kWindowWidth - 44.0, 100.0)];
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kWindowWidth - 52.0, 10.0)];
        whiteView.backgroundColor = kClearColor;
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = 20.0;
        
        NSArray *views = @[];
        switch (self.enterType) {
            case SmartBWLoginContentTypeDefault:{
                _loginInputView.top = self.optionView.bottom + 26.0;
                whiteView.height = kWindowHeight - self.navigationViews.bottom - DeviceBottomSafeHeight;
                self.sureButton.frame = CGRectMake(14.0, 120.0, kWindowWidth - 80.0, 50.0);
                [self.sureButton setTitle:@"手机号登录" forState:UIControlStateNormal];
                self.sureButton.layer.cornerRadius = 10.0;
                CGFloat w = [SmartBWAuxiliaryMeansManager computerStringWidthWithString:@"阅读并同意《用户协议》和《隐私政策》" attribute:@{NSFontAttributeName:SystemFont(13)} maxWidth:(kWindowWidth - 52.0 - 30.0)];
                NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kGrayColorByAlph(153.0)}];
                [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"《用户协议》" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kColorByHexString(@"#ED3D44")}]];
                [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"和" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kGrayColorByAlph(153.0)}]];
                [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"《隐私政策》" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kColorByHexString(@"#ED3D44")}]];
                
                
                UIButton *wxButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_X(0.5) - 26.0 - 56.0, self.sureButton.bottom + 140.0, 112.0, 90.0)];
                [wxButton addTarget:self action:@selector(wxButtonCompose) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *markIV = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 112.0, 58.0)];
                markIV.contentMode = UIViewContentModeCenter;
                markIV.image = ImageByName(@"dlzc_wxdl");
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 64.0, 112.0, 22.0)];
                lab.textColor = kBlackColor;
                lab.textAlignment = NSTextAlignmentCenter;
                lab.font = SystemFont(15);
                lab.text = @"微信登录";
                [wxButton addSubview:markIV];
                [wxButton addSubview:lab];
                
                UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.middleWidth - w*0.5 - 16.0, whiteView.height - 50.0, 30.0, 34.0)];
                [agreeButton setImage:ImageByName(NSStringFormat(@"agree_%d_mark",self.isAgreed*1)) forState:UIControlStateNormal];
                [agreeButton addTarget:self action:@selector(agreeButtonResponse:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(agreeButton.right + 2.0, agreeButton.top, w, 34.0)];
                [agreementButton setAttributedTitle:astr forState:UIControlStateNormal];
                [agreementButton addTarget:self action:@selector(showAgreementTips) forControlEvents:UIControlEventTouchUpInside];
                
                _loginInputView.height = whiteView.height;
                [whiteView addSubview:self.sureButton];
                [whiteView addSubview:agreeButton];
                [whiteView addSubview:agreementButton];
                [whiteView addSubview:wxButton];
                [_loginInputView addSubview:whiteView];
            }
                break;
                
            case SmartBWLoginContentTypeLoginByPassword:{
                _loginInputView.top = self.optionView.bottom + 12.0;
                views = @[@{@"title":@"手机号",@"views":@[self.phoneTF]},@{@"title":@"输入密码",@"views":@[self.passwordTF,self.securityButton]}];
                whiteView.height = (views.count*74.0 + 140.0);
                
                self.sureButton.top = (views.count*74.0 + 30.0);
                [self.sureButton setTitle:@"立即登录" forState:UIControlStateNormal];
                
                CGFloat w = [SmartBWAuxiliaryMeansManager computerStringWidthWithString:@"阅读并同意《用户协议》和《隐私政策》" attribute:@{NSFontAttributeName:SystemFont(13)} maxWidth:(kWindowWidth - 52.0 - 30.0)];
                NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kGrayColorByAlph(153.0)}];
                [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"《用户协议》" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kColorByHexString(@"#ED1C24")}]];
                [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"和" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kGrayColorByAlph(153.0)}]];
                [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"《隐私政策》" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kColorByHexString(@"#ED1C24")}]];
                
                
                UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.middleWidth - w*0.5 - 16.0, self.sureButton.bottom + 10.0, 30.0, 34.0)];
                [agreeButton setImage:ImageByName(NSStringFormat(@"agree_%d_mark",self.isAgreed*1)) forState:UIControlStateNormal];
                [agreeButton addTarget:self action:@selector(agreeButtonResponse:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(agreeButton.right + 2.0, self.sureButton.bottom + 10.0, w, 34.0)];
                [agreementButton setAttributedTitle:astr forState:UIControlStateNormal];
                [agreementButton addTarget:self action:@selector(showAgreementTips) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.middleWidth - 74.5, whiteView.bottom + 0.0, 74.0, 30.0)];
                [forgetButton addTarget:self action:@selector(forgetPasswordResponse) forControlEvents:UIControlEventTouchUpInside];
                [forgetButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"忘记密码" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(whiteView.middleWidth - 0.5, forgetButton.centerY - 3.0, 1.0, 6.0)];
                line.backgroundColor = kBlackColor;
                
                UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(line.right, forgetButton.top, 74.0, 30.0)];
                [registerButton addTarget:self action:@selector(registerResponse) forControlEvents:UIControlEventTouchUpInside];
                [registerButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"立即注册" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
                
                UIButton *wxButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_X(0.5) - 56.0, registerButton.bottom + 40.0, 60.0, 80.0)];
                [wxButton addTarget:self action:@selector(wxButtonCompose) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *markIV = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 58.0)];
                markIV.contentMode = UIViewContentModeCenter;
                markIV.image = ImageByName(@"dlzc_wxdl");
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 60.0, 1.0)];
                lab.textColor = kWhiteColor;
                lab.textAlignment = NSTextAlignmentCenter;
                lab.font = SystemFont(15);
                lab.text = @"微信登录";
                [wxButton addSubview:markIV];
                [wxButton addSubview:lab];
                
                _loginInputView.height = wxButton.bottom + 6.0;
                
                [whiteView addSubview:self.sureButton];
                [whiteView addSubview:agreeButton];
                [whiteView addSubview:agreementButton];
                [_loginInputView addSubview:forgetButton];
                [_loginInputView addSubview:line];
                [_loginInputView addSubview:registerButton];
                [_loginInputView addSubview:wxButton];
            }
                break;
                
            case SmartBWLoginContentTypeLoginByCode:{
                views = @[@{@"title":@"手机号",@"views":@[self.phoneTF]},@{@"title":@"验证码",@"views":@[self.codeTF,self.codeButton]}];
                whiteView.height = (views.count*74.0 + 140.0);
                
                self.sureButton.top = (views.count*74.0 + 30.0);
                [self.sureButton setTitle:@"立即登录" forState:UIControlStateNormal];
                
                CGFloat w = [SmartBWAuxiliaryMeansManager computerStringWidthWithString:@"阅读并同意《用户协议》和《隐私政策》" attribute:@{NSFontAttributeName:SystemFont(13)} maxWidth:(kWindowWidth - 52.0 - 30.0)];
                NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kGrayColorByAlph(153.0)}];
                [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"《用户协议》" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kColorByHexString(@"#ED1C24")}]];
                [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"和" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kGrayColorByAlph(153.0)}]];
                [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"《隐私政策》" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kColorByHexString(@"#ED1C24")}]];
                
                
                UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.middleWidth - w*0.5 - 16.0, self.sureButton.bottom + 10.0, 30.0, 34.0)];
                [agreeButton setImage:ImageByName(NSStringFormat(@"agree_%d_mark",self.isAgreed*1)) forState:UIControlStateNormal];
                [agreeButton addTarget:self action:@selector(agreeButtonResponse:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(agreeButton.right + 2.0, self.sureButton.bottom + 10.0, w, 34.0)];
                [agreementButton setAttributedTitle:astr forState:UIControlStateNormal];
                [agreementButton addTarget:self action:@selector(showAgreementTips) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.middleWidth - 74.5, whiteView.bottom + 0.0, 74.0, 30.0)];
                [forgetButton addTarget:self action:@selector(forgetPasswordResponse) forControlEvents:UIControlEventTouchUpInside];
                [forgetButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"忘记密码" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(whiteView.middleWidth - 0.5, forgetButton.centerY - 3.0, 1.0, 6.0)];
                line.backgroundColor = kBlackColor;
                
                UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(line.right, forgetButton.top, 74.0, 30.0)];
                [registerButton addTarget:self action:@selector(registerResponse) forControlEvents:UIControlEventTouchUpInside];
                [registerButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"立即注册" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
                
                
                UIButton *wxButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_X(0.5) - 56.0, registerButton.bottom + 40.0, 60.0, 80.0)];
                [wxButton addTarget:self action:@selector(wxButtonCompose) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *markIV = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 50.0)];
                markIV.contentMode = UIViewContentModeCenter;
                markIV.image = ImageByName(@"dlzc_wxdl");
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 60.0, 16.0)];
                lab.textColor = kWhiteColor;
                lab.textAlignment = NSTextAlignmentCenter;
                lab.font = SystemFont(13);
                lab.text = @"微信登录";
                [wxButton addSubview:markIV];
                [wxButton addSubview:lab];
                
                _loginInputView.height = wxButton.bottom + 6.0;
                
                [whiteView addSubview:self.sureButton];
                [whiteView addSubview:agreeButton];
                [whiteView addSubview:agreementButton];
                [_loginInputView addSubview:forgetButton];
                [_loginInputView addSubview:line];
                [_loginInputView addSubview:registerButton];
                [_loginInputView addSubview:wxButton];
            }
                break;
                
            case SmartBWLoginContentTypeRegisterByCode:{
                views = @[@{@"title":@"手机号",@"views":@[self.phoneTF]},@{@"title":@"验证码",@"views":@[self.codeTF,self.codeButton]},@{@"title":@"登录密码",@"views":@[self.passwordTF,self.securityButton]},@{@"title":@"邀请码",@"views":@[self.inviteTF]}];
                whiteView.height = (views.count*74.0 + 110.0);
                
                self.sureButton.top = (views.count*74.0 + 30.0);
                [self.sureButton setTitle:@"立即注册" forState:UIControlStateNormal];
                
                UIButton *pwdButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.middleWidth - 74.5, whiteView.bottom + 10.0, 74.0, 30.0)];
                [pwdButton addTarget:self action:@selector(loginExchangeToPassword) forControlEvents:UIControlEventTouchUpInside];
                [pwdButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"密码登录" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(whiteView.middleWidth - 0.5, pwdButton.centerY - 3.0, 1.0, 6.0)];
                line.backgroundColor = kBlackColor;
                
                UIButton *codeButton = [[UIButton alloc] initWithFrame:CGRectMake(line.right + 10.0, pwdButton.top, 74.0, 30.0)];
                [codeButton addTarget:self action:@selector(loginExchangeToCode) forControlEvents:UIControlEventTouchUpInside];
                [codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"验证码登录" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
                
                _loginInputView.height = codeButton.bottom + 6.0;
                
                [whiteView addSubview:self.sureButton];
                [_loginInputView addSubview:pwdButton];
                [_loginInputView addSubview:line];
                [_loginInputView addSubview:codeButton];
                
                [self startCodeTimer];
            }
                break;
                
            case SmartBWLoginContentTypePasswordForgot:{
                views = @[@{@"title":@"手机号",@"views":@[self.phoneTF]},@{@"title":@"验证码",@"views":@[self.codeTF,self.codeButton]},@{@"title":@"登录密码",@"views":@[self.passwordTF,self.securityButton]}];
                whiteView.height = (views.count*74.0 + 110.0);
                
                self.sureButton.top = (views.count*74.0 + 30.0);
                [self.sureButton setTitle:@"重置密码" forState:UIControlStateNormal];
                
                UIButton *pwdButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.middleWidth - 74.5, whiteView.bottom + 10.0, 74.0, 30.0)];
                [pwdButton addTarget:self action:@selector(loginExchangeToPassword) forControlEvents:UIControlEventTouchUpInside];
                [pwdButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"密码登录" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(whiteView.middleWidth - 0.5, pwdButton.centerY - 3.0, 1.0, 6.0)];
                line.backgroundColor = kBlackColor;
                
                UIButton *codeButton = [[UIButton alloc] initWithFrame:CGRectMake(line.right + 10.0, pwdButton.top, 74.0, 30.0)];
                [codeButton addTarget:self action:@selector(registerResponse) forControlEvents:UIControlEventTouchUpInside];
                [codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"立即注册" attributes:@{NSFontAttributeName:SystemFont(13),NSForegroundColorAttributeName:kWhiteColor}] forState:UIControlStateNormal];
                
                _loginInputView.height = codeButton.bottom + 6.0;
                
                [whiteView addSubview:self.sureButton];
                [_loginInputView addSubview:pwdButton];
                [_loginInputView addSubview:line];
                [_loginInputView addSubview:codeButton];
                
                [self startCodeTimer];
            }
                break;
                
            default:
                break;
        }
        
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *info = (NSDictionary *)obj;
//            UILabel *themeLab = [[UILabel alloc] initWithFrame:CGRectMake(20.0, idx*90.0 + 16.0, 200.0, 24.0)];
//            themeLab.textAlignment = NSTextAlignmentLeft;
//            themeLab.font = SystemFont(16);
//            themeLab.textColor = kBlackColor;
//            themeLab.text = info[@"title"];
            CGFloat y = (idx*74.0 + 16.0);
            [info[@"views"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIView *view = obj;
                view.top = y;
                [whiteView addSubview:view];
            }];
            UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(20.0, y + 73.0, whiteView.width - 40.0, 1.0)];
            hline.backgroundColor = kGrayColorByAlph(220);
//            [whiteView addSubview:themeLab];
            [whiteView addSubview:hline];
        }];
        
        [_loginInputView addSubview:whiteView];
    }
    return _loginInputView;
}

- (UITextField *)phoneTF {
    if(!_phoneTF) {
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 0.0, kWindowWidth - 92.0, 73.5)];
        _phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号" attributes:@{NSForegroundColorAttributeName:kGrayColorByAlph(200),NSFontAttributeName:SystemFont(18)}];
        _phoneTF.delegate = self;
        _phoneTF.textColor = kWhiteColor;
        _phoneTF.font = SystemFont(18);
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.returnKeyType = UIReturnKeyNext;
    }
    return _phoneTF;
}

- (UITextField *)passwordTF {
    if(!_passwordTF) {
        _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 0.0, kWindowWidth - 92.0 - 46.0, 73.5)];
        _passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:@{NSForegroundColorAttributeName:kGrayColorByAlph(200),NSFontAttributeName:SystemFont(18)}];
        _passwordTF.delegate = self;
        _passwordTF.textColor = kWhiteColor;
        _passwordTF.font = SystemFont(18);
        _passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTF.returnKeyType = self.enterType == SmartBWLoginContentTypeRegisterByCode?UIReturnKeyNext:UIReturnKeyDone;
    }
    return _passwordTF;
}

- (UIButton *)securityButton {
    if(!_securityButton) {
        _securityButton = [[UIButton alloc] initWithFrame:CGRectMake(self.passwordTF.right, 0.0, 56.0, 73.5)];
        [_securityButton setImage:ImageByName(NSStringFormat(@"security_%d_mark",self.isSecurity*1)) forState:UIControlStateNormal];
        [_securityButton addTarget:self action:@selector(securityButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    }
    return _securityButton;
}

- (UITextField *)codeTF {
    if(!_codeTF) {
        _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 0.0, kWindowWidth - 92.0 - 70.0, 73.5)];
        _codeTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:kGrayColorByAlph(200),NSFontAttributeName:SystemFont(18)}];
        _codeTF.delegate = self;
        _codeTF.textColor = kWhiteColor;
        _codeTF.font = SystemFont(18);
        _codeTF.keyboardType = UIKeyboardTypeASCIICapable;
        _codeTF.returnKeyType = self.enterType == SmartBWLoginContentTypeRegisterByCode?UIReturnKeyNext:UIReturnKeyDone;
    }
    return _codeTF;
}

- (UIButton *)codeButton {
    if(!_codeButton) {
        _codeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.codeTF.right, 0.0, 70.0, 73.5)];
        [_codeButton addTarget:self action:@selector(codeButtonResponse) forControlEvents:UIControlEventTouchUpInside];
        _codeButton.titleLabel.font = SystemFont(12);
        [_codeButton setTitleColor:kRedColor forState:UIControlStateNormal];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return _codeButton;
}

- (UITextField *)inviteTF {
    if(!_inviteTF) {
        _inviteTF = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 0.0, kWindowWidth - 92.0, 73.5)];
        _inviteTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的邀请码(必填)" attributes:@{NSForegroundColorAttributeName:kGrayColorByAlph(200),NSFontAttributeName:SystemFont(18)}];
        _inviteTF.delegate = self;
        _inviteTF.textColor = kWhiteColor;
        _inviteTF.font = SystemFont(18);
        _inviteTF.keyboardType = UIKeyboardTypeASCIICapable;
        _inviteTF.returnKeyType = UIReturnKeyDone;
    }
    return _inviteTF;
}

- (UIButton *)sureButton {
    if(!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(kWindowWidth*0.5 - 139.0, 0.0, 230.0, 50.0)];
        _sureButton.backgroundColor = kRedColor;
        _sureButton.layer.cornerRadius = 25.0;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.titleLabel.font = SystemBoldFont(18);
        [_sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonResponse) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (NSTimer *)codeTimer {
    if(!_codeTimer) {
        kWeakConfig(self);
        _codeTimer = [NSTimer safeScheduledTimerWithTimeInterval:1 block:^{
            [weakself codeTimerSelector];
        } repeats:YES];
    }
    return _codeTimer;
}

- (UILabel *)infoLab {
    if(!_infoLab) {
        CGFloat y = self.loginInputView.bottom > (kWindowHeight - DeviceBottomSafeHeight - 56.0) ? self.loginInputView.bottom + 40.0:(kWindowHeight - DeviceBottomSafeHeight - 56.0);
        _infoLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, y, kWindowWidth, 56.0)];
        _infoLab.adjustsFontSizeToFitWidth = YES;
        _infoLab.textAlignment = NSTextAlignmentCenter;
        _infoLab.font = SystemFont(12);
        _infoLab.textColor = kGrayColorByAlph(153);
        _infoLab.numberOfLines = 0;
        NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:@"满座(杭州)影视产业互联网有限公司" attributes:@{}];
        [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n1\n" attributes:@{NSFontAttributeName:SystemFont(4),NSForegroundColorAttributeName:kClearColor}]];
        [astr appendAttributedString:[[NSAttributedString alloc] initWithString:@"霍尔果斯直中取影视产业互联网有限公司" attributes:@{}]];
        _infoLab.attributedText = astr;
    }
    return _infoLab;
}

@end
