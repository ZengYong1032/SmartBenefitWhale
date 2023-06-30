//
//  YZLocationView.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YZLocationTouchResponse)(NSString *locationCity);

@interface YZLocationView : UIView

- (instancetype)initWithFrame:(CGRect)frame location:(id)location locationMark:(NSString *)markName nextMark:(NSString *)nextName response:(YZLocationTouchResponse)response;

- (void)updateLocationCity:(id)locationCity;

@end

NS_ASSUME_NONNULL_END
