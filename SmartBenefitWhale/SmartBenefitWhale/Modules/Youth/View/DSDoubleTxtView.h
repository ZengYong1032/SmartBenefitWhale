//
//  DSDoubleTxtView.h
//  Test
//
//  Created by Mac on 2023/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSDoubleTxtView : UIStackView

/// 上面的文案
@property (nonatomic, strong) UILabel *topLabel;

/// 下面的文案
@property (nonatomic, strong) UILabel *bottomLabel;

@end

NS_ASSUME_NONNULL_END
