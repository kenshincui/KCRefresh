//
//  UIScrollView+KCVerticalPagingRefresh.h
//  KCRefreshDemo
//
//  Created by KenshinCui on 15/9/22.
//  Copyright © 2015年 CMJStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCVerticalPagingRefreshHeader.h"
#import "KCVerticalPagingRefreshFooter.h"


@interface UIScrollView(KCVerticalPagingRefresh)

-(KCVerticalPagingRefreshHeader *)addVerticalPagingRefreshHeaderWithIdleText:(NSString *)idleText refreshingText:(NSString *)refreshingText refreshingBlock:(void(^)())block;
-(void)endVerticalPagingRefreshHeader;

-(KCVerticalPagingRefreshHeader *)addVerticalPagingRefreshFooterWithIdleText:(NSString *)idleText refreshingText:(NSString *)refreshingText refreshingBlock:(void(^)())block;
-(void)endVerticalPagingRefreshFooter;

@property (strong,nonatomic) KCVerticalPagingRefreshHeader *verticalPagingRefreshHeader;

@property (strong,nonatomic) KCVerticalPagingRefreshFooter *verticalPagingRefreshFooter;

@end