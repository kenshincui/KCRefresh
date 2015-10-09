//
//  UIScrollView+KCPagingRefresh.m
//  CMJStudio
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import "UIScrollView+KCNormalRefresh.h"
#import "UIView+KC.h"
@import ObjectiveC;

@implementation UIScrollView (KCNormalRefresh)
-(KCNormalRefreshHeader *)addRefreshHeaderWithRefreshingBlock:(void (^)())block{
    return [self addRefreshHeaderWithIdleText:@"下拉开始刷新" pullingText:@"松开开始刷新" refreshingText:@"正在刷新..." refreshingBlock:block];
}
- (KCNormalRefreshHeader *)addRefreshHeaderWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block {
	KCNormalRefreshHeader *refreshView = [[KCNormalRefreshHeader alloc] initWithIdleText:idleText pullingText:pullingText refreshingText:refreshingText refreshingBlock:block];
	refreshView.y = -kKCRefreshComponentHeight;
	[self addSubview:refreshView];
	self.refreshHeader = refreshView;
	return refreshView;
}
- (void)endRefreshHeader {
	[self.refreshHeader endRefreshing];
}

-(KCNormalRefreshFooter *)addRefreshFooterWithRefreshingBlock:(void (^)())block{
    return [self addRefreshFooterWithIdleText:@"上拉加载更多" pullingText:@"松开加载更多" refreshingText:@"正在加载..." refreshingBlock:block];
}
- (KCNormalRefreshFooter *)addRefreshFooterWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block {
	KCNormalRefreshFooter *refreshView = [[KCNormalRefreshFooter alloc] initWithIdleText:idleText pullingText:pullingText refreshingText:refreshingText refreshingBlock:block];
	refreshView.y = self.height;
	[self addSubview:refreshView];
	self.refreshFooter = refreshView;
	return refreshView;
}
- (void)endRefreshFooter {
	[self.refreshFooter endRefreshing];
}

#pragma mark - 私有方法

#pragma mark - 属性
- (KCNormalRefreshHeader *)refreshHeader {
	return objc_getAssociatedObject(self, _cmd);
}
- (void)setRefreshHeader:(KCNormalRefreshHeader *)refreshHeader {
	objc_setAssociatedObject(self, @selector(refreshHeader), refreshHeader, OBJC_ASSOCIATION_RETAIN);
}

- (KCNormalRefreshFooter *)refreshFooter {
	return objc_getAssociatedObject(self, _cmd);
}
- (void)setRefreshFooter:(KCNormalRefreshFooter *)refreshFooter {
	objc_setAssociatedObject(self, @selector(refreshFooter), refreshFooter, OBJC_ASSOCIATION_RETAIN);
}
@end
