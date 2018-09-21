//
//  FMDBManager+Detail.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/17.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "FMDBManager+Detail.h"

@implementation FMDBManager (Detail)


- (BOOL)checkDetailExist:(FMDatabase *)db {
    NSString *sql = @"create table if not exists 'tbl_Detail' ('detailId' VARCHAR PRIMARY KEY,'row' INTEGER,'column' INTEGER,'mark' INTEGER,'data' INTEGER,'background' INTEGER,'seleted' INTEGER)";
    
    BOOL result = [db executeUpdate:sql];
    
    return result;
}

- (BOOL)insertDetail:(NSInteger)column detailId:(NSString *)detailId {
    __block BOOL result = NO;
    for (int i = 0; i < 12; i ++) {
        [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [NSString stringWithFormat:@"insert into tbl_Detail (detailId,row,column,mark,data,background,seleted) values ('%@',%d,%ld,0,0,0,0)", detailId, i, column];
            
            BOOL result = [db executeUpdate:sql];
            if ( !result ) {
                *rollback = YES;
            }
        }];
    }
    
    return result;
    
}

- (BOOL)updateDetail:(DetailModel *)model{
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"update tbl_Detail set mark = %ld,data = %ld,background = %ld,seleted = %ld where detailId = '%@' and row = %ld and column = %ld", model.mark, model.data, model.background, model.seleted, model.detailId, model.row, model.column];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;
    
}

- (BOOL)deleteDetail:(NSString *)detailId{
    __block BOOL result = NO;
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"delete from tbl_Detail where detailId = '%@'", detailId];
        
        BOOL result = [db executeUpdate:sql];
        if ( !result ) {
            *rollback = YES;
        }
    }];
    return result;
    
}

- (NSMutableArray *)selectDetail:(NSInteger)column detailId:(NSString *)detailId{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from tbl_Detail where detailId = '%@' and column = %ld order by row asc", detailId, column];
    
    
    [self.master inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sql];
        
        while ( [rs next] ) {
            DetailModel *model = [DetailModel detailModelWithFMResultSet:rs];
            [list addObject:model];
        }
        
        [rs close];
    }];
    
    return list;
}



@end
