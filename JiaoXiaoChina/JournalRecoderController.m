//
//  JournalRecoderController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/16.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JournalRecoderController.h"
#import "PublishTopicController.h"
#import "MyCell.h"
@interface JournalRecoderController ()

@end

@implementation JournalRecoderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self createUI];
}

- (void)createUI{
    [super createUI];
    self.title = @"学车记录";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)requestData{
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlXCJL parameters:nil sucBlock:^(id responseObject) {
        
        _dataArray = responseObject[@"data"];
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
    
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.myCellLabel.text = _dataArray[indexPath.row][@"title"];
    [cell.myCellImageView sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"imgpath"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PublishTopicController *vc = [[PublishTopicController alloc]init];
    vc.pid = _dataArray[indexPath.row][@"id"];
    vc.isJournal = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(10);
        make.height.width.mas_equalTo(20);
    }];
    
    UILabel *label = [MyControl labelWithTitle:@"记录下今天的学车心情吧！" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.centerY.equalTo(view);
        make.height.mas_equalTo(20);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
