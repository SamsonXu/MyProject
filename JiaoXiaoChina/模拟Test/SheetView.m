//
//  SheetView.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/5/6.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "SheetView.h"

@interface SheetView ()
{
    UIView *_superView;
    BOOL _startMoving;
    float _height;
    float _width;
    float _y;
    UIScrollView *_scrollView;
    int _num;
    UIImageView *_imageView;
}
@end
@implementation SheetView

-(instancetype)initWithFrame:(CGRect)frame view:(UIView *)superView number:(int)num{
    if (self = [super initWithFrame:frame]) {
        _superView = superView;
        self.backgroundColor = [UIColor whiteColor];
        _height = frame.size.height;
        _width = frame.size.width;
        _y = frame.origin.y;
        _num = num;
        [self createView];
    }
    return self;
}

//创建弹出视图
- (void)createView{
    _backView = [[UIView alloc]initWithFrame:_superView.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    [_superView addSubview:_backView];
    
    //下拉图标
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"filter_arrow_up"]];
    [self addSubview:_imageView];
    KWS(ws);
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.top.equalTo(ws);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
    }];
    
    //答题统计
    NSArray *titles = @[@"正确",@"错误",@"未答"];
    for (int i = 0; i < titles.count; i++) {
        UILabel *label = [MyControl labelWithTitle:titles[i] fram:CGRectMake(10+i*60, 30, 30, 20) fontOfSize:14];
        [self addSubview:label];
        
        UILabel *numLabel = [MyControl labelWithTitle:@"0" fram:CGRectMake(10+i*60+30, 30, 30, 20) fontOfSize:12];
        numLabel.tag = 50+i;

        if (i == 0) {
            numLabel.textColor = [UIColor greenColor];

        }else if (i == 1){
            numLabel.textColor = [UIColor redColor];

        }else if (i == 2){
            numLabel.textColor = [UIColor grayColor];
        }

        [self addSubview:numLabel];
    }
    //清空统计
    UIButton *delBtn = [MyControl buttonWithFram:CGRectMake(self.frame.size.width-100, 30, 80, 20) title:@"清空记录" imageName:nil];
    [delBtn setTitleColor:KColorSystem forState:UIControlStateNormal];
    delBtn.tag = 20;
    delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    delBtn.layer.cornerRadius = 5;
    delBtn.layer.borderColor = KColorSystem.CGColor;
    delBtn.layer.borderWidth = 1;
    delBtn.layer.masksToBounds = YES;
    [delBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor grayColor];
    [self addSubview:lineLabel];
    //存放题号按钮的滑动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height-70)];
    [self addSubview:_scrollView];
    CGFloat btnWidth = (self.frame.size.width-70)/6;
    for (int i = 0; i < _num; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i%6*btnWidth+(i%6+1)*10, i/6*btnWidth+(i/6+1)*10, btnWidth, btnWidth);
        btn.layer.cornerRadius = btnWidth/2;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
    _scrollView.contentSize = CGSizeMake(0, (_num/6+2)*btnWidth+(_num/6+3)*10);
    
}

//按钮点击事件
- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 20) {//清空记录
        if (_isTest) {
            return;
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@{KTrue:[NSString stringWithFormat:@"%d",0],KFaults:[NSString stringWithFormat:@"%d",0]} forKey:KTrueFaults];
        for (int i = 0; i < _num; i++) {
            UIButton *btn = [self viewWithTag:100+i];
            btn.layer.borderColor = [UIColor grayColor].CGColor;
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
        }
        return;
    }
    NSInteger index = btn.tag-100;
    
    [UIView animateWithDuration:0.5 animations:^{
       self.frame = CGRectMake(0, _y, _width, _height);
        _backView.alpha = 0;
    }];
    [self.delegate sheetViewClick:index];
    [self.delegate changeBtnNum:index];
}

- (void)changeColorWithNum:(NSInteger)num right:(BOOL)right{
    UIButton *btn = [self viewWithTag:num+100];
    if (right) {
        btn.backgroundColor = KColorRGB(201, 237, 201);
        btn.layer.borderColor = KColorRGB(95, 210, 94).CGColor;
        [btn setTitleColor:KColorRGB(95, 210, 94) forState:UIControlStateNormal];
    }else{
        btn.backgroundColor = KColorRGB(250, 207, 208);
        btn.layer.borderColor = KColorRGB(241, 76, 82).CGColor;
        [btn setTitleColor:KColorRGB(241, 76, 82) forState:UIControlStateNormal];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    if (point.y < 25) {
        _startMoving = YES;
    }
    if (_startMoving && self.frame.origin.y >= _y-_height && [self convertPoint:point toView:_superView].y >= 80+64) {
        self.frame = CGRectMake(0, [self convertPoint:point toView:_superView].y, _width, _height);
        float offset = (_superView.frame.size.height-self.frame.origin.y)/_superView.frame.size.height*0.8;
        _backView.alpha = offset;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _startMoving = NO;
    if (self.frame.origin.y > _y-_height/2) {
        [UIView animateWithDuration:0.5 animations:^{
            if (self.isTest) {
                self.frame = CGRectMake(0, _y-64, _width, _height);
                _imageView.image = [UIImage imageNamed:@"filter_arrow_up"];
            }else{
            self.frame = CGRectMake(0, _y, _width, _height);
                
            }
        }];
        _backView.alpha = 0;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, _y-_height+64, _width, _height);
            _imageView.image = [UIImage imageNamed:@"filter_arrow_down"];
        }];
        _backView.alpha = 0.8;
    }
}

////改变答题对错数量
- (void)changeNumberWithNum:(NSArray *)array{

    for (int i = 0; i < array.count; i++) {
        UILabel *label = [self viewWithTag:50+i];
        label.text = array[i];
    }
}
@end
