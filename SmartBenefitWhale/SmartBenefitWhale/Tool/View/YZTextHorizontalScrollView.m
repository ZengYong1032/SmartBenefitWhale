//
//  YZTextHorizontalScrollView.m
//  SweetAgenda
//
//  Created by Yong Zeng on 2021/7/26.
//  Copyright © 2021 GreekMythology. All rights reserved.
//

#import "YZTextHorizontalScrollView.h"

@interface YZTextHorizontalScrollView ()

@property (nonatomic, strong) UILabel                               *contentLabel1;
@property (nonatomic, strong) UILabel                               *contentLabel2;

@property (nonatomic, assign) CGFloat                               textWidth;
@property (nonatomic, assign) int                                   wanderingOffset;

@property (nonatomic, strong) NSTimer                               *timer;

@end

@implementation YZTextHorizontalScrollView
{
    CGFloat _selfWidth;
    CGFloat _selfHeight;
}

- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 100, 20); // 设置一个初始的frame
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setInitialSettings];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setInitialSettings];
}

- (void)setInitialSettings {
    _selfWidth = self.frame.size.width;
    _selfHeight = self.frame.size.height;
    
    _contentLabel1 = nil;
    _contentLabel2 = nil;
    
    _text      = @"";
    _textFont  = [UIFont systemFontOfSize:12];
    _textColor = [UIColor blackColor];
    
    _speed = 0.03;
    _textWidth = 0;
    _wanderingOffset = -1;
    
    _moveMode = YZTextScrollWandering;
    _moveDirection = YZTextScrollMoveLeft;
    
    _timer = nil;
}


#pragma mark - Set
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _selfWidth = frame.size.width;
    _selfHeight = frame.size.height;
}
- (void)setText:(NSString *)text{
    if ([_text isEqualToString: text]) return;
    _text = text;
    [self updateTextWidth];
    [self updateLabelsFrame];
}

- (void)setTextFont:(UIFont *)textFont {
    if (_textFont == textFont) return;
    _textFont = textFont;
    [self updateTextWidth];
    [self updateLabelsFrame];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (_contentLabel1 != nil) {
        _contentLabel1.textColor = _textColor;
    }
    if (_contentLabel2 != nil) {
        _contentLabel2.textColor = _textColor;
    }
}

- (void)setSpeed:(CGFloat)speed {
    _speed = speed;
    [self move];
}

- (void)setMoveMode:(YZTextScrollMode)moveMode {
    _moveMode = moveMode;
    
    if (self.text.length == 0) {//如果字符串长度为0，直接返回
        return;
    }
    
    BOOL isMoving = NO;
    if (_timer) {
        [self stop];
        isMoving = YES;
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    switch (_moveMode) {
        case YZTextScrollContinuous: {
            if (self.moveDirection == YZTextScrollMoveLeft) {
                [self creatLabel1WithFrame1:CGRectMake(0, 0, _textWidth, _selfHeight) andLabel2WithFrame2:CGRectMake(_textWidth, 0, _textWidth, _selfHeight)];
            }
    else{
                [self creatLabel1WithFrame1:CGRectMake(_selfWidth -_textWidth, 0, _textWidth, _selfHeight) andLabel2WithFrame2:CGRectMake(_selfWidth -_textWidth -_textWidth, 0, _textWidth, _selfHeight)];
            }
            
        }break;
            
        case YZTextScrollIntermittent: {
            if (self.moveDirection == YZTextScrollMoveLeft) {
                [self creatLabel1WithFrame:CGRectMake(0, 0, _textWidth, _selfHeight)];
            }
    else{
                [self creatLabel1WithFrame:CGRectMake(_selfWidth -_textWidth, 0, _textWidth, _selfHeight)];
            }
        }break;
            
        case YZTextScrollFromOutside: {
            if (self.moveDirection == YZTextScrollMoveLeft) {
                [self creatLabel1WithFrame:CGRectMake(_selfWidth, 0, _textWidth, _selfHeight)];
            }
    else{
                [self creatLabel1WithFrame:CGRectMake(_textWidth, 0, _textWidth, _selfHeight)];
            }
        }break;
            
        case YZTextScrollWandering: {
            [self creatLabel1WithFrame:CGRectMake(0, 0, _textWidth, _selfHeight)];
        }break;
            
        default:
            break;
    }
    
    if (isMoving) {
        [self move];
    }
}

#pragma mark - Create Labels
- (void)creatLabel1WithFrame:(CGRect)frame {
    _contentLabel1 = [[UILabel alloc] initWithFrame:frame];
    _contentLabel1.text            = self.text;
    _contentLabel1.font            = self.textFont;
    _contentLabel1.textColor       = self.textColor;
    _contentLabel1.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel1];
    
    if (_contentLabel2) {
        [_contentLabel2 removeFromSuperview];
        _contentLabel2 = nil;
    }
}
- (void)creatLabel1WithFrame1:(CGRect)frame1 andLabel2WithFrame2:(CGRect)frame2 {
    [self creatLabel1WithFrame:frame1];
    
    _contentLabel2 = [[UILabel alloc] initWithFrame:frame2];
    _contentLabel2.text            = self.text;
    _contentLabel2.font            = self.textFont;
    _contentLabel2.textColor       = self.textColor;
    _contentLabel2.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel2];
}


#pragma mark - Util
- (void)updateTextWidth {
    _textWidth = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.textFont, NSFontAttributeName, nil]].width;
}

- (void)updateLabelsFrame {
    
    CGFloat label1_x = _contentLabel1.frame.origin.x;
    CGFloat label2_x = _contentLabel2.frame.origin.x;

    if (_contentLabel1 && _contentLabel2) {
        if (label1_x < label2_x) {
            _contentLabel1.frame = CGRectMake(label1_x, 0, _textWidth, _selfHeight);
            _contentLabel2.frame = CGRectMake(label1_x + _textWidth, 0, _textWidth, _selfHeight);
        } else {
            _contentLabel2.frame = CGRectMake(label2_x, 0, _textWidth, _selfHeight);
            _contentLabel1.frame = CGRectMake(label2_x + _textWidth, 0, _textWidth, _selfHeight);
            
        }
    }
    else {
        if (_contentLabel1) {
            _contentLabel1.frame = CGRectMake(label1_x, 0, _textWidth, _selfHeight);
        }
        if (_contentLabel2) {
            _contentLabel2.frame = CGRectMake(label2_x, 0, _textWidth, _selfHeight);
        }
    }
}

#pragma mark - Move Action
// YZTextScrollContinuous
- (void)moveContinuous {
    if (self.moveDirection == YZTextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x -1, 0, _textWidth, _selfHeight);
        _contentLabel2.frame = CGRectMake(_contentLabel2.frame.origin.x -1, 0, _textWidth, _selfHeight);
        if (_contentLabel1.frame.origin.x < -_textWidth) {
            _contentLabel1.frame = CGRectMake(_contentLabel2.frame.origin.x + _textWidth, 0, _textWidth, _selfHeight);
        }
        if (_contentLabel2.frame.origin.x < -_textWidth) {
            _contentLabel2.frame = CGRectMake(_contentLabel1.frame.origin.x + _textWidth, 0, _textWidth, _selfHeight);
        }
    }
    else {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x +1, 0, _textWidth, _selfHeight);
        _contentLabel2.frame = CGRectMake(_contentLabel2.frame.origin.x +1, 0, _textWidth, _selfHeight);
        if (_contentLabel1.frame.origin.x > _selfWidth) {
            _contentLabel1.frame = CGRectMake(_contentLabel2.frame.origin.x - _textWidth, 0, _textWidth, _selfHeight);
        }
        if (_contentLabel2.frame.origin.x > _selfWidth) {
            _contentLabel2.frame = CGRectMake(_contentLabel1.frame.origin.x - _textWidth, 0, _textWidth, _selfHeight);
        }
    }
}
// YZTextScrollIntermittent
- (void)moveIntermittent {
    if (self.moveDirection == YZTextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x -1, 0, _textWidth, _selfHeight);
        if (_contentLabel1.frame.origin.x < -_textWidth) {
            _contentLabel1.frame = CGRectMake(0, 0, _textWidth, _selfHeight);
        }
    }
    else{
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x +1, 0, _textWidth, _selfHeight);
        if (_contentLabel1.frame.origin.x > _selfWidth) {
            _contentLabel1.frame = CGRectMake(_selfWidth -_textWidth, 0, _textWidth, _selfHeight);
        }
    }
}
// YZTextScrollFromOutside
- (void)moveFromOutside {
    if (self.moveDirection == YZTextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x -1, 0, _textWidth, _selfHeight);
        if (_contentLabel1.frame.origin.x < -_textWidth) {
            _contentLabel1.frame = CGRectMake(_selfWidth, 0, _textWidth, _selfHeight);
        }
    }
    else{
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x +1, 0, _textWidth, _selfHeight);
        if (_contentLabel1.frame.origin.x > _selfWidth) {
            _contentLabel1.frame = CGRectMake(-_textWidth, 0, _textWidth, _selfHeight);
        }
    }
}
// YZTextScrollWandering
- (void)moveWandering{
    if (_textWidth > _selfWidth) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x + _wanderingOffset, 0, _textWidth, _selfHeight);
        if (_contentLabel1.frame.origin.x < - (_textWidth -_selfWidth +2)) {
            _wanderingOffset = 1;
        }
        if (_contentLabel1.frame.origin.x > 2) {
            _wanderingOffset = -1;
        }
    }
    else if (_textWidth < _selfWidth) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x + _wanderingOffset, 0, _textWidth, _selfHeight);
        if (_contentLabel1.frame.origin.x < 0) {
            _wanderingOffset = 1;
        }
        if (_contentLabel1.frame.origin.x > _selfWidth - _textWidth) {
            _wanderingOffset = -1;
        }
    }
}

#pragma mark - API Methods
- (void)move {
    if (_timer != nil) {
        [self stop];
    }
    switch (self.moveMode) {
        case YZTextScrollContinuous: {
            _timer = [NSTimer scheduledTimerWithTimeInterval:self.speed target:self selector:@selector(moveContinuous) userInfo:nil repeats:YES];
        }
            break;
        case YZTextScrollIntermittent: {
            _timer = [NSTimer scheduledTimerWithTimeInterval:self.speed target:self selector:@selector(moveIntermittent) userInfo:nil repeats:YES];
        }
            break;
        case YZTextScrollFromOutside: {
            _timer = [NSTimer scheduledTimerWithTimeInterval:self.speed target:self selector:@selector(moveFromOutside) userInfo:nil repeats:YES];
        }
            break;
        case YZTextScrollWandering: {
            _timer = [NSTimer scheduledTimerWithTimeInterval:self.speed target:self selector:@selector(moveWandering) userInfo:nil repeats:YES];
        }
            break;
        default:
            break;
    }
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc {
    [self stop];
}


@end
