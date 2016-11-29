//
//  TestRecodViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/12.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TestRecodViewController.h"
#import "TestRecoderCell.h"
#import "ScroeViewController.h"
#import "LoginViewController.h"
#import "RankingViewController.h"
@interface TestRecodViewController ()<UMSocialUIDelegate>
{
    UIImageView *_headView;
}
@end

@implementation TestRecodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    [super createUI];
    self.title = @"考试记录";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self addBtnWithTitle:nil imageName:@"navigationbar_icon_share" navBtn:KNavBarRight];
    [_tableView registerNib:[UINib nibWithNibName:@"TestRecoderCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    [self createHeadView];
    _tableView.tableHeaderView = _headView;
}

- (void)createHeadView{
    
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
    _headView.image = [UIImage imageNamed:@"testback"];
    _headView.backgroundColor = [UIColor whiteColor];
    _headView.userInteractionEnabled = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:@"userInfo"];
    //头像
    UIButton *headBtn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:nil imageName:nil tag:50];
    [headBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [UIImageView new];
    imageView.layer.cornerRadius = 30;
    
    imageView.layer.masksToBounds = YES;
    //姓名、登录
    UILabel *nameLabel = [UILabel new];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    //提示文字
    UILabel *proLabel = [UILabel new];
    proLabel.textColor = [UIColor grayColor];
    proLabel.font = [UIFont systemFontOfSize:14];
    proLabel.textAlignment = NSTextAlignmentCenter;
    //是否是登录状态
    if ([DefaultManager getValueOfKey:@"token"]) {
        imageView.image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selfphoto.jpg"]];
        nameLabel.text = dict[@"nickname"];
        NSInteger score = [DefaultManager getBestScore];
        if (score == 101) {
            proLabel.text = @"今天还未做过模拟考试， 赶紧开始吧";
        }else{
            proLabel.text = [NSString stringWithFormat:@"您目前的最好成绩%ld分，查看排名",score];
        }
        
    }else{
        imageView.image = [UIImage imageNamed:@"driving_header"];
        nameLabel.text = @"点击登录";
        nameLabel.textColor = KColorSystem;
        proLabel.text = @"登陆后可以查看你的考试成绩排名";
    }
    [_headView addSubview:headBtn];
    [headBtn addSubview:imageView];
    [headBtn addSubview:nameLabel];
    [_headView addSubview:proLabel];
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headView);
        make.top.equalTo(_headView).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 100));
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(headBtn);
        make.height.width.mas_equalTo(60);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.centerX.width.equalTo(headBtn);
        make.height.mas_equalTo(20);
    }];
    
    [proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.centerX.equalTo(headBtn);
        make.size.mas_equalTo(CGSizeMake(300, 20));
    }];
}

- (void)btnClick:(UIButton *)btn{
    if (![DefaultManager getValueOfKey:@"token"]) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.isPush = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        RankingViewController *vc = [[RankingViewController alloc]init];
        vc.kid = _flag;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)requestData{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:KScores];
    for (NSDictionary *dict in array) {
        TestRecoderModel *model = [[TestRecoderModel alloc]init];
        model.score = dict[@"score"];
        model.time = dict[@"time"];
        model.flag = dict[@"flag"];
        model.num = dict[@"num"];
        [_dataArray addObject:model];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ide = @"myCell";
    TestRecoderCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TestRecoderModel *model = _dataArray[indexPath.row];
    ScroeViewController *vc = [[ScroeViewController alloc]init];
    vc.score = model.score.integerValue;
    vc.time = model.time;
    vc.flag = model.flag.integerValue;
    vc.num = model.num.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"考试记录";
}
- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    KWS(ws);
    UIImage *image = [[UMSocialScreenShoterDefault screenShoter] getScreenShot];
    [MyControl UMSocialImageWithImage:image ws:ws];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
