//
//  GTSSelfInformationVCViewController.m
//  SmartHome
//
//  Created by 周宇航 on 16/5/9.
//  Copyright © 2016年 gtscn. All rights reserved.
//
#import "SCSelfInformationVC.h"


//#import "SCReFindPwdVC.h"

#import "ZYRadioButton.h"

#import "UIImage+ImageEffects.h"

@interface SCSelfInformationVC () <RadioButtonDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate,UIActionSheetDelegate, UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    UITableView * userTableView;
    NSTimer *showLater;
    UIPopoverController *popoverVC;
    LPuserModel * userInformation;
    UITextField *userName;
}
@end

@implementation SCSelfInformationVC
static int num = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的资料";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"actionBack"] style:UIBarButtonItemStyleDone target:self action:@selector(actionUpdateUserInfo)];

    userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kNMDeviceWidth, kNMDeviceHeight-64)];
    userTableView.delegate = self;
    userTableView.dataSource = self;
    userTableView.sectionHeaderHeight = 20;
    [self.view addSubview:userTableView];
//    [self.view addSubview:[self creatFootView]];
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSDictionary * dicUserInfo =[userDef objectForKey:@"watcherUserInfo"];
    
    if(dicUserInfo){
        NSError * transforError ;
        NSLog(@"%@",dicUserInfo);
      LPlivingRoomModel * userInfo = [LPlivingRoomModel arrayOfModelsFromDictionaries:@[dicUserInfo] error:&transforError].lastObject;
        userInformation = [LPuserModel arrayOfModelsFromDictionaries:@[dicUserInfo] error:&transforError].lastObject;
    }else{
        [ZYHCommonService showMakeToastView:@"用户不存在"];
        return;
    }
    
    
    //给表格添加一个尾部视图
     userTableView.tableFooterView = [[UIView alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    [userTableView reloadData];
    userTableView.backgroundColor = fRgbColor(250, 250, 250);
    num = 1;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    switch (indexPath.section) {
    case 0: {
        switch (indexPath.row) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserFormCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"UserFormCell" owner:nil options:nil].lastObject;
            }
            UILabel *LabName = (UILabel *)[cell viewWithTag:11001];
            LabName.text = @"头像";
            LabName.textColor = fRgbColor(79, 91, 28);
            LabName.font = [UIFont systemFontOfSize:13];

            UIImageView *headimage = (UIImageView *)[cell viewWithTag:11002];
            headimage.layer.cornerRadius = 15;
            headimage.contentMode=UIViewContentModeScaleAspectFill;
            headimage.layer.masksToBounds = YES;
            headimage.layer.borderColor = SYSTEMCOlOR.CGColor;
            headimage.layer.borderWidth = 0.5;
            
            [headimage sd_setImageWithURL:[NSURL URLWithString:userInformation.faceUrl] placeholderImage:[UIImage imageNamed:@"userDef"]];
            UILabel *LabNil = (UILabel *)[cell viewWithTag:11003];
            LabNil.hidden = YES;
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserFormCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"UserFormCell" owner:nil options:nil].lastObject;
            }
            UILabel *LabName = (UILabel *)[cell viewWithTag:11001];
            LabName.text = @"昵称";
            LabName.textColor = fRgbColor(79, 91, 28);
            LabName.font = [UIFont systemFontOfSize:13];

            UILabel *LabUserName = (UILabel *)[cell viewWithTag:11003];
            NSString * name=userInformation.nickname;
            if (name.length==0||[name isEqualToString:@"(null)"]) {
                name=@"";
            }
            LabUserName.text = name;
            LabUserName.textColor = fRgbColor(128, 128, 128);
            LabUserName.font = [UIFont systemFontOfSize:13];

            UIImageView *headimage = (UIImageView *)[cell viewWithTag:11002];
            headimage.hidden = YES;
            break;
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserRadioCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"UserRadioCell" owner:nil options:nil].lastObject;
            }
            UILabel *LabName = (UILabel *)[cell viewWithTag:12001];
            LabName.text = @"性别";
            LabName.textColor = fRgbColor(79, 91, 28);
            LabName.font = [UIFont systemFontOfSize:13];
            //定义单选按钮
            ZYRadioButton *RBMan = [[ZYRadioButton alloc] initWithGroupId:@"first group" index:0 size:CGSizeMake(48, 25)];
            ZYRadioButton *RBWoman = [[ZYRadioButton alloc] initWithGroupId:@"first group" index:1 size:CGSizeMake(48, 25)];
            [cell.contentView addSubview:RBMan];
            [RBMan handleTitle:@"男"];
            [cell.contentView addSubview:RBWoman];
            [RBWoman handleTitle:@"女"];

            //按照GroupId添加观察者
            [ZYRadioButton addObserverForGroupId:@"first group" observer:self];

            [RBMan mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(RBWoman.mas_left).with.offset(-20);
                make.width.mas_equalTo(@58);
                make.height.mas_equalTo(@35);
            }];
            [RBWoman mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).with.offset(-15);
                make.width.mas_equalTo(@58);
                make.height.mas_equalTo(@35);
            }];
            //
            
            if (userInformation.sex == 2) {
                [RBWoman setButtonState];
            } else if (userInformation.sex == 1) {
                [RBMan setButtonState];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
        case 7: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserFormCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"UserFormCell" owner:nil options:nil].lastObject;
            }
            UILabel *LabName = (UILabel *)[cell viewWithTag:11001];
            LabName.text = @"地区";
//            UILabel *LabUserArea = (UILabel *)[cell viewWithTag:11003];
            break;
        }

        case 4: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserFormCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"UserFormCell" owner:nil options:nil].lastObject;
            }
            UILabel *LabName = (UILabel *)[cell viewWithTag:11001];
            LabName.text = @"修改密码";
            UILabel *LabNil = (UILabel *)[cell viewWithTag:11002];
            LabNil.hidden = YES;
            UIImageView *headimage = (UIImageView *)[cell viewWithTag:11003];
            headimage.hidden = YES;

            break;
        }

        default:
            break;
        }

        break;
    }

    case 1: {

        cell = [tableView dequeueReusableCellWithIdentifier:@"UserFormCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"UserFormCell" owner:nil options:nil].lastObject;
        }
        UILabel *LabName = (UILabel *)[cell viewWithTag:11001];
        LabName.text = @"实名认证(开发中)";
        UILabel *LabNil = (UILabel *)[cell viewWithTag:11002];
        LabNil.hidden = YES;
        UIImageView *headimage = (UIImageView *)[cell viewWithTag:11003];
        headimage.hidden = YES;
        break;
    }
    default:
        break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self actionChangeUserHeadimage];
    }else if (indexPath.row==1) {
        [self actionChangeUserName];
    }else{
        return;
    }
}

#pragma mark UIAlertViewDeleage
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
    case 0:
        break;
    case 1: {
        // 读取文本框的值显示出来
        UITextField *txtUserName = [alertView textFieldAtIndex:0];
        userInformation.nickname = txtUserName.text;
        [userTableView reloadData];
        break;
    }

    default:
        break;
    }
}

//推退出登录
- (UIView *)creatFootView {

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, kNMDeviceHeight-60-64, kNMDeviceWidth, 60)];

    UIButton *btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnExit.layer.cornerRadius = 5;
    btnExit.layer.masksToBounds = YES;
    [btnExit setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnExit setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnExit addTarget:self action:@selector(actionLogout) forControlEvents:UIControlEventTouchUpInside];
    btnExit.backgroundColor = [UIColor clearColor];
    btnExit.layer.borderWidth = 1;
    btnExit.layer.borderColor = [UIColor orangeColor].CGColor;
//    [btnExit setTintColor:[UIColor whiteColor]];
    btnExit.titleLabel.font = [UIFont systemFontOfSize:20];

    [footView addSubview:btnExit];
    [btnExit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView.mas_centerX);
        make.centerY.equalTo(footView.mas_centerY);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(36);
    }];

    return footView;
}

#pragma mark -cell点击事件
- (void)actionChangeUserHeadimage {
    __weak typeof(self) weakSelf = self;
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"拍照"
                               handler:^{
                                   [weakSelf getImgFromCamera];
                               }];
    [actionSheet bk_addButtonWithTitle:@"从手机相册选择"
                               handler:^{
                                   [weakSelf getHeadImage];

                               }];
    [actionSheet bk_addButtonWithTitle:@"取消"
                                     handler:^{
                                     }];

    [actionSheet bk_setDidDismissBlock:^(UIActionSheet *sheet, NSInteger buttonIndex) {
     
    }];
    [actionSheet showInView:self.view];
}

- (void)actionChangeUserName {
    [self doAlertInput:@"修改昵称" andPlaceholder:nil];
}

- (void)actionLogout {
    
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:nil forKey:@"userInfo"];
//
//    BOOL isHave = 0;
//    NSArray * arr = self.navigationController.viewControllers;
//    for (UIViewController * vc in arr) {
//        if ([vc isKindOfClass:[LPloginVC class]]) {
//            [self.navigationController popToViewController:vc animated:YES];
//            isHave = YES;
//        }
//    }
//    if (!isHave ) {
//        LPloginVC *login = [[LPloginVC alloc] init];
//        UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:login];
//        [[UIApplication sharedApplication].keyWindow setRootViewController:nav];
//    }
}


-(void)changeHeadImageSaveCompletion:(UIImage *)changeImage{
    NSString * url =[NSString stringWithFormat:@"/userc/updateImage?vc=%@",userInformation.vc];
    NSString * requestUrl = [REQUESTURL stringByAppendingString:url];
    
    [ZYHCommonService upDataImgWithImage2:changeImage requesetUrl:requestUrl imageType:@"1" completion:^(id result, NSError *error) {
        if(error){
            [ZYHCommonService showMakeToastView:error.localizedDescription];
        }else{
            NSDictionary * dicResult =[NSDictionary dictionaryWithDictionary:result];
            if ([dicResult.allKeys containsObject:@"data"]) {
                userInformation.faceUrl = dicResult[@"data"];
                NSDictionary * dicUserInfo = [userInformation toDictionary];
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dicUserInfo forKey:@"userInfo"];
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [userTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
            }else{
                [ZYHCommonService showMakeToastView:@"返回数据错误"];
            }
        }
    }];
}

// - 修改昵称
- (void)actionUpdateUserInfo {
    NSString * url =[NSString stringWithFormat:@"/userc/updateInfo?vc=%@",userInformation.vc];
    NSString * requestUrl = [REQUESTURL stringByAppendingString:url];
    [ZYHCommonService createASIFormDataRequset:requestUrl param:@{@"nickname":userInformation.nickname} completion:^(id result, NSError *error) {
        if (error) {
            [ZYHCommonService showMakeToastView:[NSString stringWithFormat:@"昵称修改错误:%@",error.localizedDescription]];
        }else{
            NSDictionary * dicUserInfo = [userInformation toDictionary];
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dicUserInfo forKey:@"userInfo"];
        }
    }];
}

//单选按钮的代理方法 - 修改性别
- (void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId {
    if ((index+1) != userInformation.sex) {
        userInformation.sex = (int)index+1;
        NSString * url =[NSString stringWithFormat:@"/userc/updateInfo?vc=%@",userInformation.vc];
        NSString * requestUrl = [REQUESTURL stringByAppendingString:url];
        [ZYHCommonService createASIFormDataRequset:requestUrl param:@{@"sex":[NSNumber numberWithInt:userInformation.sex]} completion:^(id result, NSError *error) {
            if (error) {
                [ZYHCommonService showMakeToastView:[NSString stringWithFormat:@"性别修改错误:%@",error.localizedDescription]];
            }else{
                NSDictionary * dicUserInfo = [userInformation toDictionary];
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dicUserInfo forKey:@"userInfo"];
            }
        }];
    }
}

#pragma mark - 修改框
- (void)doAlertInput:(NSString *)Title andPlaceholder:(NSString *)placeholder {

        // 初始化
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:Title message:nil preferredStyle:UIAlertControllerStyleAlert];

        // 创建文本框
        [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            if(userInformation.nickname){
                 textField.text=userInformation.nickname;
            }else{
                textField.placeholder =@"昵称在2~12个字之间";//
            }
            textField.delegate=self;
            textField.secureTextEntry = NO;
        }];

        // 创建操作
        // UIAlertViewStyle
        //
        UIAlertAction *ChangeAlert = [UIAlertAction actionWithTitle:@"确认"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                // 读取文本框的值显示出来
                                                                userName = alertDialog.textFields.firstObject;
                                                                userName.delegate = self;
                                                                if ([self judgeNameQualified:userName.text]) {
                                                                    if (![userInformation.nickname isEqualToString:userName.text]) {
                                                                        userInformation.nickname = userName.text;
                                                                        [self actionUpdateUserInfo];
                                                                        [userTableView reloadData];
                                                                    }
                                                                } else {
                                                                    [self actionChangeUserName];
                                                                }

                                                            }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *_Nonnull action){

                                                       }];

        // 添加操作（顺序就是呈现的上下顺序）
        [alertDialog addAction:ChangeAlert];
        [alertDialog addAction:cancle];
        // 呈现警告视图
        [self presentViewController:alertDialog animated:YES completion:nil];
    
    
//    } else {
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
//        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//
//        UITextField *nameField = [alertView textFieldAtIndex:0];
//        nameField.placeholder = @"请输入昵称";
//
//        [alertView show];
//    }
}

- (int)judgeNameQualified:(NSString *)nickName {
    if (nickName.length < 1) {
        [self.view makeToast:@"昵称不可为空" duration:2.0 position:CSToastPositionTop];
        return 0;
    }else if (nickName.length <2||nickName.length >12) {
        [self.view makeToast:@"昵称在2~12个字之间" duration:2.0 position:CSToastPositionTop];
        return 0;
    }
    NSString *first = [nickName substringToIndex:1];

    if ([first isEqualToString:@" "]) {
        [self.view makeToast:@"昵称第一位不可为空格" duration:2.0 position:CSToastPositionTop];
        return 0;
    }
    NSString *last = [nickName substringFromIndex:nickName.length - 1];

    if ([last isEqualToString:@" "]) {
        [self.view makeToast:@"昵称最后一位不可为空格" duration:2.0 position:CSToastPositionTop];
        return 0;
    }

    return 1;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([textField isEqual:userName]||[textField isEqual:userName]) {
        if (range.location >= 12) {
            //[self.view makeToast:@"昵称在2~12个字之间" duration:2.0 position:CSToastPositionTop];
            return NO;
        }
//    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 12) {
        [self.view makeToast:@"昵称在2~12个字之间" duration:2.0 position:CSToastPositionTop];
        [self actionChangeUserName];
    }
    
}

#pragma mark -获取照片相册/拍照

- (void)getImgFromCamera {

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    // imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:(NSString *)kCIAttributeTypeImage, nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//获取相册照片（以下3个方法）
- (void)getHeadImage {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound) { //如果是ipad
            popoverVC = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
            popoverVC.delegate = self;
            [popoverVC presentPopoverFromRect:CGRectMake(0, 0, 120, 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        } else {
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"访问手机相册异常" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popover {
    [popover dismissPopoverAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [popoverVC dismissPopoverAnimated:YES];
    // UIImagePickerControllerOriginalImage 原始图片
    // UIImagePickerControllerEditedImage 编辑过的
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage * reduceImg =[self imageWithImageSimple:img scaledToSize:CGSizeMake(100, 100)];
    //userInformation.userHeadimage = [[UIImageView alloc] initWithImage:img];
    [self changeHeadImageSaveCompletion:reduceImg];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//压缩图片质量
- (UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

//压缩图片
- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

@end
