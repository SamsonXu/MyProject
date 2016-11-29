//
//  JZViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/27.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JZViewController.h"
#import "WebViewController.h"
#import "DTJQOneController.h"
#import "RidersTopicController.h"
#import "JZView.h"
#import "CateModel.h"
@interface JZViewController ()<JZViewDelegate>
{
    NSString *_topicNum;
}
@end

@implementation JZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self createUI];
    [self getRiderList];
}

- (void)createUI{
    NSArray *array1 = @[@"领照需知",@"领照时间与地点",@"驾照年审",@"驾照遗失挂失",@"驾照换证"];
    NSArray *array2 = @[@"新手上路",@"上路前注意事项",@"行驶时注意事项",@"停车时注意事项",@"实用驾驶技巧"];
    _bootmScrollView.showsVerticalScrollIndicator = NO;
    _bootmScrollView.showsHorizontalScrollIndicator = NO;
    JZView *view1 = [[JZView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 142) image:@"driving_lingjiazhao" titles:array1];
    view1.delegate = self;
    view1.flag = 0;
    [_bootmScrollView addSubview:view1];
    
    JZView *view2 = [[JZView alloc]initWithFrame:CGRectMake(0, 150, KScreenWidth, 142) image:@"driving_xinshou" titles:array2];
    view2.flag = 1;
    view2.delegate = self;
    [_bootmScrollView addSubview:view2];
    KWS(ws);
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlAdver1 parameters:@{@"id":@"78"} sucBlock:^(id responseObject) {
        UIImageView *imageView = [MyControl imageViewWithFram:CGRectMake(0, 0, 0, 0) url:@""];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTapClick:)];
        [imageView addGestureRecognizer:tap];
        imageView.backgroundColor = KColorRGB(19, 153, 229);
        [_bootmScrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view2.mas_bottom).offset(10);
            make.left.right.equalTo(ws.view);
            make.height.mas_equalTo(80);
        }];

    } failBlock:^{
        
    }];
       _bootmScrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight-64-49);
}

- (void)getRiderList{
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlRiderHeadList parameters:@{@"cateid":@"8"} sucBlock:^(id responseObject) {

        NSArray *array = responseObject[@"data"];
        _topicNum = responseObject[@"wd_count"];
        [self createRiderViewWith:array];
    } failBlock:^{
        
    }];
}

- (void)createRiderViewWith:(NSArray *)array{
    KWS(ws);
    UIView *backView = [UIView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewClick:)];
    [backView addGestureRecognizer:tap];
    [_bootmScrollView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(392);
        make.left.right.equalTo(ws.view);
        make.height.mas_equalTo(111);
    }];
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(backView);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *label1 = [MyControl labelWithTitle:@"驾考圈-拿本后" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    [headView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(20);
        make.centerY.equalTo(headView);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dt_main_web_forward"]];
    [headView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.right.equalTo(ws.view);
        make.height.width.mas_equalTo(20);
    }];
    
    UILabel *label2 = [MyControl labelWithTitle:[NSString stringWithFormat:@"有%@位驾友参与讨论",_topicNum] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    [headView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.right.equalTo(imageView.mas_left);
        make.height.mas_equalTo(20);
    }];
    
    CGFloat width = (KScreenWidth-70)/6;
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [_bootmScrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_bottom).offset(1);
        make.left.right.equalTo(headView);
        make.height.mas_equalTo(width+20);
    }];
    
    UIImageView *lastView = nil;
    for (int i = 0; i < 6; i++) {
        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:array[i][@"headimg"]] placeholderImage:[UIImage imageNamed:@""]];
        imageView.layer.cornerRadius = width/2;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor yellowColor];
        [bottomView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(10);
            }else{
                make.left.equalTo(bottomView).offset(10);
            }
            make.height.width.mas_equalTo(width);
        }];
        lastView = imageView;
    }
}

#pragma mark---JZViewDelegate
-(void)pushWithTag:(NSInteger)tag flag:(NSInteger)flag{
    NSArray *urlArr = @[KUrlNB1,KUrlNB2,KUrlNB3,KUrlNB4,KUrlNB5,KUrlNB6,KUrlNB7,KUrlNB8];
    if (flag == 0) {
        WebViewController *vc = [[WebViewController alloc]init];
        vc.url = urlArr[tag];
        [self.delegate doPush:vc];
        
    }else if (flag == 1){
        if (tag < 3) {
            WebViewController *vc = [[WebViewController alloc]init];
            vc.url = urlArr[tag+4];
            [self.delegate doPush:vc];
        }else{
            DTJQOneController *vc = [[DTJQOneController alloc]init];
            vc.url = urlArr[tag+4];
            vc.flag = 1;
            [self.delegate doPush:vc];
        }
        
    }
}

- (void)imgViewTapClick:(UITapGestureRecognizer *)tap{
    WebViewController *vc = [[WebViewController alloc]init];
    vc.url = @"";
    [self.delegate doPush:vc];
}

- (void)backViewClick:(UITapGestureRecognizer *)tap{
    RidersTopicController *vc = [[RidersTopicController alloc]init];
    vc.cateId = @"8";
    [self.delegate doPush:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
