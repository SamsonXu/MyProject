//
//  FeedBackViewController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/20.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UITextView *_textView;
    UITextField *_field;
    UILabel *_textLabel;//textView提示文本
}
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.title = @"意见反馈";
    
    UILabel *label1 = [MyControl labelWithTitle:@"返回" fram:CGRectMake(0, 0, 40, 40) fontOfSize:14];
    [self addBtnWithTitle:label1 imageName:nil navBtn:KNavBarLeft];
    
    UILabel *label2 = [MyControl labelWithTitle:@"发送" fram:CGRectMake(0, 0, 40, 40) fontOfSize:14];
    [self addBtnWithTitle:label2 imageName:nil navBtn:KNavBarRight];
    
    UILabel *label3 = [MyControl labelWithTitle:@"反馈内容:" fram:CGRectMake(10, 70, 100, 30) fontOfSize:14];
    
    UILabel *label4 = [MyControl labelWithTitle:@"联系方式:" fram:CGRectMake(10, 300, 100, 40) fontOfSize:14];
    
    [self.view addSubview:label3];
    [self.view addSubview:label4];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, KScreenWidth, 200)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 5, KScreenWidth, 190)];
    _textView.font = [UIFont systemFontOfSize:14];
    _textLabel = [MyControl labelWithTitle:@"请输入您的问题或意见" fram:CGRectMake(10, 5, KScreenWidth, 20) color:[UIColor grayColor] fontOfSize:14 numberOfLine:1];
    [_textView addSubview:_textLabel];
    _textView.delegate = self;
    [backView addSubview:_textView];
    
    UIView *fieldBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 340, KScreenWidth, 40)];
    fieldBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:fieldBackView];
    
    _field = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth-20, 20)];
    _field.placeholder = @"请输入您的Email/QQ/微信/手机号";
    _field.delegate = self;
    _field.font = [UIFont systemFontOfSize:14];
    [fieldBackView addSubview:_field];
    
    
}

#pragma mark-----textViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        _textLabel.hidden = NO;
    }else{
        _textLabel.hidden = YES;
    }
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    
    
    if (_textView.text.length == 0) {
        [self showAlertViewWith:@[@"请输入您的宝贵建议！",@"好的"] sel:nil];
    }else if(_field.text.length == 0){
        [self showAlertViewWith:@[@"请输入您的联系方式，方便我们及时为你做出反馈！",@"好的"] sel:nil];
    }else{
        [self showAlertViewWith:@[@"信息完整，有待完善服务器",@"好的"] sel:nil];
    }
}

- (void)pushInformation{
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
