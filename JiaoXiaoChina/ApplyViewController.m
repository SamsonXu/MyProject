//
//  ApplyViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/20.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ApplyViewController.h"
#import "NewsCenterController.h"
#import "ChangeCityController.h"
#import "ClassDetailController.h"
#import "DriveDetailController.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "ApplyCell.h"
#import "ClassCell.h"
#import "LimitSaleView.h"
#import "LimitSaleController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface ApplyViewController ()<CLLocationManagerDelegate,ChangeCityDelegate,LimitSaleViewDelegate>
{   //定位
    CLLocationManager *_locationManager;
    //滚动视图
    UIScrollView *_scrollView;
    //分页视图
    UIPageControl *_pageControl;
    //广告页数
    NSInteger _adverNum;
    //分页定时器
    NSTimer *_timer;
    //排序方式
    NSInteger _type;
    //当前城市Id
    NSString *_cityId;
    //当前经纬度
    NSString *_latitude;
    NSString *_longitude;
    //定位次数
    NSInteger _locatNum;
    //当前页数
    NSInteger _urlPage;
    //总页数
    NSInteger _totlePage;
    //广告源数组
    NSMutableArray *_advArray;
    //班型数据源数组
    NSMutableArray *_classArray;
    //限时特惠数据
    NSMutableArray *_limitSaleArray;
    //头部视图
    UIView *_headView;
    //优惠时间
    NSString *_time;
    //现金券
    UIView *_cashView;
}
@end

@implementation ApplyViewController

- (void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    _type = 0;
    _locatNum = 0;
    _urlPage = 1;
    _totlePage = _urlPage+1;
    _advArray = [[NSMutableArray alloc]init];
    _classArray = [[NSMutableArray alloc]init];
    _limitSaleArray = [[NSMutableArray alloc]init];
    [self createUI];
}

- (void)requestData{
    
    if (_urlPage >= _totlePage) {
        [_tableView.footer endRefreshing];
        return ;
    }
    [MBProgressHUD showMessage:@"正在加载"];
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlAdver1 parameters:@{@"cityid":_cityId,@"id":@"73"} sucBlock:^(id responseObject) {
        [MBProgressHUD hideHUD];
        _adverNum = [responseObject[@"count"] integerValue];
        _advArray = responseObject[@"data"];
        [self createHeadView];
    } failBlock:^{
        [MBProgressHUD hideHUD];
    }];
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlXSYH parameters:@{@"cityid":_cityId} sucBlock:^(id responseObject) {
        [MBProgressHUD hideHUD];
        [_limitSaleArray removeAllObjects];
        
        if ([responseObject[@"status"] integerValue]== 1) {
            _limitSaleArray = [ClassModel arrayOfModelsFromDictionaries:responseObject[@"volist"]];
            _time = responseObject[@"data"][@"end_time"];
        }
    } failBlock:^{
        [MBProgressHUD hideHUD];
    }];
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlSchool parameters:@{@"cityid":_cityId,@"longitude":[NSString stringWithFormat:@"%@",_longitude],@"latitude":[NSString stringWithFormat:@"%@",_latitude],@"type":[NSString stringWithFormat:@"%ld",_type],@"p":[NSString stringWithFormat:@"%ld",_urlPage]} sucBlock:^(id responseObject) {
        [MBProgressHUD hideHUD];
        _totlePage = [responseObject[@"totalPages"] integerValue];
        [_tableView.footer endRefreshing];
        
        if (_urlPage == 1) {
            [_dataArray removeAllObjects];
            [_classArray removeAllObjects];
        }
        NSArray *array = responseObject[@"data"];
        
        for (NSDictionary *dict in array) {
            ApplyModel *model = [[ApplyModel alloc]initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
            NSArray *listArr = [ClassModel arrayOfModelsFromDictionaries:dict[@"class_list"]];
            [_classArray addObject:listArr];
        }
        [_tableView reloadData];
        
    } failBlock:^{
        [MBProgressHUD hideHUD];
        [_tableView.footer endRefreshing];
    }];
}

- (void)createUI{
    
    [self createNavView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [MyControl setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    _cashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _cashView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    _cashView.hidden = YES;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:_cashView];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.51jiaxiao.com/Public/redpack_01.png"]]];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [_cashView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cashView).offset(-20);
        make.centerX.equalTo(_cashView);
        make.size.mas_equalTo(CGSizeMake(300, 205));
    }];
    
    UIButton *btn1 = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:nil imageName:@"hb2" tag:101];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cashView addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(180, 53));
    }];
    
    
    UIButton *btn2 = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:nil imageName:@"close_02" tag:102];
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cashView addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(-40);
        make.top.equalTo(imageView);
        make.height.width.mas_equalTo(30);
    }];
    
    [DefaultManager removeValueOfKey:@"currentCity"];
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.distanceFilter = 100;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
        [self addRefreshHasHeader:NO hasFooter:YES];

}

- (void)createHeadView{
    
    [_headView removeFromSuperview];
    [_timer invalidate];
    CGFloat y;
    if (_limitSaleArray.count > 0) {
        y = 465;
    }else{
        y = 255;
    }
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, y)];
    _headView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _tableView.tableHeaderView = _headView;
    //滚动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_headView addSubview:_scrollView];
    
    for (int i = 0; i < _advArray.count+1; i++) {
        
        UIImageView *imageView = [MyControl imageViewWithFram:CGRectMake(KScreenWidth*i, 0, KScreenWidth, 120) url:_advArray[i%_advArray.count][@"imgurl"]];
        imageView.tag = 200+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    
    _scrollView.userInteractionEnabled = YES;
    _scrollView.contentSize = CGSizeMake(KScreenWidth*_adverNum, 120);
    _scrollView.delegate = self;
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(100, 100, 170, 10)];
    //设置总页数
    _pageControl.numberOfPages=_adverNum;
    
    //设置当前显示的页码
    _pageControl.currentPage=0;
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor grayColor];
    //设置当前页码的指示颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [_headView addSubview:_pageControl];
    
    _currentPage = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(loopScroll) userInfo:nil repeats:YES];
    

    LimitSaleView *saleView;
    if (_limitSaleArray.count > 0) {
        
        saleView = [[LimitSaleView alloc]initWithFrame:CGRectMake(0, 130, KScreenWidth, 200)model:_limitSaleArray[0] time:_time] ;
        saleView.delegate = self;
    }else{
        saleView = [[LimitSaleView alloc]initWithFrame:CGRectMake(0, 130, 0, 0)];
    }
    [_headView addSubview:saleView];

    KWS(ws);
    NSArray *images = @[@"bmlc",@"xclc",@"fwbz",@"cjwt"];
    NSArray *titles = @[@"报名流程",@"学车流程",@"服务保障",@"常见问题"];

    CGFloat width = KScreenWidth/images.count;
    UIButton *lastBtn = nil;
    for (int i = 0; i < images.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:btn];
        //一排按钮
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (!lastBtn) {
                    make.left.equalTo(ws.view);
                }else{
                    make.left.equalTo(lastBtn.mas_right);
                }
                if (_limitSaleArray.count > 0) {
                    make.top.equalTo(saleView.mas_bottom).offset(10);
                }else{
                   make.top.equalTo(saleView.mas_bottom);
                }
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(65);
            }];
        //按钮内容

        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:images[i]]];
        [btn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(btn).offset(10);
            make.height.width.mas_equalTo(20);
        }];

        UILabel *titleLabel = [MyControl labelWithTitle:titles[i] fram:CGRectMake(0, 0, 0, 0) fontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(btn);
        }];
        lastBtn = btn;
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor lightGrayColor];
    [_headView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastBtn.mas_bottom).offset(10);
        make.left.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, 40));
    }];
    
    NSArray *headtitles = @[@"距离近",@"价格低",@"人气高",@"口碑好"];
    for (int i = 0; i < 4; i++) {
        
        UIButton *btn = [MyControl buttonWithFram:CGRectMake((width)*i, 0, width, 40) title:headtitles[i] imageName:nil tag:100+i];
        [btn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:KColorSystem forState:UIControlStateSelected];
        if (i == _type-1) {
            btn.selected = YES;
        }
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:btn];
    }
}

- (void)headBtnClick:(UIButton *)btn{
    
    NSArray *urlArr = @[KUrlApply1,KUrlApply2,KUrlApply3,KUrlApply4];
    NSInteger index = btn.tag - 200;
    WebViewController *vc = [[WebViewController alloc]init];
    vc.url = urlArr[index];
    UILabel *label = btn.subviews[1];
    vc.navTitle = label.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sortBtnClick:(UIButton *)btn{

    _type = btn.tag-100+1;
    _urlPage = 1;
    [self requestData];
}

- (void)loadMore{
    _urlPage++;
    [self requestData];
}

//定时器调用方法，自动滚动
- (void)loopScroll{
    
    if(_currentPage<_adverNum){
        _currentPage++;
        //设置滚动视图的内容偏移值(显示下一页)
        [_scrollView setContentOffset:CGPointMake(_currentPage*KScreenWidth, 0) animated:YES];
    }else if(_currentPage==_adverNum){
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        _currentPage=1;
        [_scrollView setContentOffset:CGPointMake(_currentPage*KScreenWidth, 0) animated:YES];
    }
    _pageControl.currentPage=_currentPage%_adverNum;
}

//滚动视图上图片触摸事件
- (void)tapClick:(UITapGestureRecognizer *)tap{
    
    NSInteger index = tap.view.tag-200;
    index = index%_adverNum;
    WebViewController *vc = [[WebViewController alloc]init];
    vc.navTitle = _advArray[index][@"imgtitle"];
    vc.url = _advArray[index][@"imglink"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-----scrollView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //根据偏移值计算出当前显示的界面所在的页码
    _currentPage=scrollView.contentOffset.x/KScreenWidth;
    _pageControl.currentPage=_currentPage%_adverNum;
    
    //当显示第4张图片(与第1张图片一样)时，快速切回显示第1张图片(不能加动画)
    if(_currentPage==_adverNum+1){
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y > 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else {
        if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)createNavView{
    
    //当前城市按钮
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 100, 40) title:nil imageName:nil tag:100];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [MyControl labelWithTitle:@"正在定位" fram:CGRectMake(0, 0, 0, 0) color:[UIColor whiteColor] fontOfSize:17 numberOfLine:1];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"locat"]];
    [btn addSubview:label];
    [btn addSubview:imageView];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(btn);
        make.height.mas_equalTo(30);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.centerY.equalTo(label);
        make.height.width.mas_equalTo(10);
    }];
    self.navigationItem.titleView = btn;
    
    //左边按钮
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(0, 0, 40, 40);
    
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 5, 20)];
    leftView.image = [UIImage imageNamed:@"navigationbar_icon_menu"];
    [leftbtn addSubview:leftView];
    
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    headView.layer.cornerRadius = 15;
    headView.layer.masksToBounds = YES;
    [leftbtn addSubview:headView];
    [leftbtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    
    if (![DefaultManager getValueOfKey:@"token"]) {
        
        headView.image = [UIImage imageNamed:@"driving_header"];
    }else{
        
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    if ([dict[@"headimg"] length] == 0) {
        headView.image = [UIImage imageNamed:@"f0"];
    }else{
        
        UIImage *image = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selfPhoto.jpg"]];
        headView.image = image;
    }
    }
    [self addBtnWithTitle:nil imageName:@"hb" navBtn:KNavBarRight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_classArray[section] count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ide1 = @"applyCell";
    static NSString *ide2 = @"classCell";
    
    if (indexPath.row == 0) {
        
        ApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ide1];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ApplyCell" owner:self options:nil][0];
        }
        cell.model = _dataArray[indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        
        ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:ide2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ClassCell" owner:self options:nil][0];
        }
        
        if ([_classArray[indexPath.section] count] > 0) {
            ClassModel *model = _classArray[indexPath.section][indexPath.row-1];
            cell.model = model;
            if (model.is_payment_type.integerValue != 2) {
                cell.yufuLabel.hidden = YES;
                cell.yufuImageView.hidden = YES;
            }
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 100;
    }else{
        ClassModel *model = _classArray[indexPath.section][indexPath.row-1];
        if (model.onead.length > 0 && model.label_str.length > 0) {
            return 150;
        }else if (model.onead.length > 0 || model.label_str.length > 0){
            return 120;
        }else{
            return 80;
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        DriveDetailController *vc = [[DriveDetailController alloc]init];
        vc.model = _dataArray[indexPath.section];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        ClassDetailController *vc = [[ClassDetailController alloc]init];
        vc.model = _classArray[indexPath.section][indexPath.row-1];
        vc.latitude = _latitude;
        vc.longitude = _longitude;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)headerBtnClick:(UIButton *)btn{
    
    if (_tableView.contentOffset.y > 300) {
        _tableView.contentOffset = CGPointMake(0, 300);
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations firstObject];
    
    if (_locatNum > 0) {
        return;
    }
    _locatNum++;
    CLLocationCoordinate2D cl2D = location.coordinate;
    _latitude = [NSString stringWithFormat:@"%lf",cl2D.latitude];
    _longitude = [NSString stringWithFormat:@"%lf",cl2D.longitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark=[placemarks firstObject];
        UIButton *btn = (UIButton *)self.navigationItem.titleView;
        UILabel *label = btn.subviews[0];
        UIImageView *imageView = btn.subviews[1];
        
        if (!error) {
            NSString *str = placemark.addressDictionary[@"City"];
            NSString *cityStr = [str substringToIndex:str.length-1];
            label.text = cityStr;
            [DefaultManager addValue:cityStr key:@"currentCity"];
            imageView.image = [UIImage imageNamed:@"navigationbar_arrow_down"];
            NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
            NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path];
            for (NSDictionary *dict in array) {
                if ([dict[@"areaname"] isEqualToString:cityStr]) {
                    _cityId = dict[@"id"];
                }
            }
            [self requestData];
        }else{
            label.text = @"定位失败";
        }
    }];
    
}

- (void)btnClick:(UIButton *)btn{
    
    NSInteger index = btn.tag-100;
    if (index == 0) {
        
        ChangeCityController *vc = [[ChangeCityController alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1) {
        
        [UIView animateWithDuration:1 animations:^{
            _cashView.hidden = YES;
        }];
        if ([DefaultManager getValueOfKey:@"token"]) {
            WebViewController *vc = [[WebViewController alloc]init];
            vc.navTitle = @"学车现金券";
            vc.url = [NSString stringWithFormat:@"%@?token=%@",KUrlCash,[DefaultManager getValueOfKey:@"token"]];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (index == 2){
        [UIView animateWithDuration:1 animations:^{
            _cashView.hidden = YES;
        }];
    }
}

- (void)changeCityName:(NSString *)name{
    
    UIButton *btn = (UIButton *)self.navigationItem.titleView;
    UILabel *label = btn.subviews[0];
    label.text = name;
    label.font = [UIFont boldSystemFontOfSize:17];
    
    UIImageView *imageView = btn.subviews[1];
    imageView.image = [UIImage imageNamed:@"navigationbar_arrow_down"];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path];
    for (NSDictionary *dict in array) {
        if ([dict[@"areaname"] isEqualToString:name]) {
            _cityId = dict[@"id"];
        }
    }
    _urlPage = 1;
    _type = 0;
    _tableView.contentOffset = CGPointMake(0, 0);
    [self requestData];
}

- (void)doPushWithTime:(CGFloat)time{
    
    LimitSaleController *vc = [[LimitSaleController alloc]init];
    vc.time = time;
    vc.classArray = _limitSaleArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftClick:(UIButton *)btn{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)rightClick:(UIButton *)btn{
    _cashView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
