//
//  OrderViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "OrderViewController.h"
#import "PayViewController.h"
#import "OrderCell.h"
#import "ClassModel.h"
@interface OrderViewController ()<OrderCellDelegate>
{
    UIView *_backView;
}
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名订单";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self requestData];
    [self createUI];
}

- (void)requestData{
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlOrderList parameters:@{@"token":[DefaultManager getValueOfKey:@"token"]} sucBlock:^(id responseObject) {

        _dataArray = [OrderModel arrayOfModelsFromDictionaries:responseObject[@"volist"]];
        [_tableView reloadData];
    } failBlock:^{
        
    }];
}

- (void)createUI{
    [super createUI];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [_backView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_backView);
        make.size.mas_equalTo(CGSizeMake(60, 80));
    }];
    
    UILabel *label = [MyControl labelWithTitle:@"您还没有订单哦，快去报名吧！~" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:2];
    [_backView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.centerX.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(160, 40));
    }];
    
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:@"去逛逛驾校" imageName:nil];
    [btn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = KColorSystem;
    btn.layer.cornerRadius = 5;
    [_backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.centerX.equalTo(label);
        make.size.mas_equalTo(CGSizeMake(160, 30));
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:@"OrderCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)leftClick:(UIButton *)btn{
    [self.sideMenuViewController setContentViewController:[MyTabBarController shareTabBar]];
}

- (void)pushToPayViewCtrl:(OrderModel *)orderModel{
    
    PayViewController *vc = [[PayViewController alloc]init];
    vc.isOrder = YES;
    vc.orderId = orderModel.pid;
    ClassModel *model = [[ClassModel alloc]init];
    model.title = orderModel.title;
    model.dname = orderModel.dname;
    model.is_payment_type = orderModel.is_payment_type;
    model.cheben_arr = orderModel.cheben_arr;
    model.pric = orderModel.count_price;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
