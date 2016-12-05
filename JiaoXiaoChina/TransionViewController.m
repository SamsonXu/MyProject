//
//  TransionViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/10.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TransionViewController.h"
#import "AnswerCell.h"
#import "AnswerViewController.h"
@interface TransionViewController ()
{
    NSArray *_titleArr;
    NSArray *_currentArr;
    NSMutableArray *_chapArr;
}
@end

@implementation TransionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = KGrayColor;
    [MyControl setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"AnswerCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
//    headView.backgroundColor = KGrayColor;
//    _tableView.tableHeaderView = headView;
    
    NSString *str;
    if (_flag == 0) {
        self.title = @"我的错题";
        str = @"清空所有错题";
    }else if (_flag == 1){
        self.title = @"我的收藏";
        str = @"清空所有收藏";
    }
    UIButton *btn = [UIButton new];
    [btn setTitle:str forState:UIControlStateNormal];
    btn.backgroundColor = KColorSystem;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.tag = 10;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_tableView addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tableView);
        make.top.mas_equalTo(360);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
}

- (void)btnClick:(UIButton *)btn{
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    if (_flag == 0) {
        [DefaultManager removeValueOfKey:KWrong];
    }else if (_flag == 1){
        [DefaultManager removeValueOfKey:KCollect];
    }
    [self requestData];
}

- (void)requestData{
    _chapArr = [[NSMutableArray alloc]init];
    if (_flag == 0) {
        _titleArr = @[@"查看全部错题",@"",@"答对后自动移除错题"];
        _currentArr = [DefaultManager getWrongQuestion];
    }else if (_flag == 1){
        _titleArr = @[@"全部收藏",@""];
        _currentArr = [DefaultManager getCollectQuestion];
    }
    //错题、收藏数组
    NSMutableArray *flArr = [[NSMutableArray alloc]init];
    NSInteger cb = [[DefaultManager getValueOfKey:KJZLX]integerValue];
    NSArray *array = [[DBManager shareManager]selectDataWithCb:cb];
    //当前题库
    NSMutableArray *transArray = [[NSMutableArray alloc]init];
    if (_tid == 4) {
        _tid = 2;
    }
    if (cb < 4) {
        transArray = [[DBManager shareManager]selectDataWithTk:_tid arr:array];
    }else{
        transArray = [array mutableCopy];
    }
    for (AnswerModel *model in transArray) {
        for (NSString *num in _currentArr) {
            if (num.integerValue == model.pid) {
                [flArr addObject:model];
            }
        }
    }
    for (int i = 5; i < 48; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (AnswerModel *model in flArr) {
            if (model.fid == i) {
                [array addObject:model];
            }
        }
        if (array.count > 0) {
            AnswerModel *model = [[DBManager shareManager]chapTitleWithfl:i][0];
            [_chapArr addObject:model.title];
            [_dataArray addObject:array];
        }
    }
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        UIButton *btn = [self.view viewWithTag:10];
        if (btn.selected == YES) {
            return 0;
        }
        return _dataArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.mainLabel.text = _titleArr[indexPath.section];
    if (indexPath.section == 0) {
        cell.rightLabel.text = [NSString stringWithFormat:@"%ld",_currentArr.count];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.iconImageView.hidden = NO;
    }
    if (indexPath.section == 1) {
        cell.leftLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.mainLabel.text = _chapArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.rightLabel.text = [NSString stringWithFormat:@"%ld",[_dataArray[indexPath.row]count]];
    }
    if (indexPath.section == 2) {
        UISwitch *mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(KScreenWidth-60, 10, 40, 20)];
        [mySwitch addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:mySwitch];
        cell.iconImageView.hidden = NO;
    }
    return cell;
}

- (void)switchBtnClick:(UISwitch *)sender{
    self.remove = sender.isOn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    headView.backgroundColor = KGrayColor;
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_flag == 0) {
        if (indexPath.section == 0) {
            if (_currentArr.count == 0) {
                [self showAlertViewWith:@[@"当前没有错题",@"确定"] sel:nil];
            }
            AnswerViewController *vc = [[AnswerViewController alloc]init];
            vc.number = self.tid;
            vc.type = 8;
            vc.remove = self.remove;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (_flag == 1){
        if (indexPath.section == 0) {
            if (_currentArr.count == 0) {
                [self showAlertViewWith:@[@"你还没有收藏题目",@"确定"] sel:nil];
            }
            AnswerViewController *vc = [[AnswerViewController alloc]init];
            vc.number = self.tid;
            vc.type = 9;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        AnswerViewController *vc = [[AnswerViewController alloc]init];
        vc.modelArr = _dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
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
