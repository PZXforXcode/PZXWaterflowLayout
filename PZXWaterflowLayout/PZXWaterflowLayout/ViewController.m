//
//  ViewController.m
//  PZXWaterflowLayout
//
//  Created by 彭祖鑫 on 16/3/16.
//  Copyright © 2016年 彭祖鑫. All rights reserved.
//
#warning 实际项目中，加了图片如果渲染不好会在模拟器有卡帧现象，真机测试不会有这个卡帧现象。

#import "ViewController.h"
#import "PZXWaterflowLayout.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collection;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PZXWaterflowLayout *layout = [[PZXWaterflowLayout alloc]init];
    _collection = [[UICollectionView alloc]initWithFrame:[[UIScreen mainScreen]bounds]collectionViewLayout:layout];
    
    _collection.backgroundColor = [UIColor whiteColor];
    _collection.delegate = self;
    _collection.dataSource  = self;
    //注册collectionView
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collection];
    //如果要用header则要注册此代码
    [_collection registerClass:[UICollectionReusableView class]forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReuseID"];

}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;

}
//cell可以自己设置样式。里面各个空间的高度要算好 各个控件的和要等于cell高度
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    
    
    return cell;
}
//设置collectheader

//不设置header可以不写此协议
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    // 如果自定义flowLayout之后要实现这个代理必须在自定义layout里面实现,-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;这个方法。
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"ReuseID" forIndexPath:indexPath];
        header.backgroundColor = [UIColor blackColor];
        reusableview = header;
    }
    return reusableview;
}
@end
