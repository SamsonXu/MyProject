//
//  ConsultViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/19.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ConsultViewController.h"
#import "PayViewController.h"
#import "HeadView.h"
@interface ConsultViewController ()<UITextFieldDelegate>
{
    UITextField *_nameField;
    UITextField *_phoneField;
    UITextField *_codeField;
    NSTimer *_timer;
    NSInteger _time;
}
@end

@implementation ConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)createUI{
    _time = 180;
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.title = @"咨询报名";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    
    //驾校信息
    HeadView *headView = [[HeadView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 70) model:_model];
    [self.view addSubview:headView];
    //学员信息
    UILabel *studentLabel = [MyControl labelWithTitle:@"学员信息" fram:CGRectMake(0, 144, KScreenWidth, 30) fontOfSize:14];
    studentLabel.backgroundColor = [UIColor whiteColor];
    studentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:studentLabel];
    
    NSArray *titles = @[@"学员姓名",@"手机号码",@"验证码"];
    NSArray *plachs = @[@"请输入真实姓名",@"请输入手机号码",@"请输入验证码"];
    
    for (int i = 0; i < titles.count; i++) {
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(0, 175+41*i, KScreenWidth, 40)];
        field.borderStyle = UITextBorderStyleNone;
        field.delegate = self;
        field.placeholder = plachs[i];
        [self.view addSubview:field];
        
        UILabel *label = [MyControl labelWithTitle:titles[i] fram:CGRectMake(0, 0, 80, 20) fontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        field.leftView = label;
        field.leftViewMode = UITextFieldViewModeAlways;
        field.backgroundColor = [UIColor whiteColor];
        field.font = [UIFont systemFontOfSize:14];
        
        if (i == 0) {
            _nameField = field;
        }else if (i == 1){
            _phoneField = field;
        }else if (i == 2){
            
            UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 80, 38) title:@"获取验证码" imageName:nil tag:101];
            [btn setTitleColor:KColorSystem forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            field.rightView = btn;
            field.rightViewMode = UITextFieldViewModeAlways;
            _codeField = field;
        }
    }
    
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(30, 354, KScreenWidth-60, 40) title:@"提 交" imageName:nil tag:100];
    btn.backgroundColor = KColorSystem;
    btn.layer.cornerRadius = 5;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 100) {

            if (_nameField.text.length > 0 && [MyControl isValueToPhoneNumber:_phoneField.text] && _timer) {
                KMBProgressShow;
                [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlConsult2 parameters:@{@"sms_code":_codeField.text,@"mobile_phone":_phoneField.text} sucBlock:^(id responseObject) {
                    KMBProgressHide;
                    if ([responseObject[@"status"] integerValue] == 1) {
                        
                        if (_model.is_payment.integerValue == 0) {
                            NSDictionary *dict = @{@"did":_model.did,@"kid":_model.pid,@"mobile":_phoneField.text,@"username":_nameField.text};
                            [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlPay1 parameters:dict sucBlock:^(id responseObject) {

                                [self showAlertViewWith:@[@"报名成功",@"确定"] sel:nil];
                            } failBlock:^{
                                
                            }];
                        }else{
                            
                            PayViewController *vc = [[PayViewController alloc]init];
                            vc.model = _model;
                            vc.phoneNum = _phoneField.text;
                            vc.userName = _nameField.text;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                       
                    }else{
                        [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
                    }
                } failBlock:^{
                    
                }];
                
            }else{
                
                if (_nameField.text.length == 0) {
                    [self showAlertViewWith:@[@"请输入真实姓名",@"确定"] sel:nil];
                }else if (![MyControl isValueToPhoneNumber:_phoneField.text]){
                    [self showAlertViewWith:@[@"请输入正确手机号",@"确定"] sel:nil];
                }else if (!_timer){
                    [self showAlertViewWith:@[@"请获取验证码",@"确定"] sel:nil];
                }
            }
            
        }else if (btn.tag == 101){
            if (_timer) {
                return;
            }
            if (_nameField.text.length > 0 && [MyControl isValueToPhoneNumber:_phoneField.text]) {
                KMBProgressShow;
                //获取授权码
                [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlConsult0 parameters:nil sucBlock:^(id responseObject) {
                    //获取验证码
                    NSDictionary *dict = @{@"sms_phone":_phoneField.text,@"sscode":responseObject[@"sscode"],@"sms_code":responseObject[@"sms_code"]};
                    [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlConsult1 parameters:dict sucBlock:^(id responseObject) {
                        KMBProgressHide;
                        if ([responseObject[@"status"] integerValue] == 1) {
                            
                            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
                        }else{
                            [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
                        }
                    } failBlock:^{
                        KMBProgressHide;
                    }];
                    
                } failBlock:^{
                    KMBProgressHide;
                }];
            }else{
                if (_nameField.text.length == 0) {
                    [self showAlertViewWith:@[@"请输入真实姓名",@"确定"] sel:nil];
                }else if (![MyControl isValueToPhoneNumber:_phoneField.text]){
                    [self showAlertViewWith:@[@"请输入正确手机号",@"确定"] sel:nil];
                }else{
                    
                }
            }
    }

}

- (void)refreshTime{
    
    UIButton *btn = [self.view viewWithTag:101];
    if (_time == 0) {
        [_timer invalidate];
        _timer = nil;
        _time = 180;
        [btn setTitle:@"重新发送" forState:UIControlStateNormal];
    }else{
        _time--;
        [btn setTitle:[NSString stringWithFormat:@"%lds",_time] forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
