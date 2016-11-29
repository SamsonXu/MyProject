//
//  PictureViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/11.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureCell.h"
#import "PictOneViewController.h"
#import "PictTwoViewController.h"
#define KTitle @"title"
#define KNum @"number"
#define KImages @"images"
#define KJson @"json"
@interface PictureViewController ()
{
    NSArray *_infoArr;
}
@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
}

- (void)createUI{
    [super createUI];
    self.title = @"图标速记";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"PictureCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"myCell"];
    
}

- (void)requestData{
    NSArray *array = @[@{KTitle:@"交通标志大全",KNum:@"449",KImages:@[@"trafficMark_1",@"trafficMark_2",@"trafficMark_3",@"trafficMark_4"],KJson:@""},@{KTitle:@"汽车仪表指示灯",KNum:@"25",KImages:@[@"trafficMark_5",@"trafficMark_6",@"trafficMark_7",@"trafficMark_8"],KJson:@"biaozhi_grid_car_panel_light"},@{KTitle:@"车内功能按键",KNum:@"9",KImages:@[@"trafficMark_9",@"trafficMark_10",@"trafficMark_11",@"trafficMark_12"],KJson:@"biaozhi_grid_car_fouction"},@{KTitle:@"新版交警手势",KNum:@"8",KImages:@[@"trafficMark_13",@"trafficMark_14",@"trafficMark_15",@"trafficMark_16"],KJson:@"traffic_police_gesture"},@{KTitle:@"交通事故图解",KNum:@"38",KImages:@[@"trafficMark_17",@"trafficMark_18",@"trafficMark_19",@"trafficMark_20"],KJson:@"biaozhi_grid_traffic_accident"},@{KTitle:@"色盲测试图集",KNum:@"19",KImages:@[@"34.jpg",@"33.jpg",@"32.jpg",@"31.jpg"],KJson:@"biaozhi_grid_color_blind"}];
    for (NSDictionary *dict in array) {
        PicModel *model = [[PicModel alloc]init];
        model.title = dict[KTitle];
        model.num = dict[KNum];
        model.images = dict[KImages];
        model.jsonName = dict[KJson];
        [_dataArray addObject:model];
    }
    
    
}

#pragma mark---TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ide = @"myCell";
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PicModel *model = _dataArray[indexPath.item];
    if (indexPath.row == 0) {
        PictOneViewController *vc = [[PictOneViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PictTwoViewController *vc = [[PictTwoViewController alloc]init];
        vc.navTitle = model.title;
        vc.jsonName = model.jsonName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
