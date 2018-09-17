//
//  ContentCollectionViewCell.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "ContentCollectionViewCell.h"
#import "ItemCollectionViewCell.h"

#define HeadHeight 30


@interface ContentCollectionViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSInteger itemWidth;
}

@property (strong, nonatomic)UICollectionView *collectionView;

@property (strong, nonatomic)UILabel *labelRow;
@property (strong, nonatomic)UIImageView *imgView;

@property (copy, nonatomic)NSString *row;
@property (copy, nonatomic)NSMutableArray *data;




@end


@implementation ContentCollectionViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        itemWidth = self.contentView.bounds.size.width;
        self.data = [NSMutableArray array];
        [self customUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        itemWidth = self.contentView.bounds.size.width;
        self.data = [NSMutableArray array];
        [self customUI];
    }
    return self;
}

- (void)customUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWidth:) name:@"refreshWidth" object:nil];
    
    
    NSInteger itemHeight = (self.contentView.bounds.size.height - HeadHeight) / 12;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 0;
    // 每一列cell之间的间距
    // flowLayout.minimumInteritemSpacing = 10;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    flowLayout.minimumLineSpacing = 1;// 根据需要编写
    //    flowLayout.minimumInteritemSpacing = 1;// 根据需要编写
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);// 该行代码就算不写,item也会有默认尺寸
    flowLayout.headerReferenceSize = CGSizeMake(itemWidth,HeadHeight);
    
    self.collectionView.tag = 500;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, self.contentView.bounds.size.height) collectionViewLayout:flowLayout];
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    [self.collectionView registerClass:[ItemCollectionViewCell class] forCellWithReuseIdentifier:@"itemCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ItemCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"itemCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.contentView addSubview:self.collectionView];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 12;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ItemCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
    if (!cell ) {
        cell = [[ItemCollectionViewCell alloc] init];
        
    }
//    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 10) {
        cell.partLine.hidden = YES;
    }else {
        cell.partLine.hidden = NO;
    }
    if (indexPath.row == 4) {
        cell.backgroundColor = DefaultBackColor;
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.cellData = self.data[indexPath.row];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    header.backgroundColor = RGB(236, 237,241);
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, HeadHeight)];
    self.imgView.image = [UIImage imageNamed:@"background"];
    [header addSubview:self.imgView];
    
    
    self.labelRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemWidth, HeadHeight)];
    self.labelRow.text = self.row;
    self.labelRow.backgroundColor = DefaultBackColor;
    self.labelRow.textAlignment = NSTextAlignmentCenter;
    
    [header addSubview:self.labelRow];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, HeadHeight - 1, itemWidth, 1)];
    label.backgroundColor = [UIColor colorWithSome:201];
    
    [header addSubview:label];
    
    
    
    if (self.currentRow > self.index) {
        self.labelRow.text = self.row;
        self.imgView.hidden = YES;
        self.labelRow.backgroundColor = DefaultBackColor;
    }else if (self.currentRow == self.index){
        self.labelRow.text = self.row;
        self.imgView.hidden = NO;
        self.labelRow.backgroundColor = [UIColor clearColor];
    }else{
        self.labelRow.text = @"";
        self.imgView.hidden = YES;
        self.labelRow.backgroundColor = DefaultBackColor;
    }
    
    if (self.currentRow == 0) {
        if (self.index == 0) {
            self.labelRow.text = self.row;
            self.imgView.hidden = YES;
            self.labelRow.backgroundColor = DefaultBackColor;
        }else if(self.index == 1){
            self.labelRow.text = self.row;
            self.imgView.hidden = NO;
            self.labelRow.backgroundColor = [UIColor clearColor];
        }
    }
    
    
    
    
    return header;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(itemWidth, HeadHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}


#pragma mark - 数据
-(void)setCellData:(NSArray *)cellData {
    
    self.data = [NSMutableArray arrayWithArray:cellData];
    self.row = [NSString stringWithFormat:@"%ld", self.index];
    [self.collectionView reloadData];

}

#pragma mark - 刷新宽度
- (void)refreshWidth:(NSNotification *)noti {
    NSLog(@"%@", self.contentView.subviews);
    itemWidth = [[noti object] integerValue];
    NSInteger itemHeight = (self.contentView.bounds.size.height - HeadHeight) / 12;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 0;
    // 每一列cell之间的间距
    // flowLayout.minimumInteritemSpacing = 10;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    flowLayout.minimumLineSpacing = 1;// 根据需要编写
    //    flowLayout.minimumInteritemSpacing = 1;// 根据需要编写
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);// 该行代码就算不写,item也会有默认尺寸
    flowLayout.headerReferenceSize = CGSizeMake(itemWidth,HeadHeight);
    
//    UICollectionView *collectionView = [self.contentView viewWithTag:500];
    UICollectionView *collectionView = self.contentView.subviews.firstObject;

    collectionView.frame = CGRectMake(0, 0, itemWidth, self.contentView.bounds.size.height);
    collectionView.collectionViewLayout = flowLayout;
    [self.collectionView reloadData];
}



@end
