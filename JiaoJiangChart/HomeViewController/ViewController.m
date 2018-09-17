//
//  ViewController.m
//  JiaoJiangChart
//
//  Created by 钟程 on 2018/9/13.
//  Copyright © 2018年 钟程. All rights reserved.
//

#import "ViewController.h"
#import "HomeTableViewCell.h"
#import "ContentViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *arrChartList;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUITabviewHomePage];
    [self getChartList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUITabviewHomePage {
    
    
    _tableView.delegate   = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = DefaultBackColor;
//    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)){
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
    }
    _tableView.estimatedRowHeight = 100;
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrChartList.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeTableViewCell class])];
    if ( cell == nil ) {
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([HomeTableViewCell class])];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellData = [self.arrChartList objectAtIndex:indexPath.section];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContentViewController *vc = HBALLOCOBJ(ContentViewController);
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getChartList {

    NSDictionary *dic = @{@"title":@"标题名",@"createTime":@"创建时间",@"updateTime":@"更新时间",@"row":@"0"};
    
    self.arrChartList = [NSMutableArray arrayWithArray:@[dic,dic,dic,dic,dic,dic,dic,dic,dic,dic]];
    
    [self.tableView reloadData];
}



@end
