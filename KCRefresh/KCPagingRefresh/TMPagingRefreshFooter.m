//
//  TMPagingRefreshView.m
//  Jinritemai
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 Jinritemai. All rights reserved.
//

#import "TMPagingRefreshFooter.h"
#import "TMPagingIndicatorView.h"
#import "UIView+KC.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kTMPagingRefreshIndicatorWidth 25.0

@interface TMPagingRefreshFooter()

@property (strong,nonatomic) TMPagingIndicatorView *indicatorView;
@property (strong,nonatomic) UIImageView *arrowImageView;
@property (strong,nonatomic) UILabel *descriptionLabel;

@end

@implementation TMPagingRefreshFooter
#pragma mark - 生命周期及其基类方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block{
    CGRect frame=CGRectMake(0.0, 0.0, kScreenWidth, kTMRefreshComponentHeight);
    if (self=[self initWithFrame:frame]) {
        self.idleText=idleText;
        self.pullingText=pullingText;
        self.refreshingText=refreshingText;
        self.refreshBlock=block;
    }
    return self;
}

-(void)offsetChange:(CGFloat)percent{
    [super offsetChange:percent];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.indicatorView.percent=percent;
    });
}

-(void)stateChange:(TMRefreshState)state percent:(CGFloat)percent{
    [super stateChange:state percent:percent];
    if (state==TMRefreshStateIdle) {
        self.descriptionLabel.text=self.idleText;
        [self.indicatorView endRotate];
    }else if(state==TMRefreshStatePulling){
        self.descriptionLabel.text=self.pullingText;
    }else{
        self.descriptionLabel.text=self.refreshingText;
        [self.indicatorView startRotate];
    }
}

#pragma mark - 私有方法
-(void)setup{
    self.idleText=@"上拉查看下一篇";
    self.pullingText=@"松开查看下一篇";
    self.refreshingText=@"正在切换";
    
    [self addSubview:self.indicatorView];
    
    [self addSubview:self.descriptionLabel];
}

#pragma mark - 属性
-(void)setIdleText:(NSString *)idleText{
    _idleText=idleText;
    self.descriptionLabel.text=idleText;
}

/**
 *  箭头图标
 */
-(UIImageView *)arrowImageView{
    if(!_arrowImageView){
        UIImage *image=[UIImage imageNamed:@"TMFramework.bundle/icon_arrow_gray_down"];
        _arrowImageView=[[UIImageView alloc]initWithImage:image];
    }
    return _arrowImageView;
}

/**
 *  左侧标识器视图
 */
-(TMPagingIndicatorView *)indicatorView{
    if(!_indicatorView){
        _indicatorView=[[TMPagingIndicatorView alloc]initWithFrame:CGRectMake(self.width*0.3, (self.height-kTMPagingRefreshIndicatorWidth)*0.5, kTMPagingRefreshIndicatorWidth, kTMPagingRefreshIndicatorWidth)];
        self.arrowImageView.centerX=_indicatorView.width*0.5;
        self.arrowImageView.centerY=_indicatorView.height*0.5;
        self.arrowImageView.transform=CGAffineTransformMakeRotation(M_PI);
        [_indicatorView addSubview:self.arrowImageView];
    }
    return _indicatorView;
}

/**
 *  文本信息
 */
-(UILabel *)descriptionLabel{
    if(!_descriptionLabel){
        _descriptionLabel=[UILabel labelWithFrame:CGRectMake(0, self.indicatorView.y, kScreenWidth, 21.0) textColor:[UIColor grayColor] fontSize:13.0];
        _descriptionLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _descriptionLabel;
}

@end
