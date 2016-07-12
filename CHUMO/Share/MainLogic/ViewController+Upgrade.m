//
//  ViewController+Upgrade.m
//  CHUMO
//
//  Created by xy2 on 16/5/23.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "ViewController+Upgrade.h"
#import "UpgradeView.h"
@implementation ViewController (Upgrade)


- (void)asyncUpgrade{
    
    [HttpOperation asyncUpgradeWithCompleted:^(NSDictionary *infoDic) {
        NSInteger version = [[[NSGetTools getAppVersion] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
        NSInteger serverVersion = [[infoDic objectForKey:@"b82"] integerValue];
        // 本地app 版本号 < 服务器上版本号，则更新
        if (version < serverVersion) {
            // 是否强制更新1:强制;2:非强制
            NSInteger isForceUpgrade = [[infoDic objectForKey:@"b147"] integerValue];
            
            if ([CHUMOEDITION isEqualToString:@"GOTOAPPSTORE"]) {
#pragma mark 商店版
                
            }else{
                // 更新类型:1:商店版,2:企业版
                NSInteger upgradeType = [[infoDic objectForKey:@"b78"] integerValue];
                if (upgradeType==1) {
                    NSDate *dateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"isForceUpgradeDate"];
                    
                    //到期时间
                    
                    if (dateStr!=nil) {
                        NSComparisonResult result = [dateStr compare:[NSDate date]];
                       
                        if (result == NSOrderedDescending) {
                            
                            return ;
                        }else if (result == NSOrderedAscending){
                            
                        }else if(result == NSOrderedSame){
                            
                        }
                        
                    }else{
                        if ([[infoDic objectForKey:@"b136"] integerValue]==0) {
                            
                        }else{
                            NSDate *date1 =[NSDate date];
                            dateStr =[date1 dateByAddingTimeInterval:([[infoDic objectForKey:@"b136"] integerValue]*60*60)];
                            [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:@"isForceUpgradeDate"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            return ;
                        }
                        
                    }
                }
                
            }
            
            [self configUpGradeViewWithForceUpgrade:isForceUpgrade versionDict:infoDic];
        }
    }];
}

- (void)configUpGradeViewWithForceUpgrade:(NSInteger )isForceUpgrade versionDict:(NSDictionary *)versionDict{
    [UpgradeView configUpgradeViewWithType:isForceUpgrade inview:self.view versionDict:versionDict];

}

@end
