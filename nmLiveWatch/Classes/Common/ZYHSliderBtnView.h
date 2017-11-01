//
//  ZYHSliderBtnView.h
//  hotel
//
//  Created by 周宇航 on 2016/12/20.
//  Copyright © 2016年 zj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYHSliderBtnViewDelegate;
@interface ZYHSliderBtnView : UIView<UIScrollViewDelegate>{
    //UIScrollView *_rootScrollView;                  //主视图
    UIScrollView *_topScrollView;                   //顶部页签视图
    
    CGFloat _userContentOffsetX;
    BOOL _isLeftScroll;                             //是否左滑动
    BOOL _isRootScroll;                             //是否主视图滑动
    BOOL _isBuildUI;                                //是否建立了ui
    
    NSInteger _userSelectedChannelID;               //点击按钮选择名字ID
    
    UIImageView *_shadowImageView;
    UIImage *_shadowImage;
    
    UIColor *_tabItemNormalColor;                   //正常时tab文字颜色
    UIColor *_tabItemSelectedColor;                 //选中时tab文字颜色
    UIImage *_tabItemNormalBackgroundImage;         //正常时tab的背景
    UIImage *_tabItemSelectedBackgroundImage;       //选中时tab的背景
    NSMutableArray *_viewArray;                     //主视图的子视图数组
    
    NSMutableArray *_titleArray;//top文字数组
    NSMutableArray *arrAllBtn;//所有按钮
    UIButton *_rigthSideButton;                     //右侧按钮
    
 
}

@property (nonatomic, assign) CGFloat userContentOffsetX;
@property (nonatomic, assign) NSInteger userSelectedChannelID;
@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;
@property (nonatomic, weak) id<ZYHSliderBtnViewDelegate> delegate;
@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;
@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) NSArray *viewArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) IBOutlet UIButton *rigthSideButton;
-(void)zyhSliderBtnViewchange:(NSString *)name status:(NSString *)status;
/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)buildUI;

/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
//+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

-(void)selectBtn:(int)num;
@end

@protocol ZYHSliderBtnViewDelegate <NSObject>

@required

/*!
 * @method 顶部tab个数
 * @abstract
 * @discussion
 * @param 本控件
 * @result tab个数
 */
- (NSUInteger)zyhNumberOfTab:(ZYHSliderBtnView *)view;

/*!
 * @method 每个tab所属的viewController
 * @abstract
 * @discussion
 * @param tab索引
 * @result viewController
 */
- (UIViewController *)slideZYHSwitchView:(ZYHSliderBtnView *)view viewOfTab:(NSUInteger)number;

@optional

/*!
 * @method 滑动左边界时传递手势
 * @abstract
 * @discussion
 * @param   手势
 * @result
 */
- (void)slideZYHSwitchView:(ZYHSliderBtnView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 滑动右边界时传递手势
 * @abstract
 * @discussion
 * @param   手势
 * @result
 */
- (void)slideZYHSwitchView:(ZYHSliderBtnView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 点击tab
 * @abstract
 * @discussion
 * @param tab索引
 * @result
 */
- (void)slideZYHSwitchView:(ZYHSliderBtnView *)view didselectTab:(NSUInteger)number btnSender:(UIButton*)sender;


@end
