//
//  KCPagingRefreshView.m
//  CMJStudio
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import "KCVerticalPagingRefreshFooter.h"
#import "UIView+KC.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
static CGFloat kPagingRefreshArrowWidth = 25.0;
static CGFloat kAnimationDuration = 0.3;

@interface KCVerticalPagingRefreshFooter ()

@property(strong, nonatomic) UIImageView *arrowImageView;
@property(strong, nonatomic) UILabel *descriptionLabel;

@end

@implementation KCVerticalPagingRefreshFooter
#pragma mark - 生命周期及其基类方法
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithIdleText:(NSString *)idleText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block {
	CGRect frame = CGRectMake(0.0, 0.0, kScreenWidth, kKCRefreshComponentHeight);
	if (self = [self initWithFrame:frame]) {
		self.idleText = idleText;
		self.refreshingText = refreshingText;
		self.refreshBlock = block;
	}
	return self;
}

//注意这里重写了“contentInsetChangeWithTop: bottom:”在父类中会修改originEdgeInsets
-(void)contentInsetChangeWithTop:(CGFloat)top bottom:(CGFloat)bottom{
    //    [super contentInsetChangeWithTop:top bottom:bottom];
    if (bottom!=kKCRefreshComponentHeight+self.originEdgeInsets.bottom) {
        UIEdgeInsets edgeInsets=self.originEdgeInsets;
        edgeInsets.bottom=bottom;
        //        self.originEdgeInsets=edgeInsets;
    }
}

-(void)stateChange:(KCRefreshState)state percent:(CGFloat)percent{
    //    [super stateChange:state percent:percent];//注意这里不能调用supper的方法
    if (state==KCRefreshStateIdle) {
        self.scrollView.contentInset=self.originEdgeInsets;
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            self.descriptionLabel.text=self.idleText;
        }];
    }else if(state==KCRefreshStatePulling || state == KCRefreshStateRefreshing){
        if (state == KCRefreshStateRefreshing) {//避免弹回
            self.scrollView.contentInset=UIEdgeInsetsMake(self.originEdgeInsets.top, self.originEdgeInsets.left, self.originEdgeInsets.bottom,self.originEdgeInsets.right);
            self.scrollView.contentInset=UIEdgeInsetsMake(self.originEdgeInsets.top, self.originEdgeInsets.left, self.originEdgeInsets.bottom+kKCRefreshComponentHeight*percent,self.originEdgeInsets.right);
            [self executeBlock];
        }
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            self.descriptionLabel.text=self.refreshingText;
        }];
    }
}

#pragma mark - 私有方法
- (void)setup {
	self.idleText = @"上拉查看下一篇";
	self.refreshingText = @"正在切换";

	[self addSubview:self.arrowImageView];

	[self addSubview:self.descriptionLabel];
}

#pragma mark - 属性
- (void)setIdleText:(NSString *)idleText {
	_idleText = idleText;
	self.descriptionLabel.text = idleText;
}

/**
 *  箭头图标
 */
- (UIImageView *)arrowImageView {
	if (!_arrowImageView) {
		UIImage *image = [UIImage imageNamed:@"KCFramework.bundle/icon_arrow_gray_down"];
		_arrowImageView = [[UIImageView alloc] initWithImage:image];
		_arrowImageView.x = self.width * 0.3;
		_arrowImageView.y = kPagingRefreshArrowWidth * 0.5;
        _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
	}
	return _arrowImageView;
}

/**
 *  文本信息
 */
- (UILabel *)descriptionLabel {
	if (!_descriptionLabel) {
		_descriptionLabel = [UILabel labelWithFrame:CGRectMake(0, self.arrowImageView.y, kScreenWidth, 21.0) textColor:[UIColor grayColor] fontSize:13.0];
		_descriptionLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _descriptionLabel;
}

@end
