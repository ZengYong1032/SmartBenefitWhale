//
//  YZImageDetailView.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ImageComposeType) {
    ImageComposeTypeShow = 0,
    ImageComposeTypeSave
};

typedef void(^ImageDetailViewDismiss)(void);

@interface YZImageDetailView : UIView

- (instancetype)initWithImages:(NSArray *)images handles:(NSArray *)handles observer:(UIViewController *)observer indexColor:(UIColor *)indexcolor highIndexColor:(UIColor *)highcolor backgroundColor:(UIColor *)bgcolor index:(NSInteger)index dismissCompose:(ImageDetailViewDismiss)dismissCompose;

- (void)showInWindow;

@end

NS_ASSUME_NONNULL_END
