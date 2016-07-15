//
//  HttpOperation.m
//  CHUMO
//
//  Created by xy2 on 16/4/25.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "HttpOperation.h"

@implementation HttpOperation
+ (id)shareInstance{
    static HttpOperation *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HttpOperation alloc]init];
    });
    return manager;
}
- (id)getManager{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    return manger;
}
+ (void)asyncRegisterWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *registerInfo))completed{
    [[HttpOperation shareInstance] asyncRegisterWithQueue:queue completed:completed];
}
- (void)asyncRegisterWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *registerInfo))completed{
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *result = [identifierForVendor stringByReplacingOccurrencesOfString:@"-" withString:@""];
    AFHTTPRequestOperationManager *manger = [self getManager];
    NSString *url = [NSString stringWithFormat:@"%@f_119_11_1.service?a151=%@",kServerAddressTest,result];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        NSDictionary *dict2 = infoDic[@"body"];
        //  注册成功,将信息保存到服务器
        if ([codeNum integerValue] == 200) {
            //b101 sessionId sessionID
            //b80 userId 用户ID
            //b56 password 密码
            //b81 userName 用户名称
            NSString *password = [dict2 objectForKey:@"b56"];
            NSString *userName = [dict2 objectForKey:@"b81"];
            NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",password,@"password",dict2[@"b80"],@"userId",dict2[@"b101"],@"sessionId",dict2[@"b80"],@"gender", nil];
            [[NSUserDefaults standardUserDefaults] setObject:dict1 forKey:@"regUser"];
            [MobClick event:@"registerSuccess"]; // 注册统计事件
            // 成功统计
            [self collectSaveWithStatus:3];
            dispatch_async(queue == nil ? dispatch_get_main_queue():queue, ^{
                completed(dict2);
            });
            // 登陆
            [self asyncAutoLogin];
        }else{
            // 失败统计
            [self collectSaveWithStatus:4];
            [NSGetTools showAlert:[infoDic objectForKey:@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissVC" object:@YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
/**
 *  保存统计信息 --by大海 2016年06月28日15:35:48
 */
- (void)collectSaveWithStatus:(NSInteger )status{
    [HttpOperation asyncCollectSaveWithUserType:status queue:dispatch_get_main_queue() completed:^(NSString *msg, NSInteger code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"保存注册统计" message:msg delegate:nil cancelButtonTitle:[NSString stringWithFormat:@"%ld",code] otherButtonTitles:nil, nil];
            //            [alert show];
        });
    }];
}
- (void)asyncAutoLogin{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *username = [dict objectForKey:@"userName"];
    NSString *password = [dict objectForKey:@"password"];
    [self asyncLoginWithUserName:username password:password queue:dispatch_get_main_queue() completed:^(NSDictionary *loginInfo) {
        
    }];
}
+ (void)asyncLoginWithUserName:(NSString *)username password:(NSString *)password queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *loginInfo))completed{
    [[HttpOperation shareInstance] asyncLoginWithUserName:username password:password queue:queue completed:completed];
}
- (void)asyncLoginWithUserName:(NSString *)username password:(NSString *)password queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *loginInfo))completed{
    AFHTTPRequestOperationManager *manger = [self getManager];
    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@",kServerAddressTest,username,password];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            // 保存账号 密码
            [NSGetTools updateUserAccount:username];
            [NSGetTools updateUserPassWord:password];
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
            [NSGetTools updateIsLoadWithStr:@"isLoad"];
            NSDictionary *temp = [NSDictionary dictionaryWithObjectsAndKeys:username,@"userName",password,@"password",dict2[@"b80"],@"userId",dict2[@"b101"],@"sessionId",dict2[@"b80"],@"gender", nil];
            [[NSUserDefaults standardUserDefaults] setObject:temp forKey:@"regUser"];
            dispatch_async(queue == nil ? dispatch_get_main_queue():queue, ^{
                completed(dict2);
            });
        }else if ([codeNum intValue] == 207){
            [NSGetTools showAlert:@"密码输入错误"];
        }else if ([codeNum intValue] == 206){
            [NSGetTools showAlert:@"用户信息审核不通过,请检查用户信息,或者联系客服人员"];
        }else{
            [NSGetTools showAlert:[infoDic objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncSaveUserInfoWithUserInfoDict:(NSDictionary *)userInfoDict queue:(dispatch_queue_t )queue completed:(void(^)(NSString *b34))completed{
    [[HttpOperation shareInstance] asyncSaveUserInfoWithUserInfoDict:userInfoDict queue:queue completed:completed];
}
//保存信息
- (void)asyncSaveUserInfoWithUserInfoDict:(NSDictionary *)userInfoDict queue:(dispatch_queue_t )queue completed:(void(^)(NSString *b34))completed{
//    NSString *appInfo = [NSGetTools getAppInfoString];
    AFHTTPRequestOperationManager *manger = [self getManager];
    //a34:id a69：性别
    NSString *url = [NSString stringWithFormat:@"%@f_108_11_2.service",kServerAddressTest2];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger POST:url parameters:userInfoDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum integerValue] == 200) {
            NSString *b34 = [dict2 objectForKey:@"b34"];
            [NSGetTools upDateB34:[NSNumber numberWithInteger:[b34 integerValue]]];
            dispatch_async(queue == nil ? dispatch_get_main_queue():queue, ^{
                completed(b34);
            });
        }else{
            [NSGetTools showAlert:infoDic[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncGetUserInfoWithUserId:(NSString *)p2 queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *info,DHUserInfoModel *userInfoModel))completed{
    [[HttpOperation shareInstance] asyncGetUserInfoWithUserId:p2 queue:queue completed:completed];
}
// 请求用户信息
- (void)asyncGetUserInfoWithUserId:(NSString *)p2 queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *info,DHUserInfoModel *userInfoModel))completed{
    NSString *p1 = [NSGetTools getUserSessionId];
    AFHTTPRequestOperationManager *manger = [self getManager];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
            DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
            [item setValuesForKeysWithDictionary:[dict2 objectForKey:@"b112"]];
            [item setValuesForKeysWithDictionary:dict2];
            if (![DHUserInfoDao checkUserWithUsertId:item.b80]) {
                [DHUserInfoDao insertUserToDBWithItem:item];
            }else{
                [DHUserInfoDao updateUserToDBWithItem:item userId:item.b80];
            }
            NSNumber *b144 = [dict2 objectForKey:@"b112"][@"b144"];
            [NSGetTools upDateUserVipInfo:b144];
            NSNumber *b69 = [dict2 objectForKey:@"b112"][@"b69"];
            [NSGetTools updateUserSexInfoWithB69:b69];
            // 系统生成用户号
            NSString *b152 = [[dict2 objectForKey:@"b112"] objectForKey:@"b152"];
            [[NSUserDefaults standardUserDefaults] setObject:b152 forKey:@"b152"];
            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"] forKey:@"nickName"];
            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b17"] forKey:@"b17"];
            [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"loginUser"];
            dispatch_async(queue == nil ? dispatch_get_main_queue():queue, ^{
                completed(dict2,item);
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncConfigHeaderImageDataWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSArray *array))completed{
    [[HttpOperation shareInstance] asyncConfigHeaderImageDataWithQueue:queue completed:completed];
}
// 加载头像数据
- (void)asyncConfigHeaderImageDataWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSArray *array))completed{
    NSString *p1 = [NSGetTools getUserSessionId];
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *appInfo = [NSGetTools getAppInfoString];
    NSNumber *headerNum = [NSNumber numberWithInt:1000];
    NSString *url = [NSString stringWithFormat:@"%@f_107_11_1.service?p1=%@&p2=%@&a78=%@&%@",kServerAddressTest3,p1,p2,headerNum,appInfo];
    AFHTTPRequestOperationManager *manger = [self getManager];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *modelArr = infoDic[@"body"];
            if (modelArr.count > 0) {
                NSDictionary *headDict = modelArr[0];
                NSString *urlStr = headDict[@"b57"];
                [NSGetTools upDateIconB57:urlStr];// 更新保存头像信息
                if (queue) {
                    dispatch_async(queue, ^{
                        completed(modelArr);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completed(modelArr);
                    });
                }
            }
        }else{
            completed(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncGetSystemConfigrationInfoWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSArray *array))completed{
    [[HttpOperation shareInstance] asyncGetSystemConfigrationInfoWithQueue:queue completed:completed];
}
// 系统参数请求
- (void)asyncGetSystemConfigrationInfoWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSArray *array))completed{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_101_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [self getManager];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *sysArray = infoDic[@"body"];
            for (NSDictionary *dict in sysArray) {
                NSArray *b98Arr = dict[@"b98"];
                // 默认消息
                if ([dict[@"b20"] isEqualToString:@"default_message"]) {
                    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b72"]];
                        [messageDict setValue:dict2[@"b22"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateDefaultMessageWithDict:messageDict];
                }else if ([dict[@"b20"] isEqualToString:@"charmPart"]){// 魅力部位
                    NSMutableDictionary *charmPartDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [charmPartDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatecharmPartWithDict:charmPartDict];
                }else if ([dict[@"b20"] isEqualToString:@"marriageStatus"]){// 婚状态
                    NSMutableDictionary *marriageStatusDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [marriageStatusDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatemarriageStatusWithDict:marriageStatusDict];
                }else if ([dict[@"b20"] isEqualToString:@"marrySex"]){// 婚前行为
                    NSMutableDictionary *marrySexDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [marrySexDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatemarrySexWithDict:marrySexDict];
                }else if ([dict[@"b20"] isEqualToString:@"profession"]){//职业
                    NSMutableDictionary *professionDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [professionDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateprofessionDict:professionDict];
                }else if ([dict[@"b20"] isEqualToString:@"loveType-2"]){// 喜欢的类型(女)
                    NSMutableDictionary *loveType2Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [loveType2Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateloveType2Dict:loveType2Dict];
                }else if ([dict[@"b20"] isEqualToString:@"hasLoveOther"]){// 异地恋
                    NSMutableDictionary *hasLoveOtherDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasLoveOtherDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatehasLoveOtherWithDict:hasLoveOtherDict];
                }else if ([dict[@"b20"] isEqualToString:@"star"]){// 星座
                    NSMutableDictionary *starDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [starDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatestarWithDict:starDict];
                }else if ([dict[@"b20"] isEqualToString:@"liveTogether"]){// 住一起
                    NSMutableDictionary *liveTogetherDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [liveTogetherDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateliveTogetherWithDict:liveTogetherDict];
                }else if ([dict[@"b20"] isEqualToString:@"loveType-1"]){// 喜欢的类型(男)
                    NSMutableDictionary *loveType1Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [loveType1Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateloveType1WithDict:loveType1Dict];
                }else if ([dict[@"b20"] isEqualToString:@"purpose"]){// 交友目的
                    NSMutableDictionary *purposeDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [purposeDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatepurposeWithDict:purposeDict];
                }else if ([dict[@"b20"] isEqualToString:@"blood"]){// 血型
                    NSMutableDictionary *bloodDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [bloodDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatebloodWithDict:bloodDict];
                }else if ([dict[@"b20"] isEqualToString:@"hasCar"]){// 车子
                    NSMutableDictionary *hasCarDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasCarDict setValue:dict2[@"b21"] forKey:keyStr];
                        
                    }
                    // 保存
                    [NSGetSystemTools updatehasCarWithDict:hasCarDict];
                }else if ([dict[@"b20"] isEqualToString:@"educationLevel"]){
                    NSMutableDictionary *educationLevelDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [educationLevelDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateeducationLevelWithDict:educationLevelDict];
                }else if ([dict[@"b20"] isEqualToString:@"hasChild"]){
                    NSMutableDictionary *hasChildDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasChildDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatehasChildWithDict:hasChildDict];
                }else if ([dict[@"b20"] isEqualToString:@"system_pm"]){
                    NSMutableDictionary *system_pmDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [system_pmDict setValue:dict2[@"b21"] forKey:keyStr];
                        if ([[dict2 objectForKey:@"b20"] isEqualToString:@"system_advance"]) {
                            [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"Promotion"];
                        }
                    }
                    // 保存
                    [NSGetSystemTools updatesystem_pmWithDict:system_pmDict];
                }else if ([dict[@"b20"] isEqualToString:@"favorite-2"]){
                    NSMutableDictionary *favorite2Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [favorite2Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatefavorite2WithDict:favorite2Dict];
                }else if ([dict[@"b20"] isEqualToString:@"favorite-1"]){
                    NSMutableDictionary *favorite1Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [favorite1Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatefavorite1WithDict:favorite1Dict];
                }else if ([dict[@"b20"] isEqualToString:@"kidney-1"]){
                    NSMutableDictionary *kidney1Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [kidney1Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatekidney1WithDict:kidney1Dict];
                }else if ([dict[@"b20"] isEqualToString:@"kidney-2"]){
                    NSMutableDictionary *kidney2Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [kidney2Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatekidney2WithDict:kidney2Dict];
                }else if ([dict[@"b20"] isEqualToString:@"hasRoom"]){
                    NSMutableDictionary *hasRoomDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasRoomDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatehasRoomWithDict:hasRoomDict];
                }else if ([dict[@"b20"] isEqualToString:@"timestem"]){
                    NSMutableDictionary *timestemDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        
                        [timestemDict setValue:dict2[@"b22"] forKey:dict2[@"b20"]];
                    }
                    // 保存
                    [NSGetSystemTools updatetimestemWithDict:timestemDict];
                }else if ([dict[@"b20"] isEqualToString:@"lp_pay_way"]){
                    NSMutableDictionary *timestemDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        [timestemDict setValue:dict2[@"b22"] forKey:dict2[@"b20"]];
                    }
                    // 保存
                    [[NSUserDefaults standardUserDefaults] setObject:timestemDict forKey:@"lp_pay_way"];
                }else if ([dict[@"b20"] isEqualToString:@"url_lp_bus_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_author_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_file_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_pay_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_im_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_upgrade_msc"] || [dict[@"b20"] isEqualToString:@"url_lp_h5_msc"] ){
                    for (NSDictionary *dict2 in b98Arr) {
                        DHDomainModel *item = [[DHDomainModel alloc]init];
                        item.apiId = [NSString stringWithFormat:@"%@/%@/",[dict2 objectForKey:@"b22"],[dict2 objectForKey:@"b20"]];
                        item.api = [NSString stringWithFormat:@"%@/%@/",[dict2 objectForKey:@"b22"],[dict2 objectForKey:@"b20"]];
                        item.apiName = [dict2 objectForKey:@"b20"];
                        item.apiType = @"0";
                        if (![DHDomainDao checkApiWithApi:item.api]) {
                            [DHDomainDao asyncInsertApiToDbWithItem:item];
                        }
                    }
                }else if ([dict[@"b20"] isEqualToString:@"report-1"]){
                    NSMutableDictionary *reportDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        [reportDict setValue:dict2[@"b21"] forKey:dict2[@"b22"]];
                    }
                    // 保存
                    [NSGetSystemTools updatereport1WithDict:reportDict];
                    
                }else if ([dict[@"b20"] isEqualToString:@"country_tips_set"]){
                    NSMutableDictionary *reportDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        [reportDict setValue:dict2[@"b21"] forKey:dict2[@"b22"]];
                    }
                    // 保存
                    [[NSUserDefaults standardUserDefaults] setObject:b98Arr forKey:@"recommed_system_data"];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncConfigSayHelloMessage{
    [[HttpOperation shareInstance] asyncConfigSayHelloMessage];
}
// f_119_11_2
- (void)asyncConfigSayHelloMessage{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *item = [DHUserInfoDao getUserWithCurrentUserId:userId];
    if (!item) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self asyncConfigSayHelloMessage];
        });
    }else{
        NSString *p1 = [NSGetTools getUserSessionId];
        NSString *url = [NSString stringWithFormat:@"%@f_119_11_2.service?p2=%@&p1=%@",kServerAddressTest2,item.b80,p1];
        AFHTTPRequestOperationManager *manger = [self getManager];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *datas = responseObject;
            NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
            NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
            if ([infoDic[@"code"] integerValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFromRegitser"];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
+ (void)im_asyncUploadImageWithImageList:(NSArray *)imageList completed:(void(^)(NSString *imageUrl ,long datalength,NSString *fileName))completed{
    [[HttpOperation shareInstance] im_asyncUploadImageWithImageList:imageList completed:completed];
}
// f_119_11_2
- (void)im_asyncUploadImageWithImageList:(NSArray *)imageList completed:(void(^)(NSString *imageUrl,long datalength,NSString *fileName))completed{
    NSString *p1 = [NSGetTools getUserSessionId];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *para = @{@"fileType":@"5001",@"p1":p1,@"p2":userId};
    
    for (UIImage *image in imageList) {
        NSData *data = UIImageJPEGRepresentation(image, 1);
        float index = 1.0;
        while (data.length > 1024*500) {
            data = UIImageJPEGRepresentation(image, index);
            index = index - 0.1;
        }
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmsssss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self configUUid]];
        NSString *url1 = [NSString stringWithFormat:@"%@upload.service?fileType=5001&fileName=%@",kServerAddressTest_IM_FILE,fileName];
        NSString *url =  [url1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [manger POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:data name:@"userFile" fileName:fileName mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                NSError *error = nil;
                NSString *imageUrl = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&error];
                NSLog(@"%s%@",__func__,imageUrl);
                completed(imageUrl,data.length,fileName);
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%s%@",__func__,error.userInfo);
        }];
    }
}
+ (void)im_asyncUploadAudioWithAudioData:(NSData *)audioData completed:(void(^)(NSString *fileUrl ,long datalength,NSString *fileName))completed{
    [[HttpOperation shareInstance] im_asyncUploadAudioWithAudioData:audioData completed:completed];
}
// f_119_11_2
- (void)im_asyncUploadAudioWithAudioData:(NSData *)audioData completed:(void(^)(NSString *fileUrl ,long datalength,NSString *fileName))completed{
    NSString *p1 = [NSGetTools getUserSessionId];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *para = @{@"fileType":@"5001",@"p1":p1,@"p2":userId};
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmsssss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.mp3", str];
    NSString *url1 = [NSString stringWithFormat:@"%@upload.service?fileType=5003&fileName=%@",kServerAddressTest_IM_FILE,fileName];
    NSString *url =  [url1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manger POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:audioData name:@"userFile" fileName:fileName mimeType:@"audio/basic"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSError *error = nil;
            NSString *imageUrl = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:&error];
            NSLog(@"%s%@",__func__,imageUrl);
            completed(imageUrl,audioData.length,fileName);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s%@",__func__,error.userInfo);
    }];
}
+ (void)asyncUpgradeWithCompleted:(void(^)(NSDictionary *infoDic))completed{
    [[HttpOperation shareInstance] asyncUpgradeWithCompleted:completed];
}
// f_119_11_2
- (void)asyncUpgradeWithCompleted:(void(^)(NSDictionary *infoDic))completed{
    
    NSDictionary *appinfo = [NSGetTools getAppInfoDict];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    // 用于信任https证书
    manger.securityPolicy.allowInvalidCertificates = YES;
    NSString *url1 = [NSString stringWithFormat:@"%@f_104_10_1.service",kServerAddressTest_upgrade];
    NSString *url = [url1 stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger POST:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        completed([infoDic objectForKey:@"body"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

+ (void)asyncSaveFriendshipWithFriendId:(NSString *)friendId friendName:(NSString *)friendName queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *registerInfo))completed{
    [[HttpOperation shareInstance] asyncSaveFriendshipWithFriendId:friendId friendName:friendName queue:queue completed:completed];
}
- (void)asyncSaveFriendshipWithFriendId:(NSString *)friendId friendName:(NSString *)friendName queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *registerInfo))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:friendId forKey:@"a25"];
    [appinfo setObject:friendName forKey:@"a26"];
    NSString *url = [NSString stringWithFormat:@"%@f_106_10_2.service",kServerAddressTest2];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        NSDictionary *dict2 = infoDic[@"body"];
        //  注册成功,将信息保存到服务器
        if ([codeNum integerValue] == 200) {
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncChargesWithQueue:(dispatch_queue_t )queue completed:(void(^)(BOOL permission , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncChargesWithQueue:queue completed:completed];
}
- (void)asyncChargesWithQueue:(dispatch_queue_t )queue completed:(void(^)(BOOL permission, NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    NSString *url = [NSString stringWithFormat:@"%@f_115_15_1.service",kServerAddressTest2];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSInteger codeNum = [infoDic[@"code"] integerValue];
        BOOL resultPermission = [infoDic[@"body"] boolValue];
//        BOOL resultPermission = NO;
//        if ([reslut isEqualToString:@"false"]) {
//            resultPermission = NO;
//        }else{
//            resultPermission = YES;
//        }
        completed(resultPermission,codeNum);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncExchangeChargesWithPhoneNumber:(NSString *)phoneNumber queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *registerInfo , NSInteger code,NSString *msg))completed{
    [[HttpOperation shareInstance] asyncExchangeChargesWithPhoneNumber:phoneNumber queue:queue completed:completed];
}
- (void)asyncExchangeChargesWithPhoneNumber:(NSString *)phoneNumber queue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *registerInfo , NSInteger code,NSString *msg))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%@",phoneNumber] forKey:@"a163"];
    NSString *url = [NSString stringWithFormat:@"%@f_115_16_1.service",kServerAddressTest2];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSInteger codeNum = [infoDic[@"code"] integerValue];
        NSDictionary *bodyInfo = infoDic[@"body"];
        completed(bodyInfo,codeNum,[infoDic objectForKey:@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncExchangePrepaidCodeWithPrepaidCode:(NSString *)prepaidCode queue:(dispatch_queue_t )queue completed:(void(^)(NSInteger code,NSString *msg))completed{
    [[HttpOperation shareInstance] asyncExchangePrepaidCodeWithPrepaidCode:prepaidCode queue:queue completed:completed];
}
- (void)asyncExchangePrepaidCodeWithPrepaidCode:(NSString *)prepaidCode queue:(dispatch_queue_t )queue completed:(void(^)(NSInteger code,NSString *msg))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%@",prepaidCode] forKey:@"a187"];
    NSString *url = [NSString stringWithFormat:@"%@f_115_17_1.service",kServerAddressTest2];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSInteger codeNum = [infoDic[@"code"] integerValue];
        NSString *msg = [infoDic objectForKey:@"msg"];
        completed(codeNum,msg);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncGetVipListWithType:(NSInteger )type goodsCode:(NSInteger )goodsCode catagery:(NSInteger )catagery queue:(dispatch_queue_t )queue completed:(void(^)( NSArray *vipArr , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncGetVipListWithType:type goodsCode:goodsCode catagery:catagery queue:queue completed:completed];
}
- (void)asyncGetVipListWithType:(NSInteger )type goodsCode:(NSInteger )goodsCode catagery:(NSInteger )catagery queue:(dispatch_queue_t )queue completed:(void(^)( NSArray *vipArr , NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    if (type > 0) {
        [appinfo setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"a78"];
    }
    if (goodsCode > 0) {
        [appinfo setObject:[NSString stringWithFormat:@"%ld",goodsCode] forKey:@"a13"];
    }
    [appinfo setObject:[NSString stringWithFormat:@"%ld",catagery] forKey:@"a188"];
    NSString *url = [NSString stringWithFormat:@"%@f_115_12_1.service",kServerAddressTest2];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSInteger codeNum = [infoDic[@"code"] integerValue];
        if (codeNum == 200) {
            NSArray *bodyArr = infoDic[@"body"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSDictionary *dict in bodyArr) {
                
                NSArray *b111Arr = [dict objectForKey:@"b111"];
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *b111Dict in b111Arr) {
                    YS_PayModel *model=[[YS_PayModel alloc]init];
                    [model setValuesForKeysWithDictionary:b111Dict];
                    model.privilegeList = [[b111Dict objectForKey:@"b111"] copy];
                    [tempArr addObject:model];
                }
                [arr addObject:tempArr];
            }
            completed(arr,codeNum);
        }else{
            completed(nil,-1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
+ (void)asyncCancelRequestWithQueue:(dispatch_queue_t )queue{
    [[HttpOperation shareInstance] asyncCancelRequestWithQueue:queue];
}
- (void)asyncCancelRequestWithQueue:(dispatch_queue_t )queue{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    [manger.operationQueue cancelAllOperations];
}
/**
 *  请求对话信息
 */
+ (void)asyncGetMessagesOfMySelfWithPara:(NSDictionary *)para1 completed:(void(^)(NSArray *array))completed{
    [RobotMessageHttpDao asyncGetMessagesOfMySelfWithPara:para1 completed:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(array);
        });
    }];
}
#pragma mark -- 统计 2016年06月28日14:43:58

+ (void)asyncCollectSaveWithUserType:(NSInteger )userType queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncCollectSaveWithUserType:userType queue:queue completed:completed];
}
- (void)asyncCollectSaveWithUserType:(NSInteger )userType queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    __weak typeof (&*self) weakSelf = self;
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",userType] forKey:@"userType"];
    NSString *url = [NSString stringWithFormat:@"%@f_100_10_1.service",kServerAddressTest_COLLECT];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        if (datas) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
            NSInteger codeNum = [infoDic[@"code"] integerValue];
            NSString *msg = [infoDic objectForKey:@"msg"];
            completed(msg,codeNum);
        }else{
            completed(@"数据异常",-1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 404) {
            [weakSelf asyncCollectSaveWithUserType:userType queue:queue completed:completed];
        }
        
    }];
}
+ (void)asyncCollectPaySaveWithPayType:(NSInteger )payType price:(float )price status:(NSInteger )status goodCode:(NSString *)goodCode orderNum:(NSString *)orderNum userType:(NSInteger )userType queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncCollectPaySaveWithPayType:payType price:price status:status goodCode:goodCode orderNum:orderNum userType:userType queue:queue completed:completed];
}
- (void)asyncCollectPaySaveWithPayType:(NSInteger )payType price:(float )price status:(NSInteger )status goodCode:(NSString *)goodCode orderNum:(NSString *)orderNum userType:(NSInteger )userType queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    __weak typeof (&*self) weakSelf = self;
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",payType] forKey:@"payType"];
    [appinfo setObject:[NSString stringWithFormat:@"%2f",price] forKey:@"price"];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",status] forKey:@"status"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",goodCode] forKey:@"goodCode"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",orderNum] forKey:@"orderNum"];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",userType] forKey:@"userType"];
    NSString *url = [NSString stringWithFormat:@"%@f_101_10_1.service",kServerAddressTest_COLLECT];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        if (datas) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
            NSInteger codeNum = [infoDic[@"code"] integerValue];
            NSString *msg = [infoDic objectForKey:@"msg"];
            completed(msg,codeNum);
        }else{
            completed(@"数据异常",-1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 404) {
            [weakSelf asyncCollectPaySaveWithPayType:payType price:price status:status goodCode:goodCode orderNum:orderNum userType:userType queue:queue completed:completed];
        }
    }];
}
+ (void)asyncCollectEventSaveWithPointType:(NSInteger )pointType queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncCollectEventSaveWithPointType:pointType queue:queue completed:completed];
}
- (void)asyncCollectEventSaveWithPointType:(NSInteger )pointType queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",pointType] forKey:@"pointType"];
    NSString *url = [NSString stringWithFormat:@"%@f_102_10_1.service",kServerAddressTest_COLLECT];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        if (datas) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
            NSInteger codeNum = [infoDic[@"code"] integerValue];
            NSString *msg = [infoDic objectForKey:@"msg"];
            completed(msg,codeNum);
        }else{
            completed(@"数据异常",-1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __weak typeof (&*self) weakSelf = self;
        if (operation.response.statusCode == 404) {
            [weakSelf asyncCollectEventSaveWithPointType:pointType queue:queue completed:completed];
        }
    }];
}
+ (void)asyncCollectUpgradeSaveWithOldAppVer:(NSString *)oldAppVer oldAppName:(NSString *)oldAppName queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncCollectUpgradeSaveWithOldAppVer:oldAppVer oldAppName:oldAppName queue:queue completed:completed];
}
- (void)asyncCollectUpgradeSaveWithOldAppVer:(NSString *)oldAppVer oldAppName:(NSString *)oldAppName queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%@",oldAppVer] forKey:@"oldAppVer"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",oldAppName] forKey:@"oldAppName"];
    NSString *url = [NSString stringWithFormat:@"%@f_103_10_1.service",kServerAddressTest_COLLECT];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        if (datas) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
            NSInteger codeNum = [infoDic[@"code"] integerValue];
            NSString *msg = [infoDic objectForKey:@"msg"];
            completed(msg,codeNum);
        }else{
            completed(@"数据异常",-1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __weak typeof (&*self) weakSelf = self;
        if (operation.response.statusCode == 404) {
            [weakSelf asyncCollectUpgradeSaveWithOldAppVer:oldAppVer oldAppName:oldAppName queue:queue completed:completed];
        }
    }];
}
+ (void)asyncCollectDownLoadSaveWithSource:(NSInteger )source status:(NSInteger )status target_app_id:(NSString *)target_app_id queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncCollectDownLoadSaveWithSource:source status:status target_app_id:target_app_id queue:queue completed:completed];
}
- (void)asyncCollectDownLoadSaveWithSource:(NSInteger )source status:(NSInteger )status target_app_id:(NSString *)target_app_id queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",source] forKey:@"source"];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",status] forKey:@"status"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",target_app_id] forKey:@"target_app_id"];
    NSString *url = [NSString stringWithFormat:@"%@f_104_10_1.service",kServerAddressTest_COLLECT];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        if (datas) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
            NSInteger codeNum = [infoDic[@"code"] integerValue];
            NSString *msg = [infoDic objectForKey:@"msg"];
            completed(msg,codeNum);
        }else{
            completed(@"数据异常",-1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __weak typeof (&*self) weakSelf = self;
        if (operation.response.statusCode == 404) {
            [weakSelf asyncCollectDownLoadSaveWithSource:source status:status target_app_id:target_app_id queue:queue completed:completed];
        }
    }];
}

+ (void)asyncCollectExpandUpLoadSaveWithTicket:(NSString *)ticket queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncCollectExpandUpLoadSaveWithTicket:ticket queue:queue completed:completed];
}
- (void)asyncCollectExpandUpLoadSaveWithTicket:(NSString *)ticket queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%@",ticket] forKey:@"ticket"];
    NSString *url = [NSString stringWithFormat:@"%@f_105_10_1.service",kServerAddressTest_COLLECT];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        if (datas) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
            NSInteger codeNum = [infoDic[@"code"] integerValue];
            NSString *msg = [infoDic objectForKey:@"msg"];
            completed(msg,codeNum);
        }else{
            completed(@"数据异常",-1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __weak typeof (&*self) weakSelf = self;
        if (operation.response.statusCode == 404) {
            [weakSelf asyncCollectExpandUpLoadSaveWithTicket:ticket queue:queue completed:completed];
        }
    }];
}


+ (void)asyncCollectExpandUserDownLoadUpLoadSaveWithWebCode:(NSString *)webCode appId:(NSString *)appId downloadType:(NSInteger )downloadType keynum:(NSString *)keynum queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncCollectExpandUserDownLoadUpLoadSaveWithWebCode:webCode appId:appId downloadType:downloadType keynum:keynum queue:queue completed:completed];
}
- (void)asyncCollectExpandUserDownLoadUpLoadSaveWithWebCode:(NSString *)webCode appId:(NSString *)appId downloadType:(NSInteger )downloadType keynum:(NSString *)keynum queue:(dispatch_queue_t )queue completed:(void(^)( NSString *msg , NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%@",webCode] forKey:@"webCode"];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",downloadType] forKey:@"downloadType"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",keynum] forKey:@"keynum"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",appId] forKey:@"appId"];
    NSString *url = [NSString stringWithFormat:@"%@f_105_11_1.service",kServerAddressTest_COLLECT];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        if (datas) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
            NSInteger codeNum = [infoDic[@"code"] integerValue];
            NSString *msg = [infoDic objectForKey:@"msg"];
            completed(msg,codeNum);
        }else{
            completed(@"数据异常",-1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __weak typeof (&*self) weakSelf = self;
        if (operation.response.statusCode == 404) {
            [weakSelf asyncCollectExpandUserDownLoadUpLoadSaveWithWebCode:webCode appId:appId downloadType:downloadType keynum:keynum queue:queue completed:completed];
        }
    }];
}
#pragma  mark -- 统计结束 2016年06月28日15:26:57

#pragma  mark -- 直播开始 2016年07月09日14:54:37

+ (void)asyncLive_OpenLiveWithTargetUserId:(NSString *)targetUserId nickName:(NSString *)nickName portrait:(NSString *)portrait type:(NSInteger )type delegate:(id<HttpOperationDelegate >)delegate{
    [[HttpOperation shareInstance] asyncLive_OpenLiveWithTargetUserId:targetUserId nickName:nickName portrait:portrait type:type delegate:delegate];
}
- (void)asyncLive_OpenLiveWithTargetUserId:(NSString *)targetUserId nickName:(NSString *)nickName portrait:(NSString *)portrait type:(NSInteger )type delegate:(id<HttpOperationDelegate >)delegate{
    self.delegate = delegate;
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%@",targetUserId] forKey:@"uid"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",nickName] forKey:@"name"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",portrait] forKey:@"image"];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"type"];
    NSData *jsonData = [appinfo JSONData];
    NSString *url = [NSString stringWithFormat:@"%@new",kServerAddressTest_LIVE];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setRequestHeaders:[@{@"X-ApiKey":@"j8slb29fbalc83pna2af2c2954hcw65",@"Content-Type":@"application/json"} mutableCopy]];
    [request setPostBody:[jsonData mutableCopy]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = request.responseData;
        if (data) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&error];
            if (infoDic && error == nil) {
                NSInteger codeNum = [infoDic[@"retcode"] integerValue];
                NSString *msg = [infoDic objectForKey:@"msg"];
                NSDictionary *liveInfo = [infoDic objectForKey:@"channel"];
                DHLiveInfoModel *item = [[DHLiveInfoModel alloc]init];
                [item setValuesForKeysWithDictionary:liveInfo];
                if (_delegate && [_delegate respondsToSelector:@selector(live_dataDidLoaded:code:)]) {
                    [_delegate live_dataDidLoaded:item code:codeNum];
                }
            }else{
                if (_delegate && [_delegate respondsToSelector:@selector(live_dataDidLoaded:code:)]) {
                    [_delegate live_dataDidLoaded:nil code:-100];
                }
            }
           
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(live_dataDidLoaded:code:)]) {
                [_delegate live_dataDidLoaded:nil code:-100];
            }
        }
    });
}
+ (void)asyncLive_ColsedLiveWithChanelId:(NSString *)chanelId chanelName:(NSString *)chanelName type:(NSInteger )type queue:(dispatch_queue_t )queue completed:(void(^)(NSString *msg , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncLive_ColsedLiveWithChanelId:chanelId chanelName:chanelName type:type queue:queue completed:completed];
}
- (void)asyncLive_ColsedLiveWithChanelId:(NSString *)chanelId chanelName:(NSString *)chanelName type:(NSInteger )type queue:(dispatch_queue_t )queue completed:(void(^)(NSString *msg , NSInteger code))completed{
    
//    AFHTTPRequestOperationManager *manger = [self getManager];
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%@",chanelId] forKey:@"cid"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",chanelName] forKey:@"name"];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"type"];
    NSData *jsonData = [appinfo JSONData];
//    [manger.requestSerializer setValue:@"j8slb29fbalc83pna2af2c2954hcw65" forHTTPHeaderField:@"X-ApiKey"];
    NSString *url = [NSString stringWithFormat:@"%@close",kServerAddressTest_LIVE];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setRequestHeaders:[@{@"X-ApiKey":@"j8slb29fbalc83pna2af2c2954hcw65",@"Content-Type":@"application/json"} mutableCopy]];
    
    [request setPostBody:[jsonData mutableCopy]];
    [request startSynchronous];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = request.responseData;
        if (data) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&error];
            NSInteger codeNum = [infoDic[@"retcode"] integerValue];
            NSString *msg = [infoDic objectForKey:@"msg"];
            
            completed(msg,codeNum);
        }else{
            completed(nil,-1);
        }
    });
    
    
//    [manger POST:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSData *datas = responseObject;
//        if (datas) {
//            NSError *error = nil;
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
//            NSInteger codeNum = [infoDic[@"retcode"] integerValue];
//            NSString *msg = [infoDic objectForKey:@"msg"];
//            
//            
//            completed(msg,codeNum);
//            
//        }else{
//            completed(@"数据错误",-1);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

+ (void)asyncLive_GetChanelListWithCurPage:(NSInteger )curPage pageSize:(NSInteger )pageSize queue:(dispatch_queue_t )queue completed:(void(^)( NSArray *chanelList , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncLive_GetChanelListWithCurPage:curPage pageSize:pageSize queue:queue completed:completed];
}
- (void)asyncLive_GetChanelListWithCurPage:(NSInteger )curPage pageSize:(NSInteger )pageSize queue:(dispatch_queue_t )queue completed:(void(^)( NSArray *chanelList , NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    [manger.requestSerializer setValue:@"j8slb29fbalc83pna2af2c2954hcw65" forHTTPHeaderField:@"X-ApiKey"];
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",curPage] forKey:@"curPage"];
    [appinfo setObject:[NSString stringWithFormat:@"%ld",pageSize] forKey:@"pageSize"];
    NSString *url = [NSString stringWithFormat:@"%@get_channels",kServerAddressTest_LIVE];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        if (datas) {
            NSError *error = nil;
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:datas options:(NSJSONReadingAllowFragments) error:&error];
            NSInteger codeNum = [infoDic[@"retcode"] integerValue];
            NSString *msg = [infoDic objectForKey:@"msg"];
            NSArray *liveInfoList = [infoDic objectForKey:@"channels"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *temp in liveInfoList) {
                DHLiveInfoModel *item = [[DHLiveInfoModel alloc]init];
                [item setValuesForKeysWithDictionary:temp];
                [arr addObject:item];
            }
            completed(arr,codeNum);
            
        }else{
            completed(nil,-1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



#pragma mark -- 网易云im 开始 --2016年07月12日18:59:20 
+ (void)asyncLiveIM_GetLoginTokenWithQueue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *neteaseImInfo , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncLiveIM_GetLoginTokenWithQueueueue:queue completed:completed];
}
- (void)asyncLiveIM_GetLoginTokenWithQueueueue:(dispatch_queue_t )queue completed:(void(^)(NSDictionary *neteaseImInfo , NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    [manger.requestSerializer setValue:@"j8slb29fbalc83pna2af2c2954hcw65" forHTTPHeaderField:@"X-ApiKey"];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    [appinfo setObject:[NSString stringWithFormat:@"%@",userId] forKey:@"accid"];
    NSData *jsonData = [appinfo JSONData];
    NSString *url = [NSString stringWithFormat:@"%@new",kServerAddressTest_LIVE_IM];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setRequestHeaders:[@{@"X-ApiKey":@"j8slb29fbalc83pna2af2c2954hcw65",@"Content-Type":@"application/json"} mutableCopy]];
    [request setRequestMethod:@"POST"];
    [request setPostBody:[jsonData mutableCopy]];
    [request startSynchronous];
    NSData *data = request.responseData;
    NSString *jsonStr = request.responseString;
    if (data) {
        NSError *error = nil;
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&error];
        NSInteger codeNum = [infoDic[@"retcode"] integerValue];
        NSString *msg = [infoDic objectForKey:@"msg"];
        NSDictionary *neteaseIm = [infoDic objectForKey:@"neteaseIm"] == [NSNull null] ? nil:[infoDic objectForKey:@"neteaseIm"];
        if ([neteaseIm allKeys].count > 0) {
            NSString *token = [neteaseIm objectForKey:@"token"];
            [JNKeychain saveValue:token forKey:userId];
            completed(neteaseIm,codeNum);
        }else{
            completed(nil,codeNum);
        }
        
    }else{
        completed(nil,-1);
    }
}

+ (void)asyncLiveIM_SendMessageWithRoomId:(NSString *)roomId resendFlag:(NSString *)resendFlag msgModel:(DHLiveImMsgModel *)msgModel queue:(dispatch_queue_t )queue completed:(void(^)(DHLiveImMsgModel *msgModel , NSInteger code))completed{
    [[HttpOperation shareInstance] asyncLiveIM_SendMessageWithRoomId:roomId resendFlag:resendFlag msgModel:msgModel queue:queue completed:completed];
}
- (void)asyncLiveIM_SendMessageWithRoomId:(NSString *)roomId resendFlag:(NSString *)resendFlag msgModel:(DHLiveImMsgModel *)msgModel queue:(dispatch_queue_t )queue completed:(void(^)(DHLiveImMsgModel *msgModel , NSInteger code))completed{
    
    AFHTTPRequestOperationManager *manger = [self getManager];
    [manger.requestSerializer setValue:@"j8slb29fbalc83pna2af2c2954hcw65" forHTTPHeaderField:@"X-ApiKey"];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
//    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    [appinfo setObject:[NSString stringWithFormat:@"%@",roomId] forKey:@"roomid"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",msgModel.msgid_client] forKey:@"msgId"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",msgModel.fromAccount] forKey:@"fromAccid"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",msgModel.type] forKey:@"msgType"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",resendFlag] forKey:@"resendFlag"];
    [appinfo setObject:[NSString stringWithFormat:@"%@",msgModel.attach] forKey:@"attach"];
    NSData *jsonData = [appinfo JSONData];
    NSString *url = [NSString stringWithFormat:@"%@new",kServerAddressTest_LIVE_IM_CHATROOM];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setRequestHeaders:[@{@"X-ApiKey":@"j8slb29fbalc83pna2af2c2954hcw65",@"Content-Type":@"application/json"} mutableCopy]];
    [request setRequestMethod:@"POST"];
    [request setPostBody:[jsonData mutableCopy]];
    [request startSynchronous];
    NSData *data = request.responseData;
    NSString *jsonStr = request.responseString;
    if (data) {
        NSError *error = nil;
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&error];
        NSInteger codeNum = [infoDic[@"retcode"] integerValue];
        NSString *msg = [infoDic objectForKey:@"msg"];
        NSDictionary *neteaseIm = [infoDic objectForKey:@"chatRoomMessage"] == [NSNull null] ? nil:[infoDic objectForKey:@"chatRoomMessage"];
        if ([neteaseIm allKeys].count > 0) {
            DHLiveImMsgModel *model = [[DHLiveImMsgModel alloc]init];
            [model setValuesForKeysWithDictionary:neteaseIm];
            completed(model,codeNum);
        }else{
            completed(nil,codeNum);
        }
        
    }else{
        completed(nil,-1);
    }
}

#pragma  mark -- 直播结束 2016年07月09日14:57:55

+ (void)asyncGetFriendListWithPage:(NSString *)page queue:(dispatch_queue_t )queue completed:(void(^)(NSArray *friendList , NSInteger code,NSInteger hasNext))completed{
    [[HttpOperation shareInstance] asyncGetFriendListWithPage:page queue:queue completed:completed];
}
- (void)asyncGetFriendListWithPage:(NSString *)page queue:(dispatch_queue_t )queue completed:(void(^)(NSArray *friendList , NSInteger code,NSInteger hasNext))completed{
    __weak typeof (&*self) weakSelf = self;
    AFHTTPRequestOperationManager *manger = [self getManager];
    NSMutableDictionary *appinfo = [[NSGetTools getAppInfoDict] mutableCopy];
    [appinfo setObject:page forKey:@"a95"];
    NSString *url = [NSString stringWithFormat:@"%@f_106_11_1.service",kServerAddressTest2];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:appinfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSInteger code = [[infoDic objectForKey:@"code"] integerValue];
        NSInteger hasNext = [[infoDic objectForKey:@"b96"] integerValue];
        NSArray *temp = [infoDic objectForKey:@"body"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in temp) {
            DHUserInfoModel *item = [[DHUserInfoModel alloc]init];
            [item setValuesForKeysWithDictionary:dict];
            item.friendType = [dict objectForKey:@"b78"];
            [tempArr addObject:item];
            // 存库
            if (![DHFriendDao checkFriendWithFriendId:item.b25]) {
                [DHFriendDao insertFriendToDBWithItem:item];
            }else{
                [DHFriendDao updateFriendToDBWithItem:item];
            }
        }
        completed(tempArr,code,hasNext);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



@end
