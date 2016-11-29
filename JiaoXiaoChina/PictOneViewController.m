//
//  PictureOneViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/11.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PictOneViewController.h"
#import "AnswerCell.h"
#import "PictTwoViewController.h"
@interface PictOneViewController ()

@end

@implementation PictOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    [super createUI];
    self.title = @"交通标志大全";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"AnswerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"myCell"];
}

- (void)requestData{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"TranfficSign_TypeList" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _dataArray = [SignModel arrayOfModelsFromDictionaries:rootDict[@"categorylist"]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ide = @"myCell";
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SignModel *model = _dataArray[indexPath.row];
    PictTwoViewController *vc = [[PictTwoViewController alloc]init];
    vc.navTitle = model.title;
    vc.jsonName = model.action[@"extparam"][@"jsonName"];
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
