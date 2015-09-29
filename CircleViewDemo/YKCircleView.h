//
//  YKStepCircleView.h
//  ABC360
//
//  Created by abc360 on 9/14/15.
//  Copyright (c) 2015 chenjaixin. All rights reserved.
//

/**
 
 本控件参考http://objccn.io/issue-12-2/完成。
 
 控件的类型一定要设置，控件会根据类型绘制不同的图像。
 对于进度圈类型来说totalIndex属性不是必须的。currentIndex的值为0.0f-1.0f,控件有控制。
 设置currentIndex的值产生动画，不设置currentIndex的值将没有视图显示在界面上。
 
 用法：
    1.广告页的用法，倒计时进度圈：
     实现了initWithCoder:方法，可在xib，sb中使用。
     _progressView.type = CircleViewTypeProgress;
     _progressView.downArcColor = [UIColor clearColor];
     _progressView.upArcColor = [UIColor colorWithRed:77.0f/255.0f green:185.0/255.0f blue:237.0/255.0f alpha:1.0f];
     _progressView.arcWidth = 2.0f;
     _progressView.durationTime = 0.1;
     
     在NSTimer中的回调中调用该方法；最后结束时再次调用该方法，p的值为0活者1。
     [_progressView setProgress:p duration:0.1];
    
    2.单词认知页面，步骤指示：
     _stepCircleView = [[YKCircleView alloc] initWithType:CircleViewTypeStep];
     _stepCircleView.totalIndex = _lessonDetail.tips.count + 1;
     _stepCircleView.downArcColor = [UIColor colorWithRed:217.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
     _stepCircleView.upArcColor = [UIColor colorWithRed:67.0f/255.0f green:196.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
     _stepCircleView.arcWidth = 5.0f;
     _stepCircleView.durationTime = 0.15;
     _stepCircleView.bounds = CGRectMake(0, 0, 70, 70);
     _stepCircleView.center = CGPointMake(self.view.bounds.size.width / 2, (kScreenHeight - 64.0f - _cognitionView.bounds.size.height) / 2 + _cognitionView.bounds.size.height);
     [self.view addSubview:_stepCircleView];
     
     _stepCircleView.currentIndex = 1;
 
    3.参考YKExercisesType5，进度圈。
 */

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CircleViewTypeStep = 0,//步骤圈，内部会显示当前的步骤，如"01/04"这样
    CircleViewTypeProgress,//进度圈，调用setProgress:duration:或者直接设置currentIndex的值。
} CircleViewType;

/**
 *  改变currentIndex的值就会自动生成动画
 */
@interface YKCircleView : UIView

@property (nonatomic, assign) CircleViewType type;

@property (nonatomic, assign) CGFloat currentIndex;
@property (nonatomic, assign) CGFloat totalIndex;

//动画执行时间，默认是0.25
@property (nonatomic, assign) CFTimeInterval durationTime;

//圆弧宽度
@property (nonatomic, assign) CGFloat arcWidth;

//底层圆弧颜色
@property (nonatomic, strong) UIColor *downArcColor;
//上层圆弧颜色
@property (nonatomic, strong) UIColor *upArcColor;

/**
 *  使用该方法进行初始化，传入视图的类型。
 *
 *  @param type CircleViewType
 *
 *  @return YKCircleView
 */
- (instancetype)initWithType:(CircleViewType)type;

- (void)setProgress:(CGFloat)progress duration:(CFTimeInterval)duration;

@end
