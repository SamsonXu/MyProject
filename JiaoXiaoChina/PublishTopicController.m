//
//  PublishTopicController.m
//  JiaoXiaoChina
//
//  Created by 车界（上海）广告有限 on 16/6/16.
//  Copyright © 2016年 车界（上海）广告有限. All rights reserved.
//

#import "PublishTopicController.h"
#import "CateModel.h"
@interface PublishTopicController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{   //话题文本框
    UITextField *_topicField;
    //内容文本框
    UITextView *_textView;
    //提示语
    UILabel *_plachLabel;
    //添加图片滚动视图
    UIScrollView *_scrollView;
    //当前选择的图片数
    NSInteger _currentImg;
    //图片数据源
    NSMutableArray *_imageArray;
    //话题类型数据
    NSDictionary *_typeDict;
    //话题类型
    UILabel *_typeLabel;
    
    UIButton *_typeBtn;
    //话题视图
    UIView *_backView;
    NSArray *_topicArr;
}
@end

@implementation PublishTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArray = [[NSMutableArray alloc]init];
    [self requestData];
    [self requestCate];
    [self createUI];
}

- (void)requestCate{
    
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlRiderCate parameters:nil sucBlock:^(id responseObject) {
        KMBProgressHide;
        _topicArr = [CateModel arrayOfModelsFromDictionaries:responseObject[@"data"]];
        [self createTopicView];
    } failBlock:^{
        KMBProgressHide;
    }];
}

- (void)requestData{
    if (!_isJournal) {
        return;
    }
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlTopicType parameters:@{@"id":_pid} sucBlock:^(id responseObject) {
        KMBProgressHide;
        _typeDict = responseObject[@"data"];
        _topicField.text = [NSString stringWithFormat:@" 我正在进行“%@”",_typeDict[@"title"]];
        [_typeBtn setTitle:_typeDict[@"wenda_cate_name"] forState:UIControlStateNormal];
    } failBlock:^{
        KMBProgressHide;
    }];
    
    [[HttpManager shareManager]requestDataWithMethod:KUrlGet urlString:KUrlTopicRecod parameters:@{@"token":[DefaultManager getValueOfKey:@"token"]} sucBlock:^(id responseObject) {
        KMBProgressHide;
        if ([responseObject[@"status"] integerValue] == 1) {
            _imageArray = responseObject[@"data"];
            _currentImg = _imageArray.count;
            [self changeImg];
        }
    } failBlock:^{
        KMBProgressHide;
    }];
}

- (void)changeImg{
    
    for (int i = 0; i <= _imageArray.count; i++) {
        
        UIButton *btn = [self.view viewWithTag:100+i];
        btn.hidden = NO;
        if (i < _imageArray.count) {
            btn.subviews[1].hidden = NO;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageArray[i][@"imgpath"]]]];
            [btn setImage:image forState:UIControlStateNormal];
        }
    }
}

- (void)createUI{
    
    self.title = @"发表话题";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
    UILabel *label = [MyControl boldLabelWithTitle:@"发布" fram:CGRectMake(0, 0, 40, 40) color:[UIColor whiteColor] fontOfSize:14];
    [self addBtnWithTitle:label imageName:nil navBtn:KNavBarRight];
    
    _topicField = [[UITextField alloc]initWithFrame:CGRectMake(0, 74, KScreenWidth, 20)];
    _topicField.borderStyle = UITextBorderStyleNone;
    _topicField.font = [UIFont systemFontOfSize:14];
    _topicField.placeholder = @"标题(可自选)";
    [self.view addSubview:_topicField];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 104, KScreenWidth, 1)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 105, KScreenWidth, 200)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, KScreenWidth-10, 190)];
    _textView.delegate = self;
    [backView addSubview:_textView];
    
    _plachLabel = [MyControl labelWithTitle:@"说点什么吧···" fram:CGRectMake(5, 5, 120, 20) fontOfSize:14];
    _plachLabel.textColor = [UIColor grayColor];
    [_textView addSubview:_plachLabel];
    
    _typeBtn = [UIButton new];
    [_typeBtn setTitleColor:KColorSystem forState:UIControlStateNormal];
    _typeBtn.layer.borderWidth = 1;
    _typeBtn.layer.borderColor = KColorSystem.CGColor;
    _typeBtn.layer.cornerRadius = 5;
    _typeBtn.layer.masksToBounds = YES;
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (_topicName.length > 0) {
        [_typeBtn setTitle:_topicName forState:UIControlStateNormal];
    }else{
        [_typeBtn setTitle:@"选择话题" forState:UIControlStateNormal];
    }
    [_typeBtn addTarget:self action:@selector(typeBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_typeBtn];
    
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_textView).offset(-10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UIButton *btn = [UIButton new];
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    UIImageView *locaView = [UIImageView new];
    UILabel *cityLabel = [MyControl labelWithTitle:nil fram:CGRectMake(0, 0, 0, 0) color:KColorSystem fontOfSize:14 numberOfLine:1];
    
    if ([DefaultManager getValueOfKey:@"currentCity"]) {
        btn.layer.borderColor = KColorSystem.CGColor;
        locaView.image = [UIImage imageNamed:@"dw-01"];
        cityLabel.text = [DefaultManager getValueOfKey:@"currentCity"];
    }else{
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        locaView.image = [UIImage imageNamed:@"dw-02"];
        cityLabel.text = @"获取位置失败";
        cityLabel.textColor = [UIColor grayColor];
    }
    [self.view addSubview:btn];
    [btn addSubview:locaView];
    [btn addSubview:cityLabel];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeBtn.mas_right).offset(40);
        make.centerY.equalTo(_typeBtn);
        make.height.mas_equalTo(20);
    }];
    
    [locaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn).offset(10);
        make.centerY.equalTo(btn);
        make.height.width.mas_equalTo(15);
    }];
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locaView.mas_right).offset(10);
        make.centerY.equalTo(btn);
        make.height.mas_equalTo(20);
        make.right.equalTo(btn).offset(-10);
    }];
    
    CGFloat width = (KScreenWidth-50)/4;
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [MyControl buttonWithFram:CGRectMake(10+(width+10)*(i%4), 310+(width+10)*(i/4), width, width) title:nil imageName:@"tianjia" tag:100+i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *delBtn = [MyControl buttonWithFram:CGRectMake(width-30, 10, 20, 20) title:nil imageName:@"chacha"];
        [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        delBtn.tag = 200+i;
        delBtn.hidden = YES;
        [btn addSubview:delBtn];
        if (i != 0) {
            btn.hidden = YES;
        }
        [self.view addSubview:btn];
    }
    
   
}

- (void)createTopicView{
    //话题选择视图
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _backView.alpha = 0;
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:_backView];
    
    UIView *topicView = [UIView new];
    topicView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:topicView];
    
    [topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_backView);
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(300);
    }];
    
    UILabel *headLabel = [MyControl labelWithTitle:@"选择话题" fram:CGRectMake(0, 0, 320, 30) fontOfSize:14];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [topicView addSubview:headLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29, 320, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [topicView addSubview:lineView];
    
    UIButton *hidBtn = [MyControl buttonWithFram:CGRectMake(290, 0, 30, 30) title:nil imageName:@"top_banner_close" tag:200];
    [hidBtn addTarget:self action:@selector(topicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topicView addSubview:hidBtn];
    
    UIButton *lastBtn = nil;
    for (int i = 0; i < _topicArr.count; i++) {
        
        UIButton *btn = [MyControl buttonWithFram:CGRectMake(80*(i%4), 30+90*(i/4), 80, 90) title:nil imageName:nil tag:201+i];
        [btn addTarget:self action:@selector(topicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topicView addSubview:btn];
        
        CateModel *model = _topicArr[i];
        //图片
        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.imgpath]];
        [btn addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(btn).offset(5);
            make.height.width.mas_equalTo(50);
        }];
        //标题
        UILabel *titleLabel = [MyControl labelWithTitle:model.name fram:CGRectMake(0, 0, 0, 0) fontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.equalTo(imageView.mas_bottom).offset(5);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(btn);
        }];
        lastBtn = btn;
    }

}

- (void)topicBtnClick:(UIButton *)btn{
    
    [UIView animateWithDuration:1 animations:^{
        _backView.alpha = 0;
    }];
    if (btn.tag > 200) {
        UILabel *label = btn.subviews[1];
        [_typeBtn setTitle:label.text forState:UIControlStateNormal];
    }
}

- (void)typeBtnClik:(UIButton *)btn{
    if (_isJournal || _isTopic) {
        return;
    }
    [UIView animateWithDuration:1 animations:^{
        _backView.alpha = 1;
    }];
}

- (void)delBtnClick:(UIButton *)btn{
    NSInteger index = btn.tag-200;
    for (int i = (int)index; i < _currentImg; i++) {
        UIButton *btn = [self.view viewWithTag:100+i+1];
        UIImage *image = btn.currentImage;
        UIButton *btn1 = [self.view viewWithTag:100+i];
        [btn1 setImage:image forState:UIControlStateNormal];
        if (i == _currentImg-1) {
            btn1.subviews[1].hidden = YES;
        }
    }
    UIButton *btn1 = [self.view viewWithTag:_currentImg+100];
    btn1.hidden = YES;
    _currentImg--;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"token":[DefaultManager getValueOfKey:@"token"],@"id":_imageArray[index][@"id"]} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[HttpManager shareManager]requestDataWithMethod:KUrlPut urlString:KUrlTopicImgDel parameters:str sucBlock:^(id responseObject) {
    } failBlock:^{
        
    }];
}

- (void)updataImg:(UIImage *)img{
    //转换为二进制数据
    NSString *str = @"jpeg";
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    if (data == NULL) {
        data = UIImagePNGRepresentation(img);
        str = @"png";
    }
    NSString *imgType = [MyControl typeForImageData:data];
    UIButton *btn = [self.view viewWithTag:100+_currentImg];
    UIImage *image = [UIImage sd_animatedGIFNamed:@"loding-3"];
    [btn setImage:image forState:UIControlStateNormal];
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlTopicTP parameters:@{@"token":[DefaultManager getValueOfKey:@"token"],@"image_type":imgType,@"wenda_image":data} sucBlock:^(id responseObject) {
        KMBProgressHide;
        [btn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]] forState:UIControlStateNormal];
        btn.subviews[1].hidden = NO;
        _currentImg++;
        UIButton *btn1 = [self.view viewWithTag:100+_currentImg];
        btn1.hidden = NO;
    } failBlock:^{
        KMBProgressHide;
    }];
}

- (void)btnClick:(UIButton *)btn{
    [self alertShow];
}

- (void)alertShow{
    UIActionSheet *actSheet = [[UIActionSheet alloc]initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机拍照" otherButtonTitles:@"照片图库", nil];
    actSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actSheet showInView:self.view];
}

//提示框
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }else{
        return;
    }
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _plachLabel.hidden = NO;
    }else{
        _plachLabel.hidden = YES;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(updataImg:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClick:(UIButton *)btn{
    
    if (_topicField.text.length == 0) {
        [self showAlertViewWith:@[@"请输入标题",@"确定"] sel:nil];
    }else if (_textView.text.length < 2) {
        [self showAlertViewWith:@[@"内容不能少于2个字",@"确定"] sel:nil];
    }else if (_textView.text.length > 150){
        [self showAlertViewWith:@[@"内容不能多于150个字",@"确定"] sel:nil];
    }else{
        NSString *cityName = [DefaultManager getValueOfKey:@"currentCity"];
        NSString *cityId = @"0";
        if (cityName) {
            NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
            NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:path];
            for (NSDictionary *dict in array) {
                if ([dict[@"areaname"] isEqualToString:cityName]) {
                    cityId = dict[@"id"];
                }
            }
        }else{
            cityName = @"";
        }
        if (_isJournal) {
            KMBProgressShow;
            [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlJournalPublish parameters:@{@"token":[DefaultManager getValueOfKey:@"token"],@"vid":_typeDict[@"wcid"],@"cityid":cityId,@"title":_topicField.text,@"content":_textView.text,@"cityname":cityName} sucBlock:^(id responseObject) {
                KMBProgressHide;
                [self.navigationController popViewControllerAnimated:YES];
            } failBlock:^{
                KMBProgressHide;
            }];
        }else{
            KMBProgressShow;
            [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlTopicPublish parameters:@{@"token":[DefaultManager getValueOfKey:@"token"],@"cateid":_topicId,@"cityid":cityId,@"title":_topicField.text,@"content":_textView.text,@"cityname":cityName} sucBlock:^(id responseObject) {
                KMBProgressHide;
                [self.navigationController popViewControllerAnimated:YES];
            } failBlock:^{
                KMBProgressHide;
            }];
        }
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
