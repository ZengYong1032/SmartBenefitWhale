//
//  SmartBWAuxiliaryMeansManager.m
//  SmartBenefitWhale
//
//  Created by Yong Zeng on 2023/6/7.
//

#import "SmartBWAuxiliaryMeansManager.h"
#import <WebKit/WebKit.h>
#import <Photos/Photos.h>
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

@implementation SmartBWAuxiliaryMeansManager

/// 应用窗口
+ (UIWindow *)appMainWindow {
    if (@available(iOS 15.0, *)) {
        return ((UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject).windows.firstObject;
    }
    else {
        return [UIApplication sharedApplication].windows.firstObject;
    }
}

/// 应用窗口边缘安全距离
+ (UIEdgeInsets)windowSafeArea {
    return [SmartBWAuxiliaryMeansManager appMainWindow].safeAreaInsets;
}

/// 设备底部安全高度
+ (CGFloat)deviceBottomSafeHeight {
    return [SmartBWAuxiliaryMeansManager windowSafeArea].bottom;
}

/// 设备状态栏高度
+ (CGFloat)deviceStatusBarHeight {
    CGFloat statusBarHeight = 0.f;
    if (@available(iOS 15.0, *)) {
        statusBarHeight = ((UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject).keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
    }
    else {
        statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    }
    return statusBarHeight;
}

/// 应用主线程处理响应
/// - Parameter completion: 处理模块
+ (void)mainThreadComposeCompletion:(CommonCompletion)completion {
    if (completion) {
        if ([NSThread isMainThread]) {
            completion();
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    }
}

/// 应用当前控制器
+ (UIViewController *)windowCurrentViewController {
    UIViewController* vc = [SmartBWAuxiliaryMeansManager appMainWindow].rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        else if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }
        else {
            break;
        }
    }
    
    return vc;
}

/// 应用当前控制器
+ (UIViewController *)windowTopViewController {
    UIViewController *vc = [SmartBWAuxiliaryMeansManager appMainWindow].rootViewController;
    UIViewController *topVC = vc;

    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }

    return topVC;
}

/// 通过索引打开
/// - Parameter indexstr: 索引
+ (void)openByApplication:(id)indexstr {
    NSURL *url;
    if (kClassJudgeByName(indexstr, NSURL)) {
        url = indexstr;
    }
    else if (kClassJudgeByName(indexstr, NSString)) {
        url = [NSURL URLWithString:indexstr];
    }
    else {
        return;
    }
    
//    [kApplicationManager openURL:url options:@{} completionHandler:nil];
}


#pragma mark ----------------------------------------------------- Tool Method -----------------------------------------------------
/// 对象转换成json字符串
/// @param object 对象
+ (NSString *)objectTransformJsonString:(id)object {
    NSError *error;
    NSData *jsonData;
    NSString *jsonString;
    if ([object isKindOfClass:[NSData class]]) {
        jsonData = (NSData *)object;
        jsonString = [jsonData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    else {
            jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
            if(error) {
                MyCustomLog(@"%@",error.localizedDescription);
            }
           jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    
    return jsonString;
}

/// json字符串数据转字典或数组
/// @param jsonObject json字符串/数据
+ (id)jsonStringTransformObject:(id)jsonObject {
    NSError *error = nil;
    if (jsonObject == nil) {
        return nil;
    }
    else if (kClassJudgeByName(jsonObject, NSDictionary) || kClassJudgeByName(jsonObject, NSArray)) {
        return jsonObject;
    }
    NSData *jsonData;
    if (kClassJudgeByName(jsonObject, NSData)) {
        jsonData = (NSData *)jsonObject;
    }
    else {
        jsonData = [jsonObject dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    id jsonDicObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    
    if (jsonDicObject != nil && error == nil) {
        return jsonDicObject;
    }
    else {
        MyCustomLog(@"json解析失败：%@",error);
        return nil;
    }
}

/// 对象转json字符串
/// @param object 对象数据
+ (NSString *)objectTransformJsonObjectString:(id)object {
    NSData *data;
    if ([object isKindOfClass:[NSData class]]) {
        data = object;
    }
    else {
        data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    NSString *paraStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 将JSON字符串转成无换行无空格字符串
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    paraStr = [paraStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];///去除掉首尾的空白字符和换行字符使用
    paraStr = [paraStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return paraStr;
}

/// 项目中是否存在<name>类
/// @param name 类名
+ (BOOL)classIsExistInProjectByName:(NSString *)name {
    BOOL isExist = NO;
    if (name.length > 0 && kClassJudgeByName(name, NSString)) {
        Class class = NSClassFromString(name);
        NSString *classname = NSStringFromClass(class);
        isExist = classname.length > 0;
    }
    return isExist;
}

/// 储存图片到相册
/// @param image 图片
/// @param completion 储存后的回调
+ (void)imageStoreToLibraryWithImage:(UIImage *)image completion:(CommonStatusCompletion)completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        !completion?:completion(success);
        if (error) {
//            AppMainWindow
        }
    }];
}

/// 切换横竖屏
/// @param orientation 屏幕方向
+ (void)changeInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        NSInteger val = orientation;
        // 从2开始。0：selector 1：target
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/// 颜色详细信息
/// @param originColor 颜色
+ (NSDictionary *)recieveRGBInfoDictionaryByColor:(UIColor *)originColor {
    CGFloat r=0,g=0,b=0,a=0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    return @{@"R":@(r),@"G":@(g),@"B":@(b),@"A":@(a)};
}

/// 通过Hex获取颜色对象
/// @param hexColor Hex数值
+ (UIColor *)colorWithHexValue:(long)hexColor {
    return [self colorByHex:hexColor alpha:1.];
}

// 通过十六进制数据转换颜色,透明度可调整
+ (UIColor *)colorByHex:(long)hexColor alpha:(float)opacity {
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

// 通过十六进制字符串转换颜色
+ (UIColor *)colorByHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }

    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;

    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

/// View设置渐变色
/// @param originColor 起点颜色
/// @param terminusColor 终点颜色
/// @param view 视图
/// @param size 视图size
/// @param originPoint 起点坐标
/// @param terminusPoint 终点坐标
+ (void)gradientRampOriginColor:(UIColor *)originColor terminusColor:(UIColor *)terminusColor view:(UIView *)view size:(CGSize)size originPoint:(CGPoint)originPoint terminusPoint:(CGPoint)terminusPoint {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)(originColor.CGColor),(__bridge id)(terminusColor.CGColor)];
    gradientLayer.locations = @[@0.0,@1.0];
    gradientLayer.startPoint = originPoint;
    gradientLayer.endPoint = terminusPoint;
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [view.layer addSublayer:gradientLayer];
    
    if (kClassJudgeByName(view, UIButton)) {
        [view bringSubviewToFront:((UIButton *)view).titleLabel];
    }
}

/// 储存本地信息
/// @param object 储存对象数组/字典
/// @param filepath 储存路径
+ (BOOL)storeFileWithObject:(id)object path:(NSString *)filepath {
    if (filepath.length > 0) {
        if (kClassJudgeByName(object, NSArray) || kClassJudgeByName(object, NSDictionary)) {
            if ([object writeToFile:filepath atomically:YES]) {
                return YES;
            }
        }
    }
    [AppMainWindow showAutoHudWithText:@"保存失败"];
    return NO;
}


#pragma mark ----------------------------------------------------- String About Method -----------------------------------------------------
/// 判定给定对象是否为空
/// @param astring 给定对象
+ (BOOL)checkTargetStringIsNil:(NSString *)astring {
    if (kClassJudgeByName(astring, NSNull) || !astring || astring.length == 0) {
        return YES;
    }
    else {
            return NO;
        }
}

/// 处理整型数据
/// @param obj 数据
+ (NSString *)formatIntegerWithObject:(id)obj {
    if (obj == nil || kClassJudgeByName(obj, NSNull) || kClassJudgeByName(obj, NSArray) || kClassJudgeByName(obj, NSDictionary) || (kClassJudgeByName(obj, NSString) && ((NSString *)obj).length == 0)) {
        return @"0";
    }
    else {
        return NSStringFormat(@"%@",obj);
    }
}

/// 处理字符串数据
/// @param obj 数据
+ (NSString *)transformStringByObject:(id)obj {
    if (obj == nil || kClassJudgeByName(obj, NSNull) || kClassJudgeByName(obj, NSArray) || kClassJudgeByName(obj, NSDictionary)) {
        return @"";
    }
    else {
        return NSStringFormat(@"%@",obj);
    }
}

/// 处理整形字符串数据
/// @param obj 数据
+ (NSString *)transformIntegerStringByObject:(id)obj {
    if (obj == nil || kClassJudgeByName(obj, NSNull) || kClassJudgeByName(obj, NSArray) || kClassJudgeByName(obj, NSDictionary)) {
        return @"0";
    }
    else {
        return NSStringFormat(@"%@",obj);
    }
}

/// 计算富文本字符串的最低高度
/// @param string 富文本字符串
/// @param width 宽度
+ (CGFloat)computeAttributedStringHeightWithString:(NSAttributedString *)string tvWidth:(CGFloat)width {
    if (![self checkTargetStringIsNil:string.string]) {
        NSRange range = NSMakeRange(0, string.length);
        // 获取该段attributedString的属性字典
        NSDictionary *dic = [string attributesAtIndex:0 effectiveRange:&range];
        // 计算文本的大小
        CGSize sizeToFit = [string.string boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
        
        return sizeToFit.height + 0.0;
    }
    else {
            return 0;
        }
}

/// 计算字符串的最低宽度
/// @param string 字符串
/// @param dic 文本属性
/// @param maxwidth 容器最大宽度
+ (CGFloat)computerStringWidthWithString:(NSString *)string attribute:(NSDictionary *)dic maxWidth:(CGFloat)maxwidth {
    CGFloat stringWidth = 0;
    CGSize stringsize = [string sizeWithAttributes:dic];
    if (stringsize.width > maxwidth) {
        stringWidth = maxwidth;
    }
    else {
        stringWidth = stringsize.width;
    }
    
    return stringWidth;
}

/// 计算字符串的最低高度
/// @param string 字符串
/// @param dic 文本属性
/// @param width 容器宽度
+ (CGFloat)computeAttributedStringSizeWithTargetString:(NSString *)string attribute:(NSDictionary *)dic tvWidth:(CGFloat)width {
    CGFloat __block hh = 0;
    if ([string containsString:@"\n"]) {
        BOOL haveline = ([dic valueForKey:NSParagraphStyleAttributeName] != nil);
        NSArray *words = [self seekSubStringArrayWithTarget:string partyString:@"\n"];
        [words enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *word = obj;
            if ([word isKindOfClass:[NSString class]]) {
                hh += (([self computeAttributedStringHeightWithString:[[NSAttributedString alloc] initWithString:word attributes:dic] tvWidth:width] - 16.0) + haveline*10.0);
            };
        }];
    }
    else {
        hh = [self computeAttributedStringHeightWithString:[[NSAttributedString alloc] initWithString:string attributes:dic] tvWidth:width];
    }
    
    return hh;
}

/// 计算字符串中中文和英文字符数
/// @param str 字符串
+ (NSDictionary *)computeWordCountsWithString:(NSString *)str {
    int count_EN = 0;
    int count_CN = 0;
    int count_ALL = 0;
    for (int i=0; i<str.length; i++) {
        unichar c = [str characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5) {
            count_CN++;
        }
        else {
            count_EN++;
        }
    }
    count_ALL = (count_EN + count_CN);
    
    return @{@"Count_CN":kTransformStringWithInt(count_CN),@"Count_EN":kTransformStringWithInt(count_EN),@"Count_ALL":kTransformStringWithInt(count_ALL)};
}

/// 判断是否是正常手机号码
/// @param number 手机号码
+ (BOOL)isPhoneNumberWithNumber:(NSString *)number {
    NSString *numberstring = kStringTransform(number);
    BOOL isLength = numberstring.length == 11;
    if (isLength) {
        NSDictionary *resultdic = [self computeWordCountsWithString:numberstring];
        if ([[self formatIntegerWithObject:resultdic[@"Count_CN"]] integerValue] > 0) {
            return NO;
        }
    }
    else {
        return NO;
    }
    NSString *secondstr = isLength?[number substringWithRange:NSMakeRange(1, 1)]:@"";
    NSArray *numbers = @[@"1",@"2",@"0"];
    return ([numberstring hasPrefix:@"1"] && ![numbers containsObject:secondstr]);
}

/// 判断是否包含换行符
/// @param str 字符串
+ (BOOL)isNewLineString:(NSString *)str {
    NSCharacterSet *set = [NSCharacterSet newlineCharacterSet];
    NSString *string = [str stringByTrimmingCharactersInSet:set];
    return (string.length == 0);
}

/// 判断是否包含空格
/// @param str 字符串
+ (BOOL)isWhiteSpaceString:(NSString *)str {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSString *string = [str stringByTrimmingCharactersInSet:set];
    return (string.length == 0);
}

/// 从字符串中删除空格
/// @param string 字符串
+ (NSString *)removeSpaceFromString:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/// 从字符串中删除空格和回车
/// @param string 字符串
+ (NSString *)removeWhitespaceAndNewlineCharacterSetFromString:(NSString *)string {
    if (string == nil || [string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return [NSStringFormat(@"%@",string) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/// 将字符串中指定子字符串替换成特定字符串
/// @param rstring 用于替换的特定字符串
/// @param rmstring 被替换指定子字符串
/// @param tstring 字符串
+ (NSString *)replaceString:(NSString *)rstring removestring:(NSString *)rmstring targetString:(NSString *)tstring {
    return [tstring stringByReplacingOccurrencesOfString:rmstring withString:rstring];
}

/// 将字符串中指定位置的子字符串替换成特定字符串
/// @param rstring 用于替换的特定字符串
/// @param rmrange 指定位置
/// @param tstring 字符串
+ (NSString *)replaceString:(NSString *)rstring removeRange:(NSRange)rmrange targetString:(NSString *)tstring {
    NSString *rmstr = @"";
    if ((rmrange.length + rmrange.location) > tstring.length) {
        rmstr = [tstring substringWithRange:NSMakeRange(rmrange.location, tstring.length - rmrange.location)];
    }
    else {
        rmstr = [tstring substringWithRange:rmrange];
    }
    return [tstring stringByReplacingOccurrencesOfString:rmstr withString:rstring];
}

/// 从指定字符串中根据特定字符串分解出子字符串数组
/// @param str 指定字符串
/// @param partyStr 特定字符串
+ (NSMutableArray *)seekSubStringArrayWithTarget:(NSString *)str partyString:(NSString *)partyStr {
    NSArray *strs = [NSArray array];
    if ([str containsString:partyStr]) {
        strs = [str componentsSeparatedByString:partyStr];
    }
    else if(str.length > 0) {
        strs = @[str];
    }
    
    NSMutableArray *substrs = [NSMutableArray arrayWithArray:strs];
    return substrs;
}

/// 将指定字符串逐一字符分解为字符串数组
/// @param str 指定字符串
+ (NSMutableArray *)recieveSubStringArrayWithTarget:(NSString *)str {
    NSMutableArray *strList = [NSMutableArray array];
    if (str.length > 0) {
        for (int i=0; i<str.length; i++) {
            [strList addObject:[str substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return strList;
}

/// 将字符串数组中的各字符串拼接成一个字符串
/// @param strarray 字符串数组
+ (NSString *)joinStringArray:(NSArray<NSString *>*)strarray {
    NSString *str = @"";
    for (NSString *st in strarray) {
        if (![self checkTargetStringIsNil:st]) {
            str = [str stringByAppendingString:st];
        }
    }
    
    return str;
}

/// 将字符串数组中的各字符串使用特定字符串（markstr）拼接成一个字符串
/// @param objects 字符串数组
/// @param markstr 特定字符串
+ (NSString *)joinArrayObjectsToString:(NSArray<NSString *> *)objects withMark:(NSString *)markstr {
    NSMutableString __block *objectstring = [NSMutableString string];
    [objects enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self checkTargetStringIsNil:obj]) {
            [objectstring appendString:obj];
            if (idx < ([objects count] - 1) ) {
                [objectstring appendString:markstr];
            }
        }
    }];
    return objectstring;
}

/// 格式化数据为“限制值+”的形式字符串
/// @param object 需要被格式化的数据
/// @param limitnumber 限制值
+ (NSString *)formatMoreFormWithCountObject:(id)object limit:(NSInteger)limitnumber {
    NSString *newstr = @"";
    
    if ([object isKindOfClass:[NSNumber class]]) {
        if ([object integerValue] > limitnumber) {
            newstr = NSStringFormat(@"%ld+",limitnumber);
        }
        else {
            newstr = NSStringFormat(@"%@",object);;
        }
    }
    else if ([object isKindOfClass:[NSString class]]) {
        if ([object integerValue] > limitnumber) {
            newstr = NSStringFormat(@"%ld+",limitnumber);
        }
        else {
            newstr = object;
        }
    }
    
    return newstr;
}

/// 判断本地版本是否小于给定版本以及是否支持该系统版本
/// @param appversion 给定版本
/// @param minimumOsVersion 最低支持系统版本
+ (BOOL)judgeAppVersionShouldUpdateWithDataFromAppStore:(NSString *)appversion  minimumOsVersion:(NSString *)minimumOsVersion {
    return (!DoubleStringCompare(kAPPVersionString, appversion) && [self appVersionIsLittleThanVersionFromAppStore:appversion] && ([AppDeviceSystemVersion floatValue] >= [minimumOsVersion floatValue]));
}

/// 判断本地版本是否小于给定版本
/// @param appversion 给定版本
+ (BOOL)appVersionIsLittleThanVersionFromAppStore:(NSString *)appversion {
    NSMutableArray *appversions = [self seekSubStringArrayWithTarget:kAPPVersionString partyString:@"."];
    NSMutableArray *appstoreversions = [self seekSubStringArrayWithTarget:appversion partyString:@"."];
    
    NSInteger appvcount = appversions.count;
    NSInteger appstorevcount = appstoreversions.count;
    
    for (int i=0; i<MIN(appvcount, appstorevcount); i++) {
        NSInteger app = [appversions[i] integerValue];
        NSInteger appstore = [appstoreversions[i] integerValue];
        if (app < appstore) {
            return YES;
        }
        else if(app > appstore) {
            return NO;
        }
    }
    
    if (appvcount < appstorevcount) {
        return YES;
    }
    else {
        return NO;
    }
}

/// 在字符串两端加上图片
/// @param himg 头图片
/// @param eimg 尾图片
/// @param himgrect 头图片尺寸
/// @param eimgrect 尾图片尺寸
/// @param string 字符串
/// @param attrs 文本格式属性字典
+ (NSMutableAttributedString *)appendImgAtDoubleSideWithHeadImgName:(id)himg endImgName:(id)eimg headrect:(CGRect)himgrect endrect:(CGRect)eimgrect string:(NSString *)string stringAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    NSTextAttachment *htextAttachment = [NSTextAttachment new];
    UIImage *himgobject;
    if ([himg isKindOfClass:[NSString class]]) {
        himgobject = ImageByName(himg);
    }
    else if ([himg isKindOfClass:[UIImage class]]) {
        himgobject = himg;
    }
    
    [htextAttachment setImage:himgobject];
    htextAttachment.bounds = himgrect;
    
    NSTextAttachment *etextAttachment = [NSTextAttachment new];
    UIImage *eimgobject;
    if ([eimg isKindOfClass:[NSString class]]) {
        eimgobject = ImageByName(eimg);
    }
    else if ([eimg isKindOfClass:[UIImage class]]) {
        eimgobject = eimg;
    }
    
    [etextAttachment setImage:eimgobject];
    etextAttachment.bounds = eimgrect;
    
    NSMutableAttributedString *objectstr = [NSMutableAttributedString new];
    [objectstr appendAttributedString:[NSAttributedString attributedStringWithAttachment:htextAttachment]];
    [objectstr appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:attrs]];
    [objectstr appendAttributedString:[NSAttributedString attributedStringWithAttachment:etextAttachment]];
    
    return objectstr;
}

/// 在字符串头端加上图片
/// @param img 图片
/// @param imgrect 图片尺寸
/// @param string 字符串
/// @param attrs 文本格式属性字典
+ (NSMutableAttributedString *)appendImgAtHeadWithImgName:(id)img imgrect:(CGRect)imgrect string:(NSString *)string stringAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    NSTextAttachment *textAttachment = [NSTextAttachment new];
    UIImage *imgobject;
    if ([img isKindOfClass:[NSString class]]) {
        imgobject = ImageByName(img);
    }
    else if ([img isKindOfClass:[UIImage class]]) {
        imgobject = img;
    }
    
    [textAttachment setImage:imgobject];
    textAttachment.bounds = imgrect;
    
    NSMutableAttributedString *objectstr = [NSMutableAttributedString new];
    [objectstr appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
    [objectstr appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:attrs]];
    
    return objectstr;
}

/// 在字符串末端加上图片
/// @param img 图片
/// @param imgrect 图片尺寸
/// @param string 字符串
/// @param attrs 文本格式属性字典
+ (NSMutableAttributedString *)appendImgAtEndWithImgName:(id)img imgrect:(CGRect)imgrect string:(NSString *)string stringAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:string attributes:attrs];
    NSTextAttachment *textAttachment = [NSTextAttachment new];
    UIImage *imgobject;
    if ([img isKindOfClass:[NSString class]]) {
        imgobject = ImageByName(img);
    }
    else if ([img isKindOfClass:[UIImage class]]) {
        imgobject = img;
    }
    [textAttachment setImage:imgobject];
    textAttachment.bounds = imgrect;
    [astr appendAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
    
    return astr;
}

/// 在字符串两端加删除线
/// @param word 字符串
/// @param attrs 文本格式属性字典
+ (NSMutableAttributedString *)appendLineOnWitherSideOfWords:(NSString *)word stringAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    NSMutableDictionary *attdic = [NSMutableDictionary dictionaryWithDictionary:attrs];
    [attdic setValuesForKeysWithDictionary:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrokeColorAttributeName:attrs[NSForegroundColorAttributeName]}];
    
    return [[NSMutableAttributedString alloc] initWithString:word attributes:attdic];
}

/// 将图片转化为Base64字符串
/// @param image 图片
+ (NSString *)obtainBase64CodeStringFromImage:(UIImage *)image {
    if (image == nil) {
        return @"";
    }
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *encodedImageStr = [self obtainBase64CodeStringFromData:data];
    
    return encodedImageStr;
}

/// 将数据转化为Base64字符串
/// @param data 数据
+ (NSString *)obtainBase64CodeStringFromData:(NSData *)data {
    if (data == nil) {
        return @"";
    }
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

/// 对URL字符串进行编码
/// @param str URL字符串
+ (NSString *)URLEncodedString:(NSString *)str {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [NSStringFormat(@"%@",str) stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedString;
}

/// 对已编码URL字符串进行解码
/// @param str 已编码URL字符串
+ (NSString *)URLDecodedString:(NSString *)str {
    NSString *decodedString = [NSStringFormat(@"%@",str) stringByRemovingPercentEncoding];
    return decodedString;
}

/// 查询字符串中存在多少个目标字符串
/// @param targetString 被查询字符串
/// @param word 目标字符串
+ (NSInteger)queryWordCountInTargetString:(NSString *)targetString word:(NSString *)word {
    NSInteger count = 0;
    if ([kStringTransform(targetString) containsString:kStringTransform(word)]) {
        MyCustomLog(@"\n targetString = %@\n",targetString);
        while ([kStringTransform(targetString) containsString:kStringTransform(word)]) {
            count++;
            NSRange range = [targetString rangeOfString:word];
            targetString = [targetString stringByReplacingCharactersInRange:range withString:@""];
            MyCustomLog(@"\n Replaced targetString = %@\nCount = %ld\n",targetString,count);
        }
    }
    return count;
}












#pragma mark ----------------------------------------------------- Array About Method -----------------------------------------------------
/// 目标对象<object>是否存在于数组<array>中
/// @param array 被查询数组
/// @param object 查询对象
+ (BOOL)objectIsExistInArray:(NSArray *)array object:(id)object {
    BOOL __block isExist = NO;
    if (kClassJudgeByName(array, NSArray)) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([object containsString:obj]) {
                isExist = YES;
            };
        }];
    }
    return isExist;
}

/// 两数组中的元素是否完全相同
/// @param one 数组1
/// @param other 数组2
+ (BOOL)arrayObjectEqualWithOne:(NSArray *)one other:(NSArray *)other {
    BOOL isEqual = NO;
    if(kClassJudgeByName(one, NSArray) && kClassJudgeByName(other, NSArray)) {
        isEqual = (one.count > 0 && one.count == other.count);
        if(isEqual) {
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",one];
            // 得到两个数组中不同的数据
            NSArray *reslutFilteredArray = [other filteredArrayUsingPredicate:filterPredicate];
            isEqual = reslutFilteredArray. count == 0;
        }
    }
    return isEqual;
}

/// 数组1里不同于数组2的元素集合
/// @param one 数组1
/// @param other 数组2
+ (NSMutableArray *)differentObjectsInOne:(NSArray *)one betweenOther:(NSArray *)other {
    NSMutableArray *A = [NSMutableArray arrayWithArray:one];
    NSMutableArray *B = [NSMutableArray arrayWithArray:other];
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(SELF IN %@)",one];
    // 得到两个数组中不同的数据
    NSArray *reslutFilteredArray = [B filteredArrayUsingPredicate:filterPredicate];
    
    [reslutFilteredArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [A removeObject:obj];
    }];
    
    return A;
}

/// 数组排序
/// @param datas 目标数组
/// @param isNormal 是否生序
+ (NSArray *)arrayNormalSortWithDatas:(NSArray *)datas isNormal:(BOOL)isNormal {
    if (!kClassJudgeByName(datas, NSArray)) {
        return @[];
    }
    NSArray *sortArrays = [datas sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    if (isNormal) {
        return sortArrays;
    }
    else {
        NSArray *arr = [[sortArrays reverseObjectEnumerator] allObjects];
        MyCustomLog(@"\ndatas = %@\nsortArrays = %@\nArrays = %@\n",datas,sortArrays,arr);
        return arr;
    }
}





#pragma mark ----------------------------------------------------- Spell Method -----------------------------------------------------
/// 获取首字母(大写)
/// @param object 指定字符串
+ (NSString *)firstSpellOfStringObject:(NSString *)object {
    NSMutableString *ms = [[NSMutableString alloc] initWithString:object];
    //带声仄 //不能注释掉
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformMandarinLatin, NO)) {
        //NSLog(@"pinyin: ---- %@", ms);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics, NO)) {
        NSString *bigStr = [ms uppercaseString]; // bigStr 是转换成功后的拼音
        NSString *cha = [bigStr substringToIndex:1];
        
        return cha;
    }
    return @"";
}

/// 获取给定字符串的拼音字母（大写）
/// @param object 给定字符串
+ (NSString *)objectUppercaseSpellOfStringObject:(NSString *)object {
    NSMutableString *ms = [[NSMutableString alloc] initWithString:object];
    //带声仄 //不能注释掉
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformMandarinLatin, NO)) {
        //NSLog(@"pinyin: ---- %@", ms);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics, NO)) {
        NSString *bigStr = [ms uppercaseString]; // bigStr 是转换成功后的拼音
        
        return [bigStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return @"";
}

/// 将给定字符串数组的各项转化为对应的拼音字母（大写）
/// @param objects 给定字符串数组
+ (NSMutableArray *)transluteObjectsSpellsWithObjects:(NSArray <NSString *> *)objects {
    NSMutableArray *spells = [NSMutableArray array];
    
    for (id object in objects) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSMutableArray *subArray = [NSMutableArray array];
            
            for (NSString *objc in object) {
                [subArray addObject:[self objectUppercaseSpellOfStringObject:objc]];
            }
            
            [spells addObject:subArray];
        }
        else {
                [spells addObject:[self objectUppercaseSpellOfStringObject:object]];
            }
    }
    
    return spells;
}

/// 将给定字符串数组根据中文拼音排序
/// @param list 给定字符串数组
+ (NSMutableDictionary *)sortByChineseSpellInList:(NSArray <NSString *> *)list {
    NSMutableArray *firstSpells = [NSMutableArray array];
    NSMutableDictionary *sortDic = [NSMutableDictionary dictionary];
    NSMutableArray *groups = [NSMutableArray array];
    NSInteger k=0;
    for (NSString *chineseStr in list) {
        k++;
        NSMutableString *ms = [[NSMutableString alloc] initWithString:chineseStr];
        //带声仄 不能注释掉
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformMandarinLatin, NO)) {
            //NSLog(@"pinyin: ---- %@", ms);
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0,kCFStringTransformStripDiacritics, NO)) {
            NSString *bigStr = [ms uppercaseString]; // bigStr 是转换成功后的拼音
            NSString *cha = [bigStr substringToIndex:1];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[sortDic valueForKey:cha]];
            
            if (array && (array.count > 0)) {
                [array addObject:chineseStr];
                [sortDic setObject:array forKey:cha];
            }
            else
                {
                    array = [NSMutableArray arrayWithObject:chineseStr];
                    [sortDic setObject:array forKey:cha];
                    [firstSpells addObject:cha];
                }
        }
    }
    
    NSMutableArray *newss = [NSMutableArray arrayWithArray:[firstSpells sortedArrayUsingSelector:@selector(compare:)]];
    
    for (NSString *newSpell in newss) {
        [groups addObject:sortDic[newSpell]];
    }
    
    return [self listSorting:groups spells:newss];
}

/// 将给定字符串数组根据中文拼音排序并将整理好的数据放入字典返回
/// @param modelArr 给定字符串数组
/// @param spells 给定拼音数组
+ (NSMutableDictionary *)listSorting:(NSMutableArray *)modelArr spells:(NSMutableArray *)spells {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    for(int i='A';i<='Z';i++) {
           NSMutableArray *rulesArray = [[NSMutableArray alloc] init];
           NSString *str1=[NSString stringWithFormat:@"%c",i];
           for(int j=0;j<modelArr.count;j++) {
                  NSArray *citygroup = [modelArr objectAtIndex:j];
                   NSString *key = [spells objectAtIndex:j];
                  if([key isEqualToString:str1]) {
                        [rulesArray addObject:citygroup];
                        [array addObject:citygroup];//把首字母相同的model 放到同一个数组里面
                        [spells removeObject:key];
                        [modelArr removeObject:citygroup];//model 放到 rulesArray 里面说明这个model 已经拍好序了 所以从总的modelArr里面删除
                         j--;
                     }
               }
            if (rulesArray.count >0) {
                [indexArray addObject:[NSString stringWithFormat:@"%c",i]]; //把大写字母也放到一个数组里面
            }
      }
    if (modelArr.count !=0) {
        NSMutableArray *others = [NSMutableArray array];
        for (NSArray *citys in modelArr) {
            [others addObjectsFromArray:citys];
        }

        [array addObject:others];
        [indexArray addObject:@"#"]; //把首字母不是A~Z里的字符全部放到 array里面 然后返回
    }
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:indexArray,@"Keys",array,@"CityGroup", nil];
}






#pragma mark ----------------------------------------------------- Security Method -----------------------------------------------------
/// 字符串加密
/// @param string 字符串
+ (NSString *)configSecurityWithString:(NSString *)string isSHA256:(BOOL)isSHA256 {
    if (!string) {
        return nil;
    }

    if (isSHA256) {
        return [self configSHA256WithString:string];
    }
    else {
        const char *cStr = string.UTF8String;
        unsigned char result[CC_MD5_DIGEST_LENGTH];

        CC_MD5(cStr, (CC_LONG)strlen(cStr), result);

        NSMutableString *md5Str = [NSMutableString string];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
            [md5Str appendFormat:@"%02x", result[i]];
        }
        return [md5Str lowercaseString];
    }
}

/// 字符串SHA加密
/// @param string 字符串
+ (NSString *)configSHA256WithString:(NSString *)string {
    if (!string) {
        return nil;
    }
    
    const char *s = [string cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *outdata = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [outdata description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hash;
}


#pragma mark ----------------------------------------------------- Date About Method -----------------------------------------------------
///设置日期格式
/// @param format 日期格式
+ (NSDateFormatter *)setupDateFormatterByType:(DateFormatType)format {
    NSString *formatStr = @"";
    switch (format) {
        case DateFormatTypeDefault:
            formatStr = @"yyyy-MM-dd HH:mm:ss zzz";
            break;
            
        case DateFormatTypeDate:
            formatStr = @"yyyy-MM-dd";
            break;
            
        case DateFormatTypeDateAndTime:
            formatStr = @"yyyy-MM-dd HH:mm:ss";
            break;
            
        case DateFormatTypeTimeDefault:
            formatStr = @"HH:mm:ss";
            break;
            
        case DateFormatTypeTimeHourAndMinute:
            formatStr = @"HH:mm";
            break;
            
        case DateFormatTypeName:
            formatStr = @"yyyyMMddHHmmss";
            break;
            
        case DateFormatTypeYYMM:
            formatStr = @"yyyy-MM";
            break;
            
        case DateFormatTypeMMDDTime:
            formatStr = @"MM-dd HH:mm:ss";
            break;
            
        case DateFormatTypeDD:
            formatStr = @"dd";
            break;
            
        case DateFormatTypeYY:
            formatStr = @"yyyy";
            break;
            
        case DateFormatTypeDateAndHHMM:
            formatStr = @"yyyy-MM-dd HH:mm";
            break;
            
        case DateFormatTypeMMDDHHMM:
            formatStr = @"MM-dd HH:mm";
            break;
            
        case DateFormatTypeMM:
            formatStr = @"MM";
            break;
            
        case DateFormatTypeMMDD:
            formatStr = @"MM-dd";
            break;
        default:
            formatStr = @"yyyyMMddHHmm";
            break;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatStr];
    return dateFormat;
}

/// 根据给定格式将指定日期转化为字符串
/// @param date 日期
/// @param type 给定格式
+ (NSString *)dateTransformToString:(NSDate *)date type:(DateFormatType)type {
    return [[self setupDateFormatterByType:type] stringFromDate:date];
}

/// 根据给定格式将当前日期转化为字符串
/// @param type 格式
+ (NSString *)currentDateTransformToStringByType:(DateFormatType)type {
    return [[self setupDateFormatterByType:type] stringFromDate:[NSDate date]];
}

/// 获取当前日期
/// @param type 格式
+ (NSDate *)currentDateByType:(DateFormatType)type {
    return [[self setupDateFormatterByType:type] dateFromString:[self currentDateTransformToStringByType:type]];
}

/// 将指定日期字符串格式化为日期格式
/// @param dateStr 指定日期字符串
/// @param type 格式
+ (NSDate *)stringFormatToDate:(NSString *)dateStr type:(DateFormatType)type {
    return [[self setupDateFormatterByType:type] dateFromString:dateStr];
}

/// 计算两个日期的间隔（单位 秒）
/// @param dateOne 日期字符串1
/// @param dateOther 日期字符串2
+ (NSString *)timeIntervalOfDoubleDate:(NSString *)dateOne otherDate:(NSString *)dateOther {
    NSDate *theDate = [self stringFormatToDate:dateOne type:DateFormatTypeDateAndTime];
    NSDate *otherDate = [self stringFormatToDate:dateOther type:DateFormatTypeDateAndTime];
    return NSStringFormat(@"%f",[theDate timeIntervalSinceDate:otherDate]);
}

/// 计算指定与当前时间之间的间隔（单位 秒）
/// @param dateString 指定日期字符串
+ (NSString *)timeIntervalOfCurrnetAndDateString:(NSString *)dateString {
    NSDate *theDate = [self stringFormatToDate:dateString type:DateFormatTypeDateAndTime];
    NSDate *nowDate = [NSDate date];
    return NSStringFormat(@"%f",[theDate timeIntervalSinceDate:nowDate]);
}

/// 长整型数字转化为字符串
/// @param number 长整型数字
+ (NSString *)integerTransformToString:(NSInteger)number {
    return [NSString stringWithFormat:@"%ld",number];
}

/// 将时间间隔（s）格式化为天时分秒信息集合
/// @param seconds 时间间隔
/// @param hasDay 是否转换天数
+ (NSMutableDictionary *)timeIntervalTransformToTimeInformation:(NSInteger)seconds hasDay:(BOOL)hasDay {
    NSMutableDictionary *timeDictionary = [NSMutableDictionary dictionary];

    NSInteger day = 0;
    NSString *dayStr = @"";
    if (hasDay) {
        day = seconds/(3600*24);
        dayStr = [self integerTransformToString:day];
    }
    
    NSInteger hour = 0;
    if (hasDay) {
        hour = (seconds%(3600*24))/3600;
    }
    else {
        hour = seconds/3600;
    }
    NSString *hourStr = hour >= 10 ? [self integerTransformToString:hour] : NSStringFormat(@"0%ld",hour);
    NSInteger minutes = (seconds%3600)/60;
    NSString *minuteStr = minutes >=10 ? [self integerTransformToString:minutes] : NSStringFormat(@"0%ld",minutes);
    NSInteger secondes = seconds%60;
    NSString *secondStr = secondes >=10 ?[self integerTransformToString:secondes] : NSStringFormat(@"0%ld",secondes);
    
    [timeDictionary setValue:dayStr forKey:@"Day"];
    [timeDictionary setValue:hourStr forKey:@"Hours"];
    [timeDictionary setValue:minuteStr forKey:@"Minutes"];
    [timeDictionary setValue:secondStr forKey:@"Seconds"];
    
    return [timeDictionary copy];
}

/// 将时间间隔（s）格式化为天时分秒字符串
/// @param seconds 时间间隔
/// @param hasDay 是否转换天数
+ (NSString *)transformTimeStringWithSeconds:(NSInteger)seconds hasDay:(BOOL)hasDay {
    NSDictionary *timeDic = [self timeIntervalTransformToTimeInformation:seconds hasDay:hasDay];
    if (hasDay) {
        return NSStringFormat(@"%@天 %@:%@:%@",timeDic[@"Day"],timeDic[@"Hours"],timeDic[@"Minutes"],timeDic[@"Seconds"]);
    }
    else {
        return NSStringFormat(@"%@:%@:%@",timeDic[@"Hours"],timeDic[@"Minutes"],timeDic[@"Seconds"]);
    }
}

/// 以双精度浮点型形式返回当前时间戳
+ (NSTimeInterval)currentTimeStampIntervalSince1970 {
    return [[NSDate date] timeIntervalSince1970];
}

/// 以双精度浮点型形式返回当前时间戳（毫秒级）
+ (NSTimeInterval)currentTimeStampIntervalMilliSecondsSince1970 {
    return [[NSDate date] timeIntervalSince1970]*1000;
}

/// 以字符串形式返回当前时间戳
+ (NSString *)currentTimeStamp {
    return NSStringFormat(@"%.f",[self currentTimeStampIntervalSince1970]);
}

/// 以双精度浮点型形式返回指定日期字符串的时间戳
/// @param date 指定日期字符串
/// @param type 日期格式
+ (NSTimeInterval)transformDateTimeStampIntervalWithDate:(NSString *)date type:(DateFormatType)type {
    NSDate *timedate = [self stringFormatToDate:date type:type];
    return [timedate timeIntervalSince1970];
}

/// 以字符串形式返回指定日期字符串的时间戳
/// @param date 指定日期字符串
/// @param type 日期格式
+ (NSString *)transformDateTimeStampWithDate:(NSString *)date type:(DateFormatType)type {
    return NSStringFormat(@"%.f",[self transformDateTimeStampIntervalWithDate:date type:type]);
}

/// 将时间戳转日期字符串
/// @param secs 指定时间戳
/// @param type 日期格式
+ (NSString *)transformDateStringFromTimeInterval:(NSTimeInterval)secs type:(DateFormatType)type {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    return [self dateTransformToString:date type:type];
}

/// 将时间戳转日期
/// @param secs 指定时间戳
/// @param type 日期格式
+ (NSDate *)transformDateFromTimeInterval:(NSTimeInterval)secs type:(DateFormatType)type {
    return [self stringFormatToDate:[self transformDateStringFromTimeInterval:secs type:type] type:type];
}

/// 根据指定日期转化日期信息（Date:xx月xx日、Week:周几）
/// @param date 指定日期
+ (NSDictionary *)transformDateInfoByDate:(NSDate *)date {
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return @{@"Date":[SmartBWAuxiliaryMeansManager dateTransformToString:date type:DateFormatTypeMMDD],@"Week":kStringTransform([weekday objectAtIndex:theComponents.weekday])};
}

/// 根据指定日期列表转化日期信息列表（@{Date:xx月xx日、Week:周几}）
/// @param dateList 指定日期
+ (NSArray *)transformDateInfoListByDateList:(NSArray *)dateList  {
    NSMutableArray *list = [NSMutableArray array];
    if(kClassJudgeByName(dateList, NSArray)) {
        [dateList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [list addObject:[SmartBWAuxiliaryMeansManager transformDateInfoByDate:obj]];
        }];
    }
    
    return list;
}

/// 根据指定日期列表转化日期信息列表（@{Date:xx月xx日、Week:周几}）
/// @param date 对标日期
/// @param isNext 是否是指定日期及以后
/// @param day 范围天数
+ (NSArray *)transformDateListByDate:(NSDate *)date isNext:(BOOL)isNext day:(NSInteger)day {
    NSMutableArray *list = [NSMutableArray arrayWithObject:date];
    NSTimeInterval datetime = [date timeIntervalSince1970];
    NSInteger dta = -1 + isNext*2;
    for (int i=0; i<(day - 1); i++) {
        datetime = datetime + dta*(24*3600);
        [list addObject:[SmartBWAuxiliaryMeansManager transformDateFromTimeInterval:datetime type:DateFormatTypeDate]];
    }
    
    return list;
}

#pragma mark ----------------------------------------------------- Other Method -----------------------------------------------------
/// 初始化导航控制器
/// @param rootViewController 根视图控制器
/// @param imageNormalName 常规图片名
/// @param imageHighName 高亮图片名
+ (UINavigationController *)configNavigationControllerWithRootViewController:(UIViewController *)rootViewController title:(NSString *)title normalItemImageName:(NSString *)imageNormalName highItemImageName:(NSString *)imageHighName {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    if (imageNormalName.length > 0 && imageHighName.length > 0) {
        [nc setTabBarItem:[[UITabBarItem alloc] initWithTitle:kStringTransform(title) image:ImageByName(kStringTransform(imageNormalName)) selectedImage:ImageByName(kStringTransform(imageHighName))]];
    }
    return nc;
}

/// 初始化TabBar控制器
/// @param infos 控制器信息数组
+ (UITabBarController *)configTabBarControllerWithRootViewControllereInfos:(NSArray *)infos {
    UITabBarController *tabBarController = [UITabBarController new];
    NSMutableArray *vcs = [NSMutableArray array];
    if (kClassJudgeByName(infos, NSArray)) {
        [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *info = (NSDictionary *)obj;
            [vcs addObject:[self configNavigationControllerWithRootViewController:info[@"vc"] title:kStringTransform(info[@"title"]) normalItemImageName:kStringTransform(info[@"image_n"]) highItemImageName:kStringTransform(info[@"image_s"])]];
        }];
        
        [tabBarController setViewControllers:vcs];
        tabBarController.selectedIndex = FirstIndex;
    }
    
    return tabBarController;
}

/// 配置通用导航栏和工具栏信息
+ (void)configUniversalNavigationBarAndTabBar {
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kColorByHexString(@"#999999"),NSFontAttributeName:SystemFont(12)} forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:SystemFont(12)} forState:UIControlStateSelected];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:SystemFont(20),NSStrokeColorAttributeName:[UIColor whiteColor]}];
//    [[UITabBar appearance] setBackgroundColor:kWhiteColor];
}










#pragma mark **************************************************** Third Part Method ****************************************************
/// 打开qq群
/// - Parameters:
///   - keystring: ios Key
///   - number: teamNumber
+ (void)qqTeamOpenByIOSKey:(NSString *)keystring teamNumber:(NSString *)number {
    NSString *str = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external&jump_from=webapi",number, keystring];
    [SmartBWAuxiliaryMeansManager openByApplication:str];
}

/// 清除缓存
+ (void)cleanCache {
    NSSet *dataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:dataTypes modifiedSince:fromDate completionHandler:^{
        ;
    }];
    
}

/// 注册网络状态监听
+ (void)deviceNetworkMonitorRegisterNotification {
    [SmartBWCacheManager sharedCacheTool].deviceNetworkStatusNormal = NO;
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [networkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                //网络连接断开
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                //网络已连接 之后发送通知
                [AppNotificationCenter postNotificationName:DeviceNetworkStatusNotification object:nil userInfo:nil];
            }
                break;
                
            default:
                break;
        }
    }];
    [networkReachabilityManager startMonitoring];
}

/// 移除网络状态监测
+ (void)deviceNetworkMonitorRemoveNotification {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [SmartBWCacheManager sharedCacheTool].deviceNetworkStatusNormal = YES;
}




#pragma mark **************************************************** Image About Method ****************************************************
/// 获取相册授权状态
/// @param passblock 取得授权后的响应
+ (void)requestPhotoPrivacyBeforeBlock:(CommonCompletion)passblock {
    // 获取授权状态
    PHAuthorizationStatus status;
    if (@available(iOS 14.0,*)) {
        status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    }
    else {
        status = [PHPhotoLibrary authorizationStatus];
    }
    switch (status) {
        case PHAuthorizationStatusDenied:{
            [AppMainWindow showAutoHudWithText:@"您已经拒绝了应用程序对相册的访问"];
        }
            break;
            
        case PHAuthorizationStatusAuthorized:
        case PHAuthorizationStatusLimited:{
            !passblock?:passblock();
        }
            break;
            
        case PHAuthorizationStatusNotDetermined:{
            [self dispatchAuthorizationForAccesslevelBeforeBlock:passblock];
        }
            
        default:
            break;
    }
}

/// 获取相册授权
/// @param passblock 取得授权后的响应
+ (void)dispatchAuthorizationForAccesslevelBeforeBlock:(CommonCompletion)passblock {
    if (@available(iOS 14.0,*)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusDenied:{
                    [AppMainWindow showAutoHudWithText:@"您已经拒绝了应用程序对相册的访问"];
                }
                    break;
                    
                case PHAuthorizationStatusAuthorized:
                case PHAuthorizationStatusLimited:{
                    !passblock?:passblock();
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
    else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusDenied:{
                    [AppMainWindow showAutoHudWithText:@"您已经拒绝了应用程序对相册的访问"];
                }
                    break;
                    
                case PHAuthorizationStatusAuthorized:{
                    !passblock?:passblock();
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
    
    
}


/// 生成指定尺寸的二维码
/// - Parameters:
///   - string: 指定内容
///   - size: 指定尺寸
+ (UIImage *)createQRCodeByString:(NSString *)string size:(CGFloat)size {
    if (string && string.length > 0) {
        //创建过滤器
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        //过滤器恢复默认
        [filter setDefaults];
        //给过滤器添加数据<字符串长度893>
        NSString *shareurl = string;
        NSData *data = [shareurl dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [filter setValue:data forKey:@"inputMessage"];
        //获取二维码过滤器生成二维码
        CIImage *image = [filter outputImage];
        UIImage *img = [self clearInterpolatedImageFromCIImage:image size:size];
        return img;
    }
    else {
        return nil;
    }
}

/// 调整图片清晰度
/// - Parameters:
///   - image: 图片
///   - size: 指定尺寸
+ (UIImage *)clearInterpolatedImageFromCIImage:(CIImage *)image size:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //创建bitmap
    size_t width = CGRectGetWidth(extent)*scale;
    size_t height = CGRectGetHeight(extent)*scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //保存图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/// 将两张图片合成一张图片
/// - Parameters:
///   - bgimage: 背景图片
///   - targetimage: 字图片
///   - origin: 字图片位置信息
+ (UIImage *)compoundImageByBackgroundImage:(UIImage *)bgimage targetImage:(UIImage *)targetimage origin:(CGPoint)origin {
    UIGraphicsBeginImageContext(bgimage.size);
    
    // Draw image1
    [bgimage drawInRect:CGRectMake(0, 0, bgimage.size.width, bgimage.size.height)];
    
    // Draw image2
    [targetimage drawInRect:CGRectMake(origin.x, origin.y, targetimage.size.width, targetimage.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

/// 根据滚动式图制作长图
/// - Parameter scrollView: 被制作图片的ScrollView
+ (UIImage *)snapshotByScrollView:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    CGRect frame = scrollView.frame;
    
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, [UIScreen mainScreen].scale);
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    scrollView.contentOffset = contentOffset;
    scrollView.frame = frame;
    
    return image;
}

/// 根据View制作图片
/// @param view 目标View
+ (UIImage *)snapshotByView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// 截屏
+ (UIImage *)snapshotWithScreen {
    UIGraphicsBeginImageContextWithOptions(AppMainWindow.bounds.size, NO, [UIScreen mainScreen].scale);
    [AppMainWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}









@end
