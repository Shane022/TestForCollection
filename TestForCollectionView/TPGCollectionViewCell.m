//
//  TPGCollectionViewCell.m
//  TestForCollectionView
//
//  Created by new on 17/1/6.
//  Copyright © 2017年 new. All rights reserved.
//

#import "TPGCollectionViewCell.h"

@interface TPGCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TPGCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupComponent];
    }
    return self;
}

- (void)setupComponent
{
    self.backgroundColor = [UIColor clearColor];
    
    CGRect rect = self.frame;
    CGFloat labelHeight = 30;

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (rect.size.height-labelHeight)/2, rect.size.width, labelHeight)];
    _titleLabel.backgroundColor = [UIColor orangeColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.layer.masksToBounds = YES;
    _titleLabel.layer.cornerRadius = 14;
    [self addSubview:_titleLabel];
}

- (void)reloadTitle:(NSString *)title
{
    _titleLabel.text = title;
}

@end
