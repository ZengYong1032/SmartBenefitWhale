//
//  UIColor+DSHex.h
//  Test
//
//  Created by Mac on 2023/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DSHex)

/// 十六进制转RGB
+ (UIColor *)colorWithHexColor:(NSString *)hexColorString;

/// 将一个色块转成图片
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

/// 获取一个红色图片
+ (UIImage *)getRedImageFromGiftBagSignIn;

@end

NS_ASSUME_NONNULL_END
