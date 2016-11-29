//
//  ForTestViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ForTestViewController.h"
#import "TestView.h"
#import "WebViewController.h"
#import "DTJQTwoController.h"
#import "DTJQOneController.h"
@interface ForTestViewController ()
{
    UIView *_friendView;
    //网址数组
    NSArray *_urlArr;
    //自学标题
    NSArray *_styTitles;
}
@end

@implementation ForTestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self addHeadViewWithFlag];
}

- (void)createScrollView{
    [super createScrollView];
    _bootmScrollView.showsVerticalScrollIndicator = NO;
}

//背景视图
- (void)addHeadViewWithFlag{
    //构建数据源
    //考规技巧数据源
    NSArray *images = @[@"driving_course",@"driving_jiqiao"];
    NSString *str1 = [[NSString alloc]init];
    NSString *str2 = [[NSString alloc]init];
    NSArray *titles = [[NSArray alloc]init];
    //自学直考数据源
    NSArray *styImages = [[NSArray alloc]init];
    NSArray *images1 = @[@"dt_selfstudy_xuzhi",@"dt_selfstudy_yuyue",@"dt_selfstudy_dongtai",@"dt_selfstudy_quan"];
    NSArray *images2 = @[@"skill_aqd",@"skill_dhkg",@"skill_fxp",@"skill_lhq",@"skill_jstb",@"skill_zdtb",@"skill_zczd",@"skill_zytz",@"skill_hsj",@"skill_jyjq"];
    NSArray *images3 = @[@"skill_cjpd",@"skill_dwcz",@"skill_dg",@"skill_zx",@"skill_jyjq"];
    NSArray *titles1 = @[@"直考须知",@"预约考试",@"最新动态",@"自学直考圈"];
    NSArray *titles2 = @[@"安全带",@"点火开关",@"方向盘",@"离合器",@"加速踏板",@"制动踏板",@"驻车制动",@"座椅调整",@"后视镜",@"经验技巧"];
    NSArray *titles3 = @[@"车距判断",@"档位操作",@"灯光",@"直行",@"经验技巧"];
    NSArray *url1 = @[KUrlZKXZ,KUrlYYKS,KUrlZXDT,KUrlZXZKQ];
    NSArray *url2 = @[KUrlAQD,KUrlDHKG,KUrlFXP,KUrlLHQ,KUrlJSTB,KUrlZDTB,KUrlZCZD,KUrlZYTZ,KUrlHSJ,KUrlJYJQKE];
    NSArray *url3 = @[KUrlCJPD,KUrlDWCZ,KUrlDG,KUrlZX,KUrlJYJQKS];
    //当前科目类型
    if (self.flag == 0) {
        str1 = @"科一考规";
        str2 = @"答题技巧";
        styImages = images1;
        _styTitles = titles1;
        _urlArr = url1;
    }else if (self.flag == 1){
        str1 = @"科二考规";
        str2 = @"驾考秘籍";
        styImages = images2;
        _styTitles = titles2;
        _urlArr = url2;
    }else if (self.flag == 2){
        str1 = @"科三考规";
        str2 = @"驾考秘籍";
        styImages = images3;
        _styTitles = titles3;
        _urlArr = url3;
    }else if (self.flag == 3){
        str1 = @"科四考规";
        str2 = @"答题技巧";
        styImages = images1;
        _styTitles = titles1;
        _urlArr = url1;
    }
    titles = @[str1,str2];
    //背景视图
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    [_bootmScrollView addSubview:view];
    //左按钮
    UIButton *btn1 = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:nil imageName:nil tag:50];
    btn1.backgroundColor = [UIColor whiteColor];
    btn1.userInteractionEnabled = YES;
    [btn1 addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(view);
    }];
    //间隔线
    UILabel *midLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    midLabel.backgroundColor = KColorRGB(235, 235, 241);
    [view addSubview:midLabel];
    [midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1.mas_right);
        make.height.mas_equalTo(20);
        make.top.equalTo(view).offset(5);
        make.width.mas_equalTo(1);
    }];
    //左图标
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:images[0]]];
    [btn1 addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1).offset(30);
        make.top.equalTo(btn1).offset(10);
        make.bottom.equalTo(btn1).offset(-10);
        make.width.equalTo(imageView1.mas_height);
    }];
    //左label
    UILabel *leftLabel = [MyControl labelWithTitle:titles[0] fram:CGRectMake(0, 0, 0, 0) fontOfSize:12];
    [btn1 addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView1.mas_right).offset(10);
        make.height.top.bottom.equalTo(imageView1);
        make.width.mas_equalTo(100);
    }];
    //右按钮
    UIButton *btn2 = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:nil imageName:nil tag:51];
    btn2.backgroundColor = [UIColor whiteColor];
    [btn2 addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midLabel.mas_right);
        make.height.width.centerY.equalTo(btn1);
        make.right.equalTo(view.mas_right);
    }];
    //右图标
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:images[1]]];
    [btn2 addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn2).offset(30);
        make.top.bottom.width.height.equalTo(imageView1);
    }];
    //右label
    UILabel *rightLabel = [MyControl labelWithTitle:titles[1] fram:CGRectMake(0, 0, 0, 0) fontOfSize:12];
    [btn2 addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView2.mas_right).offset(10);
        make.height.top.bottom.equalTo(imageView2);
        make.width.mas_equalTo(100);
    }];
    [view bringSubviewToFront:btn1];
    
    //自学直考
    UILabel *selfLabel = [MyControl labelWithTitle:@"自学直考" fram:CGRectMake(0, 40+10, KScreenWidth, 30) fontOfSize:14];
    selfLabel.backgroundColor = [UIColor whiteColor];
    selfLabel.textAlignment = NSTextAlignmentCenter;
    [_bootmScrollView addSubview:selfLabel];
    //添加直考视图
    //直考按钮
    KWS(ws);
    NSInteger num;
    if (styImages.count<=5) {
        num = styImages.count;
    }else{
        num = 5;
    }
    //每个按钮的宽度
    CGFloat width = KScreenWidth/num;
    UIButton *lastBtn = nil;
    for (int i = 0; i < styImages.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(selfTestClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bootmScrollView addSubview:btn];
        //一排按钮
        if (styImages.count <= 5) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (!lastBtn) {
                    make.left.equalTo(ws.view);
                }else{
                    make.left.equalTo(lastBtn.mas_right);
                }
                make.top.equalTo(selfLabel.mas_bottom).offset(1);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(65);
            }];
        }else{//两排按钮
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i%5 == 0) {
                    make.left.equalTo(ws.view);
                }else{
                    make.left.equalTo(lastBtn.mas_right);
                }
                if (i < 5) {
                    make.top.equalTo(selfLabel.mas_bottom).offset(1);
                }else{
                    if (i%5 == 0) {
                        make.top.equalTo(lastBtn.mas_bottom);
                    }else{
                        make.top.equalTo(lastBtn);
                    }
                }
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(65);
            }];
        }
        //按钮内容
        //图片
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:styImages[i]]];
        [btn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(btn).offset(5);
            make.height.width.mas_equalTo(30);
        }];
        //标题
        UILabel *titleLabel = [MyControl labelWithTitle:_styTitles[i] fram:CGRectMake(0, 0, 0, 0) fontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(imageView.mas_bottom).offset(5);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(btn);
        }];
        lastBtn = btn;
    }
    self.lastView = lastBtn;
    self.height = CGRectGetMaxY(lastBtn.frame);
}

//考规/答题技巧按钮
- (void)headBtnClick:(UIButton *)btn{
    NSArray *url1 = @[KUrlKGOne,KUrlKGTwo,KUrlKGThree,KUrlKGFour];
    NSArray *titles = @[@"科一考规",@"科二考规",@"科三考规",@"科四考规"];
    NSArray *url2 = @[KUrlDTJQOne,KUrlDTJQTwo,KUrlDTJQThree,KUrlDTJQOne];
    if (btn.tag == 50) {
        WebViewController *vc = [[WebViewController alloc]init];
        vc.url = url1[self.flag];
        vc.navTitle = titles[self.flag];
        [self.delegate doPushWithVc:vc];
    }else if (btn.tag == 51){
        if (self.flag == 0 || self.flag == 3) {
            DTJQOneController *vc = [[DTJQOneController alloc]init];
            vc.url = url2[self.flag];
            vc.flag = 0;
            [self.delegate doPushWithVc:vc];
        }else{
        DTJQTwoController *vc = [[DTJQTwoController alloc]init];
        vc.url = url2[self.flag];
        [self.delegate doPushWithVc:vc];
        }
    }
}

- (void)selfTestClick:(UIButton *)btn{
    NSInteger index = btn.tag - 200;
    WebViewController *vc = [[WebViewController alloc]init];
    vc.url = _urlArr[index];
    vc.navTitle = _styTitles[index];
    [self.delegate doPushWithVc:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
