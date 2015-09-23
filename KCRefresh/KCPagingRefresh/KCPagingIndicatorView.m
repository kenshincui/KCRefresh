//
//  KCPagingIndicatorView.m
//  CMJStudio
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import "KCPagingIndicatorView.h"
#import "UIView+KC.h"

#define kKCPagingIndicatorViewAnimationKey @"KCPagingIndicatorViewRotateAnimationKey"

@interface KCPagingIndicatorView()
@property (strong,nonatomic) CAShapeLayer *shapeLayer;
@property (strong,nonatomic) CABasicAnimation *rotateAnimation;
@end

@implementation KCPagingIndicatorView
#pragma mark - 生命周期及其基类方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.percent=0.0;
        self.color=[UIColor grayColor];
        self.backgroundColor=[UIColor clearColor];
        [self.layer addSublayer:self.shapeLayer];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    CGRect newFrame=frame;
    newFrame.size.height=newFrame.size.width;
    [super setFrame:newFrame];
}

#pragma mark - 公共方法
-(void)startRotate{
    [self endRotate];
    [self.shapeLayer addAnimation:self.rotateAnimation forKey:kKCPagingIndicatorViewAnimationKey];
}

-(void)endRotate{
    if ([self.shapeLayer animationForKey:kKCPagingIndicatorViewAnimationKey]) {
        [self.shapeLayer removeAnimationForKey:kKCPagingIndicatorViewAnimationKey];
    }
}

#pragma mark - 属性
-(void)setPercent:(CGFloat)percent{
    if(percent>1.0){
        percent=1.0;
    }
    _percent=percent;
    
    self.shapeLayer.strokeEnd=percent;//避免动画后回到原点
}

-(void)setColor:(UIColor *)color{
    _color=color;
    self.shapeLayer.strokeColor=color.CGColor;
}

/**
 *  标识层
 */
-(CAShapeLayer *)shapeLayer{
    if(!_shapeLayer){
        CGFloat radius=self.width*0.48;
        CGFloat startAngle=-M_PI_2;
        CGFloat endAngle=M_PI*1.4;
        CGPoint center=CGPointMake(self.width*0.5, self.height*0.5);
        UIBezierPath *arcPath=[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        _shapeLayer=[CAShapeLayer layer];
        _shapeLayer.bounds=self.bounds;
        _shapeLayer.position=center;
        _shapeLayer.fillColor=[UIColor clearColor].CGColor;
        _shapeLayer.lineWidth=1.0;
//        _shapeLayer.strokeColor=self.color.CGColor;
        _shapeLayer.path=arcPath.CGPath;
        
        _shapeLayer.strokeStart=0.0;
        _shapeLayer.strokeEnd=0.0;
    }
    return _shapeLayer;
}

/**
 *  旋转动画
 */
-(CABasicAnimation *)rotateAnimation{
    if(!_rotateAnimation){
        _rotateAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotateAnimation.duration=0.05;
        _rotateAnimation.fromValue=@(0.0);
        _rotateAnimation.toValue=@(M_2_PI);
        _rotateAnimation.cumulative=YES;
        _rotateAnimation.repeatCount=HUGE_VAL;
    }
    return _rotateAnimation;
}

@end
