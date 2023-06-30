//
//  YZDeleteNotificationTextFiled.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/3/14.
//

#import "YZDeleteNotificationTextFiled.h"

@implementation YZDeleteNotificationTextFiled

- (void)deleteBackward {
    [super deleteBackward];
    
    if(_keyInputDelegate && [_keyInputDelegate respondsToSelector:@selector(deleteBackward:)]) {
        [_keyInputDelegate deleteBackward:self];
    }
}

@end
