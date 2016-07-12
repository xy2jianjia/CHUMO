//
//  FmbdMessage.m
//  微信
//
//  Created by Think_lion on 15/7/5.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "FmbdMessage.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

static FMDatabaseQueue *_queue;

@implementation FmbdMessage

+(void)initialize
{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] ;
    path=[NSString stringWithFormat:@"%@/Application Support/微信/XMPPMessageArchiving.sqlite",path];
    _queue =[FMDatabaseQueue databaseQueueWithPath:path];
}


+(void)deleteChatData:(NSString*)jid
{
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL b=[db executeUpdate:@"delete from ZXMPPMESSAGEARCHIVING_MESSAGE_COREDATAOBJECT where ZBAREJIDSTR=?",jid];
        if(!b){
            NSLog(@"删除聊天数据失败");
        }
    }];
}

@end
