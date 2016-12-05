//
//  YCLeftViewController.m
//  YCW
//
//  Created by apple on 15/12/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LeftScrollViewController.h"
#import "NewsCenterController.h"
#import "SettingViewController.h"
#import "OrderViewController.h"
#import "CashViewController.h"
#import "LoginViewController.h"
#import "MyViewController.h"
#import "MyCell.h"
@interface LeftScrollViewController ()<UITableViewDataSource, UITableViewDelegate,UMSocialUIDelegate>
{
    NSArray *_imageArr;
    UIImageView *_headImageView;//头像
    UILabel *_nameLabel;//昵称
}
@property (nonatomic, copy) NSArray *lefs;
@property (nonatomic, assign) NSInteger previousRow;



@end

@implementation LeftScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _imageArr = @[@"applyorder",@"cash",@"news",@"share"];
    _lefs = @[@"报名订单", @"学车现金券", @"消息中心", @"呼朋唤友"];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 200, KScreenWidth*0.7, KScreenHeight-200);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
    _tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUserInfo) name:@"updateUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoff) name:@"logoff" object:nil];
    [self createHeaderView];
    [self createFootView];
}

- (void)logoff{
    self.hasLogin = NO;
    _headImageView.image = [UIImage imageNamed:@"driving_header"];
    _nameLabel.text = @"点击登录";
    _nameLabel.textColor = KColorSystem;
}

- (void)changeUserInfo{
    self.hasLogin = YES;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]];
    NSString *str = dict[@"headimg"];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
    _nameLabel.text = dict[@"nickname"];
    _nameLabel.textColor = [UIColor blackColor];
}

//设置头部视图
- (void)createHeaderView
{
    //头部视图
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, _tableView.frame.size.width, 200) title:nil imageName:nil tag:10];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *infoDict =  [defaults objectForKey:@"userInfo"];
    
    //头像
    _headImageView = [UIImageView new];
    _headImageView.tag = 50;
    _headImageView.layer.cornerRadius = 35;
    _headImageView.layer.masksToBounds = YES;
    [btn addSubview:_headImageView];
    
    //用户名
    _nameLabel = [MyControl labelWithTitle:@"点击登录" fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:17 numberOfLine:1];
    _nameLabel.tag = 51;
    [btn addSubview:_nameLabel];
    
    UIImage *image = [UIImage imageNamed:@"driving_header"];
    if (self.hasLogin) {
        _nameLabel.text = infoDict[@"nickname"];
        _nameLabel.textColor = [UIColor blackColor];
//        UIImage *image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selfPhoto.jpg"]];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:infoDict[@"headImage"]] placeholderImage:image];
    }else{
        _nameLabel.text = @"点击登录";
        _nameLabel.textColor = KColorSystem;
        _headImageView.image = image;
    }
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.centerY.equalTo(btn).offset(20);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(_headImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
//    [defaults addObserver:self forKeyPath:@"userInfo" options:NSKeyValueObservingOptionNew context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    
//    if (![DefaultManager getValueOfKey:keyPath]) {
//        self.hasLogin = NO;
//        UIImageView *imageView = [self.view viewWithTag:50];
//        UILabel *label = [self.view viewWithTag:51];
//        label.text = @"点击登录";
//        label.textColor = KColorSystem;
//        imageView.image = [UIImage imageNamed:@"driving_header"];
//    }else{
//        self.hasLogin = YES;
//        UIImageView *imageView = [self.view viewWithTag:50];
//        imageView.image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selfphoto.jpg"]];
//        UILabel *label = [self.view viewWithTag:51];
//        label.text = change[@"new"][@"nickname"];
//        label.textColor = [UIColor blackColor];
//    }
//    [_tableView reloadData];
//}

- (void)createFootView{
    
    NSString *title;
    NSString *image;
    NSString *str = [DefaultManager getValueOfKey:@"nightModel"];
    
    if ([str isEqualToString:@"yes"]) {
        title = @"日间";
        image = @"day";
    }else {
        title = @"夜间";
        image = @"night";
    }
    NSArray *titles = @[@"设置",title];
    NSArray *images = @[@"sidemenu_icon_settings",image];
    CGFloat width = _tableView.frame.size.width/2;
    
    for (int i = 0; i < titles.count; i++) {
        
        UIButton *btn = [MyControl buttonWithFram:CGRectMake(width*i, KScreenHeight-40, width, 40) title:nil imageName:nil tag:100+i];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:images[i]]];
        [btn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn).offset(-20);
            make.centerY.equalTo(btn);
            make.height.width.mas_equalTo(20);
        }];
        
        UILabel *label = [MyControl labelWithTitle:titles[i] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
        [btn addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn).offset(20);
            make.centerY.equalTo(btn);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(60);
        }];
    }
}

- (void)btnClick:(UIButton *)btn{
    NSInteger index = btn.tag;
    
        if (index == 10) {
            
            if (self.hasLogin) {
            MyViewController *vc = [[MyViewController alloc]init];
                vc.isScroll = YES;
            UIViewController *center = [[UINavigationController alloc]initWithRootViewController:vc];
            [self.sideMenuViewController setContentViewController:center animated:YES];
            [self.sideMenuViewController hideMenuViewController];
                
            }else{
                LoginViewController *vc = [[LoginViewController alloc]init];
                UIViewController *center = [[UINavigationController alloc]initWithRootViewController:vc];
                [self.sideMenuViewController setContentViewController:center animated:YES];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
    
    if (index == 100) {
        
        SettingViewController *vc = [[SettingViewController alloc]init];
        vc.hasLogin = self.hasLogin;
        UIViewController *center = [[UINavigationController alloc]initWithRootViewController:vc];
        [self.sideMenuViewController setContentViewController:center animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }else if (index == 101){
        
        NSString *str = [DefaultManager getValueOfKey:@"nightModel"];
        UIImageView *imageView = btn.subviews[0];
        UILabel *label = btn.subviews[1];
        
        if ([str isEqualToString:@"no"]) {
            
            str = @"yes";
            [DefaultManager addValue:str key:@"nightModel"];
            imageView.image = [UIImage imageNamed:@"day"];
            label.text = @"日间";
            
        }else if ([str isEqualToString:@"yes"]){
            
            str = @"no";
            [DefaultManager addValue:str key:@"nightModel"];
            imageView.image = [UIImage imageNamed:@"night"];
            label.text = @"夜间";
        }
       
    }
}

//设置状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lefs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ide = @"myCell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    cell.myCellLabel.text = _lefs[indexPath.row];
    cell.myCellLabel.font = [UIFont systemFontOfSize:14];
    cell.myCellImageView.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *center;
    
    if (indexPath.row < 3) {
        if (self.hasLogin == YES) {
            if (indexPath.row == 0) {
                
                OrderViewController *vc = [[OrderViewController alloc]init];
                center = [[UINavigationController alloc]initWithRootViewController:vc];
            }else if(indexPath.row == 1){
                
                CashViewController *service = [[CashViewController alloc ] init];
                center = [[UINavigationController alloc] initWithRootViewController:service];
            }else if(indexPath.row == 2){
                
                NewsCenterController *feedback = [[NewsCenterController alloc ] init];
                center = [[UINavigationController alloc] initWithRootViewController:feedback];
            }
        }else if (self.hasLogin == NO){
            LoginViewController *vc = [[LoginViewController alloc]init];
            center = [[UINavigationController alloc]initWithRootViewController:vc];
        }
        
        [self.sideMenuViewController setContentViewController:center animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }else if (indexPath.row == 3){

        NSString *url = @"http://itunes.com/apps/Samson.JiaxiaoChina";
        [UMSocialData defaultData].extConfig.title = @"最近发现一款非常棒的驾考软件，快来和我一起酷玩吧！";
        [UMSocialData defaultData].extConfig.qqData.url = url;
        [UMSocialData defaultData].extConfig.qzoneData.url = url;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        [UMSocialSnsService presentSnsIconSheetView:self.sideMenuViewController appKey:@"574d354067e58e201d0003dd"
                                          shareText:@"最近发现一款非常棒的驾考软件，快来和我一起酷玩吧！"
                                         shareImage:[UIImage imageNamed:@"icon"]
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                           delegate:self];
    }
        self.previousRow = indexPath.row;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
