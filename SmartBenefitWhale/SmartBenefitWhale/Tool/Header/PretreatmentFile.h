//
//  PretreatmentFile.h
//  JoyOfWalking
//
//  Created by Yong Zeng on 2023/5/28.
//

#ifndef PretreatmentFile_h
#define PretreatmentFile_h

//其他快捷操作
#define kClassJudgeByName(object,classname)                     [object isKindOfClass:[classname class]]

#define SmartTabBarHeight                                       [SmartBWTabBar tabBarViewHeight]

/// 窗口位置尺寸信息
#define kWindowBounds                                           [UIScreen mainScreen].bounds

/// 窗口宽
#define kWindowWidth                                            [UIScreen mainScreen].bounds.size.width

/// 窗口高
#define kWindowHeight                                           [UIScreen mainScreen].bounds.size.height

/// 窗口安全区域
#define kWindowSafeArea                                         [SmartBWAuxiliaryMeansManager windowSafeArea]

/// 基于Iphone6s宽的长度
#define IP6SW(number)                                           (kWindowWidth * number) / 375.0

/// 基于Iphone6s高的长度
#define IP6SH(number)                                           (kWindowHeight * number) / 667.0

/// 导航栏加状态栏高度
#define kNavigationBarHeight                                    ([UINavigationController new].navigationBar.frame.size.height + kStatusBarHeight)

/// 导航栏高度
#define kNavigationBarContentHeight                             (kNavigationBarHeight - kStatusBarHeight)

/// Tab栏高度
#define kTabBarHeight                                           ([UITabBarController new].tabBar.size.height)

/// 状态栏高度
#define kStatusBarHeight                                        [SmartBWAuxiliaryMeansManager deviceStatusBarHeight]

/// 比例宽度
#define kScreen_X(scale)                                        (kWindowWidth * scale)

/// 比例高度
#define kScreen_Y(scale)                                        (kWindowHeight * scale)

/// iPhone 底部安全高度
#define DeviceBottomSafeHeight                                  [SmartBWAuxiliaryMeansManager deviceBottomSafeHeight]

/// 应用管理器
#define AppApplicationManager                                   [UIApplication sharedApplication]

/// 应用管理器代理
#define AppCycleDelegate                                        ((AppDelegate *)[AppApplicationManager delegate])

/// 应用窗口
#define AppMainWindow                                           [SmartBWAuxiliaryMeansManager appMainWindow]

///通知中心
#define AppNotificationCenter                                   [NSNotificationCenter defaultCenter]

///文件管理中心
#define AppFileManager                                          [NSFileManager defaultManager]

///当前设备
#define AppDevice                                               [UIDevice currentDevice]

///主目录
#define AppBundle                                               [NSBundle mainBundle]

///本地通知中心
#define AppLocalNotificationCenter                              [UNUserNotificationCenter currentNotificationCenter]

///剪切板
#define AppPasteboard                                           [UIPasteboard generalPasteboard]

/// 系统版本
#define AppDeviceNormalSystemVersion                            [AppDevice.systemVersion doubleValue]

/// UUID
#define AppDeviceUUID                                           [[AppDevice identifierForVendor] UUIDString]

/// 用户定义的设备名称
#define AppDeviceName                                           [AppDevice name]

/// 设备系统名称
#define AppDeviceSystemName                                     [AppDevice systemName]

/// 设备系统版本
#define AppDeviceSystemVersion                                  [AppDevice systemVersion]

/// 设备类型（iPhone、iPod touch）
#define AppDeviceModel                                          [AppDevice model]

/// 本地设备模式
#define AppDeviceLocalizedModel                                 [AppDevice localizedModel]

/// APP信息
#define AppInfoDictionary                                       [AppBundle infoDictionary]

/// APP 名称
#define APPName                                                 [AppInfoDictionary objectForKey:@"CFBundleDisplayName"]

/// APP 版本号
#define kAPPVersionString                                       [AppInfoDictionary objectForKey:@"CFBundleShortVersionString"]

/// APP 构建版本号
#define kAPPBuildVersion                                        [AppInfoDictionary objectForKey:@"CFBundleVersion"]

/// 当前语言
#define kCurrentLanguage                                        ([[NSLocale preferredLanguages] objectAtIndex:0])



// 常规颜色
#define kClearColor                                             [UIColor clearColor] //clear
#define kWhiteColor                                             [UIColor whiteColor] //white
#define kBlackColor                                             [UIColor blackColor] //black
#define kGrayColor                                              [UIColor grayColor]   //gray
#define KDarkGrayColor                                          [UIColor darkGrayColor]
#define kCyanColor                                              [UIColor cyanColor]   //cyan
#define kOrangeColor                                            [UIColor orangeColor]    //orange
#define kGray2Color                                             [UIColor lightGrayColor]  //lightGray
#define kGreenColor                                             [UIColor greenColor]      //green
#define kBlueColor                                              [UIColor blueColor]        //blue
#define kRedColor                                               [UIColor redColor]          //red
#define kYellowColor                                            [UIColor yellowColor]    //yellow
#define kMagentaColor                                           [UIColor magentaColor]  //magenta
#define kPurpleColor                                            [UIColor purpleColor]    //purple
#define kBrownColor                                             [UIColor brownColor]      //brown
#define kGrayCustomColor(WHITE,ALPHA)                           [[UIColor alloc] initWithWhite:WHITE alpha:ALPHA]
#define kGrayColorByAlph(WHITE)                                 [[UIColor alloc] initWithWhite:(WHITE/255.f) alpha:1]
#define kCustomColor(RED,GREEN,BLUE,ALPHA)                      [UIColor colorWithRed:(RED/255.f) green:(GREEN/255.f) blue:(BLUE/255.f) alpha:(ALPHA)]
#define kRandomColor                                            [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256.0)/255.0 blue:arc4random_uniform(256.0)/255.0 alpha:arc4random_uniform(256.0)/255.0]//随机色
#define KColorByHEX(rgbValue)                                   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kColorByHexString(rgbstr)                               [SmartBWAuxiliaryMeansManager colorByHexString:kStringTransform(rgbstr)]


///字符串相关
/// 拼接字符串
#define NSStringFormat(format,...)                              [NSString stringWithFormat:format,##__VA_ARGS__]
/// 比较俩字符串
#define DoubleStringCompare(A,B)                                [kStringTransform(A) isEqualToString:kStringTransform(B)]
#define kTransformStringWithInteger(ainteger)                   NSStringFormat(@"%ld",ainteger)
#define kTransformStringWithInt(aint)                           NSStringFormat(@"%d",aint)
#define kTransformValueToString(value)                          NSStringFormat(@"%@",value)


/// 快捷方式
#define kStringTransform(str)                                   [SmartBWAuxiliaryMeansManager transformStringByObject:str]
#define kURL(urlstr)                                            [NSURL URLWithString:[kStringTransform(urlstr) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
#define kPathURL(filepath)                                      [NSURL fileURLWithPath:filepath]
#define kIntegerStringTransform(str)                            [SmartBWAuxiliaryMeansManager transformIntegerStringByObject:str]


/// 字体
#define SystemBoldFont(fontsize)                                [UIFont boldSystemFontOfSize:fontsize]
#define SystemFont(fontsize)                                    [UIFont systemFontOfSize:fontsize]

//String Or SEL转换快捷方式
#define kTransformStringWithSel(sel)                            NSStringFromSelector(sel)
#define kTransformSelWithString(name)                           NSSelectorFromString(name)

/// 随机数
/// 随机整数数字形式
#define kRandomInt(starts,ends)                                 ((int)(starts + (arc4random()%(ends - starts + 1))))
/// 随机整数字符串形式
#define kRandomIntString(starts,ends)                           [NSString stringWithFormat:@"%d",kRandomInt(starts,ends)]

/// 弱/强设置
#define kWeakConfig(type)                                       __weak typeof(type) weak##type = type;
#define kStrongConfig(type)                                     __strong typeof(type) strong##type = type;

/// 度数与角度的转化
/// 角度转化为度
#define kDegreesToRadian(x)                                     (M_PI * (x) / 180.0)
/// 度转化为角度
#define kRadianToDegrees(radian)                                (radian*180.0)/(M_PI)

// 图片
/// 通过名称获取图片
#define ImageByName(imageName)                                  [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
/// 通过路径获取图片
#define ImageByPath(imagePath)                                  [[UIImage imageWithContentsOfFile:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
/// 配置图片RenderingMode
#define ConfigurationRenderingModeIMG(img)                      [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]


/// 自定义打印
#ifdef DEBUG
#define MyCustomLog(FORMAT, ...) fprintf(stderr, "%s:第%d行\n\n\n**********************************************\n%s\n**********************************************\n\n\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String])
#else
#define MyCustomLog(FORMAT, ...) fprintf(stderr, "%s:第%d行\n\n\n**********************************************\n%s\n**********************************************\n\n\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String])
#endif

#endif /* PretreatmentFile_h */
