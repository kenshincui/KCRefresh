//
//  TMPagingIndicatorView.h
//  Jinritemai
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 Jinritemai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMPagingIndicatorView : UIView

/**
 *  开始旋转
 */
-(void)startRotate;

/**
 *  停止旋转
 */
-(void)endRotate;

/**
 *  标识百分比（范围：0-1）
 */
@property (assign,nonatomic) CGFloat percent;

/**
 *  颜色
 */
@property (strong,nonatomic) UIColor *color;


@end
