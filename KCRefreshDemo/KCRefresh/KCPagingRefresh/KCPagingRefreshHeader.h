//
//  KCPagingRefreshView.h
//  CMJStudio
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCRefreshComponent.h"
#import "KCRefreshHeader.h"

@interface KCPagingRefreshHeader :KCRefreshHeader
/**
 *  初始化刷新控件
 *
 *  @param idleText       空闲时文本
 *  @param pullingText    拉动状态切换时的文本
 *  @param refreshingText 刷新时的文本
 *
 *  @return 分页刷新对象
 */
-(instancetype)initWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void(^)())block;

/**
 *  默认文本
 */
@property (copy,nonatomic) NSString *idleText;
/**
 *  准备刷新时的文本
 */
@property (copy,nonatomic) NSString *pullingText;
/**
 *  刷新时的文本
 */
@property (copy,nonatomic) NSString *refreshingText;

@end
