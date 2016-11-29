//
//  ZJLXViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/29.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ZJLXViewController.h"
#import "AnswerCell.h"
#import "AnswerViewController.h"
@interface ZJLXViewController ()

@end

@implementation ZJLXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    [super createUI];
    self.title = @"章节练习";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"AnswerCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)requestData{
    if (_flag == 4) {
        _flag = 2;
    }
    _dataArray = [[DBManager shareManager]selectDataWithDataType:chapter Flag:_flag];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ide = @"myCell";
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    cell.leftLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.leftLabel.backgroundColor = KColorSystem;
    AnswerModel *model = _dataArray[indexPath.row];
    cell.mainLabel.text = model.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerViewController *vc = [[AnswerViewController alloc]init];
    vc.number = _flag;
    vc.zj = [_dataArray[indexPath.row] fid];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
