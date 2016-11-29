//
//  DTJQViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/27.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "DTJQTwoController.h"
#import "AnswerCell.h"
#import "DTJQListController.h"
@interface DTJQTwoController ()
{
    NSArray *_titleArray;
}
@end

@implementation DTJQTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    
    self.title = @"答题技巧";
    [self addBtnWithTitle:nil imageName:@"co_nav_back_btn" navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"AnswerCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)requestData{
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:self.url parameters:nil sucBlock:^(id responseObject) {
        NSArray *array = responseObject;
        for (NSDictionary *dict in array) {
            [_dataArray addObject:dict];
        }
        [_tableView reloadData];
    } failBlock:^{
        
    }];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }else{
    return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ide = @"myCell";
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    cell.iconImageView.hidden = NO;
    cell.iconImageView.frame = CGRectMake(0, 0, 40, 40);
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"pic"]]];
    cell.mainLabel.text = dict[@"name"];
    cell.leftLabel.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _dataArray[indexPath.row];
    DTJQListController *vc = [[DTJQListController alloc]init];
    vc.navTitle = dict[@"name"];
    vc.url = [NSString stringWithFormat:@"%@%@",KUrlList,dict[@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
