//
//  NSTimer+SafeTimer.h
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (SafeTimer)

+ (NSTimer *)safeScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)(void))block repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
