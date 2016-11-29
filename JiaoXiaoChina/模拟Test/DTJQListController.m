//
//  DTJQListViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/1.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "DTJQListController.h"
#import "WebViewController.h"
#import "ListCell.h"
@interface DTJQListController ()

@end

@implementation DTJQListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    [super createUI];
    self.title = _navTitle;
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)requestData{
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:_url parameters:nil sucBlock:^(id responseObject) {
        NSArray *array = responseObject[@"volist"];
        for (NSDictionary *dict in array) {
            ListModel *model = [[ListModel alloc]initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        if ([responseObject[@"totalRows"] integerValue] > 10) {
            [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:[NSString stringWithFormat:@"%@/p/2",_url] parameters:nil sucBlock:^(id responseObject) {
                NSArray *array = responseObject[@"volist"];
                for (NSDictionary *dict in array) {
                    ListModel *model = [[ListModel alloc]initWithDictionary:dict error:nil];
                    [_dataArray addObject:model];
                }
            } failBlock:^{
                
            }];
        }
        [_tableView reloadData];
    } failBlock:^{
        
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebViewController *vc = [[WebViewController alloc]init];
    ListModel *model = _dataArray[indexPath.row];
    vc.url = [NSString stringWithFormat:@"%@%@",KUrlDetail,model.pid];
    vc.navTitle = model.title;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
