//
//  YKStepCircleView.m
//  ABC360
//
//  Created by abc360 on 9/14/15.
//  Copyright (c) 2015 chenjaixin. All rights reserved.
//

#import "YKCircleView.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////

@interface YKCircleLayer : CAShapeLayer

@property (nonatomic, assign) CircleViewType type;

@property (nonatomic, assign) CGFloat currentIndex;
@property (nonatomic, assign) CGFloat totalIndex;

@property (nonatomic, assign) CFTimeInterval durationTime;

@property (nonatomic, assign) CGFloat arcWidth;

@property (nonatomic, strong) UIColor *downArcColor;
@property (nonatomic, strong) UIColor *upArcColor;

- (instancetype)initWithType:(CircleViewType)type;

@end

@implementation YKCircleLayer

@dynamic currentIndex;

- (instancetype)init {
    return [self initWithType:CircleViewTypeProgress];
}

- (instancetype)initWithType:(CircleViewType)type {
    if (self = [super init]) {
        _durationTime = 0.25f;
        _type = type;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"currentIndex"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)display {
    
    // 获取当前Index
    CGFloat currentIndex = [self.presentationLayer currentIndex];
    CGFloat x = self.bounds.size.width / 2;
    CGFloat y = self.bounds.size.height / 2;
    CGFloat radiu = self.bounds.size.width / 2 - _arcWidth / 2;
    CGFloat offset = - M_PI_2;
    
    // 创建绘制上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 绘制下层圆环
    CGContextSetStrokeColorWithColor(ctx, _downArcColor.CGColor);
    CGContextSetLineWidth(ctx, _arcWidth);//线的宽度
    CGContextAddArc(ctx, x, y, radiu, 0, 2 * M_PI, 0);
    CGContextDrawPath(ctx, kCGPathStroke); //绘制路径
    
    // 绘制上层圆环
    CGFloat angle = 0;
    if (_type == CircleViewTypeStep) {
        angle = currentIndex / _totalIndex * 2.0 * M_PI + offset;
    } else if (_type == CircleViewTypeProgress) {
        angle = currentIndex * 2.0 * M_PI + offset;
    }
    CGContextSetStrokeColorWithColor(ctx, _upArcColor.CGColor);
    CGContextSetLineWidth(ctx, _arcWidth);//线的宽度
    CGContextAddArc(ctx, x, y, radiu, offset, angle, 0);
    CGContextDrawPath(ctx, kCGPathStroke); //绘制路径
    
    if (_type == CircleViewTypeStep) {
        NSString *string = [NSString stringWithFormat:@"%.2ld/%.2ld", (long)currentIndex, (long)_totalIndex];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
        CGSize size = [string sizeWithFont:font];
        CGFloat x = (self.bounds.size.width - size.width) / 2;
        CGFloat y = (self.bounds.size.height - size.height) / 2;
        NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1.0]};
        [string drawAtPoint:CGPointMake(x, y) withAttributes:attributes];
    }
    
    //set backing image 设置 contents
    self.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"currentIndex"]) {
        CGFloat currentIndex = [[self presentationLayer] currentIndex];
        if (_type == CircleViewTypeStep) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
            animation.fromValue = @(currentIndex);
            animation.duration = _durationTime;
            return animation;
        } else if (_type == CircleViewTypeProgress) {
            if (currentIndex == 0.0f || currentIndex == 1.0f) {
                return [super actionForKey:event];
            } else {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
                animation.fromValue = @(currentIndex);
                animation.duration = _durationTime;
                return animation;
            }
        }
    }
    return [super actionForKey:event];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////

@interface YKCircleView ()

@property (nonatomic, strong) YKCircleLayer *circleLayer;

@end

@implementation YKCircleView

+ (Class)layerClass {
    return [YKCircleLayer class];
}

- (instancetype)initWithType:(CircleViewType)type {
    if (self = [super init]) {
        [self initialize];
        _circleLayer.type = type;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.clipsToBounds = YES;
    _circleLayer = (YKCircleLayer *)self.layer;
    _circleLayer.cornerRadius = _circleLayer.bounds.size.width / 2;
}

- (void)setType:(CircleViewType)type {
    _circleLayer.type = type;
}

- (void)setCurrentIndex:(CGFloat)currentIndex {
    _circleLayer.currentIndex = currentIndex;
}

- (void)setTotalIndex:(CGFloat)totalIndex {
    _circleLayer.totalIndex = totalIndex;
}

- (void)setDurationTime:(CFTimeInterval)durationTime {
    _circleLayer.durationTime = durationTime;
}

- (void)setArcWidth:(CGFloat)arcWidth {
    _circleLayer.arcWidth = arcWidth;
}

- (void)setDownArcColor:(UIColor *)downArcColor {
    _circleLayer.downArcColor = downArcColor;
}

- (void)setUpArcColor:(UIColor *)upArcColor {
    _circleLayer.upArcColor = upArcColor;
}

- (void)setProgress:(CGFloat)progress duration:(CFTimeInterval)duration; {
    _circleLayer.durationTime = duration;
    _circleLayer.currentIndex = MAX(MIN(progress, 1.0f), 0.0f);;
}

@end

