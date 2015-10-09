//
//  UIScrollView+KCPagingRefresh.h
//  CMJStudio
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCNormalRefreshHeader.h"
#import "KCNormalRefreshFooter.h"

@interface UIScrollView (KCNormalRefresh)

- (KCNormalRefreshHeader *)addRefreshHeaderWithRefreshingBlock:(void (^)())block;
- (KCNormalRefreshHeader *)addRefreshHeaderWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block;
- (void)endRefreshHeader;

- (KCNormalRefreshFooter *)addRefreshFooterWithRefreshingBlock:(void (^)())block;
- (KCNormalRefreshFooter *)addRefreshFooterWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block;
- (void)endRefreshFooter;

@property(strong, nonatomic) KCNormalRefreshHeader *refreshHeader;

@property(strong, nonatomic) KCNormalRefreshFooter *refreshFooter;

@end
