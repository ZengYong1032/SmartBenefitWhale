//
//  YZScrollTextContentView.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,YZTextContentScrollDirection) {
    YZTextContentScrollDirectionUp = 0,
    YZTextContentScrollDirectionDown,
    YZTextContentScrollDirectionLeft,
    YZTextContentScrollDirectionRight
};

typedef NS_ENUM(NSInteger,YZTextContentType) {
    YZTextContentTypeDefault = 0,
    YZTextContentTypeCarryImage,
    YZTextContentTypeFullCarryImage,
    YZTextContentTypeWelfareCarryImage
};

typedef void(^YZTextContentScrollTouchCompletion)(NSDictionary *info);

@interface YZScrollTextContentView : UIView

- (instancetype)initWithFrame:(CGRect)frame direction:(YZTextContentScrollDirection)direction type:(YZTextContentType)type duration:(NSInteger)duration contents:(NSArray *)contents touchCompletion:(YZTextContentScrollTouchCompletion)completion;

- (void)stopContentScroll;

- (void)startContentScroll;


@end

NS_ASSUME_NONNULL_END
