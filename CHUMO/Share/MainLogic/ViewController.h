//
//  ViewController.h
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <CoreLocation/CoreLocation.h>
#import "DHCityRecommendView.h"
#import "DHBlackListDao.h"
#import "DHActivityAlertView.h"
#import "DHRecommedViewV1.h"

@interface ViewController : UITabBarController<UIAlertViewDelegate,DHActivityAlertViewDelegate,DHRecommedViewV1Delegate>
// 定位使用
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic,strong) NSString *latitudeStr;
@property (nonatomic,strong) NSString *longitudeStr;

@property (nonatomic,strong) DHUserInfoModel *userinfo;

@property (nonatomic,strong) NSMutableString *ids;
@property (nonatomic,strong) NSMutableArray *recommendArr;
@property (nonatomic,assign) NSInteger sendMessageTimes;// 发消息次数
@property (nonatomic,assign) NSInteger recommendTimes;// 推荐次数
@property (nonatomic,strong) NSTimer *recommendTimer;


@property (nonatomic,assign) NSInteger sendMessageTotalTimes;// 发消息次数
@property (nonatomic,assign) NSInteger recommendTotalTimes;// 推荐次数
@property (nonatomic,assign) NSInteger reconnectedTimes;// 没有数据请求次数

@property (nonatomic,strong) NSMutableArray *bannerArr;
/**
 *  朋友列表
 */
@property (nonatomic,strong) NSMutableArray *friendArr;
- (UIViewController *)getCurrentVC;
@end

