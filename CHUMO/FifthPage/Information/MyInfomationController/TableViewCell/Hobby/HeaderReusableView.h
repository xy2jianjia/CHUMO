//
//  HeaderReusableView.h
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderReusableView : UICollectionReusableView {

    UIView *view;
    UIView *titleView;
}
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIButton *update; // 用于更新
@property (nonatomic,strong)UIButton *secUpdate;
@property (nonatomic,strong)UIButton *footButton; 
@property (nonatomic,strong)UIButton *secFootButton;

@end
