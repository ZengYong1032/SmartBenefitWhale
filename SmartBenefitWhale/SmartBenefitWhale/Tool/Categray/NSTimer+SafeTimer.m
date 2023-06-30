//
//  NSTimer+SafeTimer.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/21.
//

#import "NSTimer+SafeTimer.h"

@implementation NSTimer (SafeTimer)

+ (NSTimer *)safeScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void (^)(void))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handle:) userInfo:[block copy] repeats:repeats];
}

+ (void)handle:(NSTimer *)timer {
    void(^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
