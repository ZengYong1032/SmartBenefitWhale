//
//  YZLocationView.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/2/23.
//

#import "YZLocationView.h"

@interface YZLocationView ()

@property (nonatomic,strong) UIImageView                                            *markImageView;
@property (nonatomic,strong) UILabel                                                *locationLab;
@property (nonatomic,strong) UIImageView                                            *nextImageView;

@property (nonatomic,strong) NSAttributedString                                     *locationCity;
@property (nonatomic,copy) YZLocationTouchResponse                                  touchResponse;
@property (nonatomic,strong) NSString                                               *markName;
@property (nonatomic,strong) NSString                                               *nextName;
@property (nonatomic,assign) CGSize                                                 viewSize;

@end

@implementation YZLocationView

- (instancetype)initWithFrame:(CGRect)frame location:(id)location locationMark:(NSString *)markName nextMark:(NSString *)nextName response:(YZLocationTouchResponse)response {
    if (self = [super initWithFrame:frame]) {
        if (kClassJudgeByName(location, NSString)) {
            self.locationCity = [[NSAttributedString alloc] initWithString:location attributes:@{}];
        }
        else if (kClassJudgeByName(location, NSAttributedString)) {
            self.locationCity = location;
        }
        else {
            self.locationCity = [[NSAttributedString alloc] initWithString:@"定位" attributes:@{}];
        }
        self.locationCity = self.locationCity.string.length > 0?self.locationCity:[[NSAttributedString alloc] initWithString:@"定位" attributes:@{}];
        self.touchResponse = response;
        self.viewSize = frame.size;
        self.markName = markName;
        self.nextName = nextName;
        
        UIButton *touchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [touchButton addTarget:self action:@selector(viewTouchResponse) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.markImageView];
        [self addSubview:self.locationLab];
        [self addSubview:self.nextImageView];
        [self addSubview:touchButton];
    }
    return self;
}

- (void)updateLocationCity:(id)locationCity {
    NSAttributedString *city;
    if (kClassJudgeByName(locationCity, NSString)) {
        city = [[NSAttributedString alloc] initWithString:locationCity attributes:@{}];
    }
    else if (kClassJudgeByName(locationCity, NSAttributedString)) {
        city = locationCity;
    }

    if (!DoubleStringCompare(city.string, self.locationCity.string)) {
        self.locationCity = city?:[[NSAttributedString alloc] initWithString:@"定位" attributes:@{}];
        self.locationLab.attributedText = city;
    }
}

- (void)viewTouchResponse {
    !self.touchResponse?:self.touchResponse(kStringTransform(self.locationCity.string));
}



#pragma mark **************************************************** Subgroud Views Lazy Load Method ****************************************************
- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 0.0, 28.0, self.viewSize.height)];
        _markImageView.contentMode = UIViewContentModeCenter;
        _markImageView.image = ImageByName((self.markName.length > 0?self.markName:@"sy_dw"));
    }
    return _markImageView;
}

- (UILabel *)locationLab {
    if (!_locationLab) {
        _locationLab = [[UILabel alloc] initWithFrame:CGRectMake(self.markImageView.right, 0.0, self.viewSize.width - (18.0 + self.markImageView.right), self.viewSize.height)];
        _locationLab.textColor = kWhiteColor;
        _locationLab.textAlignment = NSTextAlignmentCenter;
        _locationLab.font = SystemBoldFont(16);
        _locationLab.attributedText = self.locationCity?:[[NSAttributedString alloc] initWithString:@"定位" attributes:@{}];
    }
    return _locationLab;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.locationLab.right + 4.0, 0.0, 10.0, self.viewSize.height)];
        _nextImageView.contentMode = UIViewContentModeCenter;
        _nextImageView.image = ImageByName((self.nextName.length > 0?self.nextName:@"sy_cs_djt"));
    }
    return _nextImageView;
}

@end
