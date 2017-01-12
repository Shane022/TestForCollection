//
//  ViewController.m
//  TestForCollectionView
//
//  Created by new on 17/1/6.
//  Copyright © 2017年 new. All rights reserved.
//

#import "ViewController.h"
#import "TPGCollectionViewCell.h"
#import "TPGHeaderView.h"

@interface ViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@end

@implementation ViewController
{
    NSMutableArray *_arrMyData;
    NSMutableArray *_arrMoreData;
    UILongPressGestureRecognizer *_longPressGesture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
}

- (void)setupComponent
{
    _arrMyData = [NSMutableArray arrayWithCapacity:0];
    _arrMoreData = [NSMutableArray arrayWithCapacity:0];
    NSArray *arrTem = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    NSArray *arrMoreTem = @[@"100",@"101",@"102",@"103"];
    _arrMyData = [NSMutableArray arrayWithArray:arrTem];
    _arrMoreData = [NSMutableArray arrayWithArray:arrMoreTem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_mainCollectionView registerClass:[TPGCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_mainCollectionView registerClass:[TPGHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    [self.view addSubview:_mainCollectionView];
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [_mainCollectionView addGestureRecognizer:_longPressGesture];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0) {
        count = _arrMyData.count;
    } else if (section == 1) {
        count = _arrMoreData.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TPGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell reloadTitle:[_arrMyData objectAtIndex:indexPath.row]];
    } else if (indexPath.section == 1) {
        [cell reloadTitle:[_arrMoreData objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TPGHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.titleLabel.text = @"我的频道";
    } else if (indexPath.section == 1) {
        headerView.titleLabel.text = @"更多频道";
    }
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSInteger sourceSection = sourceIndexPath.section;
    NSInteger destinationSection = destinationIndexPath.section;
    NSString *temp ;
    
    if (sourceSection == destinationSection) {
        // 同层
        if (sourceSection == 0) {
            temp = [_arrMyData objectAtIndex:sourceIndexPath.row];
            [_arrMyData removeObjectAtIndex:sourceIndexPath.row];
            [_arrMyData insertObject:temp atIndex:destinationIndexPath.row];
        } else if (sourceSection == 1) {
            temp = [_arrMoreData objectAtIndex:sourceIndexPath.row];
            [_arrMoreData removeObjectAtIndex:sourceIndexPath.row];
            [_arrMoreData insertObject:temp atIndex:destinationIndexPath.row];
        }
    } else {
        // 不同层
        // TODO:如果0层的元素已经全转到1层，需要添加1层的元素转移到0层的处理
        if (destinationSection == 0) {
            temp = [_arrMoreData objectAtIndex:sourceIndexPath.row];
            [_arrMoreData removeObjectAtIndex:sourceIndexPath.row];
            [_arrMyData insertObject:temp atIndex:destinationIndexPath.row];
        } else if (destinationSection == 1) {
            temp = [_arrMyData objectAtIndex:sourceIndexPath.row];
            [_arrMyData removeObjectAtIndex:sourceIndexPath.row];
            [_arrMoreData insertObject:temp atIndex:destinationIndexPath.row];
        }
    }
    
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat gap = 10;
    CGFloat numberOfItem = 6;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize size = CGSizeMake((screenWidth-gap*(numberOfItem-1-2))/numberOfItem, 40);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat gap = 10;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(gap, gap, gap, gap);
    return edgeInsets;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [collectionView performBatchUpdates:^{
            id item = [_arrMyData objectAtIndex:indexPath.row];
            [_arrMyData removeObject:item];
            [_arrMoreData addObject:item];
            NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:_arrMoreData.count-1 inSection:1];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:destinationIndexPath];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [collectionView performBatchUpdates:^{
            id item = [_arrMoreData objectAtIndex:indexPath.row];
            [_arrMoreData removeObject:item];
            [_arrMyData addObject:item];
            NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:_arrMyData.count-1 inSection:0];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:destinationIndexPath];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Action
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    NSIndexPath *indexPath = [_mainCollectionView indexPathForItemAtPoint:[gesture locationInView:_mainCollectionView]];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            //当长按手势刚开始时，开始执行移动操作
            [_mainCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            //当长按手势改变位置时，执行移动的操作
            //下面两个状态，方法和意思相同
            [_mainCollectionView updateInteractiveMovementTargetPosition:[gesture locationInView:_mainCollectionView]];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [_mainCollectionView endInteractiveMovement];
            break;
        }
        default:
            [_mainCollectionView cancelInteractiveMovement];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
