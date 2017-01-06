//
//  TPGHeaderView.m
//  TestForCollectionView
//
//  Created by new on 17/1/6.
//  Copyright © 2017年 new. All rights reserved.
//

#import "TPGHeaderView.h"

@implementation TPGHeaderView

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
    self.backgroundColor = [UIColor lightGrayColor];
    
    CGRect rect = self.frame;
    CGFloat labelWidth = 80;
    CGFloat labelHeight = 20;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (rect.size.height-labelHeight)/2, labelWidth, labelHeight)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
}

@end
