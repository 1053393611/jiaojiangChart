//
//  ContentViewController.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "ContentViewController.h"
#import "ContentCollectionViewCell.h"
#import "BottomView.h"

@interface ContentViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSInteger itemHeight;
    NSInteger itemWidth;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic)  BottomView *bottomView;

@property (strong, nonatomic) NSMutableArray *data;

@property (assign, nonatomic)  NSInteger count;

@property (assign, nonatomic)  NSInteger row;
@property (assign, nonatomic)  NSInteger list;

@property (strong, nonatomic) NSMutableArray *seletedArray;

@property (assign, nonatomic)  NSInteger contentofset;  // 记录偏移值

@property (assign, nonatomic)  BOOL isMark; // 是否有标志


@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = DefaultBackColor;
    self.contentofset = 0;
    self.isMark = NO;
    itemWidth = 70;
    self.count = 0;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
//    itemHeight = HBViewHeight;
//        NSLog(@"宽：%f, 高：%f, %f, %f", HBScreenWidth, HBScreenHeight, HBViewHeight, HBLandscapeViewHeight);
    
    self.data = [NSMutableArray array];
    self.seletedArray = [NSMutableArray array];
    [self getData];
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
            itemHeight = HBLandscapeViewHeight - 50;
        
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            itemHeight = HBViewHeight - 50;
    }

    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self createCollectionView];
    [self createBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

//- (void)doRotateAction:(NSNotification *)notification {
//    NSLog(@"宽：%f, 高：%f, %f, %f", HBScreenWidth, HBScreenHeight, HBViewHeight, HBLandscapeViewHeight);
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
//        itemHeight = HBLandscapeViewHeight;
//        [self createCollectionView];
//        [self.collectionView reloadData];
//        NSLog(@"竖屏");
//    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
//        itemHeight = HBLandscapeViewHeight;
//        [self createCollectionView];
//        [self.collectionView reloadData];
//        NSLog(@"横屏");
//    }
//}





- (void)createCollectionView {
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 0;
    // 每一列cell之间的间距
    // flowLayout.minimumInteritemSpacing = 10;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    flowLayout.minimumLineSpacing = 1;// 根据需要编写
    //    flowLayout.minimumInteritemSpacing = 1;// 根据需要编写
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);// 该行代码就算不写,item也会有默认尺寸
    
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, HBViewHeight, HBScreenWidth) collectionViewLayout:flowLayout];
    
    
    self.collectionHeight.constant = itemHeight;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.backgroundColor = DefaultBackColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [self.view addSubview:self.collectionView];
    self.collectionView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        [_collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }

}

- (void)createBottomView {
    
    
    self.bottomView = [[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:self options:nil].firstObject;
    
//    self.bottomView.frame = CGRectMake(0, itemHeight, HBScreenWidth, 50);
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    
    for (int i = 1; i < 7; i++) {
        UIButton *button = [self.bottomView viewWithTag:100 + i];
        [button addTarget:self action:@selector(numberAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    UIButton *markButton = [self.bottomView viewWithTag:201];
    [markButton addTarget:self action:@selector(markAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *widthButton = [self.bottomView viewWithTag:202];
    [widthButton addTarget:self action:@selector(widthAction) forControlEvents:UIControlEventTouchUpInside];

    
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 50;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ContentCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell ) {
        cell = [[ContentCollectionViewCell alloc] init];
        
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.index = indexPath.row;
    cell.currentRow = self.row;
    cell.cellData = self.data[indexPath.row];
    return cell;
}


#pragma mark - 按钮处理
// 数字
- (void)numberAction:(UIButton *)button {
    NSInteger index = button.tag - 100;

    if (self.row == 0) {
        [self lineFeed:index];
        self.row++;
        [self.bottomView setAllButtonWhiter];
        return;
    }
    
    if (CGColorEqualToColor(button.backgroundColor.CGColor, [UIColor colorWithQuick:220 green:250 blue:220].CGColor)) {
        [self lineFeed:index];
        [self getTopData];
        [self getBottomData];
        [self setContentOffset];
        [self setpreRowMark];
        self.row++;
        self.count = 0;
        [self.bottomView setAllButtonWhiter];
        return;
    }
    
    self.count ++;
    if (self.count >= 4) {
        [self insertData:index];
        //判断后5，6行数字
        [self.seletedArray addObject:@(index)];
        [self judgeResidue];
        
        
        self.count = 0;
        [self.bottomView setAllButtonGreen];
        return;
    }


    [self insertData:index];
    
    [self.seletedArray addObject:@(index)];
    
    
    [self.bottomView setButtonGray:index];
    
    
}

// 标志
- (void)markAction {
    self.isMark = !self.isMark;
    for (int i = 2; i < self.row; i++) {
        NSInteger center = [[self.data[i][4] objectForKey:@"data"] integerValue];
        NSArray *array = @[@2, @3, @5, @6, @7, @8];
        for (int j = 0; j < 6; j++) {
            if ([[self.data[i - 1][[array[j] integerValue]] objectForKey:@"data"] integerValue] == center) {
                if (self.isMark) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.data[i-1][[array[j] integerValue]]];
                    [dic setObject:@true forKey:@"mark"];
                    [self.data[i-1] replaceObjectAtIndex:[array[j] integerValue] withObject:dic];
                }else{
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.data[i-1][[array[j] integerValue]]];
                    [dic setObject:@false forKey:@"mark"];
                    [self.data[i-1] replaceObjectAtIndex:[array[j] integerValue] withObject:dic];
                }
                
                break;
            }
        }
    }
    [self.collectionView reloadData];
}

// row宽度
- (void)widthAction {
    itemWidth += 5;
    if (itemWidth >= 100) {
        itemWidth = 70;
    }
    [self createCollectionView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshWidth" object:[NSNumber numberWithInteger:itemWidth]];
}



#pragma mark - 数据
- (void)getData {
    self.row = 0;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < 12; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@false, @"seleted":@false}];

        [dic setObject:@(0) forKey:@"data"];
        [array addObject:dic];
    }
    
    
    
    for (int i = 0; i < 50; i++) {
        NSMutableArray *m = [NSMutableArray arrayWithArray:array];
        [self.data addObject:m];
    }
    
    
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0 ; i < 12; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@false}];
        [a addObject:dic];
    }
    [self.data replaceObjectAtIndex:1 withObject:a];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@false, @"seleted":@true}];
    [self.data.firstObject replaceObjectAtIndex:4 withObject:d];

    
}

#pragma mark 换行
// 换行
-(void)lineFeed:(NSInteger)number {
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(number), @"background":@false, @"seleted":@false}];
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < 12; i++) {
        NSMutableDictionary *dic = self.data[self.row][i];
        [dic setObject:@false forKey:@"background"];
        [array addObject:dic];
    }
    [self.data replaceObjectAtIndex:self.row withObject:array];

    
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0 ; i < 12; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@false}];
        [a addObject:dic];
    }
    [self.data replaceObjectAtIndex:self.row + 1 withObject:a];
//    [self.data addObject:a];

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@true}];

    [self.data[self.row] replaceObjectAtIndex:4 withObject:d];
    [self.data[self.row+ 1] replaceObjectAtIndex:2 withObject:dic];
    [self.collectionView reloadData];
}

#pragma mark 添加
// 数字
- (void)insertData:(NSInteger)number {
    NSArray *a = @[@2, @3, @5, @6];
    NSArray *array = @[@3, @5, @6 ,@4];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(number), @"background":@true, @"seleted":@false}];

    [self.data[self.row] replaceObjectAtIndex:[a[self.count - 1] integerValue] withObject:d];

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(0), @"background":@true, @"seleted":@true}];
    [self.data[self.row] replaceObjectAtIndex:[array[self.count - 1] integerValue] withObject:dic];
    [self.collectionView reloadData];

}

#pragma mark 判断5，6行数字
// 判断5，6行数字
- (void)judgeResidue {
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@(1),@(2),@(3),@(4),@(5),@(6)]];
    for (NSNumber *number in self.seletedArray) {
        for (int i = 0; i < array.count; i++) {
            if([array[i] integerValue] == [number integerValue]){
                [array removeObject:array[i]];
            }
        }
    }
//    NSLog(@"剩余数字：%@", array);
    
    // 判断前一row 5，6行数字
    NSInteger tmp;
    NSInteger a = [array.firstObject integerValue];
    NSInteger b = [array.lastObject integerValue];
    if (self.row - 1 != 0) {

        if (([[self.data[self.row - 1][8] objectForKey:@"data"] integerValue] == a) || ([[self.data[self.row - 1][7] objectForKey:@"data"] integerValue] == b)){
            tmp = a;
            a = b;
            b = tmp;
        }
    }
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(a), @"background":@true, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:7 withObject:d];
        
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(b), @"background":@true, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:8 withObject:dic];
    
    
    //清除已选择数字
    [self.seletedArray removeAllObjects];

    [self.collectionView reloadData];
    
}

#pragma mark 判断上面两行 数字
// 判断上面两行 数字
- (void)getTopData {
    if (self.row < 2) {
        return;
    }
    NSInteger first = [[self.data[self.row][2] objectForKey:@"data"] integerValue];
    first = [self getTop:first];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(first), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:0 withObject:d];
    
    
    NSInteger center = [[self.data[self.row][4] objectForKey:@"data"] integerValue];
    center = [self getTop:center];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(center), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:1 withObject:dic];

//    NSLog(@"{\nfirst: %ld,\ncenter: %ld}", first, center);
    
}
// 获取数字在前一row的位置
- (NSInteger)getTop:(NSInteger)number {
    NSArray *array = @[@2, @3, @5, @6, @7, @8];
    for (int i = 0; i < 6; i++) {
        if ([[self.data[self.row - 1][[array[i] integerValue]] objectForKey:@"data"] integerValue] == number) {
            if (i == 5) {
                number = i + 10;
            }else {
                number = i + 11;
            }
            return  number;
        }
    }
    return 0;
}

#pragma mark  判断下面三行 数字
// 判断下面三行 数字
- (void)getBottomData {
    if (self.row < 3) {
        return;
    }
    NSInteger center = [[self.data[self.row][4] objectForKey:@"data"] integerValue];
    center = [self getBottom:center];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(center), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:9 withObject:d];
    
    NSInteger first = [[self.data[self.row][2] objectForKey:@"data"] integerValue];
    first = [self getBottom:first];
    NSMutableDictionary *di = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(first), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:10 withObject:di];
    
    NSInteger third = [[self.data[self.row][5] objectForKey:@"data"] integerValue];
    third = [self getBottom:third];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mark":@false, @"data":@(third), @"background":@false, @"seleted":@false}];
    [self.data[self.row] replaceObjectAtIndex:11 withObject:dic];

    
//    NSLog(@"{\ncenter: %ld,\nfirst: %ld,\nthird: %ld}", center, first, third);

}

- (NSInteger)getBottom:(NSInteger)number {
    NSArray *array = @[@2, @3, @5, @6, @7, @8];
    for (int i = 0; i < 6; i++) {
        if ([[self.data[self.row - 1][[array[i] integerValue]] objectForKey:@"data"] integerValue] == number) {
            number = [[self.data[self.row - 2][[array[i] integerValue]] objectForKey:@"data"] integerValue];
            number =  [self getTop:number];
            return number;
        }
    }
    return 0;

}

#pragma mark 设置前一行标志 有标志的情况
- (void)setpreRowMark {
    NSInteger center = [[self.data[self.row][4] objectForKey:@"data"] integerValue];
    NSArray *array = @[@2, @3, @5, @6, @7, @8];
    for (int j = 0; j < 6; j++) {
        if ([[self.data[self.row - 1][[array[j] integerValue]] objectForKey:@"data"] integerValue] == center) {
            if (self.isMark) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.data[self.row-1][[array[j] integerValue]]];
                [dic setObject:@true forKey:@"mark"];
                [self.data[self.row-1] replaceObjectAtIndex:[array[j] integerValue] withObject:dic];
            }
            
            break;
        }
    }
}



#pragma mark - 设置偏移量
- (void)setContentOffset {
    if ((self.row + 1) * itemWidth > HBScreenWidth *3/5) {
        if (self.contentofset == 0) {
            self.contentofset = self.row;
        }
        [self.collectionView setContentOffset:CGPointMake((self.row - self.contentofset) * itemWidth, 0) animated:YES];
    }
}



@end
