//
//  KCRefreshHeader.m
//  CMJStudio
//
//  Created by KenshinCui on 15/7/23.
//  Copyright (c) 2015年 CMJStudio. All rights reserved.
//

#import "KCRefreshHeader.h"
#import "UIView+KC.h"
static const CGFloat kBackOriginAnimationDuration = 0.3;
@implementation KCRefreshHeader
#pragma mark - 生命周期及其基类方法
- (void)contentOffsetChangeWithY:(CGFloat)offsetY {
	[super contentOffsetChangeWithY:offsetY];
	if (offsetY > -self.originEdgeInsets.top || self.scrollView.contentSize.height == 0) { //看不到则直接返回
		return;
	}
	CGFloat offset = -(offsetY - self.originOffsetY);
	self.offsetPercent = offset / kKCRefreshComponentHeight;
	[self offsetChange:self.offsetPercent];
	if (self.panState == 2) {
		if (self.offsetPercent < 1.0) {
			self.refreshState = 1;
		} else {
			self.refreshState = 2;
		}
	} else if (self.panState == 3 && self.offsetPercent < 0.1 && self.refreshState != 1) { //松开刷新回到原始位置
											       //        self.refreshState = 1;
		//刷新后的一瞬间算作刷新状态而非空闲状态
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
	[super contentOffsetChangeWithY:height];
	self.y = -self.height;
}

- (void)contentInsetChangeWithTop:(CGFloat)top bottom:(CGFloat)bottom {
	[super contentInsetChangeWithTop:top bottom:bottom];
	if (top != kKCRefreshComponentHeight + self.originEdgeInsets.top) { //内部由于刷新修改时不改变原始值
		UIEdgeInsets edgeInsets = self.originEdgeInsets;
		edgeInsets.top = top;
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
		      self.scrollView.contentInset = UIEdgeInsetsMake(self.originEdgeInsets.top + kKCRefreshComponentHeight, self.originEdgeInsets.left, self.originEdgeInsets.bottom, self.originEdgeInsets.right);
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
	    }];
}

@end
