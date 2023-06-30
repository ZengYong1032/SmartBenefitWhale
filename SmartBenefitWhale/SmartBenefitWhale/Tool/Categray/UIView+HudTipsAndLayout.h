//
//  UIView+HudTipsAndLayout.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HudTipsAndLayout)

#pragma mark ----------------------------------------------------- Hud Tips Method -----------------------------------------------------
+ (void)showErrorHudWith:(NSString*)text;

- (void)showHudWithText:(NSString*)text;

- (void)showAutoHudWithText:(NSString*)text;

- (void)dismissHud;

#pragma mark ----------------------------------------------------- Layout Method -----------------------------------------------------

@property (nonatomic, assign) CGFloat                                   top;

@property (nonatomic, assign) CGFloat                                   bottom;

@property (nonatomic, assign) CGFloat                                   left;

@property (nonatomic, assign) CGFloat                                   right;

@property (nonatomic, assign) CGFloat                                   width;

@property (nonatomic, assign) CGFloat                                   height;

@property (nonatomic, assign) CGFloat                                   centerX;

@property (nonatomic, assign) CGFloat                                   centerY;

@property (nonatomic, assign) CGFloat                                   middleWidth;

@property (nonatomic, assign) CGFloat                                   middleHeight;

@property (nonatomic, assign) CGSize                                    size;

@property (nonatomic, assign) CGPoint                                   origin;



#pragma mark ----------------------------------------------------- Translucent View Method -----------------------------------------------------
+ (UIView *)translucentViewWithFrame:(CGRect)frame alpha:(CGFloat)alpha white:(CGFloat)white;

@end

NS_ASSUME_NONNULL_END
