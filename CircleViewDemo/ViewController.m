//
//  ViewController.m
//  CircleViewDemo
//
//  Created by Lynch on 9/29/15.
//  Copyright © 2015 Lynch. All rights reserved.
//

#import "ViewController.h"
#import "YKCircleView.h"

@interface ViewController () {
    NSTimer *_timer;
    CGFloat _second;
    CGFloat _totalSecond;
}

@property (nonatomic, strong) YKCircleView *circleView;

@property (nonatomic, assign) CGFloat second;
@property (nonatomic, assign) CGFloat totalSecond;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _circleView = [[YKCircleView alloc] initWithType:CircleViewTypeProgress];
    _circleView.downArcColor = [UIColor colorWithRed:217.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
    _circleView.upArcColor = [UIColor colorWithRed:67.0f/255.0f green:196.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
    _circleView.arcWidth = 20.0f;
    _circleView.durationTime = 0.1;
    _circleView.bounds = CGRectMake(0, 0, 200, 200);
    _circleView.center = CGPointMake(self.view.frame.size.width / 2, 150);
    [self.view addSubview:_circleView];
    
    _second = 10.0f;
    _totalSecond = 10.0f;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer:) userInfo:self repeats:YES];
}

- (void)onTimer:(id)sender {
    _second -= 0.1f;
    
    CGFloat p = _second / _totalSecond;
    if(p >= 0 && p <= 1) {
        [_circleView setProgress:p duration:0.1];
    }
    
    if(p <= 0.0f) {
        [_timer invalidate];
        [_circleView setProgress:0.0f duration:0.1];
    }
}

@end
