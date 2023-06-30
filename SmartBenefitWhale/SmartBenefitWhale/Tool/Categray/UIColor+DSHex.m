//
//  UIColor+DSHex.m
//  Test
//
//  Created by Mac on 2023/6/29.
//

#import "UIColor+DSHex.h"
#import <UIKit/UIKit.h>

@implementation UIColor (DSHex)

static UIImage *giftBagSignInRedImage = nil;

/// 十六进制转RGB
+ (UIColor *)colorWithHexColor:(NSString *)hexColorString {
    if ([hexColorString hasPrefix:@"#"]) {
        hexColorString = [hexColorString substringFromIndex:1];
    }
    if (hexColorString.length != 6) {
        return  nil;
    }
    NSRange range = NSMakeRange(0, 2);
    NSString *redStr = [hexColorString substringWithRange:range];
    range.location = 2;
    NSString *greenStr = [hexColorString substringWithRange:range];
    range.location = 4;
    NSString *blueStr = [hexColorString substringWithRange:range];
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redStr] scanHexInt:&red];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&green];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&blue];
    return [UIColor colorWithRed:red / 255.0f  green:green / 255.0f blue:blue / 255.0f alpha:1];
}

/// 将一个色块转成图片
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// 获取一个红色图片
+ (UIImage *)getRedImageFromGiftBagSignIn {
    if (!giftBagSignInRedImage) {
        giftBagSignInRedImage = [self createImageWithColor:UIColor.redColor size:CGSizeMake(6, 6)];
    }
    return giftBagSignInRedImage;
}

@end
