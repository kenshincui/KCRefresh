
//
//  KCCardView.m
//  KCRefreshDemo
//
//  Created by KenshinCui on 15/9/22.
//  Copyright © 2015年 CMJStudio. All rights reserved.
//

#import "KCCardView.h"
#import "UIView+KC.h"

#define kScreenSize ([UIScreen mainScreen].bounds.size)

static const CGFloat kCommonSpace = 8.0;
@interface KCCardView ()

@property(strong, nonatomic) UIImageView *avatarImageView;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *introductionLabel;

@end

@implementation KCCardView
#pragma mark - 生命周期及其基类方法
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setupUI];
	}
	return self;
}

#pragma mark - 私有方法
- (void)setupUI {
	self.backgroundColor = [UIColor colorWithRed:18.0 / 255.0 green:144.0 / 255.0 blue:191.0 / 255.0 alpha:1.0];
	[self addSubview:self.avatarImageView];
	[self addSubview:self.nameLabel];
	[self addSubview:self.introductionLabel];
}

#pragma mark - 属性
- (void)setPerson:(KCPerson *)person {
	_person = person;

	_avatarImageView.image = [UIImage imageNamed:person.avatarUrl];
	_nameLabel.text = person.name;
	_introductionLabel.text = person.introduction;
	_introductionLabel.width = kScreenSize.width - 2 * kCommonSpace;
	[_introductionLabel sizeToFit];
}

/**
 *  头像
 */
- (UIImageView *)avatarImageView {
	if (!_avatarImageView) {
		_avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenSize.width, kScreenSize.width)];
        _avatarImageView.contentMode=UIViewContentModeScaleAspectFit;
	}
	return _avatarImageView;
}

/**
 *  姓名
 */
- (UILabel *)nameLabel {
	if (!_nameLabel) {
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCommonSpace, kScreenSize.width - 25.0, 200.0, 21.0)];
		_nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
		_nameLabel.textColor = [UIColor colorWithRed:243.0 / 255.0 green:115.0 / 255.0 blue:45.0 / 255.0 alpha:1.0];
	}
	return _nameLabel;
}

/**
 *  简介，高度不固定
 */
- (UILabel *)introductionLabel {
	if (!_introductionLabel) {
		_introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCommonSpace, kScreenSize.width + 3 * kCommonSpace, kScreenSize.width - 2 * kCommonSpace, 21.0)];
		_introductionLabel.font = [UIFont systemFontOfSize:18.0];
		_introductionLabel.textColor = [UIColor whiteColor];
		_introductionLabel.numberOfLines = 0;
	}
	return _introductionLabel;
}
@end
