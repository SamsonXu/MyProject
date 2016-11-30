//
//  RankingViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RankingViewController.h"
#import "RankingCell.h"
@interface RankingViewController ()
{
    //排序分类
    NSInteger _type;
    //当前城市id
    NSString *_currCity;
    UIButton *_lastBtn;
    NSArray *_imgArr;
    //城市id
    NSString *_cityId;
}
@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_kid == 4) {
        _kid = 2;
    }
    _type = 0;
    _currCity = @"2";
    _cityId = @"2";
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path];
    for (NSDictionary *dict in array) {
        if ([dict[@"areaname"] isEqualToString:[DefaultManager getValueOfKey:@"currentCity"]]) {
            _cityId = dict[@"id"];
        }
    }
    [self requestData];
    [self createUI];
}

- (void)requestData{
    
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlRank parameters:@{@"kid":[NSString stringWithFormat:@"%ld",_kid],@"cityid":_currCity,@"type":[NSString stringWithFormat:@"%ld",_type]} sucBlock:^(id responseObject) {
        KMBProgressHide;
        _dataArray = [RankModel arrayOfModelsFromDictionaries:responseObject[@"data"]];
        [_tableView reloadData];
    } failBlock:^{
        KMBProgressHide;
    }];
}

- (void)createUI{
    _imgArr = @[@"rank_first",@"rank_second",@"rank_third"];
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self addBtnWithTitle:nil imageName:@"navigationbar_icon_share" navBtn:KNavBarRight];
    NSString *cityStr = [DefaultManager getValueOfKey:@"currentCity"];
    if (cityStr.length == 0) {
        cityStr = @"北京";
    }
    UISegmentedControl *segc=[[UISegmentedControl alloc]initWithItems:@[cityStr,@"全国"]];
    segc.frame=CGRectMake(0, 0, 140, 30);
    [segc addTarget:self action:@selector(changeSegementedControl:) forControlEvents:UIControlEventValueChanged];
    [segc setSelectedSegmentIndex:0];
    [segc setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = segc;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    NSArray *times = @[@"今日",@"本周",@"本月",@"总榜"];
    CGFloat width = KScreenWidth/4;
    for (int i = 0; i < times.count; i++) {
        UIButton *btn = [MyControl buttonWithFram:CGRectMake(width*i, 0, width, 40) title:times[i] imageName:nil tag:100+i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:KColorSystem forState:UIControlStateSelected];
        [headView addSubview:btn];
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, KScreenWidth, KScreenHeight-94) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RankingCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)btnClick:(UIButton *)btn{
    NSInteger index = btn.tag - 100;
    _lastBtn.selected = NO;
    btn.selected = YES;
    _type = index;
    _lastBtn = btn;
    [self requestData];
}

- (void)changeSegementedControl:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    if (index == 0) {
        _currCity = _cityId;
    }else if (index == 1){
        _currCity = @"0";
    }
    [self requestData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    if (indexPath.row < 3) {
        cell.rankLabel.hidden = YES;
        cell.rankImgView.hidden = NO;
        cell.rankImgView.image = [UIImage imageNamed:_imgArr[indexPath.row]];
    }else{
        cell.rankImgView.hidden = YES;
        cell.rankLabel.hidden = NO;
        cell.rankLabel.text = [NSString stringWithFormat:@"第%ld名",indexPath.row+1];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
