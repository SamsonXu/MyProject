//
//  LimitSaleController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/15.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "LimitSaleController.h"
#import "LimitCell.h"
@interface LimitSaleController ()
{
    NSTimer *_timer;
}
@end

@implementation LimitSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    
    [super createUI];
    self.title = @"限时特惠";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self createHeadView];
    [_tableView registerNib:[UINib nibWithNibName:@"LimitCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void)createHeadView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"limitsale"]];
    [view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    UILabel *endLabel = [MyControl labelWithTitle:@"距离结束" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [view addSubview:endLabel];
    
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScreenWidth-160);
        make.centerY.equalTo(view);
        make.height.mas_equalTo(20);
    }];
    
    //倒计时
    UILabel *lastLabel = nil;
    NSArray *array = @[[NSString stringWithFormat:@"%ld",(NSInteger)_time/3600],[NSString stringWithFormat:@"%ld",(NSInteger)_time%3600/60],[NSString stringWithFormat:@"%ld",(NSInteger)_time%3600%60]];
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *label = [MyControl labelWithTitle:array[i] fram:CGRectMake(0, 0, 0, 0) fontOfSize:12];
        label.tag = 100+i;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = KColorSystem;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(endLabel);
            if (lastLabel) {
                make.left.equalTo(lastLabel.mas_right).offset(10);
            }else{
                make.left.equalTo(endLabel.mas_right).offset(10);
            }
            make.height.width.mas_equalTo(20);
        }];
        
        if (i < 2) {
            
            UILabel *label1 = [MyControl labelWithTitle:@":" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
            label1.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label1];
            
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label);
                make.left.equalTo(label.mas_right);
                make.size.mas_equalTo(CGSizeMake(10, 20));
            }];
        }
        
        
        lastLabel = label;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime) userInfo:nil repeats:YES];
}

- (void)reduceTime{
    
    if (_time == 0) {
        [_timer invalidate];
        return;
    }
    _time--;
    NSArray *array = @[[NSString stringWithFormat:@"%ld",(NSInteger)_time/3600],[NSString stringWithFormat:@"%ld",(NSInteger)_time%3600/60],[NSString stringWithFormat:@"%ld",(NSInteger)_time%3600%60]];
    
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [self.view viewWithTag:100+i];
        label.text = array[i];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _classArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LimitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.applyLabel.layer.cornerRadius = 5;
    cell.applyLabel.layer.masksToBounds = YES;
    cell.model = _classArray[indexPath.row];
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
