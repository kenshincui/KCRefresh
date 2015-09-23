//
//  TMRefreshComponent.h
//  Jinritemai
//
//  Created by KenshinCui on 15/7/23.
//  Copyright (c) 2015年 Jinritemai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTMRefreshComponentHeight 44.0

/**
 *  刷新状态
 */
typedef NS_ENUM(NSInteger, TMRefreshState){
    /**
     *  空闲状态
     */
    TMRefreshStateIdle=1,
    /**
     *  即将刷新状态
     */
    TMRefreshStatePulling,
    /**
     *  刷新状态
     */
    TMRefreshStateRefreshing
};

/**
 *  基础刷新组件
 *  
 *  注意：
 *  1.非特殊情况下不建议直接集成此类，优先选择TMRefreshHeader或TMRefreshFooter，
 *    并且不建议重写contentOffsetChangeWithY:、panStateChangeWithState:、contentSizeChangeWithHeight:
 *    建议重写offsetChange:、stateChange:percent:，前者主要进行内部状态转化，后者用于刷新状态转化（进一步抽象）
 *  2.此控件适用于UIScrollview或者其子类，不仅仅用于分页刷新同样适用于普通的刷新情况
 *
 *  使用方法：
 *  1.继承于TMRefreshComponent
 *  2.重写offsetChange:和stateChange:percent:方法
 */
@interface TMRefreshComponent : UIView
#pragma mark - 生命周期及其基类方法
/**
 *  偏移量发生变化
 *
 *  @param offsetY y方向上的偏移量
 */
-(void)contentOffsetChangeWithY:(CGFloat)offsetY;

/**
 *  拖拽状态发生变化
 *
 *  @param panState 拖拽状态
 */
-(void)panStateChangeWithState:(NSUInteger)panState;

/**
 *  尺寸发生变化
 *
 *  @param height 高度
 */
-(void)contentSizeChangeWithHeight:(CGFloat)height;

/**
 *  边距发生变化
 *
 *  @param top    顶部边距
 *  @param bottom 底部边距
 */
-(void)contentInsetChangeWithTop:(CGFloat)top bottom:(CGFloat)bottom;

#pragma mark - 属性
/**
 *  所在的滚动视图
 */
@property (weak,nonatomic) UIScrollView *scrollView;

/**
 *  当前拖拽状态
 */
@property (assign,nonatomic) NSUInteger panState;

#pragma mark - 公共方法
/**
 *  结束刷新
 */
-(void)endRefreshing;
/**
 *  执行block
 */
-(void)executeBlock;

#pragma mark - 虚方法需要子类实现
/**
 *  偏移量即将发生改变
 *
 *  @param percent 偏移量百分比
 */
-(void)offsetChange:(CGFloat)percent;

/**
 *  状态即将发生改变
 *
 *  @param state   状态
 *  @param percent 偏移量百分比
 */
-(void)stateChange:(TMRefreshState)refreshState percent:(CGFloat)percent;

#pragma mark - 虚属性需要子类实现
/**
 *  刷新状态，默认为TMRefreshStateIdle
 */
@property (assign,nonatomic) TMRefreshState refreshState;

/**
 *  移动偏移量（范围：0.0-1.0）
 */
@property (assign,nonatomic) CGFloat offsetPercent;

/**
 *  UIScrollView非刷新状态下的边距（刷新时会TMRefreshComponent会自动将其增大）
 */
@property (assign,nonatomic) UIEdgeInsets originEdgeInsets;

#pragma mark - 调用者写属性
/**
 *  刷新时的回调方法
 */
@property (copy,nonatomic) void(^refreshBlock)();

@end

