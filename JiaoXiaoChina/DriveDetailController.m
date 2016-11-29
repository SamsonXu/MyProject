//
//  DriveDetailController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "DriveDetailController.h"
#import "DriveCommentCell.h"
#import "WebViewController.h"
#import "CommentListController.h"
#import "ClassDetailController.h"
@interface DriveDetailController ()
{
    NSMutableArray *_classArray;
    NSMutableArray *_commentArray;
    NSString *_commentNum;
}
@end

@implementation DriveDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _classArray = [[NSMutableArray alloc]init];
    _commentArray = [[NSMutableArray alloc]init];
    [self requestData];
    [self createUI];
}

- (void)requestData{

    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlClassList parameters:@{@"id":_model.pid} sucBlock:^(id responseObject) {

        _classArray = [ClassModel arrayOfModelsFromDictionaries:responseObject[@"data"]];
        [_tableView reloadData];
    } failBlock:^{
        
    }];
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlCommentList parameters:@{@"id":_model.pid} sucBlock:^(id responseObject) {

        _commentNum = responseObject[@"totalRows"];
        _commentArray = [DrivCommentModel arrayOfModelsFromDictionaries:responseObject[@"volist"]];
        [_tableView reloadData];
    } failBlock:^{
        
    }];
}

- (void)createUI{
    [super createUI];
    self.title = @"驾校详情";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self addBtnWithTitle:nil imageName:@"navigationbar_icon_share" navBtn:KNavBarRight];
    _tableView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-40);
    NSArray *images = @[@"",@""];
    NSArray *titles = @[@"驾校详情",@"电话咨询"];
    for (int i = 0; i < images.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KScreenWidth/2*i, KScreenHeight-40, KScreenWidth/2, 40);
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:images[i]]];
        [btn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(btn).offset(30);
            make.height.width.mas_equalTo(20);
        }];
        
        UILabel *label = [MyControl labelWithTitle:titles[i] fram:CGRectMake(0, 0, 0, 0) color:KColorSystem fontOfSize:14 numberOfLine:1];
        [btn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(imageView.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return _classArray.count;
    }else {
        if (_commentArray.count < 3) {
            return _commentArray.count;
        }else{
            return 3;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ide1 = @"applyCell";
    static NSString *ide2 = @"classCell";
    static NSString *ide3 = @"DriveCommentCell";
    
    if (indexPath.section == 0) {
        
        ApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ide1];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ApplyCell" owner:self options:nil][0];
        }
        cell.model = _model;
        cell.countLabel.text = [NSString stringWithFormat:@"评论人数%@人",_model.plnum];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 1){
        
        ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:ide2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ClassCell" owner:self options:nil][0];
        }
        ClassModel *model = _classArray[indexPath.row];
        cell.model = model;
        if (model.is_payment_type.integerValue != 2) {
            cell.yufuLabel.hidden = YES;
            cell.yufuImageView.hidden = YES;
        }
        return cell;
    }else if (indexPath.section == 2){
        
        DriveCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ide3];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"DriveCommentCell" owner:self options:nil][0];
        }
        cell.model = _commentArray[indexPath.row];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        UILabel *label = [MyControl labelWithTitle:[NSString stringWithFormat:@"学员评价(%ld)",0+_commentNum.integerValue] fram:CGRectMake(0, 10, KScreenWidth, 20) fontOfSize:14];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    if (section == 1) {
        return 10;
    }
    if (section == 2) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label1 = [MyControl labelWithTitle:[NSString stringWithFormat:@"已有%@人报名",_model.order_num] fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
        [view addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(10);
            make.height.mas_equalTo(20);
        }];
        return view;
    }else if (section == 2){
        
        if (_commentArray.count > 3) {
            UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, KScreenWidth, 30) title:@"查看更多评价" imageName:nil];
            btn.tag = 102;
            btn.backgroundColor = [UIColor whiteColor];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            return btn;
        }
    }
    return nil;
}

- (void)btnClick:(UIButton *)btn{
    
    NSInteger index = btn.tag-100;
    if (index == 0) {
        WebViewController *vc = [[WebViewController alloc]init];
        vc.navTitle = _model.dname;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 1){
        [self showAlertViewWith:@[@"咨询驾校中国专业学车顾问",[NSString stringWithFormat:@"%@",_model.tel],@"取消",@"确定"] sel:@selector(telephone)];
    }else if (index == 2){
        CommentListController *vc = [[CommentListController alloc]init];
        vc.commentArray = _commentArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)telephone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.tel]]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1){
        ClassModel *model = _classArray[indexPath.row];
        if (model.onead.length > 0 && model.label_str.length > 0) {
            return 150;
        }else if (model.onead.length > 0 || model.label_str.length > 0){
            return 120;
        }else{
            return 80;
        }
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        WebViewController *vc = [[WebViewController alloc]init];
        vc.navTitle = _model.dname;
        vc.url = [NSString stringWithFormat:@"%@?id=%@",KUrlDriveDetail,_model.pid];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        
        ClassDetailController *vc = [[ClassDetailController alloc]init];
        vc.model = _classArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    KWS(ws);
    [MyControl UMSocialWithTitle:_model.dname url:[NSString stringWithFormat:@"%@?id=%@",KUrlDriveDetail,_model.pid] ws:ws];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
