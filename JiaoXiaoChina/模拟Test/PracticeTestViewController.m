//
//  PracticeTestViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/9.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PracticeTestViewController.h"
#import "AnswerViewController.h"
#import "LoginViewController.h"
@interface PracticeTestViewController ()
{
    //考试题目数量
    NSInteger _topicNum;
}
@end

@implementation PracticeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self createUI];
}

- (void)createScrollView{
    [super createScrollView];
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    _bootmScrollView.backgroundColor = [UIColor whiteColor];
    _bootmScrollView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64);
    _bootmScrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight-64);
    NSString *str;
    if (self.flag == 1) {
        str = @"科目一";
    }else if (self.flag == 4){
        str = @"科目四";
    }
    self.title = [NSString stringWithFormat:@"%@模拟考试",str];
}

- (void)createUI{
    
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
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selfphoto.jpg"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager fileExistsAtPath:path];
        if (success) {
            imageView.image = [UIImage imageWithContentsOfFile:path];

        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"headimg"]]];
        }
        
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
    
    [_bootmScrollView addSubview:headBtn];
    [headBtn addSubview:imageView];
    [headBtn addSubview:nameLabel];
    [_bootmScrollView addSubview:proLabel];
    
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bootmScrollView);
        make.top.equalTo(_bootmScrollView.mas_bottom).offset(20);
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
    
    //考试介绍
    NSString *path = [[NSBundle mainBundle]pathForResource:@"QuestBank" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSInteger jzNum = [[defaults objectForKey:KJZLX]integerValue];
    NSDictionary *jzDict = [[NSDictionary alloc]init];
    NSString *str1;
    NSString *str2;
    
    if (jzNum < 5) {
        jzDict = array[0][jzNum-1];
    }else{
        jzDict = array[1][jzNum-7];
    }
    
    NSArray *titleArray = @[@"全国通用",@"考题数量",@"考试时间",@"合格标准",@"出题规则"];
    NSString *str3 = [NSString stringWithFormat:@"满分%@分，%@分及格",jzDict[@"totlescore"],jzDict[@"passscore"]];
    NSString *str4 = @"按公安部规定比例随机抽取";
    
    if (self.flag == 1) {
        
        _topicNum = [jzDict[@"topicnum"] integerValue];
        str1 = [NSString stringWithFormat:@"%@题",jzDict[@"topicnum"]];
        str2 = [NSString stringWithFormat:@"%@分钟",jzDict[@"time"]];
        
    }else if (self.flag == 4){
        
        str1 = @"50题";
        str2 = @"30分钟";
        
    }
    
    NSArray *array1 = @[[NSString stringWithFormat:@"%@%@",jzDict[@"type"],jzDict[@"drivetype"]],str1,str2,str3,str4];
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UILabel *label = [MyControl labelWithTitle:titleArray[i] fram:CGRectMake(60, 180+40*i, 100, 20) fontOfSize:14 numberOfLine:1];
        [_bootmScrollView addSubview:label];
        
        UILabel *label2 = [MyControl labelWithTitle:array1[i] fram:CGRectMake(40+100+20, 180+40*i, 200, 20) fontOfSize:14 numberOfLine:1];
        label2.textColor = KColorRGB(233, 120, 27);
        [_bootmScrollView addSubview:label2];
    }
    
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:@"全真模拟考试" imageName:nil tag:100];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = KColorSystem;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bootmScrollView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bootmScrollView);
        make.top.mas_equalTo(390);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
}

- (void)btnClick:(UIButton *)btn{
    
    NSInteger index = btn.tag;
    
    if (index == 50) {
        
        if ([DefaultManager getValueOfKey:@"token"]) {

        }else{
            LoginViewController *vc = [[LoginViewController alloc]init];
            vc.isPush = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (index == 100){
        
        AnswerViewController *vc = [[AnswerViewController alloc]init];
        vc.type = 6;
        vc.number = self.flag;
        vc.topicNum = _topicNum;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
