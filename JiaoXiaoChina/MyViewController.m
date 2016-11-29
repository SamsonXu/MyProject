//
//  MyViewController.m
//  MyFamily
//
//  Created by qianfeng on 16/3/17.
//  Copyright (c) 2016年 Motion. All rights reserved.
//

#import "MyViewController.h"
#import "SetViewController.h"
#import "JournalViewController.h"
#import "LoginViewController.h"
#import "MyCell.h"
@interface MyViewController ()
{
    NSDictionary *_dict;
}
@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated{
    if (!_isScroll) {
        self.tabBarController.tabBar.hidden =NO;
    }
    [self createHeaderView];
    [self requestDate];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    [super createUI];
    self.title = @"个人主页";
    if (_isScroll) {
        [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    }

    [_tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}


//设置头部视图
- (void)createHeaderView
{
    //头部视图
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 260)];
    view.backgroundColor = [UIColor whiteColor];
    //背景图片
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"person.jpg"];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(login)];
    [imageView addGestureRecognizer:tap];
    [view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.width.equalTo(view);
        make.centerX.equalTo(view);
        make.height.mas_equalTo(@220);
    }];
    
    UIImageView *headView = [UIImageView new];
    headView.image = [UIImage imageNamed:@"f0"];
    headView.layer.cornerRadius = 50;
    headView.layer.masksToBounds = YES;
    
    UILabel *nameLabel = [MyControl labelWithTitle:@"未登录" fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:17 numberOfLine:1];
    nameLabel.textColor = KColorSystem;
    
    UIImageView *sexView = [UIImageView new];
    
    if ([DefaultManager getValueOfKey:@"token"]) {
        
        UILabel *label = [UILabel new];
        label.text = @"编辑";
        [self addBtnWithTitle:label imageName:nil navBtn:KNavBarRight];
        _dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]];
        NSString *str = _dict[@"headimg"];
        
        if (str.length == 0) {
            headView.image = [UIImage imageNamed:@"f0"];
        }else{
            headView.image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selfPhoto.jpg"]];
           
        }
        NSString *imgStr;
        
        if ([_dict[@"sex"] integerValue] == 1) {
            imgStr = @"user_sex_male";
        }else if ([_dict[@"sex"] integerValue] == 2){
            imgStr = @"user_sex_female";
        }
        sexView.image = [UIImage imageNamed:imgStr];
        nameLabel.text = _dict[@"nickname"];
    }
    
    [view addSubview:headView];
    [view addSubview:nameLabel];
    [view addSubview:sexView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.centerY.equalTo(imageView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(headView.mas_bottom).offset(30);
        make.height.mas_equalTo(20);
    }];
    
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.left.equalTo(nameLabel.mas_right).offset(20);
        make.height.width.mas_equalTo(20);
    }];
    
    UILabel *label2 = [MyControl labelWithTitle:@"驾校中国------让学车更快、更简单" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:0];
    [view addSubview:label2];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(15);
        make.leading.equalTo(view).offset(10);
        make.trailing.equalTo(view).offset(-10);
    }];
    _tableView.tableHeaderView = view;
}

- (void)login{
    
    if (![DefaultManager getValueOfKey:@"token"]) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.isPush = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)requestDate
{
    [_dataArray removeAllObjects];
    NSArray *jzArr = @[@"未选择",@"小车",@"客车",@"货车",@"摩托车",@"轮式自行车",@"恢复资格证",@"货运",@"客运",@"危险品",@"教练员",@"电车"];
    NSArray *array1 = @[@"area",@"mycheben",@"journal"];
    NSArray *array2 = @[@"我的学车日志",@"报考驾照",@"地区"];
    NSArray *array3;
    
    if ([DefaultManager getValueOfKey:@"token"]) {
        NSString *jzStr = _dict[@"is_cb"];
        NSInteger i = jzStr.integerValue;
        array3 = @[@"",jzArr[i],_dict[@"city_name"]];
    }else{
        array3 = @[@"",@"",@""];
    }
    
    for (int i = 0; i < array1.count; i++) {
        MyCellModel *model = [[MyCellModel alloc]init];
        model.image = array1[i];
        model.leftTitle = array2[i];
        model.rightTitle = array3[i];
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ide = @"myCell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    MyCellModel *model = _dataArray[indexPath.row];
    cell.model = model;
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)leftClick:(UIButton *)btn{
    [self.sideMenuViewController setContentViewController:[MyTabBarController shareTabBar]];
}

- (void)rightClick:(UIButton *)btn{
    SetViewController *vc = [[SetViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![DefaultManager getValueOfKey:@"token"]) {
        
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.isPush = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 0) {
        
        JournalViewController *vc = [[JournalViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
