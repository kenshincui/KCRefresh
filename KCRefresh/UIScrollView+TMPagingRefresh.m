//
//  UIScrollView+TMPagingRefresh.m
//  Jinritemai
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 Jinritemai. All rights reserved.
//

#import "UIScrollView+TMPagingRefresh.h"
@import ObjectiveC;

@implementation UIScrollView(TMPagingRefresh)
-(TMPagingRefreshHeader *)addPagingRefreshHeaderWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block{
    TMPagingRefreshHeader *refreshView=[[TMPagingRefreshHeader alloc]initWithIdleText:idleText pullingText:pullingText refreshingText:refreshingText refreshingBlock:block];
    [self addSubview:refreshView];
    self.pagingRefreshHeader=refreshView;
    return refreshView;
}
-(void)endPagingRefreshHeader{
    [self.pagingRefreshHeader endRefreshing];
}

-(TMPagingRefreshFooter *)addPagingRefreshFooterWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block{
    TMPagingRefreshFooter *refreshView=[[TMPagingRefreshFooter alloc]initWithIdleText:idleText pullingText:pullingText refreshingText:refreshingText refreshingBlock:block];
    [self addSubview:refreshView];
    self.pagingRefreshFooter=refreshView;
    return refreshView;
}
-(void)endPagingRefreshFooter{
    [self.pagingRefreshFooter endRefreshing];
}

#pragma mark - 私有方法


#pragma mark - 属性
-(TMPagingRefreshHeader *)pagingRefreshHeader{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setPagingRefreshHeader:(TMPagingRefreshHeader *)pagingRefreshHeader{
    objc_setAssociatedObject(self, @selector(pagingRefreshHeader), pagingRefreshHeader, OBJC_ASSOCIATION_RETAIN);
}

-(TMPagingRefreshFooter *)pagingRefreshFooter{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setPagingRefreshFooter:(TMPagingRefreshFooter *)pagingRefreshFooter{
    objc_setAssociatedObject(self, @selector(pagingRefreshFooter), pagingRefreshFooter, OBJC_ASSOCIATION_RETAIN);
}
@end
