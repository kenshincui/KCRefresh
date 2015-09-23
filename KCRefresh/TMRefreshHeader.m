//
//  TMRefreshHeader.m
//  Jinritemai
//
//  Created by KenshinCui on 15/7/23.
//  Copyright (c) 2015年 Jinritemai. All rights reserved.
//

#import "TMRefreshHeader.h"
#import "UIView+KC.h"

@implementation TMRefreshHeader
#pragma mark - 生命周期及其基类方法
-(void)contentOffsetChangeWithY:(CGFloat)offsetY{
    [super contentOffsetChangeWithY:offsetY];
    if (offsetY>-self.originEdgeInsets.top) { //看不到则直接返回
        return;
    }
    CGFloat offset=-offsetY;
    self.offsetPercent=offset/kTMRefreshComponentHeight;
    [self offsetChange:self.offsetPercent];
    if (self.panState==2) {
        if (self.offsetPercent<1.0){
            self.refreshState=1;
        }else{
            self.refreshState=2;
        }
    }else if(self.panState==3&&self.offsetPercent<0.1) { //松开刷新回到原始位置
        self.refreshState=1;
    }
}

-(void)panStateChangeWithState:(NSUInteger)panState{
    [super panStateChangeWithState:panState];
    if (panState==1) {
        self.refreshState=1;
    }else if (panState==3){
        if (self.offsetPercent>=1.0) {
            self.refreshState=3;
        }else{
            self.refreshState=1;
        }
    }
}

-(void)contentSizeChangeWithHeight:(CGFloat)height{
    [super contentOffsetChangeWithY:height];
    self.y=-self.height;
}

-(void)contentInsetChangeWithTop:(CGFloat)top bottom:(CGFloat)bottom{
    [super contentInsetChangeWithTop:top bottom:bottom];
    if (top!=kTMRefreshComponentHeight+self.originEdgeInsets.top) { //内部由于刷新修改时不改变原始值
        UIEdgeInsets edgeInsets=self.originEdgeInsets;
        edgeInsets.top=top;
        self.originEdgeInsets=edgeInsets;
    }
}

-(void)offsetChange:(CGFloat)percent{
    
}

-(void)stateChange:(TMRefreshState)refreshState percent:(CGFloat)percent{
    if (refreshState == TMRefreshStateRefreshing) {
        [UIView animateWithDuration:0.5 animations:^{
            //修改顶部边界让刷新控件完全显示出来
            self.scrollView.contentInset=UIEdgeInsetsMake(self.originEdgeInsets.top + kTMRefreshComponentHeight, self.originEdgeInsets.left, self.originEdgeInsets.bottom,self.originEdgeInsets.right);
        } completion:^(BOOL finished) {
            [self executeBlock];
        }];
    }else if (refreshState == TMRefreshStateIdle){
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset=self.originEdgeInsets;
        }];
    }
}

@end
