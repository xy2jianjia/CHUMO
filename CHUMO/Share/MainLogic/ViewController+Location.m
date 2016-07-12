//
//  ViewController+Location.m
//  CHUMO
//
//  Created by xy2 on 16/3/12.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "ViewController+Location.h"
@implementation ViewController (Location)
// 定位
- (void)configLocationManager {
    self.geocoder = [[CLGeocoder alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.f;
    NSString *m8 = [[UIDevice currentDevice] systemVersion];// 系统版本号
    if ([m8 floatValue] >= 8) {
        [self.locationManager requestAlwaysAuthorization];//ios8以后添加这句
    }
    [self.locationManager startUpdatingLocation];
}

// 定位代理
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    double latitude = currentLocation.coordinate.latitude;// 纬度
    double longitude = currentLocation.coordinate.longitude;// 经度
    self.latitudeStr = [NSString stringWithFormat:@"%f", latitude];
    self.longitudeStr = [NSString stringWithFormat:@"%f", longitude];
    // 1.既然已经定位到了用户当前的经纬度了,那么可以让定位管理器 停止定位了
    [self.locationManager stopUpdatingLocation];
    // 2.然后,取出第一个位置,根据其经纬度,通过CLGeocoder反向解析,获得该位置所在的城市名称,转成城市对象,用工具保存
    CLLocation *loc = locations[0];
    // 3.CLGeocoder反向通过经纬度,获得城市名
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        // 从字典中取出 state---->某某市
        CLPlacemark *place = placemarks[0];
        // 市
        NSString *cityStr = place.addressDictionary[@"City"];
        // 省
        NSString *stateStr = place.addressDictionary[@"State"];
        //获取plist中的数据
        NSDictionary *cityDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cityCode" ofType:@"plist"]];
        NSDictionary *stateDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"provinceCode" ofType:@"plist"]];
        NSDictionary *cityCodeDict = cityDict[cityStr];
        NSDictionary *stateCodeDict = stateDict[stateStr];
        NSString *a9 = cityCodeDict[@"city_code"];
        NSString *a67 = stateCodeDict[@"provence_code"];
        CGFloat a40 = latitude;// 经
        CGFloat a38 = longitude;// 纬
        NSNumber *a38Num = [NSNumber numberWithFloat:a38];
        NSNumber *a40Num = [NSNumber numberWithFloat:a40];
        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:a9,@"a9",a67,@"a67",a38Num,@"a38",a40Num,@"a40", nil];
//        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:a9,@"a9",a67,@"a67",a38Num,@"a38",a40Num,@"a40", nil];
        [NSGetTools updateCLLocationWithDict:cllDict];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateGPS:cllDict];
        });
        
    }];
}
- (void)updateGPS:(NSMutableDictionary *)dict{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
    //字典反,写反
    NSString *url = [NSString stringWithFormat:@"%@f_112_11_2.service?a40=%@&a38=%@&a67=%@&a9=%@&p1=%@&p2=%@&%@",kServerAddressTest2,[dict objectForKey:@"a40"],[dict objectForKey:@"a38"],[dict objectForKey:@"a67"],[dict objectForKey:@"a9"],p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
}
// 定位失败代理
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied){
//        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"330100",@"a9",@"330000",@"a67",@"30.291924863746186",@"a38",@"120.0842098311915",@"a40", nil];
        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"330100",@"a9",@"330000",@"a67",@"120.0842098311915",@"a38",@"30.291924863746186",@"a40", nil];
        [NSGetTools updateCLLocationWithDict:cllDict];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
//        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"330100",@"a9",@"330000",@"a67",@"30.291924863746186",@"a38",@"120.0842098311915",@"a40", nil];
        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"330100",@"a9",@"330000",@"a67",@"120.0842098311915",@"a38",@"30.291924863746186",@"a40", nil];
        [NSGetTools updateCLLocationWithDict:cllDict];
    }
}

@end
