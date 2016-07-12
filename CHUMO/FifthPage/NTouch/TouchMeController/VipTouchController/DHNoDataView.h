//
//  DHNoDataView.h
//  CHUMO
//
//  Created by xy2 on 16/2/18.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DHNoDataView;
@protocol DHNoDataViewDelegate <NSObject>
/**
 *  点击事件代理
 *
 *  @param emptyView 所在无数据视图
 *  @param btnTag    点击按钮的tag
 */
- (void)emptyView:(DHNoDataView *)emptyView btnTag:(NSInteger )btnTag;

@end
@interface DHNoDataView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *nodataImageView;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
/**
 *  来自哪个页面 1、我触动的，2、触动我的，3、谁看过我
 */
//@property (assign, nonatomic) NSInteger fromWhere;
@property (nonatomic , assign)id<DHNoDataViewDelegate>delegate;
@end
