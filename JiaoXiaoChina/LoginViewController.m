//
//  LoginViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/4/28.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "ForgetCodeController.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_nameField;//用户名
    UITextField *_passField;//密码
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.title = @"登录";
    [self addBtnWithTitle:nil imageName:@"co_nav_back_btn" navBtn:KNavBarLeft];
    
    NSArray *titles = @[@"用户名:",@"密 码:"];
    NSArray *places = @[@"请输入手机号",@"请输入密码"];
    
    for (int i = 0; i < 2; i++) {
        
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
        }
        [view addSubview:field];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 84+49, KScreenWidth, 1)];
    lineView.backgroundColor = KGrayColor;
    [self.view addSubview:lineView];
    
    UIButton *logBtn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:@"登 录" imageName:nil tag:100];
    [logBtn setBackgroundColor:KColorSystem];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    logBtn.layer.cornerRadius = 10;
    [self.view addSubview:logBtn];
    
    KWS(ws);
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(224);
        make.centerX.equalTo(ws.view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(KScreenWidth - 20);
    }];

    NSArray *titles1 = @[@"忘记密码？",@"快速注册"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:titles1[i] imageName:nil tag:11+i];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 101+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logBtn.mas_bottom).offset(20);
            if (i == 0) {
                make.left.equalTo(logBtn);
            }else if (i == 1){
                make.right.equalTo(logBtn);
            }
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)leftClick:(UIButton *)btn{
    if (_isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
       [self.sideMenuViewController setContentViewController:[MyTabBarController shareTabBar]];
    }
    
}

- (void)popView{
    [self.sideMenuViewController setContentViewController:[MyTabBarController shareTabBar]];
}

- (void)btnClick:(UIButton *)btn{
     NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (id obj in [cookieJar cookies]) {
        [cookieJar deleteCookie:obj];
    }
    NSInteger index = btn.tag-100;
    if (index == 0) {
        NSArray *array;
        NSString *str;
        if (_nameField.text.length == 0) {
            str = @"请输入手机号";
        }else if (_passField.text.length == 0){
            str = @"请输入密码";
        }else if (![MyControl isValueToPhoneNumber:_nameField.text]) {
            str = @"请输入正确的手机号";
        }else if (![MyControl isValueToCode:_passField.text]){
            str = @"密码有6-20为字符组成";
        }else{
            
            NSDictionary *dict = @{@"username":_nameField.text,@"password":_passField.text};
            KMBProgressShow;
            [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlLogin parameters:dict sucBlock:^(id responseObject) {
                KMBProgressHide;
                NSString *message = responseObject[@"msg"];
                NSArray *array = @[message,@"确定"];
                if (!self.isPush) {
                    [self showAlertViewWith:array sel:nil];
                }
                if ([message isEqualToString:@"登录成功！"]) {
                    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    NSHTTPCookie *cookie = [[cookieJar cookies]lastObject];
                    [DefaultManager addValue:cookie.value key:@"token"];
                    NSLog(@"defaultToken:---%@",[DefaultManager getValueOfKey:@"token"]);
                    //获取用户信息
                    [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlInfo parameters:@{@"token":[DefaultManager getValueOfKey:@"token"]} sucBlock:^(id responseObject) {
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:dict forKey:@"userInfo"];
                        
                        if (self.isPush) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else{
                            [self.sideMenuViewController setContentViewController:[MyTabBarController shareTabBar]];
                        }
                        
                    } failBlock:^{
                        
                    }];

                    
                }
               
            } failBlock:^{
                KMBProgressHide;
            }];
            return;
        }
        array = @[str,@"确定"];
        [self showAlertViewWith:array sel:nil];
    }else if (index == 1){
        ForgetCodeController *vc = [[ForgetCodeController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (index == 2){
        RegistViewController *vc = [[RegistViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
