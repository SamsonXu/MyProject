//
//  InformationViewController.m
//  NiceBeen
//
//  Created by qianfeng on 16/3/28.
//  Copyright (c) 2016年 Motion. All rights reserved.
//

#import "SetViewController.h"
#import "NickNameController.h"
#import "QuestionBankController.h"
#import "ChangeCityController.h"
#import "AFHTTPSessionManager.h"
@interface SetViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,QuestionBankDelegate,NickNameDelegate,ChangeCityDelegate>
{
    //pickView数据源
    NSArray *_pickArray;
    UIPickerView *_pickView;
    //pickView背景视图
    UIView *_backView;
    //pickView背景视图
    UIView *_moveView;
    //当前pickView选中行上的数据
    NSString *_currentSex;
    //当前驾照类型
    NSInteger _currentDrive;
    UIView *_topView;
    //当前pickView显示的用户属性
    NSInteger _currentProperty;
    //存储用户信息的字典
    NSMutableDictionary *_dict;
    UIImageView *_headView;
    //图片数据
    NSData *_fileData;
    //图片存储地址
    NSString *_filePath;
    //请求网址
    NSString *_urlStr;
}
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
    _pickArray = [[NSArray alloc]init];
    _filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/selfPhoto.jpg"];
    [self pickViewShow];
}

- (void)createUI
{
    [super createUI];
    self.title = @"完善资料";
    [self addBtnWithTitle:nil imageName:KBtnBack navBtn:KNavBarLeft];
}

- (void)requestData{
    
    [_dataArray removeAllObjects];
    _dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]];
    NSString *sexStr;
    
    if (_currentSex.length > 0) {
        sexStr = _currentSex;
    }else if ([_dict[@"sex"] isEqualToString:@"0"]) {
        sexStr = @"保密";
    }else if ([_dict[@"sex"]isEqualToString:@"1"]){
        sexStr = @"男";
    }else if ([_dict[@"sex"] isEqualToString:@"2"]){
        sexStr = @"女";
    }
    
    NSArray *jzArr = @[@"未选择",@"小车",@"客车",@"货车",@"摩托车",@"轮式自行车",@"恢复资格证",@"货运",@"客运",@"危险品",@"教练员",@"电车"];
    NSString *jzStr = _dict[@"is_cb"];
    NSInteger i = jzStr.integerValue;
    jzStr = jzArr[i];
    NSArray *array = @[@[@"头像",_dict[@"headimg"]],@[@"昵称",_dict[@"nickname"]],@[@"性别",sexStr],@[@"报考驾照",jzStr],@[@"地区",_dict[@"city_name"]]];
    
    [_dataArray addObjectsFromArray:array];
    [_tableView reloadData];
}

- (void)updateWithType:(NSString *)type info:(NSArray *)info{
    NSString *method = KUrlPut;
    NSDictionary *dict;

    if ([type isEqualToString:@"face"]) {//头像
        method = KUrlPost;
        _urlStr = KUrlUpdateFace;
        dict = @{@"token":[DefaultManager getValueOfKey:@"token"],@"face_image":info[0],@"image_type":info[1]};
    }else if ([type isEqualToString:@"city"]){//城市
        
        _urlStr = KUrlUpdateCity;
        dict = @{@"city_id":info[0],@"city_name":info[1],@"token":[DefaultManager getValueOfKey:@"token"]};
    }else if ([type isEqualToString:@"jiazhao"]){//驾照
        
        _urlStr = KUrlUpdateJZ;
        dict = @{@"cheben":info[0],@"token":[DefaultManager getValueOfKey:@"token"]};
    }else if ([type isEqualToString:@"sex"]){//性别
        
        _urlStr = KUrlUpdateSex;
        dict = @{@"sex":info[0],@"token":[DefaultManager getValueOfKey:@"token"]};
    }else if ([type isEqualToString:@"name"]){//昵称
        
        _urlStr = KUrlUpdateName;
        dict = @{@"nickname":info[0],@"token":[DefaultManager getValueOfKey:@"token"]};
    }
    
    if ([method isEqualToString:KUrlPost]) {
        KMBProgressShow;
        [[HttpManager shareManager]requestDataWithMethod:method urlString:_urlStr parameters:dict sucBlock:^(id responseObject) {
            KMBProgressHide;
            if ([responseObject[@"status"] integerValue] == 1) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:responseObject[@"data"]]];
                UIImage *image = [UIImage imageWithData:data];
                [MyControl writhImageToFileWith:image];
                [self updateInfo];
            }
        } failBlock:^{
            KMBProgressHide;
        }];
    }else if ([method isEqualToString:KUrlPut]){
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        KMBProgressShow;
        [[HttpManager shareManager]requestDataWithMethod:method urlString:_urlStr parameters:str sucBlock:^(id responseObject) {
            KMBProgressHide;
            if ([responseObject[@"status"] integerValue] == 1) {
                [self updateInfo];
            }
        } failBlock:^{
            KMBProgressHide;
            [self showAlertViewWith:@[@"请检查网络连接",@"确定"] sel:nil];
        }];
    }
}

- (void)updateInfo{
    //重新请求用户信息
    KMBProgressShow;
    [[HttpManager shareManager]requestDataWithMethod:KUrlPost urlString:KUrlInfo parameters:@{@"token":[DefaultManager getValueOfKey:@"token"]} sucBlock:^(id responseObject) {
        KMBProgressHide;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dict[@"is_cb"] forKey:KJZLX];
        if ([_urlStr isEqualToString:KUrlUpdateJZ]) {
            [DefaultManager createQuestionBase];
        }
        [defaults setObject:dict forKey:@"userInfo"];
        [self requestData];
    } failBlock:^{
        KMBProgressHide;
    }];
    
}

- (void)leftBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(UIButton *)btn
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ide = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ide];
    }
    
    if (indexPath.row == 0) {
        
        _headView = [UIImageView new];
        _headView.tag = 110;
        _headView.clipsToBounds = YES;
        _headView.layer.cornerRadius = 25;
        _headView.image = [UIImage imageWithContentsOfFile:_filePath];
        [cell.contentView addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(10);
            make.bottom.equalTo(cell.contentView).offset(-15);
            make.right.equalTo(cell.contentView).offset(-5);
            make.width.equalTo(_headView.mas_height);
        }];
    }else{
        
        cell.detailTextLabel.text = _dataArray[indexPath.row][1];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataArray[indexPath.row][0];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        [self alertShow];
    }else if (indexPath.row == 1) {
        
        NickNameController *vc = [[NickNameController alloc]init];
        vc.name = _dict[@"nickname"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2){
        
        _currentPage = 2;
        _pickArray = @[@"保密",@"男",@"女"];
        [self showPickView];
    }else if (indexPath.row == 3){
        
        QuestionBankController *vc = [[QuestionBankController alloc]init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        
        ChangeCityController *vc = [[ChangeCityController alloc]init];
        vc.infoDelegate = self;
        vc.isInfo = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)pickViewShow{
    //半透明视图
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _topView.backgroundColor = [UIColor blackColor];
    [_backView addSubview:_topView];
    _topView.alpha = 0;
    
    //pickView背景视图
    _moveView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 330)];
    _moveView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [_backView addSubview:_moveView];
    //按钮
    NSArray *titles = @[@"取消",@"确定"];
    for (int i = 0; i < titles.count; i++) {
        
        UIButton *btn = [MyControl buttonWithFram:CGRectMake(0, 0, 30, 30) title:titles[i] imageName:nil tag:100+i];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (i == 0) {
            btn.frame = CGRectMake(0, 0, 50, 30);
        }else if (i == 1){
            btn.frame = CGRectMake(KScreenWidth-40, 0, 40, 30);
            [btn setTitleColor:KColorSystem forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moveView addSubview:btn];
    }
    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, KScreenWidth, 300)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.alpha = 1;
    _pickView.showsSelectionIndicator = YES;
    _pickView.backgroundColor = [UIColor whiteColor];
    [_moveView addSubview:_pickView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewHid)];
    [_backView addGestureRecognizer:tap];
    _backView.alpha = 0;
}

//pickView上按钮事件
- (void)btnClick:(UIButton *)btn{
    
    NSInteger index = btn.tag-100;
    if (index == 0) {
        [self backViewHid];
    }else if (index == 1){
        NSString *str;
        if ([_currentSex isEqualToString:@"保密"]) {
            str = @"0";
        }else if ([_currentSex isEqualToString:@"男"]){
            str = @"1";
        }else if ([_currentSex isEqualToString:@"女"]){
            str = @"2";
        }
        [self updateWithType:@"sex" info:@[str]];
        [self backViewHid];
    }
}

//隐藏pickView
- (void)backViewHid{
    
    [UIView animateWithDuration:0.5 animations:^{
        _moveView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 0);
        _backView.alpha = 0;
    }];
}

//弹出pickView
- (void)showPickView{
    
    [_pickView reloadAllComponents];
    [UIView animateWithDuration:0.5 animations:^{
        _topView.alpha = 0.3;
        _moveView.frame = CGRectMake(0, KScreenHeight-330, KScreenWidth, 330);
        _backView.alpha = 1;
    }];
}

#pragma mark-----pickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _pickArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currentSex = _pickArray[row];
}

- (void)changeBankWithStr:(NSString *)str{
    [self updateWithType:@"jiazhao" info:@[str]];
}

#pragma  mark---alertCtrlDelegate
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


#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    
    UIImage *smallImage = [MyControl writhImageToFileWith:image];
    //转换为二进制数据
    NSString *str = @"jpeg";
    
    NSData *data = UIImageJPEGRepresentation(smallImage, 1.0);
    if (data == NULL) {
        data = UIImagePNGRepresentation(smallImage);
        str = @"png";
    }
    NSString *str1 = [MyControl typeForImageData:data];
    [self updateWithType:@"face"info:@[data,str1]];

}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark---NickNameDelegate
- (void)changeNameWithName:(NSString *)name{
    
    [self showAlertViewWith:@[@"昵称修改成功",@"确定"] sel:nil];
    [self updateInfo];
}

- (void)changeCityInfo:(NSArray *)info{
    [self updateWithType:@"city" info:info];
}

- (void)leftClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
