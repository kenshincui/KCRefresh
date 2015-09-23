//
//  TMRefreshFooter.m
//  Jinritemai
//
//  Created by KenshinCui on 15/7/23.
//  Copyright (c) 2015年 Jinritemai. All rights reserved.
//

#import "TMRefreshFooter.h"
#import "UIView+KC.h"

@implementation TMRefreshFooter

#pragma mark - 生命周期及其基类方法
-(void)contentOffsetChangeWithY:(CGFloat)offsetY{
    [super contentOffsetChangeWithY:offsetY];
    CGFloat offset=offsetY;
    if (offset+self.scrollView.height-self.scrollView.contentSize.height<0) {
        return;
    }
    self.offsetPercent=(offset+self.scrollView.height-self.scrollView.contentSize.height)/kTMRefreshComponentHeight;
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
    [super contentSizeChangeWithHeight:height];
    self.y=height;
}

-(void)contentInsetChangeWithTop:(CGFloat)top bottom:(CGFloat)bottom{
    [super contentInsetChangeWithTop:top bottom:bottom];
    if (bottom!=kTMRefreshComponentHeight+self.originEdgeInsets.bottom) { //内部由于刷新修改时不改变原始值
        UIEdgeInsets edgeInsets=self.originEdgeInsets;
        edgeInsets.bottom=bottom;
        self.originEdgeInsets=edgeInsets;
    }
}

-(void)offsetChange:(CGFloat)percent{
    
}

-(void)stateChange:(TMRefreshState)refreshState percent:(CGFloat)percent{
    if (refreshState == TMRefreshStateRefreshing) {
        [UIView animateWithDuration:0.5 animations:^{
            //修改顶部边界让刷新控件完全显示出来
            self.scrollView.contentInset=UIEdgeInsetsMake(self.originEdgeInsets.top, self.originEdgeInsets.left, self.originEdgeInsets.bottom+kTMRefreshComponentHeight,self.originEdgeInsets.right);
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
