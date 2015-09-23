//
//  UIScrollView+KCPagingRefresh.m
//  CMJStudio
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import "UIScrollView+KCPagingRefresh.h"
#import "UIView+KC.h"
@import ObjectiveC;

@implementation UIScrollView(KCPagingRefresh)
-(KCPagingRefreshHeader *)addPagingRefreshHeaderWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block{
    KCPagingRefreshHeader *refreshView=[[KCPagingRefreshHeader alloc]initWithIdleText:idleText pullingText:pullingText refreshingText:refreshingText refreshingBlock:block];
    refreshView.y = -kKCRefreshComponentHeight;
    [self addSubview:refreshView];
    self.pagingRefreshHeader=refreshView;
    return refreshView;
}
-(void)endPagingRefreshHeader{
    [self.pagingRefreshHeader endRefreshing];
}

-(KCPagingRefreshFooter *)addPagingRefreshFooterWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block{
    KCPagingRefreshFooter *refreshView=[[KCPagingRefreshFooter alloc]initWithIdleText:idleText pullingText:pullingText refreshingText:refreshingText refreshingBlock:block];
    refreshView.y = self.height;
    [self addSubview:refreshView];
    self.pagingRefreshFooter=refreshView;
    return refreshView;
}
-(void)endPagingRefreshFooter{
    [self.pagingRefreshFooter endRefreshing];
}

#pragma mark - 私有方法


#pragma mark - 属性
-(KCPagingRefreshHeader *)pagingRefreshHeader{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setPagingRefreshHeader:(KCPagingRefreshHeader *)pagingRefreshHeader{
    objc_setAssociatedObject(self, @selector(pagingRefreshHeader), pagingRefreshHeader, OBJC_ASSOCIATION_RETAIN);
}

-(KCPagingRefreshFooter *)pagingRefreshFooter{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setPagingRefreshFooter:(KCPagingRefreshFooter *)pagingRefreshFooter{
    objc_setAssociatedObject(self, @selector(pagingRefreshFooter), pagingRefreshFooter, OBJC_ASSOCIATION_RETAIN);
}
@end

