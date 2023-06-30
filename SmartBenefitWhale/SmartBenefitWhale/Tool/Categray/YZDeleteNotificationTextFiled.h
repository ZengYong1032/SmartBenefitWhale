//
//  YZDeleteNotificationTextFiled.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KeyTputTextFiledDelegate <NSObject>

@optional
- (void)deleteBackward:(UITextField *)textFiled;

@end

@interface YZDeleteNotificationTextFiled : UITextField

@property (nonatomic,assign) id<KeyTputTextFiledDelegate> keyInputDelegate;

@end

NS_ASSUME_NONNULL_END
