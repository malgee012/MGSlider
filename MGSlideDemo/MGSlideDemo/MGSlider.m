//
//  MGSlider.m
//  MGSlideDemo
//
//  Created by maling on 2019/7/24.
//  Copyright © 2019 maling. All rights reserved.
//

#import "MGSlider.h"

@interface UIView (MGFrame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@end

#define MGValveWidth 15
//static CGFloat const progressLineHeight = 2.0f;
@interface MGSlider ()

@property (nonatomic, strong) UIImageView *untrackView;
@property (nonatomic, strong) UIImageView *trackView;
@property (nonatomic, strong) UIImageView *valveIV;
@property (nonatomic, assign) CGRect valveRect;
@property (nonatomic, assign, getter=isSpot) BOOL spot;
@property (nonatomic, copy) void(^changeEvent)(CGFloat value);
@property (nonatomic, copy) void(^endValueEvent)(CGFloat value);

@end
@implementation MGSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initData];
        [self setupSubviews];
    }
    return self;
}

- (void)initData
{
    _touchRangeEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _thumbSize = CGSizeMake(MGValveWidth, MGValveWidth);
    _progress = 0.5f;
    _zoom = YES;
    _untrackColor = [UIColor lightGrayColor];
    _trackColor = [UIColor orangeColor];
    _thumbColor = _trackColor;
    _margin = 20.0f;
    _progressLineHeight = 2.0f;
}

- (void)setupSubviews
{
    _untrackView = [[UIImageView alloc] init];
    _untrackView.backgroundColor = _untrackColor;
    [self addSubview:_untrackView];
    
    _trackView = [[UIImageView alloc] init];
    _trackView.backgroundColor = _trackColor;
    [self addSubview:_trackView];
    
    _valveIV = [[UIImageView alloc] init];
    _valveIV.contentMode = UIViewContentModeScaleAspectFit;
    _valveIV.backgroundColor = _thumbColor;
    [self addSubview:_valveIV];
    
    [self updateSubviewFrame];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.valveRect, _touchRangeEdgeInsets);
    BOOL isContain =  CGRectContainsPoint(hitFrame, point);
    if (isContain) {
        self.spot = YES;
        if (self.isZoom) {
            [UIView animateWithDuration:0.25 animations:^{
                self.valveIV.transform = CGAffineTransformMakeScale(2, 2);
            }];
        }
        [self moveValvePoint:point];
    } else {
        self.spot = NO;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (self.isSpot) {
        [self moveValvePoint:point];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.endValueEvent && self.spot) {
        CGFloat progress = (self.valveIV.centerX - _margin) / (self.width - _margin * 2);
        self.endValueEvent(progress);
    }
    if (self.isZoom) {
        [UIView animateWithDuration:0.25 animations:^{
            self.valveIV.transform = CGAffineTransformIdentity;
        }];
    }
    self.spot = NO;
}

- (void)moveValvePoint:(CGPoint)point
{
    if (point.x < _margin) {
        point.x = _margin;
    } else if (point.x > self.width - _margin) {
        point.x = self.width - _margin;
    }
    
    self.valveIV.centerX = point.x;
    CGFloat progress = (self.valveIV.centerX - _margin) / (self.width - _margin * 2);
    if (self.changeEvent) {
        self.changeEvent(progress);
    }
    
    _trackView.x = _margin;
    _trackView.width =  _valveIV.centerX - _margin;
    
    _valveRect = CGRectMake(self.valveIV.centerX - _thumbSize.width * 0.5f, (self.height - _thumbSize.height) * 0.5f, _thumbSize.width, _thumbSize.height);
}

- (void)changeValue:(void(^_Nullable)(CGFloat value))changeEvent endValue:(void(^_Nullable)(CGFloat value))endValue
{
    self.changeEvent = changeEvent;
    self.endValueEvent = endValue;
}

- (void)setTouchRangeEdgeInsets:(UIEdgeInsets)touchRangeEdgeInsets
{
    _touchRangeEdgeInsets = touchRangeEdgeInsets;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self updateSubviewFrame];
}

- (void)setThumbSize:(CGSize)thumbSize
{
    _thumbSize = thumbSize;
    [self updateSubviewFrame];
}

- (void)setUntrackColor:(UIColor *)untrackColor
{
    _untrackColor = untrackColor;
    _untrackView.backgroundColor = untrackColor;
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackColor = trackColor;
    _trackView.backgroundColor = trackColor;
}

- (void)setProgressLineHeight:(CGFloat)progressLineHeight
{
    _progressLineHeight = progressLineHeight;
    [self updateSubviewFrame];
}

- (void)setThumbColor:(UIColor *)thumbColor
{
    _thumbColor = thumbColor;
    _valveIV.backgroundColor = thumbColor;
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
    [self updateSubviewFrame];
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    _thumbImage = thumbImage;
    self.valveIV.image = thumbImage;
}

- (void)setTrackImage:(UIImage *)trackImage
{
    _trackImage = trackImage;
    if (trackImage) {
        _trackView.image = [trackImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    }
}

- (void)setUntrackImage:(UIImage *)untrackImage
{
    _untrackImage = untrackImage;
    if (untrackImage) {
        _untrackView.image = [untrackImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    }
}

- (void)updateSubviewFrame
{
    _valveIV.frame = CGRectMake(_margin + (self.width - _margin * 2) * _progress, 0.5f * (self.height - _thumbSize.height), _thumbSize.width, _thumbSize.height);
    self.valveRect = _valveIV.frame;
    _valveIV.layer.cornerRadius = _valveIV.width * 0.5f;
    _valveIV.layer.masksToBounds = YES;
    
    _untrackView.frame = CGRectMake(_margin, 0.5f * (self.height - _progressLineHeight), self.width - _margin * 2, _progressLineHeight);
    _untrackView.layer.cornerRadius = _untrackView.height * 0.5f;
    _untrackView.layer.masksToBounds = YES;
    
    _trackView.frame = CGRectMake(_margin, 0.5f * (self.height - _progressLineHeight), _valveIV.centerX - _margin, _progressLineHeight);
    _trackView.layer.cornerRadius = _trackView.height * 0.5;
    _trackView.layer.masksToBounds = YES;

}

@end




@implementation UIView (MGFrame)
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)x {
    return self.frame.origin.x;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    
}
- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    
    center.y = centerY;
    
    self.center = center;
}
- (CGFloat)centerY {
    return self.center.y;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}
- (CGFloat)top
{
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
- (CGFloat)left
{
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}
- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}
- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
@end
