//
//  SmartBWAuxiliaryMeansManager.h
//  SmartBenefitWhale
//
//  Created by Yong Zeng on 2023/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define DeviceNetworkStatusNotification                             @"DeviceNetworkWifiOr4GConnect"

typedef void(^CommonCompletion)(void);
typedef void(^CommonStatusCompletion)(BOOL success);

typedef NS_ENUM(NSInteger,DateFormatType) {
    DateFormatTypeDefault = 0,
    DateFormatTypeDate,
    DateFormatTypeDateAndTime,
    DateFormatTypeTimeDefault,
    DateFormatTypeTimeHourAndMinute,
    DateFormatTypeName,
    DateFormatTypeYYMM,
    DateFormatTypeMMDDTime,
    DateFormatTypeDD,
    DateFormatTypeYY,
    DateFormatTypeDateAndHHMM,
    DateFormatTypeMMDDHHMM,
    DateFormatTypeMM,
    DateFormatTypeMMDD
};


@interface SmartBWAuxiliaryMeansManager : NSObject

/// 应用窗口
+ (UIWindow *)appMainWindow;

/// 应用窗口边缘安全距离
+ (UIEdgeInsets)windowSafeArea;

/// 设备底部安全高度
+ (CGFloat)deviceBottomSafeHeight;

/// 设备状态栏高度
+ (CGFloat)deviceStatusBarHeight;

/// 应用主线程处理响应
/// - Parameter completion: 处理模块
+ (void)mainThreadComposeCompletion:(CommonCompletion)completion;

/// 应用当前控制器
+ (UIViewController *)windowCurrentViewController;

/// 应用当前控制器
+ (UIViewController *)windowTopViewController;

/// 通过索引打开
/// - Parameter indexstr: 索引
+ (void)openByApplication:(id)indexstr;

#pragma mark ----------------------------------------------------- Tool Method -----------------------------------------------------
/// 对象转换成json字符串
/// @param object 对象
+ (NSString *)objectTransformJsonString:(id)object;

/// json字符串数据转字典或数组
/// @param jsonObject json字符串/数据
+ (id)jsonStringTransformObject:(id)jsonObject;

/// 对象转json字符串
/// @param object 对象数据
+ (NSString *)objectTransformJsonObjectString:(id)object;

/// 项目中是否存在<name>类
/// @param name 类名
+ (BOOL)classIsExistInProjectByName:(NSString *)name;

/// 储存图片到相册
/// @param image 图片
/// @param completion 储存后的回调
+ (void)imageStoreToLibraryWithImage:(UIImage *)image completion:(CommonStatusCompletion)completion;

/// 切换横竖屏
/// @param orientation 屏幕方向
+ (void)changeInterfaceOrientation:(UIInterfaceOrientation)orientation;

/// 颜色详细信息
/// @param originColor 颜色
+ (NSDictionary *)recieveRGBInfoDictionaryByColor:(UIColor *)originColor;

/// 通过Hex获取颜色对象
/// @param hexColor Hex数值
+ (UIColor *)colorWithHexValue:(long)hexColor;

// 通过十六进制数据转换颜色,透明度可调整
+ (UIColor *)colorByHex:(long)hexColor alpha:(float)opacity;

// 通过十六进制字符串转换颜色
+ (UIColor *)colorByHexString:(NSString *)color;

/// View设置渐变色
/// @param originColor 起点颜色
/// @param terminusColor 终点颜色
/// @param view 视图
/// @param size 视图size
/// @param originPoint 起点坐标
/// @param terminusPoint 终点坐标
+ (void)gradientRampOriginColor:(UIColor *)originColor terminusColor:(UIColor *)terminusColor view:(UIView *)view size:(CGSize)size originPoint:(CGPoint)originPoint terminusPoint:(CGPoint)terminusPoint;


/// 储存本地信息
/// @param object 储存对象数组/字典
/// @param filepath 储存路径
+ (BOOL)storeFileWithObject:(id)object path:(NSString *)filepath;

#pragma mark ----------------------------------------------------- String About Method -----------------------------------------------------
/// 处理字符串数据
/// @param obj 数据
+ (NSString *)transformStringByObject:(id)obj;

/// 处理整形字符串数据
/// @param obj 数据
+ (NSString *)transformIntegerStringByObject:(id)obj;

/// 计算富文本字符串的最低高度
/// @param string 富文本字符串
/// @param width 宽度
+ (CGFloat)computeAttributedStringHeightWithString:(NSAttributedString *)string tvWidth:(CGFloat)width;

/// 计算字符串的最低宽度
/// @param string 字符串
/// @param dic 文本属性
/// @param maxwidth 容器最大宽度
+ (CGFloat)computerStringWidthWithString:(NSString *)string attribute:(NSDictionary *)dic maxWidth:(CGFloat)maxwidth;

/// 计算字符串的最低高度
/// @param string 字符串
/// @param dic 文本属性
/// @param width 容器宽度
+ (CGFloat)computeAttributedStringSizeWithTargetString:(NSString *)string attribute:(NSDictionary *)dic tvWidth:(CGFloat)width;

/// 判断是否是正常手机号码
/// @param number 手机号码
+ (BOOL)isPhoneNumberWithNumber:(NSString *)number;

/// 判断是否包含换行符
/// @param str 字符串
+ (BOOL)isNewLineString:(NSString *)str;

/// 判断是否包含空格
/// @param str 字符串
+ (BOOL)isWhiteSpaceString:(NSString *)str;

/// 从字符串中删除空格
/// @param string 字符串
+ (NSString *)removeSpaceFromString:(NSString *)string;

/// 从字符串中删除空格和回车
/// @param string 字符串
+ (NSString *)removeWhitespaceAndNewlineCharacterSetFromString:(NSString *)string;

/// 将字符串中指定子字符串替换成特定字符串
/// @param rstring 用于替换的特定字符串
/// @param rmstring 被替换指定子字符串
/// @param tstring 字符串
+ (NSString *)replaceString:(NSString *)rstring removestring:(NSString *)rmstring targetString:(NSString *)tstring;

/// 将字符串中指定位置的子字符串替换成特定字符串
/// @param rstring 用于替换的特定字符串
/// @param rmrange 指定位置
/// @param tstring 字符串
+ (NSString *)replaceString:(NSString *)rstring removeRange:(NSRange)rmrange targetString:(NSString *)tstring;

/// 从指定字符串中根据特定字符串分解出子字符串数组
/// @param str 指定字符串
/// @param partyStr 特定字符串
+ (NSMutableArray *)seekSubStringArrayWithTarget:(NSString *)str partyString:(NSString *)partyStr;

/// 将指定字符串逐一字符分解为字符串数组
/// @param str 指定字符串
+ (NSMutableArray *)recieveSubStringArrayWithTarget:(NSString *)str;

/// 将字符串数组中的各字符串拼接成一个字符串
/// @param strarray 字符串数组
+ (NSString *)joinStringArray:(NSArray<NSString *>*)strarray;

/// 将字符串数组中的各字符串使用特定字符串（markstr）拼接成一个字符串
/// @param objects 字符串数组
/// @param markstr 特定字符串
+ (NSString *)joinArrayObjectsToString:(NSArray<NSString *> *)objects withMark:(NSString *)markstr;

/// 格式化数据为“限制值+”的形式字符串
/// @param object 需要被格式化的数据
/// @param limitnumber 限制值
+ (NSString *)formatMoreFormWithCountObject:(id)object limit:(NSInteger)limitnumber;

/// 判断本地版本是否小于给定版本以及是否支持该系统版本
/// @param appversion 给定版本
/// @param minimumOsVersion 最低支持系统版本
+ (BOOL)judgeAppVersionShouldUpdateWithDataFromAppStore:(NSString *)appversion  minimumOsVersion:(NSString *)minimumOsVersion;

/// 判断本地版本是否小于给定版本
/// @param appversion 给定版本
+ (BOOL)appVersionIsLittleThanVersionFromAppStore:(NSString *)appversion;

/// 在字符串两端加上图片
/// @param himg 头图片
/// @param eimg 尾图片
/// @param himgrect 头图片尺寸
/// @param eimgrect 尾图片尺寸
/// @param string 字符串
/// @param attrs 文本格式属性字典
+ (NSMutableAttributedString *)appendImgAtDoubleSideWithHeadImgName:(id)himg endImgName:(id)eimg headrect:(CGRect)himgrect endrect:(CGRect)eimgrect string:(NSString *)string stringAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs;

/// 在字符串头端加上图片
/// @param img 图片
/// @param imgrect 图片尺寸
/// @param string 字符串
/// @param attrs 文本格式属性字典
+ (NSMutableAttributedString *)appendImgAtHeadWithImgName:(id)img imgrect:(CGRect)imgrect string:(NSString *)string stringAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs;

/// 在字符串末端加上图片
/// @param img 图片
/// @param imgrect 图片尺寸
/// @param string 字符串
/// @param attrs 文本格式属性字典
+ (NSMutableAttributedString *)appendImgAtEndWithImgName:(id)img imgrect:(CGRect)imgrect string:(NSString *)string stringAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs;

/// 在字符串两端加删除线
/// @param word 字符串
/// @param attrs 文本格式属性字典
+ (NSMutableAttributedString *)appendLineOnWitherSideOfWords:(NSString *)word stringAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs;

/// 将图片转化为Base64字符串
/// @param image 图片
+ (NSString *)obtainBase64CodeStringFromImage:(UIImage *)image;

/// 将数据转化为Base64字符串
/// @param data 数据
+ (NSString *)obtainBase64CodeStringFromData:(NSData *)data;

/// 对URL字符串进行编码
/// @param str URL字符串
+ (NSString *)URLEncodedString:(NSString *)str;

/// 对已编码URL字符串进行解码
/// @param str 已编码URL字符串
+ (NSString *)URLDecodedString:(NSString *)str;

/// 查询字符串中存在多少个目标字符串
/// @param targetString 被查询字符串
/// @param word 目标字符串
+ (NSInteger)queryWordCountInTargetString:(NSString *)targetString word:(NSString *)word;




#pragma mark ----------------------------------------------------- Array About Method -----------------------------------------------------
/// 目标对象<object>是否存在于数组<array>中
/// @param array 被查询数组
/// @param object 查询对象
+ (BOOL)objectIsExistInArray:(NSArray *)array object:(id)object;

/// 两数组中的元素是否完全相同
/// @param one 数组1
/// @param other 数组2
+ (BOOL)arrayObjectEqualWithOne:(NSArray *)one other:(NSArray *)other;

/// 数组1里不同于数组2的元素集合
/// @param one 数组1
/// @param other 数组2
+ (NSMutableArray *)differentObjectsInOne:(NSArray *)one betweenOther:(NSArray *)other;

/// 数组排序
/// @param datas 目标数组
/// @param isNormal 是否生序
+ (NSArray *)arrayNormalSortWithDatas:(NSArray *)datas isNormal:(BOOL)isNormal;




#pragma mark ----------------------------------------------------- Spell Method -----------------------------------------------------
/// 获取首字母(大写)
/// @param object 指定字符串
+ (NSString *)firstSpellOfStringObject:(NSString *)object;

/// 获取给定字符串的拼音字母（大写）
/// @param object 给定字符串
+ (NSString *)objectUppercaseSpellOfStringObject:(NSString *)object;

/// 将给定字符串数组的各项转化为对应的拼音字母（大写）
/// @param objects 给定字符串数组
+ (NSMutableArray *)transluteObjectsSpellsWithObjects:(NSArray <NSString *> *)objects;

/// 将给定字符串数组根据中文拼音排序
/// @param list 给定字符串数组
+ (NSMutableDictionary *)sortByChineseSpellInList:(NSArray <NSString *> *)list;

/// 将给定字符串数组根据中文拼音排序并将整理好的数据放入字典返回
/// @param modelArr 给定字符串数组
/// @param spells 给定拼音数组
+ (NSMutableDictionary *)listSorting:(NSMutableArray *)modelArr spells:(NSMutableArray *)spells;


#pragma mark ----------------------------------------------------- Security Method -----------------------------------------------------
/// 字符串加密
/// @param string 字符串
+ (NSString *)configSecurityWithString:(NSString *)string isSHA256:(BOOL)isSHA256;

/// 字符串SHA加密
/// @param string 字符串
+ (NSString *)configSHA256WithString:(NSString *)string;

#pragma mark ----------------------------------------------------- Date About Method -----------------------------------------------------
///设置日期格式
/// @param format 日期格式
+ (NSDateFormatter *)setupDateFormatterByType:(DateFormatType)format;

/// 根据给定格式将指定日期转化为字符串
/// @param date 日期
/// @param type 给定格式
+ (NSString *)dateTransformToString:(NSDate *)date type:(DateFormatType)type;

/// 根据给定格式将当前日期转化为字符串
/// @param type 格式
+ (NSString *)currentDateTransformToStringByType:(DateFormatType)type;

/// 获取当前日期
/// @param type 格式
+ (NSDate *)currentDateByType:(DateFormatType)type;

/// 将指定日期字符串格式化为日期格式
/// @param dateStr 指定日期字符串
/// @param type 格式
+ (NSDate *)stringFormatToDate:(NSString *)dateStr type:(DateFormatType)type;

/// 计算两个日期的间隔（单位 秒）
/// @param dateOne 日期字符串1
/// @param dateOther 日期字符串2
+ (NSString *)timeIntervalOfDoubleDate:(NSString *)dateOne otherDate:(NSString *)dateOther;

/// 计算指定与当前时间之间的间隔（单位 秒）
/// @param dateString 指定日期字符串
+ (NSString *)timeIntervalOfCurrnetAndDateString:(NSString *)dateString;

/// 长整型数字转化为字符串
/// @param number 长整型数字
+ (NSString *)integerTransformToString:(NSInteger)number;

/// 将时间间隔（s）格式化为天时分秒信息集合
/// @param seconds 时间间隔
/// @param hasDay 是否转换天数
+ (NSMutableDictionary *)timeIntervalTransformToTimeInformation:(NSInteger)seconds hasDay:(BOOL)hasDay;

/// 将时间间隔（s）格式化为天时分秒字符串
/// @param seconds 时间间隔
/// @param hasDay 是否转换天数
+ (NSString *)transformTimeStringWithSeconds:(NSInteger)seconds hasDay:(BOOL)hasDay;

/// 以双精度浮点型形式返回当前时间戳
+ (NSTimeInterval)currentTimeStampIntervalSince1970;

/// 以双精度浮点型形式返回当前时间戳（毫秒级）
+ (NSTimeInterval)currentTimeStampIntervalMilliSecondsSince1970;

/// 以字符串形式返回当前时间戳
+ (NSString *)currentTimeStamp;

/// 以双精度浮点型形式返回指定日期字符串的时间戳
/// @param date 指定日期字符串
/// @param type 日期格式
+ (NSTimeInterval)transformDateTimeStampIntervalWithDate:(NSString *)date type:(DateFormatType)type;

/// 以字符串形式返回指定日期字符串的时间戳
/// @param date 指定日期字符串
/// @param type 日期格式
+ (NSString *)transformDateTimeStampWithDate:(NSString *)date type:(DateFormatType)type;

/// 将时间戳转日期字符串
/// @param secs 指定时间戳
/// @param type 日期格式
+ (NSString *)transformDateStringFromTimeInterval:(NSTimeInterval)secs type:(DateFormatType)type;

/// 将时间戳转日期
/// @param secs 指定时间戳
/// @param type 日期格式
+ (NSDate *)transformDateFromTimeInterval:(NSTimeInterval)secs type:(DateFormatType)type;

/// 根据指定日期转化日期信息（Date:xx月xx日、Week:周几）
/// @param date 指定日期
+ (NSDictionary *)transformDateInfoByDate:(NSDate *)date;

/// 根据指定日期列表转化日期信息列表（@{Date:xx月xx日、Week:周几}）
/// @param dateList 指定日期
+ (NSArray *)transformDateInfoListByDateList:(NSArray *)dateList;

/// 根据指定日期列表转化日期信息列表（@{Date:xx月xx日、Week:周几}）
/// @param date 对标日期
/// @param isNext 是否是指定日期及以后
/// @param day 范围天数
+ (NSArray *)transformDateListByDate:(NSDate *)date isNext:(BOOL)isNext day:(NSInteger)day;


#pragma mark ----------------------------------------------------- Other Method -----------------------------------------------------
/// 初始化导航控制器
/// @param rootViewController 根视图控制器
/// @param imageNormalName 常规图片名
/// @param imageHighName 高亮图片名
+ (UINavigationController *)configNavigationControllerWithRootViewController:(UIViewController *)rootViewController title:(NSString *)title normalItemImageName:(NSString *)imageNormalName highItemImageName:(NSString *)imageHighName;

/// 初始化TabBar控制器
/// @param infos 控制器信息数组
+ (UITabBarController *)configTabBarControllerWithRootViewControllereInfos:(NSArray *)infos;

/// 配置通用导航栏和工具栏信息
+ (void)configUniversalNavigationBarAndTabBar;




#pragma mark **************************************************** Third Part Method ****************************************************
/// 打开qq群
/// - Parameters:
///   - keystring: ios Key
///   - number: teamNumber
+ (void)qqTeamOpenByIOSKey:(NSString *)keystring teamNumber:(NSString *)number;

/// 清除缓存
+ (void)cleanCache;

/// 注册网络状态监听
+ (void)deviceNetworkMonitorRegisterNotification;

/// 移除网络状态监测
+ (void)deviceNetworkMonitorRemoveNotification;









#pragma mark **************************************************** Image About Method ****************************************************

/// 获取相册授权状态
/// @param passblock 取得授权后的响应
+ (void)requestPhotoPrivacyBeforeBlock:(CommonCompletion)passblock;

/// 生成指定尺寸的二维码
/// - Parameters:
///   - string: 指定内容
///   - size: 指定尺寸
+ (UIImage *)createQRCodeByString:(NSString *)string size:(CGFloat)size;

/// 调整图片清晰度
/// - Parameters:
///   - image: 图片
///   - size: 指定尺寸
+ (UIImage *)clearInterpolatedImageFromCIImage:(CIImage *)image size:(CGFloat)size;

/// 根据滚动式图制作长图
/// - Parameter scrollView: 被制作图片的ScrollView
+ (UIImage *)snapshotByScrollView:(UIScrollView *)scrollView;

/// 根据View制作图片
/// @param view 目标View
+ (UIImage *)snapshotByView:(UIView *)view;

/// 截屏
+ (UIImage *)snapshotWithScreen;





@end

NS_ASSUME_NONNULL_END
