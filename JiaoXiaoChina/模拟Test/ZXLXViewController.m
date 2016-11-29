//
//  ZXLXViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/27.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ZXLXViewController.h"
#import "AnswerCell.h"
#import "ZJLXViewController.h"
#import "AnswerViewController.h"
#define KImage @"image"
#define KTitle @"title"
@interface ZXLXViewController ()
{
    UIView *_footView;
}
@end

@implementation ZXLXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
    [self footView];
}

- (void)createUI{
    [super createUI];
    self.title = @"专项练习";
    [self addBtnWithTitle:nil imageName:@"co_nav_back_btn" navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"AnswerCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)requestData{
    NSDictionary *dict1 = @{KImage:@"driving_chapter_icon",KTitle:@"章节练习"};
    NSDictionary *dict2 = @{KImage:@"icon_controversial_topics",KTitle:@"易错题"};
    [_dataArray addObjectsFromArray:@[dict1,dict2]];
    
}

#pragma mark----tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ide = @"myCell";
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    cell.iconImageView.hidden = NO;
    cell.iconImageView.image = [UIImage imageNamed:_dataArray[indexPath.section][KImage]];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.mainLabel.text = _dataArray[indexPath.section][KTitle];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ZJLXViewController *vc = [[ZJLXViewController alloc]init];
        vc.flag = _flag;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        AnswerViewController *vc = [[AnswerViewController alloc]init];
        vc.number = _flag+1;
        vc.type = 3;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//尾部视图
- (void)footView{
    NSArray *array = [[DBManager shareManager]selectDataWithDataType:itemTp Flag:0];
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth, 0)];
    //分类按钮
    UIButton *lastBtn = [UIButton new];
    lastBtn = nil;
    for (int i = 0; i < array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor whiteColor];
        [_footView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i%2 == 0) {
                make.left.equalTo(_footView);
            }else{
                make.left.equalTo(lastBtn.mas_right).offset(1);
            }
            if (i == 0) {
                make.top.equalTo(_footView).offset(10);
            }else if(i%2 == 0){
                make.top.equalTo(lastBtn.mas_bottom).offset(1);
            }else if(i%2 == 1){
                make.top.equalTo(lastBtn);
            }
            if (i == array.count-1) {
                make.bottom.equalTo(_footView);
            }
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(KScreenWidth/2);
        }];
        //按钮序号
        UILabel *label = [MyControl labelWithTitle:[NSString stringWithFormat:@"%d",i+1] fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:12 numberOfLine:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.backgroundColor = KColorSystem;
        [btn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.width.height.mas_equalTo(20);
            make.left.equalTo(btn).offset(20);
        }];
        //标题
        DataModel *model = array[i];
        UILabel *titleLabel = [MyControl labelWithTitle:model.title fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
        [btn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(label.mas_right).offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
        }];
        lastBtn = btn;
    }
}

//题型按钮点击事件
- (void)btnClick:(UIButton *)btn{
    AnswerViewController *vc = [[AnswerViewController alloc]init];
    vc.number = self.flag+1;
    vc.type = 10;
    vc.fl = btn.tag-100;
    [self.navigationController pushViewController:vc animated:YES];
}

//尾部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return _footView;
    }
    return nil;
}

//返回上一界面
- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
