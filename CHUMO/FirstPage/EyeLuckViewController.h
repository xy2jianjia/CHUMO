//
//  EyeLuckViewController.h
//  StrangerChat
//
//  Created by long on 15/10/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SDCycleScrollView.h"
@interface EyeLuckViewController : UICollectionViewController <CLLocationManagerDelegate,SDCycleScrollViewDelegate>

// 定位使用
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) CLGeocoder *geocoder;
@property (nonatomic,strong) NSString *latitudeStr;
@property (nonatomic,strong) NSString *longitudeStr;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UIImageView *rangeimageV;
@property (nonatomic,strong) UILabel *rangeLabel;
@property (nonatomic,strong) UIButton *starButton;
@property (nonatomic,strong) UIImageView *imageView2 ;
@property (nonatomic,strong) UIImageView *vipImageV;
@property (nonatomic,strong) NSMutableArray *bannerArr;
@end
