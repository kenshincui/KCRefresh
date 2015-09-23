//
//  UIScrollView+KCPagingRefresh.h
//  CMJStudio
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCPagingRefreshHeader.h"
#import "KCPagingRefreshFooter.h"

@interface UIScrollView(KCPagingRefresh)

-(KCPagingRefreshHeader *)addPagingRefreshHeaderWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void(^)())block;
-(void)endPagingRefreshHeader;

-(KCPagingRefreshFooter *)addPagingRefreshFooterWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void(^)())block;
-(void)endPagingRefreshFooter;

@property (strong,nonatomic) KCPagingRefreshHeader *pagingRefreshHeader;

@property (strong,nonatomic) KCPagingRefreshFooter *pagingRefreshFooter;

@end

