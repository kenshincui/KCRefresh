//
//  KCRefreshComponent.m
//  CMJStudio
//
//  Created by KenshinCui on 15/7/23.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import "KCRefreshComponent.h"

@interface KCRefreshComponent()
//UIScrollView手势，避免UIScrollView被释放后移除KVO报错
@property (strong,nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

//是否已经开始拖拽，默认为NO
@property (assign,nonatomic) BOOL startDrag;
@end

@implementation KCRefreshComponent
#pragma mark - 生命周期及其基类方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview&&![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    [self removeObserver];
    if (newSuperview) {
        self.scrollView=(UIScrollView *)newSuperview;
        self.originEdgeInsets=self.scrollView.contentInset;
        _originOffsetY = self.scrollView.contentOffset.y;
        [self addObserver];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentOffset"]){ //偏移量发生变化
        CGPoint offset=[[change valueForKey:@"new"] CGPointValue];
        if (!self.startDrag) {
            _originOffsetY = offset.y;
        }
        [self contentOffsetChangeWithY:offset.y];
//    }else if([keyPath isEqualToString:@"pan.state"]){ //拖拽状态发生变化
    }else if([keyPath isEqualToString:@"state"]){ //拖拽状态发生变化
        self.startDrag = YES;
        NSInteger panState=[[change valueForKey:@"new"] integerValue];
        _panState=panState;
        [self panStateChangeWithState:panState];
    }else if([keyPath isEqualToString:@"contentSize"]){
        CGSize contentSize=[[change valueForKey:@"new"] CGSizeValue];
        [self contentSizeChangeWithHeight:contentSize.height];
    }else if([keyPath isEqualToString:@"contentInset"]){
        UIEdgeInsets edgeInsets=[[change valueForKey:@"new"] UIEdgeInsetsValue];
        if (!self.startDrag) {
            self.originEdgeInsets = edgeInsets;
        }
        [self contentInsetChangeWithTop:edgeInsets.top bottom:edgeInsets.bottom];
    }
}

//-(void)dealloc{
////    [self removeObserver];
//}

-(void)contentOffsetChangeWithY:(CGFloat)offsetY{
    
}
-(void)panStateChangeWithState:(NSUInteger)panState{
    
}
-(void)contentSizeChangeWithHeight:(CGFloat)height{
    
}
-(void)contentInsetChangeWithTop:(CGFloat)top bottom:(CGFloat)bottom{
    
}
#pragma mark - 私有方法
-(void)initializer{
    
}

-(void)addObserver{
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//    [self.scrollView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    self.panGestureRecognizer=self.scrollView.panGestureRecognizer;
    [self.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserver{
    //注意这里不能使用“self.scrollView removeObserver: forKeyPath:”因为在UIScrollView被销毁时此时没有self.scrollView但是存在self.supperview
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
//    [self.superview removeObserver:self forKeyPath:@"pan.state"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
    [self.superview removeObserver:self forKeyPath:@"contentInset"];
    [self.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    self.panGestureRecognizer=nil;
}

#pragma mark - 属性
-(void)setRefreshState:(KCRefreshState)refreshState{
    if (_refreshState!=refreshState) {
        _refreshState=refreshState;
        [self stateChange:refreshState percent:self.offsetPercent];
    }
}

#pragma mark - 公共方法
-(void)endRefreshing{
    //注意对于有些情况下结束刷新后需要延迟一会才能变成空闲状态（此情况下在回到原来位置的过程中算作刷新），此时需要重写此方法
    self.refreshState=KCRefreshStateIdle;
}

-(void)executeBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        !self.refreshBlock?:self.refreshBlock();
    });
}

#pragma mark - 虚方法空实现（避免警告）
-(void)stateChange:(KCRefreshState)refreshState percent:(CGFloat)percent{
    
}
-(void)offsetChange:(CGFloat)percent{
    
}

@end
