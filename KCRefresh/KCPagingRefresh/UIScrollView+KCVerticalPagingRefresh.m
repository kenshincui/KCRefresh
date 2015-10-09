//
//  UIScrollView+KCVerticalPagingRefresh.m
//  KCRefreshDemo
//
//  Created by KenshinCui on 15/9/22.
//  Copyright © 2015年 CMJStudio. All rights reserved.
//

#import "UIScrollView+KCVerticalPagingRefresh.h"
#import "UIView+KC.h"
@import ObjectiveC;


@implementation UIScrollView(KCVerticalPagingRefresh)
-(KCVerticalPagingRefreshHeader *)addVerticalPagingRefreshHeaderWithIdleText:(NSString *)idleText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block{
    KCVerticalPagingRefreshHeader *refreshView=[[KCVerticalPagingRefreshHeader alloc]initWithIdleText:idleText refreshingText:refreshingText refreshingBlock:block];
    refreshView.y = -kKCRefreshComponentHeight;
    [self addSubview:refreshView];
    self.verticalPagingRefreshHeader=refreshView;
    return refreshView;
}
-(void)endVerticalPagingRefreshHeader{
    self.contentInset = self.verticalPagingRefreshHeader.originEdgeInsets; //恢复初始化状态
    [self.verticalPagingRefreshHeader endRefreshing];
}

-(KCVerticalPagingRefreshFooter *)addVerticalPagingRefreshFooterWithIdleText:(NSString *)idleText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block{
    KCVerticalPagingRefreshFooter *refreshView=[[KCVerticalPagingRefreshFooter alloc]initWithIdleText:idleText refreshingText:refreshingText refreshingBlock:block];
    refreshView.y = self.height;
    [self addSubview:refreshView];
    self.verticalPagingRefreshFooter=refreshView;
    return refreshView;
}
-(void)endVerticalPagingRefreshFooter{
    self.contentInset = self.verticalPagingRefreshHeader.originEdgeInsets; //恢复初始化状态
    [self.verticalPagingRefreshFooter endRefreshing];
}

#pragma mark - 私有方法


#pragma mark - 属性
-(KCVerticalPagingRefreshHeader *)verticalPagingRefreshHeader{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setVerticalPagingRefreshHeader:(KCVerticalPagingRefreshHeader *)pagingRefreshHeader{
    objc_setAssociatedObject(self, @selector(verticalPagingRefreshHeader), pagingRefreshHeader, OBJC_ASSOCIATION_RETAIN);
}

-(KCVerticalPagingRefreshFooter *)verticalPagingRefreshFooter{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setVerticalPagingRefreshFooter:(KCVerticalPagingRefreshFooter *)pagingRefreshFooter{
    objc_setAssociatedObject(self, @selector(verticalPagingRefreshFooter), pagingRefreshFooter, OBJC_ASSOCIATION_RETAIN);
}
@end
