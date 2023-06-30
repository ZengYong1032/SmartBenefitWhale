//
//  YZImageDetailView.m
//  CapacityAudienceFromNowOn
//
//  Created by Yong Zeng on 2023/5/12.
//

#import "YZImageDetailView.h"

@interface YZImageDetailView ()
<
    UIScrollViewDelegate
>

@property (nonatomic,strong) UIScrollView                                   *imagesScrollView;
@property (nonatomic,strong) UIView                                         *indexView;
@property (nonatomic,assign) NSInteger                                      index;

@property (nonatomic,strong) UITapGestureRecognizer                         *tapGR;
@property (nonatomic,strong) UILongPressGestureRecognizer                   *longPressGR;

@property (nonatomic,strong) NSArray                                        *images;
@property (nonatomic,strong) NSMutableArray                                 *imageLists;
@property (nonatomic,strong) NSArray                                        *handles;

@property (nonatomic,strong) UIColor                                        *bgColor;
@property (nonatomic,strong) UIColor                                        *indexColor;
@property (nonatomic,strong) UIColor                                        *highIndexColor;

@property (nonatomic,strong) UIViewController                               *observer;

@property (nonatomic,copy) ImageDetailViewDismiss                           dismissCompose;


@end

@implementation YZImageDetailView

- (instancetype)initWithImages:(NSArray *)images handles:(NSArray *)handles observer:(UIViewController *)observer indexColor:(UIColor *)indexcolor highIndexColor:(UIColor *)highcolor backgroundColor:(UIColor *)bgcolor index:(NSInteger)index dismissCompose:(ImageDetailViewDismiss)dismissCompose {
    if (self = [super initWithFrame:kWindowBounds]) {
        _index = index;
        _handles = [NSArray arrayWithArray:handles];
        _images = [NSArray arrayWithArray:images];
        _observer = observer;
        _indexColor = indexcolor;
        _highIndexColor = highcolor;
        _bgColor = bgcolor;
        _dismissCompose = dismissCompose;
        
        self.backgroundColor = bgcolor;
        [self addSubview:self.imagesScrollView];
        [self addSubview: self.indexView];
    }
    return self;
}

#pragma mark <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Image Detail Scroll View Delegate Method  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.images.count > 1) {
        self.index = floorf((scrollView.contentOffset.x/kWindowWidth));
        [self refreshIndexView];
    }
}

#pragma mark ----------------------------------------------------- Business Event Method -----------------------------------------------------
/// 渲染视图
- (void)showInWindow {
    [AppMainWindow addSubview:self];
}

/// 移除视图
- (void)dismissFromWindow {
    [self removeFromSuperview];
    [self composeAfterDismiss];
}

/// 点击响应
- (void)imageViewTapCompose {
    [self dismissFromWindow];
}

/// 长按响应
- (void)imageViewLongPressCompose:(UIGestureRecognizer *)gesture {
    if (self.handles.count > 0) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            kWeakConfig(self);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"请选择相关操作" preferredStyle:UIAlertControllerStyleActionSheet];
            [self.handles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                switch ([obj integerValue]) {
                    case ImageComposeTypeSave:{
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"保存相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            UIImage *image = [weakself imageByIndex:weakself.index];
                            if (image) {
                                [SmartBWAuxiliaryMeansManager imageStoreToLibraryWithImage:image completion:^(BOOL success) {
                                    [AppMainWindow showAutoHudWithText:@"图片已保存相册"];
                                }];
                            }
                        }];
                        [alertVC addAction:action];
                    }
                        break;
                        
                    default:
                        break;
                };
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                ;
            }];
            [alertVC addAction:cancelAction];
            
            [self.observer presentViewController:alertVC animated:YES completion:nil];
        }
    }
}

- (UIImage *)imageByIndex:(NSInteger)index {
    UIImage *image;
    if (index >= self.imageLists.count || !kClassJudgeByName(self.imageLists[index], UIImage)) {
        [AppMainWindow showAutoHudWithText:@"图片获取失败,请稍后试试"];
    }
    else {
        image = self.imageLists[index];
    }
    return image;
}

/// 回调响应
- (void)composeAfterDismiss {
    !self.dismissCompose?:self.dismissCompose();
}

#pragma mark *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* Views Refresh Method *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
- (void)refreshIndexView {
    [self.indexView removeFromSuperview];
    self.indexView = nil;
    [self addSubview:self.indexView];
}

#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
- (UIScrollView *)imagesScrollView {
    if (!_imagesScrollView) {
        kWeakConfig(self);
        _imagesScrollView = [[UIScrollView alloc] initWithFrame:kWindowBounds];
        [_imagesScrollView setShowsVerticalScrollIndicator:NO];
        [_imagesScrollView setShowsHorizontalScrollIndicator:NO];
        _imagesScrollView.bounces = YES;
        _imagesScrollView.pagingEnabled = YES;
        _imagesScrollView.scrollEnabled = YES;
        _imagesScrollView.scrollsToTop = YES;
        _imagesScrollView.contentInset = UIEdgeInsetsZero;
        _imagesScrollView.autoresizingMask  = UIViewAutoresizingFlexibleWidth;
        _imagesScrollView.delaysContentTouches = YES;
        _imagesScrollView.delegate = self;
        [_imagesScrollView setBackgroundColor:kClearColor];
        
        _imagesScrollView.contentSize = CGSizeMake(kWindowWidth*(self.images.count), 0);
        [_imagesScrollView addGestureRecognizer:self.tapGR];
        if (self.handles.count > 0) {
            [_imagesScrollView addGestureRecognizer:self.longPressGR];
        }
        
        [self.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth*idx, kStatusBarHeight, kWindowWidth, kWindowHeight - kStatusBarHeight - DeviceBottomSafeHeight)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [weakself.imageLists addObject:@""];
            if (kClassJudgeByName(obj, NSString) && kStringTransform(obj).length > 0) {
                [imageView sd_setImageWithURL:kURL(obj) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (error) {
                        imageView.image = ImageByName(@"error_image_mark");
                    }
                    else {
                        [weakself.imageLists replaceObjectAtIndex:idx withObject:image];
                    }
                }];
            }
            else if (kClassJudgeByName(obj, UIImage)) {
                [weakself.imageLists replaceObjectAtIndex:idx withObject:obj];
                imageView.image = obj;
            }
            else {
                imageView.image = ImageByName(@"error_image_mark");
            }
            
            [_imagesScrollView addSubview:imageView];
        }];
        if (self.index > 0) {
            [_imagesScrollView setContentOffset:CGPointMake(self.index*kWindowWidth, 0) animated:NO];
        }
    }
    return _imagesScrollView;
}

- (UITapGestureRecognizer *)tapGR {
    if (!_tapGR) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapCompose)];
        _tapGR.numberOfTouchesRequired = 1;
    }
    return _tapGR;
}

- (UILongPressGestureRecognizer *)longPressGR {
    if (!_longPressGR) {
        _longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPressCompose:)];
        _longPressGR.minimumPressDuration = 1.0;
        _longPressGR.cancelsTouchesInView = NO;
    }
    return _longPressGR;
}

- (UIView *)indexView {
    if (!_indexView) {
        _indexView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight - DeviceBottomSafeHeight - 40.0, kWindowWidth, 40.0)];
        NSInteger count = self.images.count;
        CGFloat w = 6.0;
        CGFloat spacex = 6.0;
        CGFloat x = (kWindowWidth - (w*count + spacex*(count - 1)))*0.5;
        CGFloat y = (20.0 - w*0.5);
        for (int i=0; i<self.images.count; i++) {
            BOOL isCurrent = (i == self.index);
            UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(x + i*(w + spacex), y, w, w)];
            circleView.layer.cornerRadius = w*0.5;
            circleView.layer.masksToBounds = YES;
            circleView.backgroundColor = (isCurrent?self.highIndexColor:self.indexColor);
            
            [_indexView addSubview:circleView];
        }
    }
    return _indexView;
}

#pragma mark **************************************************** Resource Lazy Load Method ****************************************************
- (NSMutableArray *)imageLists {
    if (!_imageLists) {
        _imageLists = [NSMutableArray array];
    }
    return _imageLists;
}

@end
