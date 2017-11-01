//
//  nmNoDataView.h
//  nmLiveWatch
//
//  Created by zyh on 2017/10/31.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class nmNoDataView;
@protocol nmNoDataViewDelegate <NSObject>
-(void)noDataViewReloadData:(nmNoDataView *)view;
@end

@interface nmNoDataView : UIView{
    UIImageView * errorImg;
    UILabel * errorLab;
}
@property(nonatomic,strong)NSString * errorStr;
@property(nonatomic,weak)id<nmNoDataViewDelegate> delegate;
-(void)setNoDataView;
@end
