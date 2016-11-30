//
//  RegistViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/28.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "RegistViewController.h"
#import "WebViewController.h"
@interface RegistViewController ()<UITextFieldDelegate>
{
    UITextField *_nameField;
    UITextField *_passField;
    UITextField *_codeField;
    NSTimer *_timer;
    NSInteger _time;
    NSDictionary *_testDict;
    BOOL _hasTest;
}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    _time = 180;
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.title = @"注册";
    [self addBtnWithTitle:nil imageName:@"co_nav_back_btn" navBtn:KNavBarLeft];
    //文本框
    NSArray *titles = @[@"用户名:",@"密 码:",@"验证码:"];
    NSArray *places = @[@"请输入手机号",@"请输入密码",@"请输入验证码"];
    for (int i = 0; i < titles.count; i++) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64+20+49*i, KScreenWidth, 49)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel *leftLabel = [MyControl labelWithTitle:titles[i] fram:CGRectMake(30, 10, 60, 30) fontOfSize:14];
        leftLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:leftLabel];
        
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(95, 10, KScreenWidth-95, 30)];
        field.placeholder = places[i];
        field.adjustsFontSizeToFitWidth = YES;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.font = [UIFont systemFontOfSize:14];
        field.delegate = self;
        
        if (i == 0) {
            field.keyboardType = UIKeyboardTypeNumberPad;
            _nameField = field;
        }else if (i == 1){
            field.secureTextEntry = YES;
            _passField = field;
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
        [view addSubview:field];
    }
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 84+49, KScreenWidth, 1)];
    lineView1.backgroundColor = KGrayColor;
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 84+49*2, KScreenWidth, 1)];
    lineView2.backgroundColor = KGrayColor;
    [self.view addSubview:lineView2];
    
    //注册按钮
    UIButton *logBtn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:@"注 册" imageName:nil tag:100];
    [logBtn setBackgroundColor:KColorSystem];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    logBtn.layer.cornerRadius = 10;
    [self.view addSubview:logBtn];
    KWS(ws);
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(274);
        make.centerX.equalTo(ws.view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(KScreenWidth - 20);
    }];
    //解释label
    UILabel *label = [MyControl labelWithTitle:@"点击“注册”按钮，即表示您已同意" fram:CGRectMake(0, 0, 0, 0) color:[UIColor grayColor] fontOfSize:12 numberOfLine:1];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logBtn.mas_bottom).offset(20);
        make.left.equalTo(logBtn);
        make.height.mas_equalTo(20);
    }];
    //协议按钮
    UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:@"《用户使用协议》" imageName:nil tag:102];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn setTitleColor:KColorSystem forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.left.equalTo(label.mas_right);
        make.height.equalTo(label);
    }];
}

- (void)btnClick:(UIButton *)btn{
        NSInteger index = btn.tag-100;
        if (index == 0) {
            if ([MyControl isValueToPhoneNumber:_nameField.text] && [MyControl isValueToCode:_passField.text] && _timer) {
                
                NSDictionary *dict = @{@"mobile_phone":_nameField.text,@"password":_passField.text,@"sms_code":_codeField.text};
                KMBProgressShow;
                [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlRegist2 parameters:dict sucBlock:^(id responseObject) {
                    KMBProgressHide;
                    if ([responseObject[@"status"] integerValue] == 1) {
                        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                        NSHTTPCookie *cookie = [[cookieJar cookies]lastObject];
                        [DefaultManager addValue:cookie.value key:@"token"];
                        [self.sideMenuViewController setContentViewController:[MyTabBarController shareTabBar]];
                    }else{
                        [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
                    }
                } failBlock:^{
                    KMBProgressHide;
                }];
                
            }else{
            NSArray *array;
            NSString *str;
            if (_nameField.text.length == 0) {
                str = @"请输入手机号";
            }else if (_passField.text.length == 0){
                str = @"请输入密码";
            }else if (![MyControl isValueToPhoneNumber:_nameField.text]) {
                str = @"请输入正确的手机号";
            }else if (![MyControl isValueToCode:_passField.text]){
                str = @"密码由6-20为字符组成";
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
            if ([MyControl isValueToPhoneNumber:_nameField.text] && [MyControl isValueToCode:_passField.text]) {
                //获取授权码
                [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlRegist0 parameters:nil sucBlock:^(id responseObject) {
                    //获取验证码
                    NSDictionary *dict = @{@"sms_phone":_nameField.text,@"sscode":responseObject[@"sscode"],@"sms_code":responseObject[@"sms_code"]};
                    [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlRegist1 parameters:dict sucBlock:^(id responseObject) {
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
            }else{
                
            NSArray *array;
            NSString *str;
            if (_nameField.text.length == 0) {
                str = @"请输入手机号";
            }else if (_passField.text.length == 0){
                str = @"请输入密码";
            }else if (![MyControl isValueToPhoneNumber:_nameField.text]) {
                str = @"请输入正确的手机号";
            }else if (![MyControl isValueToCode:_passField.text]){
                str = @"密码由6-20为字符组成";
            }
            array = @[str,@"确定"];
            [self showAlertViewWith:array sel:nil];
                
            }
            
        }else if (index == 2){
            
            WebViewController *vc = [[WebViewController alloc]init];
            vc.title = @"用户使用协议";
            vc.url = @"";
            [self.navigationController pushViewController:vc animated:YES];
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
