//
//  YZSearchView.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SearchContentCompletion)(NSString *searchContent, BOOL isStart);

@interface YZSearchView : UIView

- (instancetype)initWithFrame:(CGRect)frame  searchMark:(NSString *)mark placeHolder:(NSAttributedString *)placeholder searchCompletion:(SearchContentCompletion)completion;

- (instancetype)initWithFrame:(CGRect)frame bgcolor:(UIColor*)color cornerRadius:(CGFloat)corner searchMark:(NSString *)mark placeHolder:(NSAttributedString *)placeholder searchCompletion:(SearchContentCompletion)completion;

- (void)searchViewResignFirstResponder;

@end

NS_ASSUME_NONNULL_END
