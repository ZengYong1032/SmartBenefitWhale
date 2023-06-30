//
//  UIViewController+SmartBWAuxiliaryService.m
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/14.
//

#import "UIViewController+SmartBWAuxiliaryService.h"

@implementation UIViewController (SmartBWAuxiliaryService)

- (void)configBackgroundImageViewWithImage:(id)image rect:(CGRect)rect {
    UIImageView *bgImageView = [self.view viewWithTag:2023061500];
    if (!bgImageView) {
        bgImageView = [[UIImageView alloc] initWithFrame:kWindowBounds];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        bgImageView.tag = 2023061500;
        [self.view addSubview:bgImageView];
    }
    
    if (kClassJudgeByName(image, UIImage)) {
        bgImageView.image = image;
    }
    else if (kClassJudgeByName(image, NSString)) {
        bgImageView.image = ImageByName(image);
    }
    
    if (!CGRectEqualToRect(rect, CGRectZero)) {
        bgImageView.frame = rect;
    }
}

@end
