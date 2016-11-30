//
//  PayViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PayViewController.h"
#import "CashViewController.h"
#import "OrderViewController.h"
#import "HeadView.h"
#import "PayCell.h"
#import "CashModel.h"
#import "payRequsestHandler.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
@interface PayViewController ()<CashViewCtrlDelegate>
{
    NSInteger _currentCell;
    CashModel *_cashModel;
}
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self createUI];
}

- (void)requestData{
    _dataArray = [NSMutableArray arrayWithArray:@[@{@"image":@"wx",@"title":@"微信支付"},@{@"image":@"zfb",@"title":@"支付宝支付"}]];
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlCashList parameters:@{@"token":[DefaultManager getValueOfKey:@"token"]} sucBlock:^(id responseObject) {
        KMBProgressHide;
        NSArray *array = [CashModel arrayOfModelsFromDictionaries:responseObject[@"data"]];
        NSString *str;
        if (_model.is_payment_type.integerValue == 2) {
            str = _model.yufujin;
        }else{
            str = _model.pric;
        }
        NSMutableArray *modelArr = [[NSMutableArray alloc]init];
        for (CashModel *model in array) {
            if ([model.is_use isEqualToString:@"0"] && [model.is_expire isEqualToString:@"0"] && model.price.integerValue < str.integerValue) {
                [modelArr addObject:model];
            }
        }
        if (modelArr.count > 0) {
            _cashModel = modelArr[0];

            UILabel *label1 = [self.view viewWithTag:10];
            label1.text = [NSString stringWithFormat:@"减%@",_cashModel.price];
            [_tableView reloadData];
            
            UILabel *label2 = [self.view viewWithTag:11];
            label2.text = [NSString stringWithFormat:@"￥%ld",_model.pric.integerValue - _cashModel.price.integerValue];
        }
        
    } failBlock:^{
        KMBProgressHide;
    }];
}

- (void)createUI{
    [super createUI];
    _currentCell = 100;
    self.title = @"确认支付";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    
    UIView *bottmoView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
    bottmoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottmoView];
    UILabel *label1 = [MyControl labelWithTitle:@"现金券" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    [bottmoView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottmoView);
        make.left.equalTo(bottmoView).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *label2 = [MyControl labelWithTitle:@"减0" fram:CGRectMake(0, 0, 0, 0) color:KColorSystem fontOfSize:16 numberOfLine:1];
    label2.tag = 10;
    [bottmoView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottmoView);
        make.left.equalTo(label1.mas_right);
        make.height.equalTo(label1);
    }];
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:@"确认支付" imageName:nil];
    btn.backgroundColor = KColorSystem;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottmoView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(bottmoView);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    UILabel *priceLabel = [MyControl labelWithTitle:[NSString stringWithFormat:@"￥ %@",_model.pric] fram:CGRectMake(0, 0, 0, 0) color:KColorSystem fontOfSize:16 numberOfLine:1];
    priceLabel.tag = 11;
    [bottmoView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottmoView);
        make.right.equalTo(btn.mas_left).offset(-10);
        make.height.equalTo(label1);
    }];
    UILabel *label3 = [MyControl labelWithTitle:@"待支付" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14];
    [bottmoView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottmoView);
        make.right.equalTo(priceLabel.mas_left);
        make.height.equalTo(label1);
    }];
}

- (void)btnClick:(UIButton *)btn{
    if (_currentCell == 100) {
        [self showAlertViewWith:@[@"未选择支付方式",@"确定"] sel:nil];
        return;
    }
    if (_currentCell == 0) {
        if ([WXApi isWXAppInstalled]) {
            if (_isOrder) {
                KMBProgressShow;
                [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlPay3 parameters:@{@"id":_orderId,@"token":[DefaultManager getValueOfKey:@"token"],@"pay_type":@"1"} sucBlock:^(id responseObject) {
                    KMBProgressHide;
//                    NSLog(@"id:%@",_orderId);
//                    NSLog(@"-----%@---%@",responseObject,responseObject[@"msg"]);
                    NSDictionary *wxDict = responseObject[@"data"];
                    //下面的参数让服务端传过来
                    PayReq *request = [[PayReq alloc] init];
                    //商户号，由微信分配
                    request.partnerId = wxDict[@"partnerid"];
                    //预支付交易会话ID，由微信分配
                    request.prepayId= wxDict[@"prepayid"];
                    //扩展字段，目前固定值Sign=WXPay
                    request.package = wxDict[@"package"];
                    //随机字符串
                    request.nonceStr= wxDict[@"noncestr"];
                    //时间戳
                    request.timeStamp= [wxDict[@"timestamp"] intValue];
                    //签名
                    request.sign= wxDict[@"sign"];
                    [WXApi sendReq:request];
                } failBlock:^{
                    KMBProgressHide;
                }];
            }else{
                NSDictionary *dict = @{@"did":_model.did,@"kid":_model.pid,@"mobile":_phoneNum,@"username":_userName,@"token":[NSString stringWithFormat:@"%@",[DefaultManager getValueOfKey:@"token"]],@"pay_type":@"1",@"rid":[NSString stringWithFormat:@"%@",_cashModel.pid]};
                KMBProgressShow;
                [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlPay2 parameters:dict sucBlock:^(id responseObject) {
                    KMBProgressHide;
                    NSDictionary *wxDict = responseObject[@"data"];
                    //下面的参数让服务端传过来
                    PayReq *request = [[PayReq alloc] init];
                    //商户号，由微信分配
                    request.partnerId = wxDict[@"partnerid"];
                    //预支付交易会话ID，由微信分配
                    request.prepayId= wxDict[@"prepayid"];
                    //扩展字段，目前固定值Sign=WXPay
                    request.package = wxDict[@"package"];
                    //随机字符串
                    request.nonceStr= wxDict[@"noncestr"];
                    //时间戳
                    request.timeStamp= [wxDict[@"timestamp"] intValue];
                    //签名
                    request.sign= wxDict[@"sign"];
                    [WXApi sendReq:request];
                    
                } failBlock:^{
                    KMBProgressHide;
                }];

            }
        }else{
            [self showAlertViewWith:@[@"您的设备尚未安装微信",@"确定"] sel:nil];
        }
    }else if (_currentCell == 1){
        
        if (_isOrder) {
            KMBProgressShow;
            [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlPay3 parameters:@{@"id":_orderId,@"token":[DefaultManager getValueOfKey:@"token"],@"pay_type":@"2"} sucBlock:^(id responseObject) {
                KMBProgressHide;
//                NSLog(@"---%@---%@",responseObject,responseObject[@"msg"]);
                
                [[AlipaySDK defaultService] payOrder:responseObject[@"data"] fromScheme:@"jiaxiaochina" callback:^(NSDictionary *resultDic) {

                }];

            } failBlock:^{
                KMBProgressHide;
            }];
        }else{
            NSDictionary *dict = @{@"did":_model.did,@"kid":_model.pid,@"mobile":_phoneNum,@"username":_userName,@"token":[NSString stringWithFormat:@"%@",[DefaultManager getValueOfKey:@"token"]],@"pay_type":@"2",@"rid":[NSString stringWithFormat:@"%@",_cashModel.pid]};
            KMBProgressShow;
            [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlPay2 parameters:dict sucBlock:^(id responseObject) {
                KMBProgressHide;
//                NSLog(@"---%@",responseObject);
                [[AlipaySDK defaultService] payOrder:responseObject[@"data"] fromScheme:@"jiaxiaochina" callback:^(NSDictionary *resultDic) {
//                    NSLog(@"here-----%@",resultDic);
                }];
            } failBlock:^{
                KMBProgressHide;
            }];

        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
    }
    if (indexPath.section == 0) {
        HeadView *vc = [[HeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 70) model:_model];
        [cell.contentView addSubview:vc];
        return cell;
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"我的学车现金券";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"未选择优惠券";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        if (_cashModel.price.length > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"现金券减%@元",_cashModel.price];
            cell.detailTextLabel.textColor = KColorRGB(52, 164, 40);
        }
        return cell;
    }else if (indexPath.section == 2){
        PayCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
        if (!payCell) {
            payCell = [[NSBundle mainBundle]loadNibNamed:@"PayCell" owner:self options:nil][0];
        }
        NSDictionary *dict = _dataArray[indexPath.row];
        payCell.iconImageView.image = [UIImage imageNamed:dict[@"image"]];
        payCell.titleLabel.text = dict[@"title"];
        if (indexPath.row == _currentCell) {
            payCell.rightImageView.image = [UIImage imageNamed:@"ndui"];
        }else{
            payCell.rightImageView.image = [UIImage imageNamed:@"chek"];
        }
        return payCell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UILabel *label = [MyControl boldLabelWithTitle:@"   支付方式" fram:CGRectMake(0, 0, 0, 0) color:[UIColor blackColor] fontOfSize:16];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        return label;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 40;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentCell = indexPath.row;
    if (indexPath.section == 1) {
        CashViewController *vc = [[CashViewController alloc]init];
        vc.isPay = YES;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [_tableView reloadData];
}

- (void)combackInfoWith:(CashModel *)model{
    _cashModel = model;

    UILabel *label = [self.view viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%@元",_cashModel.price];
    [_tableView reloadData];
}

- (void)leftClick:(UIButton *)btn{
    if (!_isOrder) {
        NSDictionary *dict = @{@"did":_model.did,@"kid":_model.pid,@"mobile":_phoneNum,@"username":_userName,@"token":[NSString stringWithFormat:@"%@",[DefaultManager getValueOfKey:@"token"]]};

        [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlPay1 parameters:dict sucBlock:^(id responseObject) {
            
        } failBlock:^{
            
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
