//
//  KCPagingRefreshView.m
//  CMJStudio
//
//  Created by KenshinCui on 15/7/22.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import "KCNormalRefreshFooter.h"
#import "UIView+KC.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kKCNormalRefreshIndicatorWidth 25.0
static const CGFloat kRotateAnimationDuration = 0.2 ;
@interface KCNormalRefreshFooter ()

@property(strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property(strong, nonatomic) UIImageView *arrowImageView;
@property(strong, nonatomic) UILabel *descriptionLabel;

@end

@implementation KCNormalRefreshFooter
#pragma mark - 生命周期及其基类方法
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithIdleText:(NSString *)idleText pullingText:(NSString *)pullingText refreshingText:(NSString *)refreshingText refreshingBlock:(void (^)())block {
	CGRect frame = CGRectMake(0.0, 0.0, kScreenWidth, kKCRefreshComponentHeight);
	if (self = [self initWithFrame:frame]) {
		self.idleText = idleText;
		self.pullingText = pullingText;
		self.refreshingText = refreshingText;
		self.refreshBlock = block;
	}
	return self;
}

- (void)stateChange:(KCRefreshState)state percent:(CGFloat)percent {
	[super stateChange:state percent:percent];
	if (state == KCRefreshStateIdle) {
		self.descriptionLabel.text = self.idleText;
		[self.indicatorView stopAnimating];
        self.arrowImageView.hidden = NO;
        [UIView animateWithDuration:kRotateAnimationDuration  animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
	} else if (state == KCRefreshStatePulling) {
		self.descriptionLabel.text = self.pullingText;
        [UIView animateWithDuration:kRotateAnimationDuration  animations:^{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }];
	} else {
		self.descriptionLabel.text = self.refreshingText;
		[self.indicatorView startAnimating];
        self.arrowImageView.hidden = YES;
        
	}
}

#pragma mark - 私有方法
- (void)setup {
	self.idleText = @"上拉加载更多";
	self.pullingText = @"松开加载";
	self.refreshingText = @"正在加载...";

    [self addSubview:self.arrowImageView];
	[self addSubview:self.indicatorView];
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
		UIImage *image = [UIImage imageNamed:@"KCFramework.bundle/arrow_gray_down"];
		_arrowImageView = [[UIImageView alloc] initWithImage:image];
        _arrowImageView.x = self.width * 0.3;
		_arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
	}
	return _arrowImageView;
}

/**
 *  加载视图
 */
-(UIActivityIndicatorView *)indicatorView{
    if(!_indicatorView){
        _indicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0, 0.0, kKCNormalRefreshIndicatorWidth, kKCNormalRefreshIndicatorWidth)];
        _indicatorView.color = [UIColor grayColor];
        _indicatorView.center = self.arrowImageView.center;
    }
    return _indicatorView;
}

/**
 *  文本信息
 */
- (UILabel *)descriptionLabel {
	if (!_descriptionLabel) {
		_descriptionLabel = [UILabel labelWithFrame:CGRectMake(0, self.indicatorView.y, kScreenWidth, 21.0) textColor:[UIColor grayColor] fontSize:13.0];
		_descriptionLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _descriptionLabel;
}

@end
