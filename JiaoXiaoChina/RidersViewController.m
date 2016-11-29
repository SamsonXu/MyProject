//
//  RidersViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/23.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RidersViewController.h"
#import "PublishTopicController.h"
#import "RidersTopicController.h"
#import "TopicDetailViewController.h"
#import "LoginViewController.h"
#import "TopicCell.h"
@interface RidersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectView;
    UIPageControl *_pageCtrl;
    NSMutableArray *_collectArr;
    NSArray *_imgList;
    NSInteger _colSection;
    
}
@end

@implementation RidersViewController

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectArr = [[NSMutableArray alloc]init];
    _urlPage = 1;
    _totlePage = _urlPage+1;
    [self requestCate];
    [self requestData];
    [self createUI];
}

- (void)createUI{

    self.title = @"驾考圈";
    [self addBtnWithTitle:nil imageName:@"answer_mode_answer" navBtn:KNavBarRight];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 120;
    [_tableView registerClass:[RiderCellOne class] forCellReuseIdentifier:@"myCell"];
    [self.view addSubview:_tableView];
    [self addRefreshHasHeader:YES hasFooter:YES];
}

- (void)requestCate{
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlRiderCate parameters:nil sucBlock:^(id responseObject) {
        _collectArr = [CateModel arrayOfModelsFromDictionaries:responseObject[@"data"]];
        if (_collectArr.count%4 == 0) {
            _colSection = _collectArr.count/4;
        }else{
            _colSection = _collectArr.count/4+1;
        }

        [self createHeadView];
    } failBlock:^{
        
    }];
}

- (void)requestData{
    if (_urlPage >= _totlePage) {
        [_tableView.footer endRefreshing];
        return ;
    }
    NSDictionary *dict;
    if ([DefaultManager getValueOfKey:@"token"]) {
        dict = @{@"token":[NSString stringWithFormat:@"%@",[DefaultManager getValueOfKey:@"token"]],@"p":[NSString stringWithFormat:@"%ld",_urlPage],@"elite":@"1"};
    }
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlRiders parameters:dict sucBlock:^(id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        _totlePage = [responseObject[@"totalPages"] integerValue];
        if (_urlPage == 1 || _urlPage == 0) {
            [_dataArray removeAllObjects];
            _userNum = [NSString stringWithFormat:@"%@",responseObject[@"wd_user_count"]];
            _topicNum = [NSString stringWithFormat:@"%@",responseObject[@"wd_count"]];
        }
        [self updateNum];
        NSArray *array = [JournalModel arrayOfModelsFromDictionaries:responseObject[@"volist"]];
        [_dataArray addObjectsFromArray:array];
        [_tableView reloadData];
    } failBlock:^{
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

- (void)updateNum{
    UILabel *label1 = [self.view viewWithTag:103];
    label1.text = [NSString stringWithFormat:@"%.2lf万",_userNum.floatValue/10000];
    UILabel *label2 = [self.view viewWithTag:105];
    label2.text = [NSString stringWithFormat:@"%.2lf万",_topicNum.floatValue/10000];;
}

- (void)createHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 171)];
    headView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:titleView];
    UILabel *label1 = [MyControl labelWithTitle:@"考友圈" fram:CGRectMake(0, 0, 0, 0) fontOfSize:17];
    [titleView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(10);
        make.centerY.equalTo(titleView);
        make.height.mas_equalTo(20);
    }];
    UILabel *label2 = [MyControl labelWithTitle:@"考友" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    label2.textColor = [UIColor grayColor];
    [titleView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.left.equalTo(label1.mas_right).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *label3 = [MyControl labelWithTitle:@"" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    label3.tag = 103;
    label3.textColor = KColorRGB(253, 88, 52);
    [titleView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.left.equalTo(label2.mas_right).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *label4 = [MyControl labelWithTitle:@"话题" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    label4.textColor = [UIColor grayColor];
    [titleView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.left.equalTo(label3.mas_right).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *label5 = [MyControl labelWithTitle:@"" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    label5.tag = 105;
    label5.textColor = KColorRGB(253, 88, 52);
    [titleView addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.left.equalTo(label4.mas_right).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake((KScreenWidth-30)/4, 100);
    flow.minimumInteritemSpacing = 0;
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 41, KScreenWidth, 120) collectionViewLayout:flow];
    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.showsHorizontalScrollIndicator = NO;
    _collectView.showsVerticalScrollIndicator = NO;
    _collectView.pagingEnabled = YES;
    [_collectView registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellWithReuseIdentifier:@"myCell"];
    [headView addSubview:_collectView];
    _pageCtrl = [UIPageControl new];
    _pageCtrl.numberOfPages = _colSection;
    _pageCtrl.currentPage = 0;
    _pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
    _pageCtrl.currentPageIndicatorTintColor = KColorSystem;
    [_collectView addSubview:_pageCtrl];
    [_pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];

    _tableView.tableHeaderView = headView;
}

- (void)refresh{
    _urlPage = 1;
    [self requestData];
}

- (void)loadMore{
    _urlPage++;
    [self requestData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RiderCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _dataArray.count;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        UILabel *label = [MyControl labelWithTitle:@"    精选话题" fram:CGRectMake(0, 10, KScreenWidth, 30) fontOfSize:14];
        label.backgroundColor = [UIColor whiteColor];
        return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JournalModel *model = _dataArray[indexPath.row];
    if (model.nickname.length != 0) {
        TopicDetailViewController *vc = [[TopicDetailViewController alloc]init];
        vc.isOthers = YES;
        vc.pid = model.pid;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        return _colSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.model = _collectArr[indexPath.row+indexPath.section*4];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RidersTopicController *vc = [[RidersTopicController alloc]init];
    CateModel *model = _collectArr[indexPath.item + indexPath.section*4];
    vc.cateId = model.pid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = _collectView.contentOffset.x/KScreenWidth;
    _pageCtrl.currentPage = index;
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

- (void)rightClick:(UIButton *)btn{
    PublishTopicController *vc = [[PublishTopicController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

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

- (void)gotoLogin{
    LoginViewController *vc = [[LoginViewController alloc]init];
    vc.isPush = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
