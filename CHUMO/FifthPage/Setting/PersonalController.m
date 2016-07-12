//
//  PersonalController.m
//  StrangerChat
//
//  Created by zxs on 15/11/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "PersonalController.h"
#import "PersonViewCell.h"
#import "LogeViewCell.h"
#import "NPOpinionController.h"
#import "NPAboutUsController.h"
#import "AccountController.h"
#import "DHAlertView.h"
#import "DHBlackListViewController.h"
#import "DHActivityViewController.h"
#import "WXSubmitTableViewCell.h"

#define KCell_A @"kcell_1"
#define KCell_B @"kcell_2"
#define KCell_C @"kcell_3"
@interface PersonalController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,DHAlertViewDelegate>
{
    UITableView *tempTableView;
    NSInteger currentSelect;
    
}
@property (nonatomic,strong)NSArray *nameArray;
@property (nonatomic,strong)NSArray *versionArray;
@end

@implementation PersonalController

- (NSArray *)nameArray {

    return @[@"清理缓存",@"检查更新",@"意见反馈"];
}

- (NSArray *)versionArray {
    
    return @[@"",@"发现新版本",@""];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutTempTableView];
    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    
}

- (void)leftAction {

    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)layoutTempTableView
{
    tempTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    tempTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
//    [tempTableView registerClass:[PersonViewCell class] forCellReuseIdentifier:KCell_A];
//    [tempTableView registerClass:[LogeViewCell class] forCellReuseIdentifier:KCell_B];
    [tempTableView registerClass:[WXSubmitTableViewCell class] forCellReuseIdentifier:KCell_C];
    
    [tempTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tempTableView.tableFooterView = [[UIView alloc]init];
    tempTableView.backgroundColor = [UIColor colorWithRed:0.941 green:0.929 blue:0.949 alpha:1.000];
    [self.view addSubview:tempTableView];
    
}

#pragma mark - UITabelView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =nil;
    
    if (indexPath.section == 0){
       cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @"清理缓存";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
    }else if(indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @"关于我们";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }else if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @"黑名单";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }else if(indexPath.section == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"活动相关";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }else{
//        cell.textLabel.text = @"退出登录";
        WXSubmitTableViewCell *submitcell=[tableView dequeueReusableCellWithIdentifier:KCell_C];
        
        if (!submitcell) {
            submitcell = [[WXSubmitTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:KCell_C];
        }
        [submitcell.details setTitle:@"退出登录" forState:(UIControlStateNormal)];
        [submitcell.details addTarget:self action:@selector(userLogoutAction:) forControlEvents:(UIControlEventTouchUpInside)];
        submitcell.backgroundColor=[UIColor clearColor];
        [submitcell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        cell=submitcell;
    }
    
    
    return cell;
}
- (void)userLogoutAction:(id)sender{
    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
    NSString *userName = [[loginUser objectForKey:@"b112"] objectForKey:@"b81"];
    if (userName && ![userName isEqualToString:@"(null)"] && ![userName isEqualToString:@"(NULL)"] && ![userName isEqualToString:@""""]) {
        // 长度为11位，第二位不为0，为已经绑定手机
        NSString *secNumber = [userName substringWithRange:NSMakeRange(1, 1)];
        if ([userName length] == 11 && [secNumber integerValue] != 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loaded"];
            [Mynotification postNotificationName:@"loginStateChange" object:nil];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                currentSelect=1;
                DHAlertView *alert1 = [[DHAlertView alloc]init];
                [alert1 configAlertWithAlertTitle:@"温馨提示" alertContent:@"您还未绑定手机号，退出登录若忘记密码，会无法找回哦~"];
                [alert1.cancelBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
                [alert1.sureBtn setTitle:@"去绑定" forState:(UIControlStateNormal)];
                alert1.delegate = self;
                [self.view addSubview:alert1];
            });
        }
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loaded"];
        [SocketManager asyncLogout];
        //            [Mynotification postNotificationName:@"loginStateChange" object:nil];
        [Mynotification postNotificationName:@"loginStateChangeAndLogin" object:nil];
        [NSGetTools logOutService];
    }
    //        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
    //            if (!error && info) {
    //                NSLog(@"退出成功");
    //            }
    //        } onQueue:nil];
}
#pragma mark -------delegata Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==4) {
        return 60;
    }else{
        return 40;
    }
    
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return gotHeight(10);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, gotHeight(10))];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

        if (indexPath.section == 0 ) {
        // 清理缓存
            currentSelect=0;
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            DHAlertView *alert1 = [[DHAlertView alloc]init];
            [alert1 configAlertWithAlertTitle:@"温馨提示" alertContent:[NSString stringWithFormat:@"缓存为%.2f M ,确定要清除么？",[self folderSizeAtPath:cachePath]]];
            [alert1.cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
            [alert1.sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
            alert1.delegate = self;
            [self.view addSubview:alert1];
            
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"缓存为%.2f M ,确定要清除么？",[self folderSizeAtPath:cachePath]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
            
            
     }else if (indexPath.section == 1) { // 关于我们
        NPAboutUsController *aboutUs = [[NPAboutUsController alloc] init];
        aboutUs.title = @"关于我们";
        [self.navigationController pushViewController:aboutUs animated:YES];
        
    }else if (indexPath.section == 2) {
        // 黑名单
        DHBlackListViewController *blackVc = [[DHBlackListViewController alloc]initWithStyle:(UITableViewStyleGrouped)];
        [self.navigationController pushViewController:blackVc animated:YES];
    }else if (indexPath.section == 3) {
        // 活动相关
        DHActivityViewController *activityVc = [[DHActivityViewController alloc]init];
        [self.navigationController pushViewController:activityVc animated:YES];
    }else{
        
    }
    
}
//- (void)alertView:(DHAlertView *)alertView onClickBtnAtIndex:(NSInteger )index{
//    if (index == 0) {
////        return;
//        [SocketManager asyncLogout];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loaded"];
//        //推到首页
////        [Mynotification postNotificationName:@"loginStateChange" object:nil];
//        //推到登录页
//        [Mynotification postNotificationName:@"loginStateChangeAndLogin" object:nil];
//        // 清除userdefault 里所有数据
//        NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
//        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//        NSString *date = [[[DHTool shareTool] stringFromDate:[NSDate date]] substringToIndex:10];
//        for (NSString *key in [defaultsDictionary allKeys]) {
//            // 不删除发消息
//            if (![[NSString stringWithFormat:@"%@-%@",date,userId] isEqualToString:key] &&![[NSString stringWithFormat:@"%@-firstRobot",date] isEqualToString:key] && ![[NSString stringWithFormat:@"%@-secondRobot",date] isEqualToString:key] &&![@"CLLocation" isEqualToString:key] &&[[NSString stringWithFormat:@"%@_%@hasSended",date,userId] isEqualToString:key] && ![[NSString stringWithFormat:@"%@_%@_%d_hasSend",date,userId,1] isEqualToString:key]&& ![[NSString stringWithFormat:@"%@_%@_%d_hasSend",date,userId,2] isEqualToString:key]&& ![[NSString stringWithFormat:@"%@_%@_%d_hasSend",date,userId,3] isEqualToString:key]) {
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
//            }
//        }
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }else{
//        NResetController *reset = [[NResetController alloc] init];
//        reset.title = @"绑定手机号";
//        reset.msgType = @"3";
//        [self.navigationController pushViewController:reset animated:true];
//    }
//}

- (void)alertView:(DHAlertView *)alertView onClickBtnAtIndex:(NSInteger )index{
    switch (currentSelect) {
        case 0:
        {//清缓存
            if (index == 0) {
                return;
            }else{
                NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                [self clearCache:cachePath];
            }
        }
            break;
        case 1:
        {//退出
            if (index == 0) {
                //        return;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loaded"];
                //        [Mynotification postNotificationName:@"loginStateChange" object:nil];
                [Mynotification postNotificationName:@"loginStateChangeAndLogin" object:nil];
                [NSGetTools logOutService];
            }else{
                NResetController *reset = [[NResetController alloc] init];
                reset.title = @"绑定手机号";
                reset.msgType = @"3";
                [self.navigationController pushViewController:reset animated:true];
            }
        }
            break;
            
        default:
            break;
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }else{
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        [self clearCache:cachePath];
    }
}

/**
 *  单个文件的大小
 *
 *  @param filePath 文件路径
 *
 *  @return 返回文件大小
 */
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/**
 *  遍历文件夹获得文件夹大小，返回多少M
 *
 *  @param folderPath 文件夹路径
 *
 *  @return 返回M
 */

- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //过滤掉不想删除的文件
            if ([fileName rangeOfString:[NSString stringWithFormat:@"chat_"]].location == NSNotFound) {
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
