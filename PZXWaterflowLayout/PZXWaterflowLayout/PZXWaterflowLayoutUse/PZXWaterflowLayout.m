//
//  PZXWaterflowLayout.m
//  瀑布流呆萌
//
//  Created by 彭祖鑫 on 16/1/26.
//  Copyright © 2016年 彭祖鑫. All rights reserved.
//

#import "PZXWaterflowLayout.h"

#define JPCollectionW self.collectionView.frame.size.width
#warning 在这里可以修改各种属性！
/** 每一行之间的间距 */
static const CGFloat JPDefaultRowMargin = 10;
/** 每一列之间的间距 */
static const CGFloat JPDefaultColumnMargin = 10;
/** 一列之间的间距 top(是第一列), left, bottom, right */
static const UIEdgeInsets JPDefaultInsets = {150, 10, 10, 10};
/** 默认的列数 */
static const int JPDefaultColumsCount = 2;

@interface PZXWaterflowLayout ()
/** 每一列的最大Y值 */
@property (nonatomic, strong) NSMutableArray *columnMaxYs;
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
//cell高度
@property (nonatomic, assign) CGFloat h;

@end

@implementation PZXWaterflowLayout

#pragma mark - 懒加载
- (NSMutableArray *)columnMaxYs
{
    if (!_columnMaxYs) {
        _columnMaxYs = [[NSMutableArray alloc] init];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

#pragma mark - 实现内部的方法
/**
 * 决定了collectionView的contentSize
 */
- (CGSize)collectionViewContentSize
{
    // 找出最长那一列的最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最大值
        if (destMaxY < columnMaxY) {
            destMaxY = columnMaxY;
        }
    }
    return CGSizeMake(0, destMaxY + JPDefaultInsets.bottom);
}
//prepareLayout 每次reload都会走一次
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 重置每一列的最大Y值
    [self.columnMaxYs removeAllObjects];
    for (NSUInteger i = 0; i<JPDefaultColumsCount; i++) {
        [self.columnMaxYs addObject:@(JPDefaultInsets.top)];
    }
    
    // 计算所有cell的布局属性
    [self.attrsArray removeAllObjects];
    
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i < count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
    
    //这是设置header的方法 如果不要header刻意注释掉
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    [self.attrsArray addObject:attributes];
}

/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //add first supplementaryView

    
    return self.attrsArray;
}

/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /** 计算indexPath位置cell的布局属性 */
    
    // 水平方向上的总间距
    CGFloat xMargin = JPDefaultInsets.left + JPDefaultInsets.right + (JPDefaultColumsCount - 1) * JPDefaultColumnMargin;
    // cell的宽度
    CGFloat w = (JPCollectionW - xMargin) / JPDefaultColumsCount;
    // cell的高度，测试数据，随机数
#warning 根据高度返回高度
    _h = 100+arc4random()%300 ;
    //可以将你从后台得到的高度存放到一个数组里面然后在这里分别赋值给_h，如下方注释处一样。 heightArr是一个单例，用来存放后台取到的高度数组。
    
//    if ([[Instance shareInstance].heightArr count] > 0) {
//        
//       _h = [[Instance shareInstance].heightArr[indexPath.row] floatValue];
//
//    }
    // 找出最短那一列的 列号 和 最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    NSUInteger destColumn = 0;
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最小值
        if (destMaxY > columnMaxY) {
            destMaxY = columnMaxY;
            destColumn = i;
        }
    }
    
    // cell的x值
    CGFloat x = JPDefaultInsets.left + destColumn * (w + JPDefaultColumnMargin);
    // cell的y值
    CGFloat y = destMaxY + JPDefaultRowMargin;
    // cell的frame
    attrs.frame = CGRectMake(x, y, w, _h);
    
    // 更新数组中的最大Y值
    self.columnMaxYs[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}
//追加视图(用于header)如果不需要可以注释掉
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    
    attrs.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, 145);
    
    
    return attrs;
}


@end
