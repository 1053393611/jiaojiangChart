//
//  ContentCollectionViewCell.h
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)NSArray *cellData;
@property (assign, nonatomic)NSInteger index;
@property (assign, nonatomic)NSInteger currentRow;



@end
