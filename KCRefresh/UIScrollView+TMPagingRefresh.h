//
//  UIScrollView+TMPagingRefresh.h
//  Jinritemai
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 Jinritemai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMPagingRefreshHeader.h"
#import "TMPagingRefreshFooter.h"

@interface UIScrollView(TMPagingRefresh)

-(TMPagingRefreshHeader *)addPagingRefreshHeaderWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void(^)())block;
-(void)endPagingRefreshHeader;

-(TMPagingRefreshFooter *)addPagingRefreshFooterWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void(^)())block;
-(void)endPagingRefreshFooter;

@property (strong,nonatomic) TMPagingRefreshHeader *pagingRefreshHeader;

@property (strong,nonatomic) TMPagingRefreshFooter *pagingRefreshFooter;

@end
