//
//  YZVersionUpdateView.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UpdateCompletion)(void);

@interface YZVersionUpdateView : UIView

- (instancetype)initWithContent:(NSString *)contentstr updateSource:(NSString *)updatesource isMustUpdate:(BOOL)isMust completion:(UpdateCompletion)completion;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
