//
//  ViewController.m
//  MGSlideDemo
//
//  Created by maling on 2019/7/24.
//  Copyright © 2019 maling. All rights reserved.
//

#import "ViewController.h"
#import "MGSlider.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGSlider *slider = [[MGSlider alloc] initWithFrame:CGRectMake(20, 200, [UIScreen mainScreen].bounds.size.width - 40, 100)];
    slider.backgroundColor = [UIColor cyanColor];
    
    slider.touchRangeEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
    slider.thumbSize = CGSizeMake(10, 10);
    slider.progress = 0.8;
    slider.margin = 50;
    [self.view addSubview:slider];
    [slider changeValue:^(CGFloat value) {
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>> %f", value);
    } endValue:^(CGFloat value) {
       
        NSLog(@"结束 %f", value);
    }];
    
}


@end
