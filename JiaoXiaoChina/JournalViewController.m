//
//  JournalViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/16.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "JournalViewController.h"
#import "JournalRecoderController.h"
#import "TopicDetailViewController.h"
#import "JournalCell.h"
@interface JournalViewController ()<JournalCellDelegate>
{
    NSDictionary *_dict;
}
@end

@implementation JournalViewController

- (void)viewWillAppear:(BOOL)animated{
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)requestData{
    
    NSDictionary *dict;
    if (_isOthers) {
        dict = @{@"token":[DefaultManager getValueOfKey:@"token"],@"uid":_uid};
//        NSLog(@"%@",_uid);
    }else{
        dict = @{@"token":[DefaultManager getValueOfKey:@"token"]};
    }
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlTopicList parameters:dict sucBlock:^(id responseObject) {
        KMBProgressHide;
        if ([responseObject[@"status"] integerValue] == 1) {
            _dict = responseObject[@"userinfo"];
            _dataArray = [JournalModel arrayOfModelsFromDictionaries:responseObject[@"volist"]];
            [self createHeaderView];
            [_tableView reloadData];
        }else{
//            NSLog(@"%@",responseObject[@"msg"]);
        }
    } failBlock:^{
        KMBProgressHide;
    }];
}

- (void)createUI{
    [super createUI];
    
    self.title = @"我的学车日志";
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(KScreenWidth-60, KScreenHeight-60, 40, 40) title:nil imageName:@"jia"];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    if (_isOthers) {
        btn.hidden = YES;
        self.title = @"Ta的学车日志";
    }
    
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [_tableView registerNib:[UINib nibWithNibName:@"JournalCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 120;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}


- (void)btnClick:(UIButton *)btn{
    JournalRecoderController *vc = [[JournalRecoderController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//设置头部视图
- (void)createHeaderView
{
    if (!_isOthers) {
        _dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]];
    }
    //背景图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
    imageView.image = [UIImage imageNamed:@"test_record_bg"];
    imageView.clipsToBounds = YES;
    //头像
    UIImageView *headView = [UIImageView new];
    NSString *str = _dict[@"headimg"];
    if (str.length == 0) {
        headView.image = [UIImage imageNamed:@"f0"];
    }else{
        [headView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"f0"]];
    }
    headView.layer.cornerRadius = 30;
    headView.layer.masksToBounds = YES;
    [imageView addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView).offset(20);
        make.centerY.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    //用户名
    UILabel *nameLabel = [MyControl labelWithTitle:_dict[@"nickname"] fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:17 numberOfLine:1];
    nameLabel.textColor = KColorSystem;
    [imageView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).offset(10);
        make.top.equalTo(headView);
        make.height.mas_equalTo(20);
    }];
    
    //性别
    UIImageView *sexView = [UIImageView new];
    NSString *imgStr = @"";
    if ([_dict[@"sex"] integerValue] == 1) {
        imgStr = @"user_sex_male";
    }else if ([_dict[@"sex"] integerValue] == 2){
        imgStr = @"user_sex_female";
    }
    sexView.image = [UIImage imageNamed:imgStr];
    [imageView addSubview:sexView];
    
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.left.equalTo(nameLabel.mas_right).offset(20);
        make.height.width.mas_equalTo(20);
    }];
    _tableView.tableHeaderView = imageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JournalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDetailViewController *vc = [[TopicDetailViewController alloc]init];
    JournalModel *model = _dataArray[indexPath.row];
    vc.pid = model.pid;
    vc.isOthers = _isOthers;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-----JournalDelegate
- (void)changFavoriteNum:(BOOL)add pid:(NSString *)pid{
    NSString *urlStr;
    
    if (add) {
        urlStr = KUrlFavAdd;
    }else{
        urlStr = KUrlFavDel;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"token":[DefaultManager getValueOfKey:@"token"],@"id":pid} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlPut urlString:urlStr parameters:str sucBlock:^(id responseObject) {
    } failBlock:^{
        
    }];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
