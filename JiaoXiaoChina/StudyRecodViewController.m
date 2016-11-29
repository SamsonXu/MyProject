//
//  StudyRecodViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/12.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "StudyRecodViewController.h"
#import "PiechartDetchView.h"
#import "PiechartModel.h"
#import "AnswerViewController.h"
@interface StudyRecodViewController ()<UIAlertViewDelegate>


{
    UIView *_bgView;
    PiechartDetchView *_chartTwo;
}
@end

@implementation StudyRecodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
}

- (void)createScrollView{
    [super createScrollView];
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self addBtnWithTitle:nil imageName:@"navigationbar_icon_share" navBtn:KNavBarRight];
    self.title = @"统计分析";
    _bootmScrollView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-100);
    _bootmScrollView.contentSize = CGSizeMake(0, KScreenHeight-64);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:KTrueFaults];
    NSString *str1 = dict[KTrue];
    NSString *str2 = dict[KFaults];
    NSInteger cb = [[defaults objectForKey:KJZLX]integerValue];
    NSArray *array = [[DBManager shareManager]selectDataWithCb:cb];
    NSMutableArray *transArray = [[NSMutableArray alloc]init];
    if (_flag == 4) {
        _flag = 2;
    }
    if (cb < 4) {
        transArray = [[DBManager shareManager]selectDataWithTk:_flag arr:array];
    }else{
        transArray = [array mutableCopy];
    }
    NSMutableArray *numArr = [[NSMutableArray alloc]init];
    NSArray *queArr = [DefaultManager getQuestionBase];
    for (NSString *num in queArr) {
        for (AnswerModel *model in transArray) {
            if (num.integerValue == model.pid) {
                [numArr addObject:model];
            }
        }
    }
    NSString *str3 = [NSString stringWithFormat:@"%ld",[numArr count]];
    //饼状图背景
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 400)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bootmScrollView addSubview:_bgView];
    NSInteger totlenum = str1.integerValue+str2.integerValue+str3.integerValue;
    PiechartModel *model1 = [[PiechartModel alloc]init];
    model1.color = [UIColor redColor];
    model1.perStr = [NSString stringWithFormat:@"%lf",(CGFloat)str1.integerValue/totlenum];
    
    PiechartModel *model3 = [[PiechartModel alloc]init];
    model3.color = KColorRGB(115, 193, 0);
    model3.perStr = [NSString stringWithFormat:@"%lf",(CGFloat)str2.integerValue/totlenum];
    NSArray *testArray = [NSArray arrayWithObjects:model1,model3, nil];
    
    //饼状图
    _chartTwo = [[PiechartDetchView alloc]initWithFrame:CGRectMake(0, 0, 150, 150) withStrokeWidth:30 andColor:[UIColor redColor] andPerArray:testArray  andAnimation:YES];
    [_bgView addSubview:_chartTwo];
    KWS(ws);
    [_chartTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view).offset(-100);
        make.top.equalTo(_bgView).offset(80);
        make.height.with.mas_equalTo(200);
    }];
    
    //统计label
    NSArray *array1 = @[[UIColor greenColor],[UIColor redColor],[UIColor grayColor]];
    NSArray *array2 = @[@"答对题",@"答错题",@"未做题"];
    NSArray *array3 = @[str1,str2,str3];
    for (int i = 0; i < array1.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(180, 305+30*i, 10, 10)];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 5;
        view.backgroundColor = array1[i];
        [_bgView addSubview:view];
        
        UILabel *label = [MyControl labelWithTitle:[NSString stringWithFormat:@"%@ %@题",array2[i],array3[i]] fram:CGRectMake(200, 300+30*i, 80, 20) color:[UIColor grayColor] fontOfSize:12 numberOfLine:1];
        [_bgView addSubview:label];
    }
    
    //底部视图
    UIView *_bootmView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-80, KScreenWidth, 80)];
    _bootmView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bootmView];
    NSArray *array4 = @[@"顺序练习",@"随机练习"];
    CGFloat width = (KScreenWidth-50)/2;
    for (int i = 0; i < array4.count; i++) {
        UIButton *btn = [MyControl buttonWithFram:CGRectMake(20+(width+10)*i, 20, width, 40) title:array4[i] imageName:nil tag:100+i];
        [btn setTitle:array4[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = KColorSystem;
        [_bootmView addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)btn{
    AnswerViewController *vc = [[AnswerViewController alloc]init];
    if (btn.tag == 100) {
        vc.type = 5;
        vc.number = self.flag;
    }else if (btn.tag == 101){
        vc.type = 1;
        vc.number = self.flag;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
