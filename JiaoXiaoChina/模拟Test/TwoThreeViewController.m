//
//  TwoThreeViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/13.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "TwoThreeViewController.h"
#import "MovieCell.h"
#import "LightViewController.h"
#import "MoiveViewController.h"
#import "MoiveManagerController.h"
#import "WebViewController.h"
#import "RidersTopicController.h"
@interface TwoThreeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_collectView;
    NSString *_topicNum;//话题数
    NSString *_cateid;//话题id
}
@end

@implementation TwoThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self addCollectionView];
    [self getRiderList];
}

- (void)addCollectionView{
    
    CGFloat y = 320;
    NSInteger num;
    if (self.flag == 2) {
        [self addLightView];
        y = 332;
        num = 8;
    }else{
        y = 342;
        num = 6;
    }
    [self createHeadView];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing = 10;
    flow.minimumInteritemSpacing = 10;
    flow.itemSize = CGSizeMake(170, 150);
    flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, y, KScreenWidth, (num/2)*160) collectionViewLayout:flow];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    [_collectView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellWithReuseIdentifier:@"myCell"];
    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.contentSize = CGSizeMake(KScreenWidth, 0);
    _collectView.bounces = NO;
    _collectView.showsVerticalScrollIndicator = NO;
    _bootmScrollView.contentSize = CGSizeMake(KScreenWidth, 160*(num/2)+y+121);
    [_bootmScrollView addSubview:_collectView];
}

- (void)requestData{
    NSString *str;
    NSString *adStr;
    if (self.flag == 1) {
        str = KUrlTest2;
        adStr = @"76";
    }else if (self.flag == 2){
        str = KUrlTest3;
        adStr = @"77";
    }
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlAdver1 parameters:@{@"id":adStr} sucBlock:^(id responseObject) {
        [self addImageViewWithImageUrl:@""];
        [_collectView reloadData];
    } failBlock:^{
        
    }];
   
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:str parameters:nil sucBlock:^(id responseObject) {
        NSArray *array = responseObject[@"volist"];
        for (NSDictionary *dict in array) {
            MovieModel *model = [[MovieModel alloc]init];
            model.title = dict[@"title"];
            model.pic_url = dict[@"pic_url"];
            model.video_url = dict[@"video_url"];
            model.url = dict[@"url"];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    } failBlock:^{
        
    }];
    
}

- (void)createHeadView{
    NSInteger y;
    NSString *str;
    if (self.flag == 1) {
        y = 300;
        str = @"科二教学视频下载管理";
    }else if (self.flag == 2){
        y = 290;
        str = @"科三教学视频下载管理";
    }
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, y, KScreenWidth, 40) title:nil imageName:nil];
    UIImageView *imageView = [MyControl imageViewWithFram:CGRectMake(5, 7, 25, 25) imageName:@"subject3_player_icon_play"];
    UILabel *label = [MyControl labelWithTitle:str fram:CGRectMake(40, 10, 150, 20) fontOfSize:14];
    UIImageView *rightView = [MyControl imageViewWithFram:CGRectMake(KScreenWidth-30, 10, 20, 20) imageName:@"login_auth_login_arrow"];
    [btn addSubview:imageView];
    [btn addSubview:label];
    [btn addSubview:rightView];
    [btn addTarget:self action:@selector(managerClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];
    [_bootmScrollView addSubview:btn];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MovieModel *model = _dataArray[indexPath.row];
    MoiveViewController *vc = [[MoiveViewController alloc]init];
    vc.model = model;
    [self.delegate doPushWithVc:vc];
}

- (void)addLightView{
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 240, KScreenWidth, 40) title:nil imageName:nil];
    UIImageView *imageView = [MyControl imageViewWithFram:CGRectMake(0, 5, 30, 30) imageName:@"subject3_light_voice_icon"];
    UILabel *label = [MyControl labelWithTitle:@"灯光语音场景模拟" fram:CGRectMake(40, 10, 150, 20) fontOfSize:14];
    UIImageView *rightView = [MyControl imageViewWithFram:CGRectMake(KScreenWidth-30, 10, 20, 20) imageName:@"login_auth_login_arrow"];
    [btn addSubview:imageView];
    [btn addSubview:label];
    [btn addSubview:rightView];
    [btn addTarget:self action:@selector(lightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];
    [_bootmScrollView addSubview:btn];
}

- (void)lightBtnClick:(UIButton *)btn{
    LightViewController *vc = [[LightViewController alloc]init];
    [self.delegate doPushWithVc:vc];
}

- (void)managerClick:(UIButton *)btn{
    MoiveManagerController *vc = [[MoiveManagerController alloc]init];
    vc.flag = self.flag;
    vc.modelArr = _dataArray;
    [self.delegate doPushWithVc:vc];
}

//添加广告图片
- (void)addImageViewWithImageUrl:(NSString *)imageUrl {
    UIImageView *imageVierw = [MyControl imageViewWithFram:CGRectMake(0, 0, KScreenWidth, 70) url:imageUrl];
    imageVierw.backgroundColor = KColorRGB(19, 153, 229);
    imageVierw.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageBtnClick:)];
    [imageVierw addGestureRecognizer:tap];
    [_bootmScrollView addSubview:imageVierw];
    KWS(ws);
    [imageVierw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.lastView.mas_bottom).offset(10);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(70);
        make.centerX.equalTo(ws.view);
    }];
    
    
    self.lastView = imageVierw;
}

- (void)getRiderList{
    if (self.flag == 1) {
        _cateid = @"3";
    }else if (self.flag == 2){
        _cateid = @"4";
    }
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlRiderHeadList parameters:@{@"cateid":_cateid} sucBlock:^(id responseObject) {
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
        make.top.equalTo(_collectView.mas_bottom).offset(10);
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
    
    NSString *str;
    if (self.flag == 1) {
        str = @"科目二";
    }else if (self.flag == 2){
        str = @"科目三";
    }
    UILabel *label1 = [MyControl labelWithTitle:[NSString stringWithFormat:@"驾考圈-%@",str] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
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
    [self.view addSubview:bottomView];
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


- (void)imageBtnClick:(UIButton *)btn{

    WebViewController *vc = [[WebViewController alloc]init];
    vc.url = @"http://api.51jiaxiao.com/Naben/index.html";
    [self.delegate doPushWithVc:vc];
    
}

- (void)backViewClick:(UITapGestureRecognizer *)tap{
    RidersTopicController *vc = [[RidersTopicController alloc]init];
    vc.cateId = _cateid;
    [self.delegate doPushWithVc:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
