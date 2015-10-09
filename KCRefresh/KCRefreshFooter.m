//
//  KCRefreshFooter.m
//  CMJStudio
//
//  Created by KenshinCui on 15/7/23.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import "KCRefreshFooter.h"
#import "UIView+KC.h"

static const CGFloat kBackOriginAnimationDuration = 0.3;

@implementation KCRefreshFooter

#pragma mark - 生命周期及其基类方法
- (void)contentOffsetChangeWithY:(CGFloat)offsetY {
	[super contentOffsetChangeWithY:offsetY];
	CGFloat offset = offsetY;
	if (offset + self.scrollView.height - self.scrollView.contentSize.height < 0 || self.scrollView.contentSize.height == 0) {
		return;
	}
	self.offsetPercent = (offset + self.scrollView.height - self.scrollView.contentSize.height) / kKCRefreshComponentHeight;
	[self offsetChange:self.offsetPercent];
	if (self.panState == 2) {
		if (self.offsetPercent < 1.0) {
			self.refreshState = 1;
		} else {
			self.refreshState = 2;
		}
	} else if (self.panState == 3 && self.offsetPercent < 0.1 && self.refreshState != 1) { //松开刷新回到原始位置
											       //		self.refreshState = 1;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kBackOriginAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		  self.refreshState = 1;
		});
	}
}

- (void)panStateChangeWithState:(NSUInteger)panState {
	[super panStateChangeWithState:panState];
	if (panState == 1) {
		self.refreshState = 1;
	} else if (panState == 3) {
		if (self.offsetPercent >= 1.0) {
			self.refreshState = 3;
		} else {
			self.refreshState = 1;
		}
	}
}

- (void)contentSizeChangeWithHeight:(CGFloat)height {
	[super contentSizeChangeWithHeight:height];
	self.y = height;
}

- (void)contentInsetChangeWithTop:(CGFloat)top bottom:(CGFloat)bottom {
	[super contentInsetChangeWithTop:top bottom:bottom];
	if (bottom != kKCRefreshComponentHeight + self.originEdgeInsets.bottom) { //内部由于刷新修改时不改变原始值
		UIEdgeInsets edgeInsets = self.originEdgeInsets;
		edgeInsets.bottom = bottom;
		self.originEdgeInsets = edgeInsets;
	}
}

- (void)offsetChange:(CGFloat)percent {
}

- (void)stateChange:(KCRefreshState)refreshState percent:(CGFloat)percent {
	if (refreshState == KCRefreshStateRefreshing) {
		[UIView animateWithDuration:0.5
		    animations:^{
		      //修改顶部边界让刷新控件完全显示出来
		      self.scrollView.contentInset = UIEdgeInsetsMake(self.originEdgeInsets.top, self.originEdgeInsets.left, self.originEdgeInsets.bottom + kKCRefreshComponentHeight, self.originEdgeInsets.right);
		    }
		    completion:^(BOOL finished) {
		      [self executeBlock];
		    }];
	} else if (refreshState == KCRefreshStateIdle) {
		[UIView animateWithDuration:kBackOriginAnimationDuration
				 animations:^{
				   self.scrollView.contentInset = self.originEdgeInsets;
				 }];
	}
}

/**
 *  结束刷新，注意这里重写了父类的处理，将松开之后的0.3秒内算作刷新状态而非空闲状态
 */
- (void)endRefreshing {
	[UIView animateWithDuration:kBackOriginAnimationDuration
	    animations:^{
	      self.scrollView.contentInset = self.originEdgeInsets;
	    }
	    completion:^(BOOL finished) {
	      self.refreshState = 1;
	      self.offsetPercent = 0.0; //避免再次上拉比例不正确造成自动加载
	    }];
}

@end
