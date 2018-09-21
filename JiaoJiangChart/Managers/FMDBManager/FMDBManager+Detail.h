//
//  FMDBManager+Detail.h
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager (Detail)

// 创建表
- (BOOL)checkDetailExist:(FMDatabase *)db;

// 插入一列默认数据
- (BOOL)insertDetail:(NSInteger)column detailId:(NSString *)detailId;

// 更新
- (BOOL)updateDetail:(DetailModel *)model;

// 删除全部
- (BOOL)deleteDetail:(NSString *)detailId;

// 选择
- (NSMutableArray *)selectDetail:(NSInteger)column detailId:(NSString *)detailId;

@end
