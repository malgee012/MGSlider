//
//  MGSlider.h
//  MGSlideDemo
//
//  Created by maling on 2019/7/24.
//  Copyright © 2019 maling. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MGSlider : UIView

@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, assign) UIEdgeInsets touchRangeEdgeInsets;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat margin; // 距离左右内间距
@property (nonatomic, assign, getter=isZoom) BOOL zoom; // 默认点击放大
@property (nullable, nonatomic, strong) UIColor *untrackColor;
@property (nullable, nonatomic, strong) UIColor *trackColor;
@property (nullable, nonatomic, strong) UIColor *thumbColor;


- (void)changeValue:(void(^_Nullable)(CGFloat value))changeEvent endValue:(void(^_Nullable)(CGFloat value))endValue;


@end


