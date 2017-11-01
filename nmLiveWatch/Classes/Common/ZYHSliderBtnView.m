//
//  ZYHSliderBtnView.m
//  hotel
//
//  Created by 周宇航 on 2016/12/20.
//  Copyright © 2016年 zj. All rights reserved.
//

#import "ZYHSliderBtnView.h"
#import "devBtn.h"

static CGFloat kHeightOfTopScrollView = 40.0f;
static CGFloat kWightOfTopScrollView = 40.0f;
static CGFloat kOriginXOfTopScrollView = 0.0f;
static CGFloat kWidthOfBtnName = 89.0f;

static const CGFloat kWidthOfButtonMargin = 0.0f;
static const CGFloat kFontSizeOfTabButton = 13.0f;
static const NSUInteger kTagOfRightSideButton = 999;


@implementation ZYHSliderBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)initValues
{
    //创建顶部可滑动的tab
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kOriginXOfTopScrollView, kWightOfTopScrollView, kHeightOfTopScrollView)];
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor clearColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_topScrollView];
    _userSelectedChannelID = 100;
    
    //    //创建主滚动视图
    //    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeightOfTopScrollView, self.bounds.size.width, self.bounds.size.height - kHeightOfTopScrollView)];
    //    _rootScrollView.delegate = self;
    //    _rootScrollView.pagingEnabled = YES;
    //    _rootScrollView.userInteractionEnabled = YES;
    //    _rootScrollView.bounces = NO;
    //    _rootScrollView.showsHorizontalScrollIndicator = NO;
    //    _rootScrollView.showsVerticalScrollIndicator = NO;
    //    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    //    _userContentOffsetX = 0;
    //    [_rootScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    //    [self addSubview:_rootScrollView];
    
    _viewArray = [[NSMutableArray alloc] init];
    
    _isBuildUI = NO;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        kHeightOfTopScrollView=frame.size.height;
        kWightOfTopScrollView=frame.size.width;
        kOriginXOfTopScrollView=frame.origin.x;
        [self initValues];
    }
    return self;
}

#pragma mark getter/setter

- (void)setRigthSideButton:(UIButton *)rigthSideButton
{
    UIButton *button = (UIButton *)[self viewWithTag:kTagOfRightSideButton];
    [button removeFromSuperview];
    rigthSideButton.tag = kTagOfRightSideButton;
    _rigthSideButton = rigthSideButton;
    [self addSubview:_rigthSideButton];
    
}

#pragma mark - 创建控件

//当横竖屏切换时可通过此方法调整布局
- (void)layoutSubviews
{
    //创建完子视图UI才需要调整布局
    if (_isBuildUI) {
        //如果有设置右侧视图，缩小顶部滚动视图的宽度以适应按钮
        if (self.rigthSideButton.bounds.size.width > 0) {
            _rigthSideButton.frame = CGRectMake(self.bounds.size.width - self.rigthSideButton.bounds.size.width, 0,
                                                _rigthSideButton.bounds.size.width, _topScrollView.bounds.size.height);
            
            _topScrollView.frame = CGRectMake(0, 0,
                                              self.bounds.size.width - self.rigthSideButton.bounds.size.width, kHeightOfTopScrollView);
        }
              //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        [self adjustScrollViewContentX:button];
    }
}

/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)buildUI
{
    
    [_viewArray removeAllObjects];
    NSUInteger number = [self.delegate zyhNumberOfTab:self];
    for (int i=0; i<number; i++) {
        UIViewController *vc = [self.delegate slideZYHSwitchView:self viewOfTab:i];
        [_viewArray addObject:vc];
        // [_rootScrollView addSubview:vc.view];
    }
    
    [self createNameButtons];
    
      _isBuildUI = YES;
    
    //创建完子视图UI才需要调整布局
    [self setNeedsLayout];
}

-(void)selectBtn:(int)num{
    devBtn * btn=arrAllBtn[num];
    [self selectNameButton:btn];
}

/*!
 * @method 初始化顶部tab的各个按钮
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)createNameButtons
{
    
    _shadowImageView = [[UIImageView alloc] init];
    [_shadowImageView setImage:_shadowImage];
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = kWidthOfButtonMargin;
    //每个tab偏移量
    CGFloat xOffset = kWidthOfButtonMargin;
    arrAllBtn=[NSMutableArray arrayWithCapacity:0];
    if ([_viewArray count]<4) {
         CGSize textSize=CGSizeMake(kWightOfTopScrollView/_viewArray.count, kHeightOfTopScrollView);
        for (int i = 0; i < [_viewArray count]; i++) {
            devBtn *button = [[devBtn alloc]init];
            [button setTag:i+100];
            //累计每个tab文字的长度
            topScrollViewContentWidth += kWidthOfButtonMargin+textSize.width;
            //设置按钮尺寸
            [button setFrame:CGRectMake(xOffset,0,
                                        textSize.width, kHeightOfTopScrollView)];
            //计算下一个tab的x偏移量
            xOffset += textSize.width + kWidthOfButtonMargin;
//            NSDictionary * dic=_titleArray[i];
//
//            button.labName.font=[UIFont systemFontOfSize:13];
//            button.labName.textColor=[UIColor whiteColor];
//
//            NSData * data1 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:dic[@"icon"]]];
//            UIImage *image1 = [[UIImage alloc]initWithData:data1];
//
//            NSData * data2 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:dic[@"activeIcon"]]];
//            UIImage *image2 = [[UIImage alloc]initWithData:data2];
//
//            button.imgDef=image1;
//            button.imgSel=image2;

            button.theSelStr=_titleArray[i];//dic[@"keyName"];
            button.theStr=_titleArray[i];//dic[@"keyName"];
            [button setDevBtn];
            
            button.selected=NO;
            [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
            [_topScrollView addSubview:button];
            [arrAllBtn addObject:button];
        }
        
    }else{
        
        for (int i = 0; i < [_viewArray count]; i++) {
            // UIViewController *vc = _viewArray[i];
            devBtn *button = [[devBtn alloc]init];
            CGSize textSize=CGSizeMake(kWightOfTopScrollView/4, kHeightOfTopScrollView);
            
            //累计每个tab文字的长度
            topScrollViewContentWidth += kWidthOfButtonMargin+textSize.width;
            //设置按钮尺寸
            [button setFrame:CGRectMake(xOffset,0,
                                        textSize.width, kHeightOfTopScrollView)];
            //计算下一个tab的x偏移量
            xOffset += textSize.width + kWidthOfButtonMargin;
            
            [button setTag:i+100];
            if (i == 0) {
                _shadowImageView.frame = CGRectMake(topScrollViewContentWidth, kHeightOfTopScrollView-_shadowImage.size.height, textSize.width, 10);
                button.selected = YES;
            }
//            NSDictionary * dic=_titleArray[i];
//
//            button.labName.font=[UIFont systemFontOfSize:13];
//            button.labName.textColor=[UIColor whiteColor];
//            NSData * data1 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:dic[@"icon"]]];
//            UIImage *image1 = [[UIImage alloc]initWithData:data1];
//
//            NSData * data2 = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:dic[@"activeIcon"]]];
//            UIImage *image2 = [[UIImage alloc]initWithData:data2];
//
//            button.imgDef=image1;
//            button.imgSel=image2;
            button.theSelStr=_titleArray[i];//dic[@"keyName"];
            button.theStr=_titleArray[i];//dic[@"keyName"];
            [button setDevBtn];
            button.selected=NO;
            [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
            [_topScrollView addSubview:button];
            _topScrollView.layer.masksToBounds=NO;
            [arrAllBtn addObject:button];
            
        }
 
    }
    
    [_topScrollView addSubview:_shadowImageView];
    _shadowImageView.opaque=YES;
    _shadowImageView.layer.zPosition=100;
    
    //设置顶部滚动视图的内容总尺寸
    _topScrollView.contentSize = CGSizeMake(topScrollViewContentWidth, kHeightOfTopScrollView);
}

-(void)zyhSliderBtnViewchange:(NSString *)name status:(NSString *)status{
    for (devBtn * btn in arrAllBtn) {
        if ([btn.theStr isEqualToString:name]) {
            if ([status isEqualToString:@"on"]) {
                btn.selected=1;
            }else{
                 btn.selected=0;
            }
            [btn changeDevBtnShow];
        }
    }
   
   
}
#pragma mark - 顶部滚动视图逻辑方法

/*!
 * @method 选中tab时间
 * @abstract
 * @discussion
 * @param 按钮
 * @result
 */
- (void)selectNameButton:(devBtn *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    for (devBtn * btn in arrAllBtn){
        if (![btn isEqual:sender]) {
            btn.selected=0;
            [btn changeDevBtnShow];
        }
    }

    //如果更换按钮
    if (sender.tag != _userSelectedChannelID) {
        //取之前的按钮
//        devBtn *lastButton = (devBtn *)[_topScrollView viewWithTag:_userSelectedChannelID];
//        lastButton.selected = NO;
//        [lastButton changeDevBtnShow];
        //赋值按钮ID
        
       
        
        _userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        [UIView animateWithDuration:0.25 animations:^{
            
            [_shadowImageView setFrame:CGRectMake(sender.frame.origin.x, kHeightOfTopScrollView-_shadowImage.size.height, sender.frame.size.width, 10)];
            
        } completion:^(BOOL finished) {
            if (finished) {

                _isRootScroll = NO;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(slideZYHSwitchView:didselectTab:btnSender:)]) {
                    [self.delegate slideZYHSwitchView:self didselectTab:_userSelectedChannelID - 100 btnSender:sender];
                }
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        
//        sender.selected = NO;
        [sender changeDevBtnShow];
        if (self.delegate && [self.delegate respondsToSelector:@selector(slideZYHSwitchView:didselectTab:btnSender:)]) {
            [self.delegate slideZYHSwitchView:self didselectTab:_userSelectedChannelID - 100 btnSender:sender];
        }

    }
}

/*!
 * @method 调整顶部滚动视图x位置
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    //如果 当前显示的最后一个tab文字超出右边界
    if (sender.frame.origin.x - _topScrollView.contentOffset.x > self.bounds.size.width - (kWidthOfButtonMargin+sender.bounds.size.width)) {
        //向左滚动视图，显示完整tab文字
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (_topScrollView.bounds.size.width- (kWidthOfButtonMargin+sender.bounds.size.width)), 0)  animated:YES];
    }
    
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (sender.frame.origin.x - _topScrollView.contentOffset.x < kWidthOfButtonMargin) {
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - kWidthOfButtonMargin, 0)  animated:YES];
    }
}

#pragma mark 主视图逻辑方法

//滚动视图开始时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    if (scrollView == _rootScrollView) {
    //        _userContentOffsetX = scrollView.contentOffset.x;
    //    }
}

//滚动视图结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if (scrollView == _rootScrollView) {
    //        //判断用户是否左滚动还是右滚动
    //        if (_userContentOffsetX < scrollView.contentOffset.x) {
    //            _isLeftScroll = YES;
    //        }
    //        else {
    //            _isLeftScroll = NO;
    //        }
    //    }
}

//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    if (scrollView == _rootScrollView) {
    //        _isRootScroll = YES;
    //        //调整顶部滑条按钮状态
    //        int tag = (int)scrollView.contentOffset.x/self.bounds.size.width +100;
    //        UIButton *button = (UIButton *)[_topScrollView viewWithTag:tag];
    //        [self selectNameButton:button];
    //    }
}

//传递滑动事件给下一层
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    //    //当滑道左边界时，传递滑动事件给代理
    //    if(_rootScrollView.contentOffset.x <= 0) {
    //        if (self.slideSwitchViewDelegate
    //            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)]) {
    //            [self.slideSwitchViewDelegate slideSwitchView:self panLeftEdge:panParam];
    //        }
    //    } else if(_rootScrollView.contentOffset.x >= _rootScrollView.contentSize.width - _rootScrollView.bounds.size.width) {
    //        if (self.slideSwitchViewDelegate
    //            && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panRightEdge:)]) {
    //            [self.slideSwitchViewDelegate slideSwitchView:self panRightEdge:panParam];
    //        }
    //    }
}


@end
