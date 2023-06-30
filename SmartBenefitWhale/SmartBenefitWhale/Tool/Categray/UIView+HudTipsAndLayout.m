//
//  UIView+HudTipsAndLayout.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/21.
//

#import "UIView+HudTipsAndLayout.h"
#import "MBProgressHUD.h"

#define HUD_TAG                 (90000 + 'H')
#define HUD_AUTO_TAG            (90001 +'H')
#define HUD_DELAY_TIME          (3.0f)

@implementation UIView (HudTipsAndLayout)

#pragma mark ----------------------------------------------------- Hud Tips Method -----------------------------------------------------

+ (void)showErrorHudWith:(NSString*)text {
    [self.class showWindowHudWith:text status:1];
}

+ (void)showWindowHudWith:(NSString*)text status:(NSInteger)status {
    
    UIView* view = AppMainWindow;
    [MBProgressHUD hideHUDForView:view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    
    switch (status) {
        case 0:{
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            hud.customView = [[UIImageView alloc] initWithImage:image];
            hud.detailsLabel.text = text;
        }break;
        case 1:{
            UIImage *image = [[UIImage imageNamed:@"Errormark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            hud.customView = [[UIImageView alloc] initWithImage:image];
            hud.detailsLabel.text = text;
        }break;
        case 2:{
            hud.mode = MBProgressHUDModeText;
            hud.customView = nil;
            hud.detailsLabel.font = [UIFont systemFontOfSize:16];
            hud.detailsLabel.text = text;
        }break;
        default:
            break;
    }
    
    hud.square = NO;
    hud.minSize= CGSizeMake(100, 100);
    
    [hud hideAnimated:YES afterDelay:HUD_DELAY_TIME];
}

- (void)showHudWithText:(NSString*)text {
    [SmartBWCacheManager hubcountAdd:1];
    MBProgressHUD *hud = [self viewWithTag:HUD_TAG];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.tag = HUD_TAG;
}

- (void)showAutoHudWithText:(NSString*)text {
    MBProgressHUD* lastHud = [self viewWithTag:HUD_AUTO_TAG];
    if(lastHud){
        lastHud.detailsLabel.text = text;
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.tag = HUD_AUTO_TAG;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.defaultMotionEffectsEnabled = NO;
    [hud hideAnimated:YES afterDelay:HUD_DELAY_TIME];
}

- (void)dismissHud {
    [SmartBWCacheManager hubcountSubtraction:1];
    if([SmartBWCacheManager hubcount] <= 0) {
        [SmartBWCacheManager setHubcount:0];
        kWeakConfig(self);
        [SmartBWAuxiliaryMeansManager mainThreadComposeCompletion:^{
            MBProgressHUD *hud = [weakself viewWithTag:HUD_TAG];
            if (hud) {
                [hud hideAnimated:YES];
            }
        }];
    }
}

#pragma mark ----------------------------------------------------- Layout Method -----------------------------------------------------
- (void)setTop:(CGFloat)t {
    self.frame = CGRectMake(self.left, t, self.width, self.height);
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)b {
    self.frame = CGRectMake(self.left, b - self.height, self.width, self.height);
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)l {
    self.frame = CGRectMake(l, self.top, self.width, self.height);
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)r {
    self.frame = CGRectMake(r - self.width, self.top, self.width, self.height);
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setWidth:(CGFloat)w {
    self.frame = CGRectMake(self.left, self.top, w, self.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)h {
    self.frame = CGRectMake(self.left, self.top, self.width, h);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.left, self.top, size.width, size.height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

- (CGFloat)middleWidth {
    return self.size.width*0.5;
}

- (void)setMiddleWidth:(CGFloat)middleWidth {
    self.frame = CGRectMake(self.left, self.top, middleWidth*2.0, self.height);
}

- (CGFloat)middleHeight {
    return self.size.height*0.5;
}

- (void)setMiddleHeight:(CGFloat)middleHeight {
    self.frame = CGRectMake(self.left, self.top, self.width, middleHeight*2.0);
}

#pragma mark ----------------------------------------------------- Translucent View Method -----------------------------------------------------
+ (UIView *)translucentViewWithFrame:(CGRect)frame alpha:(CGFloat)alpha white:(CGFloat)white {
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    [bgView setBackgroundColor:[UIColor clearColor]];
    UIView *tanslucentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
    [tanslucentView setBackgroundColor:kGrayCustomColor(white, alpha)];
    [tanslucentView setTag:20230208];
    [bgView addSubview:tanslucentView];
    
    return bgView;
}

@end
