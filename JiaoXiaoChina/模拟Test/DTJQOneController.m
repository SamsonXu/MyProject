//
//  DTJQOneController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/1.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "DTJQOneController.h"
#import "WebViewController.h"
#import "AnswerCell.h"
@interface DTJQOneController ()

@end

@implementation DTJQOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    [super createUI];
    if (_flag == 0) {
        self.title = @"答题技巧";
    }else if (_flag == 1){
        self.title = @"实用驾车技巧";
    }
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"AnswerCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)requestData{
    
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:self.url parameters:nil sucBlock:^(id responseObject) {
        
        KMBProgressHide;
        NSArray *array = responseObject[@"volist"];
        for (NSDictionary *dict in array) {
            [_dataArray addObject:@{@"title":dict[@"title"],@"id":dict[@"id"]}];
            
        }
        if ([responseObject[@"totalRows"] integerValue] > 10) {
            [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:[NSString stringWithFormat:@"%@2",self.url] parameters:nil sucBlock:^(id responseObject) {
                NSArray *array = responseObject[@"volist"];
                for (NSDictionary *dict in array) {
                    [_dataArray addObject:@{@"title":dict[@"title"],@"id":dict[@"id"]}];
                    
                }
                [_tableView reloadData];
            } failBlock:^{
                
            }];
        }
        [_tableView reloadData];
    } failBlock:^{
        KMBProgressHide;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.leftLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.leftLabel.backgroundColor = KColorSystem;
    cell.leftLabel.layer.cornerRadius = 5;
    cell.leftLabel.clipsToBounds = YES;
    cell.mainLabel.text = _dataArray[indexPath.row][@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebViewController *vc = [[WebViewController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@%@",KUrlDetail,_dataArray[indexPath.row][@"id"]];
    vc.navTitle = _dataArray[indexPath.row][@"title"];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_flag == 0) {
        return 30;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_flag == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0)];
        UILabel *label1 = [MyControl labelWithTitle:@"答题技巧" fram:CGRectMake(0, 0, 0, 0) color:[UIColor colorWithWhite:0.5 alpha:1] fontOfSize:12 numberOfLine:1];
        [view addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.mas_equalTo(10);
            make.height.equalTo(view);
        }];
        UILabel *label2 = [MyControl labelWithTitle:@"教练总结，让你事半功倍" fram:CGRectMake(0, 0, 0, 0) color:[UIColor colorWithWhite:0.5 alpha:1] fontOfSize:12 numberOfLine:1];
        [view addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-10);
            make.centerY.height.equalTo(view);
        }];
        
        return view;
    }else{
        return nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y > 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else {
        if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
