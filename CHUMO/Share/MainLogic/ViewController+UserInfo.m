//
//  ViewController+UserInfo.m
//  CHUMO
//
//  Created by xy2 on 16/3/12.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "ViewController+UserInfo.h"

@implementation ViewController (UserInfo)
//- (void)login{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
//    NSString *username = [dict objectForKey:@"userName"];
//    NSString *password = [dict objectForKey:@"password"];
//    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
//    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@",kServerAddressTest,username,password];
//    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSData *datas = responseObject;
//        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
//        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
//        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
//        NSDictionary *dict2 = infoDic[@"body"];
//        NSNumber *codeNum = infoDic[@"code"];
//        if ([codeNum intValue] == 200) {
//            // 保存账号 密码
//            [NSGetTools updateUserAccount:username];
//            [NSGetTools updateUserPassWord:password];
//            // 保存用户ID
//            [NSGetTools upDateUserID:dict2[@"b80"]];
//            // 保存用户SessionId
//            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
//            [NSGetTools updateIsLoadWithStr:@"isLoad"];
//            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"regUser"];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self asyncLoadRobotsToDBWithUserId:dict2[@"b80"] sessionId:dict2[@"b101"]];
//                [self connectEaseModWithUserId:[NSString stringWithFormat:@"%@",dict2[@"b80"]] password:password];
//            });
//        }else if ([codeNum intValue] == 207){
//            [NSGetTools showAlert:@"密码输入错误"];
//        }else if ([codeNum intValue] == 206){
//            [NSGetTools showAlert:@"用户信息审核不通过,请检查用户信息,或者联系客服人员"];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error.userInfo);
//    }];
//}
//// 请求用户信息
//- (void)getUserInfosWithp1:(NSString *)p1 p2:(NSString *)p2{
//    
//    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
//    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    NSString *appinfoStr = [NSGetTools getAppInfoString];
//    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
//    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSData *datas = responseObject;
//        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
//        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
//        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
//        NSNumber *codeNum = infoDic[@"code"];
//        if ([codeNum intValue] == 200) {
//            NSDictionary *dict2 = infoDic[@"body"];
//            DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
//            [item setValuesForKeysWithDictionary:[dict2 objectForKey:@"b112"]];
//            [item setValuesForKeysWithDictionary:dict2];
//            if (![DBManager checkUserWithUsertId:item.b80]) {
//                [DBManager insertUserToDBWithItem:item];
//            }else{
//                [DBManager updateUserToDBWithItem:item userId:item.b80];
//            }
//            NSNumber *b34 = [dict2 objectForKey:@"b112"][@"b34"];
//            [NSGetTools upDateB34:b34];
//            NSNumber *b144 = [dict2 objectForKey:@"b112"][@"b144"];
//            [NSGetTools upDateUserVipInfo:b144];
//            NSNumber *b69 = [dict2 objectForKey:@"b112"][@"b69"];
//            [NSGetTools updateUserSexInfoWithB69:b69];
//            // 系统生成用户号
//            NSString *b152 = [[dict2 objectForKey:@"b112"] objectForKey:@"b152"];
//            [[NSUserDefaults standardUserDefaults] setObject:b152 forKey:@"b152"];
//            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"] forKey:@"nickName"];
//            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b17"] forKey:@"b17"];
//            [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"loginUser"];
//            // 是会员就不再骚扰
//            if ([item.b144 integerValue] == 2) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [self pushfirstNotificationWithUserInfo:item];
//                });
//            }
//            NSString *date = [[[DHTool shareTool] stringFromDate:[NSDate date]] substringToIndex:10];
//            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//            NSInteger recommendTime = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"recommend-%@-%@",date,userId]];
//            NSInteger recommend_sendMsgTimes = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"recommend_sendMsg-%@-%@",date,userId]];
//            if (recommendTime <= 10 && recommend_sendMsgTimes <= 3) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [self asyncLoadRecommend];
//                });
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"===error-%@",error.userInfo);
//    }];
//}
@end
