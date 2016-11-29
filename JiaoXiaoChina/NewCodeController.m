//
//  NewCodeController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/18.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "NewCodeController.h"
#import "MyViewController.h"
#import "LoginViewController.h"
@interface NewCodeController ()<UITextFieldDelegate>
{
    UITextField *_newPassField1;
    UITextField *_newPassField2;
}
@end

@implementation NewCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
        self.title = @"重置密码";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    //文本框
    NSArray *titles = @[@"新密码:",@"确认密码:"];
    NSArray *places = @[@"6-20位字符",@"再次输入密码"];
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
            _newPassField1 = field;
        }else if (i == 1){
            _newPassField2 = field;
        }
        [self.view addSubview:field];
    }
    //登录按钮
    UIButton *logBtn = [MyControl buttonWithFram:CGRectMake(0, 0, 0, 0) title:@"确 定" imageName:nil tag:100];
    [logBtn setBackgroundColor:KColorSystem];
    [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    logBtn.layer.cornerRadius = 10;
    [self.view addSubview:logBtn];
    KWS(ws);
    [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_newPassField2.mas_bottom).offset(40);
        make.centerX.equalTo(ws.view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(KScreenWidth - 20);
    }];

}

- (void)btnClick:(UIButton *)btn{
    NSArray *array;
    NSString *str;
    if (_newPassField1.text.length == 0) {
        str = @"请输入新密码";
    }else if (![MyControl isValueToCode:_newPassField1.text]){
        str = @"密码由6-20位字符组成";
    }else if (_newPassField2.text.length == 0){
        str = @"请再次输入密码";
    }else if (![_newPassField1.text isEqualToString:_newPassField2.text]){
        str = @"两次输入密码不一致，请再次输入";
    }else{

        NSDictionary *dict = @{@"mobile_phone":_number,@"password":_newPassField1.text,@"password2":_newPassField2.text,@"sms_code":_code};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [[HttpManager shareManager]requestDataWithMethod:KUrlPut urlString:KUrlCode3 parameters:str sucBlock:^(id responseObject) {
            if ([responseObject[@"status"] integerValue] == 1) {
                [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]init]] animated:YES];
                }];
            }
            else{
                [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
            }
        } failBlock:^{

        }];
        return;
    }
    array = @[str,@"确定"];
    [self showAlertViewWith:array sel:nil];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
