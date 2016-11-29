//
//  ForgetCodeController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/18.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "ForgetCodeController.h"
#import "NewCodeController.h"
@interface ForgetCodeController ()<UITextFieldDelegate>
{
    UITextField *_nameField;
    UITextField *_codeField;
    NSTimer *_timer;
    NSInteger _time;
    BOOL _hasTest;
}
@end

@implementation ForgetCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    _time = 180;
    _hasTest = NO;
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.title = @"找回密码";
    [self addBtnWithTitle:nil imageName:@"co_nav_back_btn" navBtn:KNavBarLeft];
    //文本框
    NSArray *titles = @[@"用户名:",@"验证码:"];
    NSArray *places = @[@"请输入手机号",@"请输入验证码"];
    for (int i = 0; i < titles.count; i++) {
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(0, 64+20+39*i, KScreenWidth, 40)];
        field.borderStyle = UITextBorderStyleRoundedRect;
        UILabel *leftLabel = [MyControl labelWithTitle:titles[i] fram:CGRectMake(0, 0, 100, 40) fontOfSize:14];
        leftLabel.textAlignment = NSTextAlignmentRight;
        field.leftView = leftLabel;
        field.leftViewMode = UITextFieldViewModeAlways;
        field.placeholder = places[i];
        field.adjustsFontSizeToFitWidth = YES;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.font = [UIFont systemFontOfSize:14];
        field.delegate = self;
        if (i == 0) {
            field.keyboardType = UIKeyboardTypeNumberPad;
            _nameField = field;
        }else if (i == 1){
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
        [self.view addSubview:field];
    }
    //确定按钮
    UIButton *logBtn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:@"确 定" imageName:nil tag:100];
    [logBtn setBackgroundColor:KColorSystem];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    logBtn.layer.cornerRadius = 10;
    [self.view addSubview:logBtn];
    KWS(ws);
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeField.mas_bottom).offset(40);
        make.centerX.equalTo(ws.view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(KScreenWidth - 20);
    }];
    
}

- (void)btnClick:(UIButton *)btn{
    NSInteger index = btn.tag-100;
    if (index == 0) {
        if ([MyControl isValueToPhoneNumber:_nameField.text]) {
            
            NSDictionary *dict = @{@"sms_phone":_nameField.text,@"sms_code":_codeField.text};
            [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlCode2 parameters:dict sucBlock:^(id responseObject) {
                if ([responseObject[@"status"] integerValue] == 1) {
                    NewCodeController *vc = [[NewCodeController alloc]init];
                    vc.number = _nameField.text;
                    vc.code = _codeField.text;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
                }
            } failBlock:^{
                
            }];
        }else{
        NSArray *array;
        NSString *str;
        if (_nameField.text.length == 0) {
            str = @"请输入手机号";
        }else if (![MyControl isValueToPhoneNumber:_nameField.text]) {
            str = @"请输入正确的手机号";
        }else if (_codeField.text.length == 0){
            str = @"请输入验证码";
        }else if (!_hasTest){
            str = @"请获取验证码";
        }
        array = @[str,@"确定"];
        [self showAlertViewWith:array sel:nil];
        }
    }else if (index == 1){
        if (_timer) {
            return;
        }
        if (![MyControl isValueToPhoneNumber:_nameField.text]) {
            [self showAlertViewWith:@[@"请输入正确的手机号",@"确定"] sel:nil];
        }else{
            //获取授权码
            [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlCode0 parameters:nil sucBlock:^(id responseObject) {
                //获取验证码
                NSDictionary *dict = @{@"sms_phone":_nameField.text,@"sscode":responseObject[@"sscode"],@"sms_code":responseObject[@"sms_code"]};
                [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlCode1 parameters:dict sucBlock:^(id responseObject) {
                    if ([responseObject[@"status"] integerValue] == 1) {
                        _hasTest = YES;
                        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
                    }else{
                        [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
                    }
                } failBlock:^{
                    
                }];
                
            } failBlock:^{
                
            }];
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

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
