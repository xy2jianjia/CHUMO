//
//  NearPeopleViewController.h
//  StrangerChat
//
//  Created by long on 15/11/4.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface NearPeopleViewController : UIViewController <CLLocationManagerDelegate>

// 定位使用
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) CLGeocoder *geocoder;
@property (nonatomic,strong) NSString *latitudeStr;
@property (nonatomic,strong) NSString *longitudeStr;

@end
