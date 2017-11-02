//
//  LPLivePlayingLayoutView.m
//  AlivcLiveVideoDemo
//
//  Created by zyh on 2017/10/13.
//  Copyright © 2017年 Alibaba Video Cloud. All rights reserved.
//

#import "LPLivePlayingLayoutView.h"

#import <ImSDK/ImSDK.h>

@implementation LPLivePlayingLayoutView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    //开启和监听 设备旋转的通知（不开启的话，设备方向一直是UIInterfaceOrientationUnknown）
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(layoutViewOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    cellConWidth = kNMDeviceWidth * 0.7;
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTapSelf)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer * leftPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(actionChangeVolume:)];
    [self addGestureRecognizer:leftPanGesture];
    
    
    [self loadViewInit];
    [self setLayoutView];
    [self setViewFrame];
    
    [self addSureBtnOnKeyboardBar];
    [self registerForKeyboardNotifications];
    
    return self;
}

-(void)loadViewInit{
    _arrText=[NSMutableArray arrayWithCapacity:0];
    talkTableView = [[UITableView alloc]init];
    headerView = [[UIView alloc]init];
    userImg = [[UIImageView alloc]init];
    labWatchNum = [[UILabel alloc]init];
    labFansNum = [[UILabel alloc]init];
    btnClose = [[UIButton alloc]init];
    imgClose = [[UIImageView alloc]init];
    
    _labTimer = [[UILabel alloc]init];
    _imgConnect = [[UIImageView alloc]init];
    _btnConnect = [[UIButton alloc]init];
    
    
    txtTalk =[[UITextField alloc]init];
    btnSend = [[UIButton alloc]init];
    btnMore = [[UIButton alloc]init];
    
    [self addSubview:headerView ];
    [headerView addSubview:userImg ];
    [headerView addSubview:labWatchNum ];
    [headerView addSubview:labFansNum ];
    [headerView addSubview:btnClose ];
    [headerView addSubview:imgClose ];
    [self addSubview:talkTableView ];
    [self addSubview:_labTimer ];
    [self addSubview:_imgConnect ];
    [self addSubview:_btnConnect ];
    [self addSubview:btnSend ];
    [self addSubview:txtTalk ];
    [self addSubview:btnMore ];
    
}

-(void)setLayoutView{
   
    
    talkTableView.backgroundColor = [UIColor clearColor];
    talkTableView.delegate = self;
    talkTableView.dataSource = self;
    talkTableView.tableFooterView = [[UIView alloc]init];
    talkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   

    
    [userImg sd_setImageWithURL:[NSURL URLWithString:self.playerModel.faceUrl] placeholderImage:[UIImage imageNamed:@"userDef"]];
    userImg.layer.cornerRadius = 15;
    userImg.layer.masksToBounds = YES;
    labWatchNum.font = [UIFont systemFontOfSize:10];
    labFansNum.font = [UIFont systemFontOfSize:10];
    labWatchNum.textAlignment = NSTextAlignmentRight;
    labFansNum.textAlignment = NSTextAlignmentRight;
    imgClose.image = [UIImage imageNamed:@"close_white"];
    [btnClose addTarget:self action:@selector(actionCloseLivePlaying:) forControlEvents:UIControlEventTouchUpInside];
    if (self.playerModel) {
        labWatchNum.text =[NSString stringWithFormat:@"%d在线",self.playerModel.userNum];
    }else{
        labWatchNum.text =@"0在线";
    }
    
    _labTimer.font = [UIFont systemFontOfSize:10];
    
    btnMore.backgroundColor = [UIColor whiteColor];
    btnMore.layer.cornerRadius = 15;
    btnMore.layer.masksToBounds = YES;
    
    _imgConnect.hidden = YES;
    _btnConnect.hidden = YES;
    _imgConnect.image =[UIImage imageNamed:@"m_connect"];
    [_btnConnect addTarget:self action:@selector(actionConncetReplace:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnMore setImage:[UIImage imageNamed:@"talk"] forState:UIControlStateNormal];
    [btnMore addTarget:self action:@selector(actionShowKey) forControlEvents:UIControlEventTouchUpInside];
    
    
    txtTalk.delegate =self;
    txtTalk.hidden = YES;
    btnSend.hidden = YES;
    txtTalk.backgroundColor =[UIColor whiteColor];
    txtTalk.layer.cornerRadius = 5;
    txtTalk.layer.masksToBounds = YES;
    
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(actionSendMsg:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setViewFrame{
    headerView.frame = CGRectMake(0, 20, kNMDeviceWidth, 44);
    userImg.frame = CGRectMake(15, (44-30)/2.0, 30, 30);
    labWatchNum.frame = CGRectMake(15+30+3, (44-25)/2.0+3, 50, 11);
    labFansNum.frame = CGRectMake(15+30+3, (44-25)/2.0-3+15, 30, 11);
    btnClose.frame = CGRectMake(kNMDeviceWidth-40-15, (44-40)/2.0, 40, 40);
    imgClose.center = btnClose.center;
    imgClose.bounds = CGRectMake(0, 0, 18, 18);
    
    _labTimer.frame = CGRectMake(15, 64, 50, 20);
    
    _btnConnect.center = CGPointMake(_labTimer.center.x+38, _labTimer.center.y);
    _btnConnect.bounds = CGRectMake(0,0, 44, 44);
    _imgConnect.center = _btnConnect.center;
    _imgConnect.bounds = CGRectMake(0, 0, 18, 18);
    
    talkTableView.frame = CGRectMake(15, 84, cellConWidth,0 );//kNMDeviceHeight-84-88
    txtTalk.frame = CGRectMake(15, kNMDeviceHeight-30-10, kNMDeviceWidth-30-10-50,30 );
    btnSend.frame = CGRectMake(kNMDeviceWidth-50-15, kNMDeviceHeight-30-10, 50, 30);
    btnMore.frame = CGRectMake(15, kNMDeviceHeight-30-10, 30, 30);
    
}

-(void)setAllViewFrame{
    headerView.frame = CGRectMake(0, 0, kNMDeviceHeight, 44);
    
    userImg.frame = CGRectMake(15, (44-30)/2.0, 30, 30);
    labWatchNum.frame = CGRectMake(15+30+3, (44-25)/2.0+3, 50, 11);
    labFansNum.frame = CGRectMake(15+30+3, (44-25)/2.0-3+15, 30, 11);
    btnClose.frame = CGRectMake(kNMDeviceHeight-40-15, (44-40)/2.0, 40, 40);
    imgClose.center = btnClose.center;
    imgClose.bounds = CGRectMake(0, 0, 18, 18);
    
    _labTimer.frame = CGRectMake(15, 44, 50, 20);
    
    _btnConnect.center = CGPointMake(_labTimer.center.x+38, _labTimer.center.y);
    _btnConnect.bounds = CGRectMake(0,0, 44, 44);
    _imgConnect.center = _btnConnect.center;
    _imgConnect.bounds = CGRectMake(0, 0, 18, 18);
    
    talkTableView.frame = CGRectMake(15, 64, cellConWidth, 0);//kNMDeviceWidth-84-88
    
    txtTalk.frame = CGRectMake(15, kNMDeviceWidth-30-10, kNMDeviceWidth-30-10-50,30 );
    btnSend.frame = CGRectMake(kNMDeviceHeight-50-15, kNMDeviceWidth-30-10, 50, 30);
    
    btnMore.frame = CGRectMake(15, kNMDeviceWidth-30-10, 30, 30);
  ///  controlView.frame = CGRectMake(0, 0, kNMDeviceHeight, kNMDeviceWidth);
}


-(void)setWatcherNum:(int)watcherNum{
    if (watcherNum) {
        labWatchNum.text =[NSString stringWithFormat:@"%d在线",watcherNum];
    }else{
        labWatchNum.text =@"0在线";
    }
}

-(void)reloadConversationTabelView:(NSArray *)arrNewText{
    [_arrText addObjectsFromArray:arrNewText];
    float allHeight= 0;
    float strWight = cellConWidth;
//    if (!isScreenRotate) {
//        nowHeight = cellConWidth-30;
//    }else{
//        nowHeight = cellConWidth-30;
//    }
    for (NSDictionary * dicSend in _arrText) {
        NSString * msgStr;
        if ([dicSend[@"type"] intValue] ==1) {
            TIMUserProfile *sendUser =dicSend[@"senderInfo"];
            msgStr = [NSString stringWithFormat:@"%@ %@",sendUser.nickname,dicSend[@"msg"]];
        }else if ([dicSend[@"type"] intValue] ==2){
            TIMGroupMemberInfo *sendUser =dicSend[@"senderInfo"];
            msgStr = [NSString stringWithFormat:@"@系统提示 %@进入房间",sendUser.member];
        }else if([dicSend[@"type"] intValue] ==3){
            NSString *sendUser =dicSend[@"senderInfo"];
            msgStr = [NSString stringWithFormat:@"@系统提示 %@退出房间",sendUser];
        }else{
            msgStr = dicSend[@"msg"];
        }
        
        float nowHeight = [ZYHCommonService heightForString:msgStr fontSize:TEXTFONT+3 andWidth:strWight];
        nowHeight += 5;
        if (nowHeight<25) {
            nowHeight = 25;
        }
        allHeight += nowHeight;
    }
    
    if (isScreenRotate) {
        if (allHeight>(kNMDeviceHeight - 84-50)) {
            allHeight =kNMDeviceHeight - 84-50;
        }
        talkTableView.frame = CGRectMake(15, kNMDeviceWidth-50-allHeight, cellConWidth, allHeight);
    }else{
        if (allHeight>(kNMDeviceWidth - 64-50)) {
            allHeight =kNMDeviceWidth - 64-50;
        }
        talkTableView.frame = CGRectMake(15, kNMDeviceHeight-50-allHeight, cellConWidth,allHeight);
    }
    [talkTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(talkTableView.contentSize.height>talkTableView.bounds.size.height){
//            [talkTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_arrText.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//            [talkTableView setContentOffset:CGPointMake(0, talkTableView.contentSize.height-talkTableView.bounds.size.height) animated:NO];
//            [talkTableView setContentOffset:CGPointMake(0, talkTableView.contentSize.height-talkTableView.bounds.size.height)];
        }
    });
}

#pragma mark - 界面

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrText.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    static NSString * idnetifierStr = @"commonIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:idnetifierStr];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LPConMsgCell" owner:nil options:nil].lastObject;
    }

    NSDictionary * dicSend = _arrText[indexPath.row];
    NSMutableAttributedString *hintString ;
    if ([dicSend[@"type"] intValue] ==1) {
        TIMUserProfile *sendUser =dicSend[@"senderInfo"];
        NSString * name;
        if (sendUser.nickname.length) {
            name = sendUser.nickname;
        }else{
            name =sendUser.identifier;
        }
        
        NSString * msgStr = [NSString stringWithFormat:@"%@ %@",name,dicSend[@"msg"]];
        hintString = [[NSMutableAttributedString alloc] initWithString:msgStr];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1 = [[hintString string] rangeOfString:name];
        [hintString addAttribute:NSForegroundColorAttributeName value:fRgbColor(35, 194, 194) range:range1];

    }else if ([dicSend[@"type"] intValue] ==2){
        TIMGroupMemberInfo *sendUser =dicSend[@"senderInfo"];
        NSString * msgStr = [NSString stringWithFormat:@"@系统提示 %@进入房间",sendUser.member];
        hintString = [[NSMutableAttributedString alloc] initWithString:msgStr];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1 = [[hintString string] rangeOfString:@"@系统提示"];
        [hintString addAttribute:NSForegroundColorAttributeName value:fRgbColor(232, 178, 20) range:range1];

    }else if ([dicSend[@"type"] intValue] ==3){
        NSString *sendUser =dicSend[@"senderInfo"];
        NSString * msgStr = [NSString stringWithFormat:@"@系统提示 %@退出房间",sendUser];
        hintString = [[NSMutableAttributedString alloc] initWithString:msgStr];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1 = [[hintString string] rangeOfString:@"@系统提示"];
        [hintString addAttribute:NSForegroundColorAttributeName value:fRgbColor(232, 178, 20) range:range1];
    }else{
        hintString = [[NSMutableAttributedString alloc] initWithString:dicSend[@"msg"]];
    }
    
    UILabel * labMsg = [cell viewWithTag:12160311];
    labMsg.attributedText = hintString;
    
    UIView * backView = [cell viewWithTag:1216030];
    dispatch_async(dispatch_get_main_queue(), ^{
         backView.frame = CGRectMake(0, 2.5, labMsg.frame.size.width+6, backView.frame.size.height);
    });
    
   // float txtLength=msgStr.length * TEXTFONT+6;
   // if(txtLength<cellConWidth){
   //     backView.frame = CGRectMake(0, 2.5, txtLength, /backView.frame.size.height);
   // }else{
   //     backView.frame = CGRectMake(0, 2.5, cell.frame.size.width, backView.frame.size.height);
   // }
    
    cell.backgroundColor =[UIColor clearColor];
    cell.contentView.backgroundColor =[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float strWight = cellConWidth-30;;
//    if (!isScreenRotate) {
//        strWight = cellConWidth-30;
//    }else{
//
//    }
    NSDictionary * dicSend = _arrText[indexPath.row];
    NSString * msgStr;
    if ([dicSend[@"type"] intValue] ==1) {
        TIMUserProfile *sendUser =dicSend[@"senderInfo"];
        msgStr = [NSString stringWithFormat:@"%@ %@",sendUser.nickname,dicSend[@"msg"]];
    }else if ([dicSend[@"type"] intValue] ==2){
        TIMGroupMemberInfo *sendUser =dicSend[@"senderInfo"];
        msgStr = [NSString stringWithFormat:@"@系统提示 %@进入房间",sendUser.member];
    }else if([dicSend[@"type"] intValue] ==3){
        NSString *sendUser =dicSend[@"senderInfo"];
        msgStr = [NSString stringWithFormat:@"@系统提示 %@退出房间",sendUser];
    }else{
        msgStr = dicSend[@"msg"];
    }
    
    float nowHeight = [ZYHCommonService heightForString:msgStr fontSize:TEXTFONT+3 andWidth:strWight];
    nowHeight += 5;
    if (nowHeight<25) {
        return 25;
    }
    return nowHeight;
}

#pragma mark 输入框
-(void)addSureBtnOnKeyboardBar{
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(changeTxtResponder)];
    [doneButton setTintColor:fRgbColor(60, 180, 240)];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [txtTalk setInputAccessoryView:topView];
}

- (void) registerForKeyboardNotifications{
    keyWordHight=0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}


- (void) keyboardWasShown:(NSNotification *) notif{

//    NSDictionary *userInfo = [notif userInfo];
//    //创建value来获取 userinfo里的键盘frame大小
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    //创建cgrect 来获取键盘的值
//    CGRect keyboardRect = [aValue CGRectValue];
//    //最后获取高度 宽度也是同理可以获取
//    keyWordHight = keyboardRect.size.height+35;
//
//    isKeyShow=YES;
//    isMove = YES;
//    NSLog(@"keyBoard:%f", keyWordHight);  //250
//    [UIView animateWithDuration:0.1
//                     animations:^{
//                         self.frame=CGRectMake(self.frame.origin.x, 0-keyWordHight, self.frame.size.width, self.frame.size.height);
//                     }
//                     completion:nil];
}

- (void) keyboardDidShown:(NSNotification *) notif{
    if (isKeyShow) {
        return;
    }
    NSDictionary *userInfo = [notif userInfo];
    //创建value来获取 userinfo里的键盘frame大小
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //创建cgrect 来获取键盘的值
    CGRect keyboardRect = [aValue CGRectValue];
    //最后获取高度 宽度也是同理可以获取
    keyWordHight = keyboardRect.size.height+35;
    
    isKeyShow=YES;
    isMove = YES;
    NSLog(@"keyBoard did show:%f", keyWordHight);  //250
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.frame=CGRectMake(self.frame.origin.x, 0-keyWordHight, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}

- (void) keyboardWasHidden:(NSNotification *) notif{
    isKeyShow=NO;
    if (!isMove) {
        return;
    }
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}

#pragma mark - 指令执行
-(void)actionTapSelf{
    if(isKeyShow){
        [self changeTxtResponder];
    }else{
        [self livePlayingControl:8 sender:nil];
    }
}

-(void)actionCloseLivePlaying:(UIButton *)sender{
    [self livePlayingControl:7 sender:sender];
}

-(void)actionConncetReplace:(UIButton *)sender{
    [self livePlayingControl:6 sender:sender];
}

-(void)actionShowMoreControlView{
}

-(void)actionSendMsg:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(livePlayingSendMsg:sender:)]) {
        [self.delegate livePlayingSendMsg:txtTalk.text sender:sender];
    }
}

-(void)actionShowKey{
    
//    NSUserDefaults * userDefaults =[NSUserDefaults standardUserDefaults];
//    NSDictionary * dicHaveLoad =[userDefaults objectForKey:@"userHaveLoad"];
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"WX_ACCESS_TOKEN"];
//    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:@"WX_OPEN_ID"];
    
    
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
//    [userDef setObject:dicResult forKey:@"getWeChatPremiss"];
    NSDictionary * dicHaveLoad =[userDef objectForKey:@"getWeChatPremiss"];
    
    
    
    if (dicHaveLoad) {
        [self changeTxtShow:YES];
    }else{
        
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:nil message:@"\n是否微信授权登录？\n"];
        [self addSubview:alert];
        [alert bk_addButtonWithTitle:@"确定"
                             handler:^{
                                 [self livePlayingControl:9 sender:nil];
                             }];
        [alert bk_setCancelButtonWithTitle:@"取消"
                                   handler:^{
                                   }];
        [alert show];
    }
}

-(void)changeTxtShow:(BOOL)isShow{
    if (isShow) {
        [txtTalk becomeFirstResponder];
    }
    btnMore.hidden = isShow;
    btnSend.hidden = !isShow;
    txtTalk.hidden = !isShow;
}

-(void)setClearTxtView{
    txtTalk.text = @"";
}


-(void)livePlayingControl:(int)btnNum sender:(id)sender{
  //  controlView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(livePlayingLayout:sender:)]) {
        [self.delegate livePlayingLayout:btnNum sender:sender];
    }
    
    if (btnNum == -1) {
        return;
    }else if (btnNum == 0) {//旋转
        isScreenRotate =!isScreenRotate;
        if (!isScreenRotate) {
            
            cellConWidth = kNMDeviceWidth * 0.7;
            CGAffineTransform spin = CGAffineTransformMakeRotation(0);
            [self setTransform:spin];
            [self setViewFrame];
        }else{
            
            cellConWidth = kNMDeviceHeight * 0.7;
            CGAffineTransform spin = CGAffineTransformMakeRotation(-M_PI/2);
            [self setTransform:spin];
            [self setAllViewFrame];
        }
        self.frame =CGRectMake(0, 0, kNMDeviceWidth,kNMDeviceHeight);
        [self reloadConversationTabelView:nil];
    }
}

-(void)actionChangeVolume:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        panPoint = [sender translationInView:self];
        
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint newPoint = [sender translationInView:self];
        float w =fabsf(newPoint.x -panPoint.x);
        float h = fabsf(newPoint.y - panPoint.y);
        
            if ([self.delegate respondsToSelector:@selector(livePlayingChangeViewShow:type:)]) {
                if (newPoint.x<(kNMDeviceWidth/2)&&h>w) {
                    [self.delegate livePlayingChangeViewShow:(newPoint.y - panPoint.y) type:1];
                }else if (newPoint.x>(kNMDeviceWidth/2)&&h>w) {
                    [self.delegate livePlayingChangeViewShow:(newPoint.y - panPoint.y) type:2];
                    
                }
                
               
            }
        
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        
    }else if (sender.state == UIGestureRecognizerStateCancelled) {
        
    }else if (sender.state == UIGestureRecognizerStateFailed) {
        
    }else{
        
    }
}


-(void)layoutViewOrientationChange:(NSNotification *)notification{
    if (!isScreenRotate) {
        return;
    }
    //宣告一個UIDevice指標，並取得目前Device的狀況
    UIDevice *device = [UIDevice currentDevice] ;
    NSNumber *value;
    //取得當前Device的方向，來當作判斷敘述。（Device的方向型態為Integer）
    static CGFloat angle = 0;
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"螢幕朝上平躺");
            break;

        case UIDeviceOrientationFaceDown:
            NSLog(@"螢幕朝下平躺");
            break;

            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;

        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"螢幕向左橫置");
            angle = M_PI/2;
            value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
            break;

        case UIDeviceOrientationLandscapeRight:
            NSLog(@"螢幕向右橫置");
            angle = -M_PI/2;
            value =[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
            break;

        case UIDeviceOrientationPortrait:
            NSLog(@"螢幕直立");
            angle = 0;
            value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            break;

        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"螢幕直立，上下顛倒");
//            angle = -M_PI;
//            value = [NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown];
            break;

        default:
            NSLog(@"無法辨識");
            break;
    }
    
    if(angle){
        CGAffineTransform spin = CGAffineTransformMakeRotation(angle);
        [self setTransform:spin];
    }
    
//    if(angle == M_PI/2||angle == -M_PI/2){
//        self.frame =CGRectMake(0, 0, kNMDeviceWidth,kNMDeviceHeight);
//        [self setAllViewFrame];
//    }
    
}

#pragma mark UITextViewDelegate
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    [self keyboardWasShown:nil];
//    return YES;
//
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView{
//    [self keyboardWasHidden:nil];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self changeTxtShow:NO];
    return YES;
}

-(void)changeTxtResponder{
    [txtTalk resignFirstResponder];
    [self changeTxtShow:NO];
}

@end
