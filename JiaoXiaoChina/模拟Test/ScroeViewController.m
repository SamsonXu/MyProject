//
//  ScroeViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/10.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ScroeViewController.h"
#import "AnswerViewController.h"
@interface ScroeViewController ()

@end

@implementation ScroeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    self.title = @"考试成绩";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self addBtnWithTitle:nil imageName:@"nav_delete" navBtn:KNavBarRight];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    backView.image = [UIImage imageNamed:@"ksbj"];
    [self.view addSubview:backView];
    
    NSArray *images = @[@"jscs",@"mlss",@"testshare"];
    NSString *imageName;
    UIColor *color;
    if (self.score >= 90) {
        imageName = images[0];
        color = KColorSystem;
    }else{
        imageName = images[1];
        color = [UIColor redColor];
    }
    KWS(ws);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]];
    //头像
    UIImageView *headView = [UIImageView new];
    NSString *str = dict[@"headimg"];
    if (str.length == 0) {
        headView.image = [UIImage imageNamed:@"f0"];
    }else{
        [headView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"f0"]];
    }
    headView.layer.cornerRadius = 30;
    headView.layer.masksToBounds = YES;
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(20);
        make.top.equalTo(ws.view).offset(84);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    //用户名
    UILabel *nameLabel = [MyControl labelWithTitle:dict[@"nickname"] fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:17 numberOfLine:1];
    nameLabel.textColor = KColorSystem;
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).offset(10);
        make.centerY.equalTo(headView);
        make.height.mas_equalTo(20);
    }];
    
    //性别
    UIImageView *sexView = [UIImageView new];
    NSString *imgStr = @"";
    if ([dict[@"sex"] integerValue] == 1) {

        imgStr = @"user_sex_male";
    }else if ([dict[@"sex"] integerValue] == 2){
        imgStr = @"user_sex_female";

    }
    sexView.image = [UIImage imageNamed:imgStr];
    [self.view addSubview:sexView];
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.left.equalTo(nameLabel.mas_right).offset(20);
        make.height.width.mas_equalTo(20);
    }];

    //考试成绩图片
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.top.equalTo(headView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(240, 295));
    }];
    //分数
    UILabel *label1 = [MyControl boldLabelWithTitle:[NSString stringWithFormat:@"%ld",_score] fram:CGRectMake(0, 0, 0, 0) color:color fontOfSize:40];
    [imageView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.centerY.equalTo(imageView).offset(-30);
        make.height.mas_equalTo(30);
    }];
    UILabel *label2 = [MyControl boldLabelWithTitle:@"分" fram:CGRectMake(0, 0, 0, 0) color:color fontOfSize:14];
    [imageView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(10);
        make.centerY.equalTo(label1).offset(10);
        make.height.width.mas_equalTo(20);
    }];
    //用时
    UILabel *label3 = [MyControl boldLabelWithTitle:[NSString stringWithFormat:@"用时 %@",_time] fram:CGRectMake(40, 80, 30, 20) color:[UIColor grayColor] fontOfSize:14];
    [imageView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *shareBtn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:nil imageName:images[2] tag:100];
    [shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.centerX.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(246, 40));
    }];
    
    NSArray *btnImgs = @[@"testlook",@"testwrong",@"testcl"];
    NSArray *btnTitles = @[@"查看试卷",@"只看错题",@"再来一次"];
    //每个按钮的宽度
    CGFloat width = KScreenWidth/btnImgs.count;
    UIButton *lastBtn = nil;
    for (int i = 0; i < images.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        //一排按钮
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastBtn) {
                make.left.equalTo(ws.view);
            }else{
                make.left.equalTo(lastBtn.mas_right);
            }
            make.top.equalTo(shareBtn.mas_bottom).offset(20);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(65);
        }];
        //按钮内容
        //图片
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:btnImgs[i]]];
        [btn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(btn).offset(5);
            make.height.width.mas_equalTo(30);
        }];
        //标题
        UILabel *titleLabel = [MyControl labelWithTitle:btnTitles[i] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(imageView.mas_bottom).offset(5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(btn);
        }];
        lastBtn = btn;
    }
    UILabel *titlelabel = [MyControl boldLabelWithTitle:@"驾 考 就 选 驾 校 中 国" fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:20];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(ws.view);
        make.top.equalTo(lastBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)btnClick:(UIButton *)btn{
    NSInteger index = btn.tag-100;
    if (index == 0) {
        KWS(ws);
        UIImage *image = [[UMSocialScreenShoterDefault screenShoter] getScreenShot];
        [MyControl UMSocialImageWithImage:image ws:ws];
    }else if (index == 1){
        AnswerViewController *vc = [[AnswerViewController alloc]init];
        vc.type = 6;
        vc.number = _flag;
        vc.topicNum = _num;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 2){
        AnswerViewController *vc = [[AnswerViewController alloc]init];
        vc.type = 6;
        vc.number = _flag;
        vc.topicNum = _num;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 3){
        AnswerViewController *vc = [[AnswerViewController alloc]init];
        vc.type = 6;
        vc.number = _flag;
        vc.topicNum = _num;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定删除该次考试记录" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [DefaultManager removeScoreRecoderWithScore:_score time:_time];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
