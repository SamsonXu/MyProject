//
//  RidersTopicController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RidersTopicController.h"
#import "PublishTopicController.h"
@interface RidersTopicController ()
{
    NSDictionary *_dict;
}
@end

@implementation RidersTopicController

- (void)viewWillDisappear:(BOOL)animated{

}

- (void)viewDidAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    _urlPage = 1;
    _totlePage = _urlPage+1;
    self.hidesBottomBarWhenPushed = YES;
    [super createUI];
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    _tableView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64);
}

- (void)requestData{
    if (_urlPage >= _totlePage) {
        [_tableView.footer endRefreshing];
        return ;
    }
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlRiders parameters:@{@"cateid":_cateId,@"p":[NSString stringWithFormat:@"%ld",_urlPage],@"token":[NSString stringWithFormat:@"%@",[DefaultManager getValueOfKey:@"token"]]} sucBlock:^(id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        _totlePage = [responseObject[@"totalPages"] integerValue];
        if (_urlPage == 1 || _urlPage == 0) {
            [_dataArray removeAllObjects];
        }
        NSArray *array = [JournalModel arrayOfModelsFromDictionaries:responseObject[@"volist"]];
        [_dataArray addObjectsFromArray:array];
        
        _dict = @{@"wd_count":responseObject[@"wd_count"],@"wd_user_count":responseObject[@"wd_user_count"],@"cate_name":responseObject[@"cate_name"],@"adstr":responseObject[@"adstr"],@"imgpath":responseObject[@"imgpath"]};
        [self createHeadView];
        [_tableView reloadData];
    } failBlock:^{
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];

}

- (void)createHeadView{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    UIImageView *imageView = [UIImageView new];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_dict[@"imgpath"]]];
    imageView.layer.cornerRadius = 35;
    imageView.layer.masksToBounds = YES;
    [headView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.left.equalTo(headView).offset(10);
        make.height.width.mas_equalTo(70);
    }];
    
    UILabel *label1 = [MyControl labelWithTitle:_dict[@"cate_name"] fram:CGRectMake(0, 0, 0, 0) fontOfSize:16];
    [headView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.top.equalTo(imageView);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *label2 = [MyControl labelWithTitle:@"成员" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [headView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1);
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *label3 = [MyControl labelWithTitle:[NSString stringWithFormat:@"%@",_dict[@"wd_user_count"]] fram:CGRectMake(0, 0, 0, 0) color:KColorRGB(253, 88, 52) fontOfSize:14 numberOfLine:1];
    [headView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label2);
        make.left.equalTo(label2.mas_right).offset(10);
        make.height.mas_equalTo(20);
    }];

    UILabel *label4 = [MyControl labelWithTitle:@"话题" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [headView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label2);
        make.left.equalTo(label3.mas_right).offset(40);
        make.height.mas_equalTo(20);
    }];

    UILabel *label5 = [MyControl labelWithTitle:[NSString stringWithFormat:@"%@",_dict[@"wd_count"]] fram:CGRectMake(0, 0, 0, 0) color:KColorRGB(253, 88, 52) fontOfSize:14 numberOfLine:1];
    label5.tag = 105;
    [headView addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label2);
        make.left.equalTo(label4.mas_right).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *label6 = [MyControl labelWithTitle:_dict[@"adstr"] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    [headView addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1);
        make.top.equalTo(label5.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, KScreenWidth, 10)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [headView addSubview:bottomView];
    _tableView.tableHeaderView = headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [MyControl labelWithTitle:@"    最新话题" fram:CGRectMake(0, 10, KScreenWidth, 30) fontOfSize:14];
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    PublishTopicController *vc = [[PublishTopicController alloc]init];
    vc.topicId = _cateId;
    vc.topicName = _dict[@"cate_name"];
    vc.isTopic = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
