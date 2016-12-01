//
//  ChangeCityController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/22.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ChangeCityController.h"

@interface ChangeCityController ()<UISearchResultsUpdating>
{
    UISearchController *_searchCtrl;//搜索栏
    NSMutableArray *_resultArray;
    NSMutableArray *_hotArray;
    NSInteger _line;
    NSMutableArray *_indexArray;
}
@end

@implementation ChangeCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self createUI];
}

- (void)requestData{
    
    _hotArray = [[NSMutableArray alloc]init];
    _resultArray = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path];
    NSMutableArray *listArr = [[NSMutableArray alloc]init];
    //一级城市
    for (NSDictionary *dict in array) {
        if ([dict[@"verify"]integerValue] == 1) {
            [listArr addObject:dict];
        }
    }
    
    //按首字母排序
    for (int i = 0; i < listArr.count; i++) {
        for (int j = 0; j < listArr.count-i-1; j++) {
            NSDictionary *dict1 = listArr[j];
            NSDictionary *dict2 = listArr[j+1];
            if ([dict1[@"py"] characterAtIndex:0] > [dict2[@"py"] characterAtIndex:0]) {
                [listArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    
    //热门城市
    for (NSDictionary *dict in listArr) {
        if ([dict[@"hot"]integerValue] == 1) {
            [_hotArray addObject:dict];
        }
    }
    
    //首字母检索
    _indexArray = [[NSMutableArray alloc]init];
    [_indexArray addObject:UITableViewIndexSearch];
    for (int i = 'A'; i <= 'Z'; i++) {
        if (i != 'U' && i != 'V' && i != 'I' && i != 'O') {
            [_indexArray addObject:[NSString stringWithFormat:@"%c",i]];
        }
    }
    
    //按首字母排序
    for (char ch = 'a'; ch <= 'z' ; ch++) {
        
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in listArr) {
            if ([dict[@"py"]characterAtIndex:0] == ch) {
                [arr addObject:dict];
            }
        }
        if (arr.count > 0) {
            
            [_dataArray addObject:arr];
        }
        
    }
    
    if (_hotArray.count%3 == 0) {
        _line = _hotArray.count/3;
    }else{
        _line = _hotArray.count/3+1;
    }
    
    
}

- (void)createUI{
    
    self.title = @"切换城市";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [MyControl setExtraCellLineHidden:_tableView];
    [self.view addSubview:_tableView];
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 90)];
    headView.backgroundColor = [UIColor whiteColor];
    
    _searchCtrl = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchCtrl.searchBar.frame = CGRectMake(0, 0, KScreenWidth, 40);
    _searchCtrl.searchBar.barTintColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    _searchCtrl.searchBar.placeholder = @"请输入城市名或拼音查询";
    [_searchCtrl.searchBar sizeToFit];
    _searchCtrl.hidesNavigationBarDuringPresentation = YES;
    _searchCtrl.dimsBackgroundDuringPresentation = NO;
    _searchCtrl.searchResultsUpdater = self;
    [headView addSubview:_searchCtrl.searchBar];
    
    UILabel *label = [MyControl labelWithTitle:@"当前定位城市" fram:CGRectMake(10, 60, 200, 20) fontOfSize:14];
    [headView addSubview:label];
    
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:[DefaultManager getValueOfKey:@"currentCity"] imageName:nil tag:10];
    [btn setTitleColor:KColorSystem forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.right.equalTo(headView).offset(-60);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"driving_location"]];
    [headView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.right.equalTo(btn.mas_left).offset(-10);
        make.height.with.mas_equalTo(15);
    }];
    
    _tableView.tableHeaderView = headView;
    _tableView.sectionIndexColor = [UIColor grayColor];
    _tableView.sectionIndexMinimumDisplayRowCount = 10;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_searchCtrl.isActive) {
        return 1;
    }
    return _indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_searchCtrl.isActive) {
        return _resultArray.count;
    }
    if (section == 0) {
        return 1;
    }
    return [_dataArray[section-1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ide = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
    }
    
    if (_searchCtrl.isActive) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        cell.textLabel.text = _resultArray[indexPath.row][@"areaname"];
    }else if (indexPath.section == 0){
        
        CGFloat width = (KScreenWidth-50)/3;
        UIView *hotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40*_line)];
        hotView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < _hotArray.count; i++) {
            
            UIButton *btn = [MyControl buttonWithFram:CGRectMake(10+(width+10)*(i%3), 10+40*(i/3), width, 30) title:_hotArray[i][@"areaname"] imageName:nil tag:100+i];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.cornerRadius = 5;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [hotView addSubview:btn];
        }
        [cell.contentView addSubview:hotView];
        
    }else {
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        NSDictionary *dict = _dataArray[indexPath.section-1][indexPath.row];
        cell.textLabel.text = dict[@"areaname"];
    }
    return cell;
}

- (void)btnClick:(UIButton *)btn{
    
    NSInteger i = btn.tag-100;
    if (_isInfo) {
        [self.infoDelegate changeCityInfo:@[_hotArray[i][@"id"],_hotArray[i][@"areaname"]]];
    }else{
        [self.delegate changeCityName:btn.currentTitle];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (!_searchCtrl.active) {
        if (indexPath.section == 0) {
            return;
        }
        if (_isInfo) {
            [self.infoDelegate changeCityInfo:@[_dataArray[indexPath.section-1][indexPath.row][@"id"],_dataArray[indexPath.section-1][indexPath.row][@"areaname"]]];
        }else{
            [self.delegate changeCityName:_dataArray[indexPath.section-1][indexPath.row][@"areaname"]];
        }
        
    }else{
        
        if (_isInfo) {
            [self.infoDelegate changeCityInfo:@[_resultArray[indexPath.row][@"id"],_resultArray[indexPath.row][@"areaname"]]];
        }else{
            [self.delegate changeCityName:_resultArray[indexPath.row][@"areaname"]];
        }
        _searchCtrl.active = NO;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *str;
    
    if (_searchCtrl.isActive) {
        str =  @"  搜索到下列城市";
    }else if (section == 0) {
        str =  @"  热门城市";
    }else{
        str = [NSString stringWithFormat:@"     %@",_indexArray[section]];
    }
    
    UILabel *label = [MyControl labelWithTitle:str fram:CGRectMake(0, 0, KScreenWidth, 20) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    return label;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (_searchCtrl.isActive) {
        return @"搜索到下列城市";
    }
    if (section == 0) {
        return @"热门城市";
    }
    
    return _indexArray[section];
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    if (_searchCtrl.isActive) {
        return nil;
    }
    return _indexArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_searchCtrl.active) {
        return 40;
    }else if (indexPath.section == 0) {
        return _line*40+10;
    }else{
        return 40;
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [_resultArray removeAllObjects];
    NSString *putStr = searchController.searchBar.text;
    NSInteger length = putStr.length;
    if (length == 0) {
        [_tableView reloadData];
        return;
    }
    for (NSArray *array in _dataArray) {
        
        for (NSDictionary *dict in array) {
            if ([putStr isEqualToString:[dict[@"areaname"] substringToIndex:length]]) {
                [_resultArray addObject:dict];
            }
        }
        
    }
    [_tableView reloadData];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
