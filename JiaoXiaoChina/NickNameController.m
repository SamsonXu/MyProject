//
//  NickNameController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/18.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "NickNameController.h"
#import "SetViewController.h"
@interface NickNameController ()
{
    UITextField *_textView;
}
@end

@implementation NickNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    [super createUI];
    self.title = @"昵称";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    [self addBtnWithTitle:[MyControl labelWithTitle:@"提交" fram:CGRectMake(0, 0, 0, 0) fontOfSize:14] imageName:nil navBtn:KNavBarRight];
    
    _textView = [[UITextField alloc]initWithFrame:CGRectMake(0, 30, KScreenWidth, 50)];
    _textView.text = _name;
    _textView.backgroundColor = [UIColor whiteColor];
    [_tableView addSubview:_textView];
    
    UILabel *label = [MyControl labelWithTitle:@"昵称长度为1~10个字,可作为账号直接登录" fram:CGRectMake(10, 80, KScreenWidth, 20) color:[UIColor grayColor] fontOfSize:12 numberOfLine:1];
    [_tableView addSubview:label];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    
    if ([_textView.text isEqualToString:_name]){
        [self showAlertViewWith:@[@"昵称未做修改",@"确定"] sel:nil];
    }else if (_textView.text.length > 0 && _textView.text.length <= 10) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"nickname":_textView.text,@"token":[DefaultManager getValueOfKey:@"token"]} options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        KMBProgressShow;
        [[HttpManager shareManager]requestDataWithMethod:KUrlPut urlString:KUrlUpdateName parameters:str sucBlock:^(id responseObject) {
            KMBProgressHide;
            if ([responseObject[@"status"] integerValue] == 1){
                
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate changeNameWithName:_textView.text];
            }else{
                [self showAlertViewWith:@[responseObject[@"msg"],@"确定"] sel:nil];
            }
        } failBlock:^{
            KMBProgressHide;
        }];
    }else {
        [self showAlertViewWith:@[@"昵称长度为1~10个字！",@"确定"] sel:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
