//
//  CommentListController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "CommentListController.h"
#import "DriveCommentCell.h"
@interface CommentListController ()

@end

@implementation CommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    [super createUI];
    self.title = @"评价列表";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"DriveCommentCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DriveCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = _commentArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
