# MGSlider


**效果图**
<p align="center">
<img src="./image/iii.gif" style="zoom:50%" align=center/>
</p>

```

 MGSlider *slider = [[MGSlider alloc] initWithFrame:CGRectMake(20, 200, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    slider.touchRangeEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
    slider.thumbSize = CGSizeMake(10, 10);
    slider.progress = 0.8;
    slider.margin = 50;
    [self.view addSubview:slider];
    [slider changeValue:^(CGFloat value) {
    
    } endValue:^(CGFloat value) {
        NSLog(@"end: %f", value);
    }];

```