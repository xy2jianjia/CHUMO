//
//  DetailViewController.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailCell.h"
#import "MailboxController.h"
#import "DetailObject.h"
#import "BasicObject.h"
#import "DHBasicModel.h"
#define KCell_A @"kcell_1"
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,DetaiSelectorDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    NSInteger indexCell;
    NSInteger indexPathRow;
    UITableView *tempTable;
    NSIndexPath *indexPathItem;
    NSNumber *sexNum;
    
    NSString *dating_purposeStr;//交友目的
    NSString *loveValueStr; // 恋爱观
    NSString *meetingStr; // 首次见面希望
    NSString *makeLoveStr; // 喜欢爱爱的地方
    
    NSString *intentionStr; // 意向
    NSString *marriageStr;  // 婚姻
    NSString *houseStr;     // 房子
    NSString *CarStr;       // 车子
    NSString *charmStr;     // 魅力
    NSString *relationStr;  // 异地恋
    NSString *specifGirl;   // 类型
    NSString *specifBoy;
    NSString *sexUal;       // 性行为
    NSString *parentStr;    // 父母同住
    NSString *childStr;     // 孩子
    
    NSMutableDictionary *childDic;
    NSMutableDictionary *parentDic;
    NSMutableDictionary *sexUalDic;
    NSMutableDictionary *typeGrilDic;
    NSMutableDictionary *typeBoyDic;
    NSMutableDictionary *relationDic;
    NSMutableDictionary *charmDic;
    NSMutableDictionary *carDic;
    NSMutableDictionary *homeDic;
    NSMutableDictionary *marriageDic;
    NSMutableDictionary *intentionDic;
    //20160630
    NSMutableDictionary *dating_purposeDic;//新交友目的
    NSMutableDictionary *indulgedDic;//恋爱观
    NSMutableDictionary *meet_placeDic;//见面干嘛
    NSMutableDictionary *love_placeDic;//爱爱地点
}

@property (nonatomic,strong)NSArray *detaiArray;
@property (nonatomic,strong)NSMutableArray *titlePick;
@property (nonatomic,strong)NSString *titleStr;

@property (nonatomic,strong)NSArray *dating_purposeA;                 // 新交友目的
@property (nonatomic,strong)NSMutableArray * dating_purposeM;
@property (nonatomic,strong)NSArray *indulgedA;                 // 恋爱观
@property (nonatomic,strong)NSMutableArray * indulgedM;
@property (nonatomic,strong)NSArray *meet_placeA;                 // 见面干嘛
@property (nonatomic,strong)NSMutableArray * meet_placeM;
@property (nonatomic,strong)NSArray *love_placeA;                 // 爱爱地点
@property (nonatomic,strong)NSMutableArray * love_placeM;
@property (nonatomic,strong)NSArray *intention;                 // 交友意向
@property (nonatomic,strong)NSMutableArray * intentionM;
@property (nonatomic,strong)NSMutableArray *marriageM;          // 婚姻
@property (nonatomic,strong)NSArray *marriageAray;
@property (nonatomic,strong)NSMutableArray *homeM;              // 房子
@property (nonatomic,strong)NSArray *homeAray;
@property (nonatomic,strong)NSMutableArray *carM;               // 车
@property (nonatomic,strong)NSArray *carAray;
@property (nonatomic,strong)NSMutableArray *charmM;             // 魅力
@property (nonatomic,strong)NSArray *charmAray;
@property (nonatomic,strong)NSMutableArray *relationshipM;      // 异地恋
@property (nonatomic,strong)NSArray *relationshipAray;
#warning  值存入数据库 不然退出回来就没有值了
@property (nonatomic,strong)NSMutableArray *typeMboy;           // 类型(男)
@property (nonatomic,strong)NSArray *typeArayboy;
@property (nonatomic,strong)NSMutableArray *typeMgril;          // 类型(女)
@property (nonatomic,strong)NSArray *typeAraygril;
@property (nonatomic,strong)NSMutableArray *sexualM;            // 性行为
@property (nonatomic,strong)NSArray *sexualAray;
@property (nonatomic,strong)NSMutableArray *parentM;            // 父母同住
@property (nonatomic,strong)NSArray *parentAray;
@property (nonatomic,strong)NSMutableArray *childM;             // 小孩
@property (nonatomic,strong)NSArray *childAray;
@property (nonatomic,strong)NSMutableArray *pickerArray;        // 所有选择的结果

@end

@implementation DetailViewController




- (NSArray *)detaiArray {

    return @[@"恋爱观",@"首次见面希望",@"喜欢爱爱的地方",@"邮箱",@"交友目的",@"婚姻状况",@"是否有房",@"是否有车",@"魅力部位",@"是否接受异地恋",@"喜欢的异性类型",@"婚前性行为",@"和父母同住",@"是否要小孩"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kUIColorFromRGB(0xf0edf2);
    self.pickerArray = [NSMutableArray arrayWithObjects:@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写", nil];
    self.titlePick = [NSMutableArray array];
    [self.titlePick addObject:self.detaiArray];
    
    sexNum = [NSGetTools getUserSexInfo];   // 1男 2女
    [self layoutTempTable];
    [self n_datePicks];
    [self n_getmarriage];
    [self n_gethome];
    [self n_getcat];
    [self n_getcharm];
    [self n_getrelationship];
    [self n_gettype];
    [self n_getmarrySex];
    [self n_getparent];
    [self n_getchild];
    [self n_getpurpose];
    [self n_getdatingPurpose];//交友目的
    [self n_getmeetPlace];//首次见面希望
    [self n_getlovePlace];//爱爱地方
    [self n_getIndulged];
}

- (void)n_acquisition {

    DHBasicModel *item = nil;
    if (self.dataArr.count > 0) {
        
        
        item = [self.dataArr objectAtIndex:0];
        [self replaceContentWithstring:item.indulged   number:0];
        [self replaceContentWithstring:item.meet_place   number:1];
        [self replaceContentWithstring:item.love_place   number:2];
        if (item.email!=nil) {
            [self replaceContentWithstring:item.email   number:3];
        }
        [self replaceContentWithstring:item.dating_purpose   number:4];
//        [self replaceContentWithstring:item.purpose   number:1];
        [self replaceContentWithstring:item.marriage  number:5];
        [self replaceContentWithstring:item.hasRoom  number:6];
        [self replaceContentWithstring:item.hasCar  number:7];
        [self replaceContentWithstring:item.charmPart number:8];
        [self replaceContentWithstring:item.LoveOther number:9];
        [self replaceContentWithstring:item.loveType  number:10];
        [self replaceContentWithstring:item.marrySex  number:11];
        [self replaceContentWithstring:item.together   number:12];
        [self replaceContentWithstring:item.hasChild   number:13];
        
    }else{
        [self replaceContentWithstring:[DetailObject getMailbox]      number:0];
        [self replaceContentWithstring:[DetailObject getMailbox]      number:0];
        [self replaceContentWithstring:[DetailObject getIntention]    number:1];
        [self replaceContentWithstring:[DetailObject getMarriage]     number:2];
        [self replaceContentWithstring:[DetailObject getHouse]        number:3];
        [self replaceContentWithstring:[DetailObject getCar]          number:4];
        [self replaceContentWithstring:[DetailObject getcharm]        number:5];
        [self replaceContentWithstring:[DetailObject getRelationship] number:6];
        [self replaceContentWithstring:[DetailObject getSpecific]     number:7];
        [self replaceContentWithstring:[DetailObject getSexual]       number:8];
        [self replaceContentWithstring:[DetailObject getParent]       number:9];
        [self replaceContentWithstring:[DetailObject getChild]        number:10];
        
    }
    
}

/**
 *  Description
 *
 *  @param data   获取选择器的内容
 *  @param number 替换数组中的第几个
 */
- (void)replaceContentWithstring:(NSString *)data number:(int)number {
    
    if (data.length > 0) {
        self.pickerArray[number] = data;
    }else {
        self.pickerArray[number] = @"未填写";
    }
}

#pragma mark --- 小孩
- (void)n_getchild {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.childM   = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools gethasChild];
    childDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [childDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.childM addObject:valuestr];
    }
    self.childAray = [NSArray arrayWithArray:self.childM];
}
#pragma mark --- 父母同住
- (void)n_getparent {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.parentM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getliveTogether];
    parentDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [parentDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.parentM addObject:valuestr];
    }
    self.parentAray = [NSArray arrayWithArray:self.parentM];
}
#pragma mark --- 婚前性行为
- (void)n_getmarrySex {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.sexualM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getmarrySex];
    sexUalDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [sexUalDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.sexualM addObject:valuestr];
    }
    self.sexualAray = [NSArray arrayWithArray:self.sexualM];
    
}
#pragma mark --- 喜欢的类型
- (void)n_gettype {
    
    
   if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {  // 1为男 2为女
       
       NSMutableArray *sort = [NSMutableArray array];
       self.typeMboy    = [NSMutableArray array];
       NSDictionary *dic  = [NSGetSystemTools getloveType1];
       typeBoyDic = [NSMutableDictionary dictionary];
       for (NSString *s in dic) {
           
           NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
           [typeBoyDic setValue:s forKey:value];
           
           int intString = [s intValue];  // 排序
           BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
           [sort addObject:basic];
       }
       [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
       for (BasicObject *b in sort) {
           NSString *numStr = [NSString stringWithFormat:@"%@",b];
           NSString *valuestr = [dic objectForKey:numStr];
           [self.typeMboy addObject:valuestr];
       }
       self.typeArayboy = [NSArray arrayWithArray:self.typeMboy];
       
       
    }else {
        
        NSMutableArray *sort = [NSMutableArray array];
        self.typeMgril    = [NSMutableArray array];
        self.typeAraygril = [NSArray array];  // 最终的结果
        NSDictionary *dic  = [NSGetSystemTools getloveType2];
        typeGrilDic = [NSMutableDictionary dictionary];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
            [typeGrilDic setValue:s forKey:value];
            
            int intString = [s intValue];  // 排序
            BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
            [sort addObject:basic];
        }
        [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
        for (BasicObject *b in sort) {
            NSString *numStr = [NSString stringWithFormat:@"%@",b];
            NSString *valuestr = [dic objectForKey:numStr];
            [self.typeMgril addObject:valuestr];
        }
        self.typeAraygril = [NSArray arrayWithArray:self.typeMgril];
    }
}
#pragma mark --- 异地恋
- (void)n_getrelationship {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.relationshipM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools gethasLoveOther];
    relationDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [relationDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.relationshipM addObject:valuestr];
    }
    self.relationshipAray = [NSArray arrayWithArray:self.relationshipM];
    
}
#pragma mark --- 魅力
- (void)n_getcharm {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.charmM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getcharmPart];
    charmDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [charmDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.charmM addObject:valuestr];
    }
    self.charmAray = [NSArray arrayWithArray:self.charmM];
}
#pragma mark --- 车
- (void)n_getcat {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.carM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools gethasCar];
    carDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [carDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.carM addObject:valuestr];
    }
    self.carAray = [NSArray arrayWithArray:self.carM];
}
#pragma mark --- 房子
- (void)n_gethome {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.homeM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools gethasRoom];
    homeDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [homeDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.homeM addObject:valuestr];
    }
    self.homeAray = [NSArray arrayWithArray:self.homeM];
    
}
#pragma mark --- 婚姻
- (void)n_getmarriage {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.marriageM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getmarriageStatus];
    marriageDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [marriageDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.marriageM addObject:valuestr];
    }
    self.marriageAray = [NSArray arrayWithArray:self.marriageM];
}
#pragma mark --- 喜欢爱爱的地方
- (void)n_getlovePlace {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.love_placeM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getlovePlace];
    love_placeDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [love_placeDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.love_placeM addObject:valuestr];
    }
    self.love_placeA = [NSArray arrayWithArray:self.love_placeM];
}
#pragma mark --- 恋爱观
- (void)n_getIndulged {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.indulgedM   = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getIndulged];
    indulgedDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [indulgedDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.indulgedM addObject:valuestr];
    }
    self.indulgedA = [NSArray arrayWithArray:self.indulgedM];
}
#pragma mark --- 首次见面希望
- (void)n_getmeetPlace {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.meet_placeM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getmeetPlace];
    meet_placeDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [meet_placeDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.meet_placeM addObject:valuestr];
    }
    self.meet_placeA = [NSArray arrayWithArray:self.meet_placeM];
}
#pragma mark --- 交友目的
- (void)n_getdatingPurpose {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.dating_purposeM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getdatingPurpose];
    dating_purposeDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [dating_purposeDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.dating_purposeM addObject:valuestr];
    }
    self.dating_purposeA = [NSArray arrayWithArray:self.dating_purposeM];
}
#pragma mark --- 交友意向
- (void)n_getpurpose {

    NSMutableArray *sort = [NSMutableArray array];
    self.intentionM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getpurpose];
    intentionDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [intentionDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.intentionM addObject:valuestr];
    }
    self.intention = [NSArray arrayWithArray:self.intentionM];
}

#pragma mark --- pick and 代理
- (void)n_datePicks {

    self.detaPick = [[DetaiPicker alloc] initWithFrame:CGRectZero];
    self.detaPick.backgroundColor = [UIColor whiteColor];
    self.detaPick.detaisDatagate        = self;
    self.detaPick.pickerView.delegate   = self;
    self.detaPick.pickerView.dataSource = self;
    [self.view addSubview:self.detaPick];
}
#pragma mark --- 代理方法
- (void)pickerDonBtnHaveClick:(DetaiPicker *)select resultString:(NSString *)resultString {
    DHBasicModel *item = nil;
    if (self.dataArr.count > 0) {
        item = [self.dataArr objectAtIndex:0];
    }
    switch (indexCell) { //  意向
        case 0: {
            if (loveValueStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }
            
            [DetailObject updateIntentionWithStr:loveValueStr];
            item.indulged=loveValueStr;
        }
            break;
        case 1: {
            if (meetingStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }
            
            [DetailObject updateIntentionWithStr:meetingStr];
            item.meet_place=meetingStr;
        }
            break;
        case 2: {
            if (makeLoveStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }
            
            [DetailObject updateIntentionWithStr:makeLoveStr];
            item.love_place=makeLoveStr;
        }
            break;
        case 4: {
            if (dating_purposeStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateIntentionWithStr:dating_purposeStr];
            item.dating_purpose=dating_purposeStr;
        }
            break;
        case 5: {  // 婚姻状况
            if (marriageStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateMarriageWithStr:marriageStr];
            item.marriage=marriageStr;
        }
            break;
        case 6: {  // 是否有房
            if (houseStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateHouseWithStr:houseStr];
            item.hasRoom=houseStr;
        }
            break;
        case 7: {  // 是否有车
            if (CarStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateCarWithStr:CarStr];
            item.hasCar=CarStr;
        }
            break;
        case 8: {  // 魅力部位
            if (charmStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updatecharmWithStr:charmStr];
            item.charmPart=charmStr;
        }
            break;
        case 9: { //  是否接受异地
            if (relationStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateRelationshipmWithStr:relationStr];
            item.LoveOther=relationStr;
        }
            break;
        case 10: { // 喜欢的异性类型
            
            
            if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if (specifBoy == nil) {
                    [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
                }
                
                [DetailObject updateSpecificWithStr:specifBoy];
                item.loveType=specifBoy;
            }else {
                if (specifGirl == nil) {
                    [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
                }
                
                [DetailObject updateSpecificWithStr:specifGirl];
                item.loveType=specifGirl;
            }
            
        }
            break;
        case 11: { // 婚前性行为
            if (sexUal == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateSexualWithStr:sexUal];
            item.marrySex=sexUal;
        }
            break;
        case 12: { // 和父母同住
            if (parentStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateParentWithStr:parentStr];
            item.together=parentStr;
        }
            break;
        default: { // 是否要孩子
            if (childStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateChildWithStr:childStr];
            item.hasChild=childStr;
        }
            break;
    }
    [self n_acquisition];
    [tempTable reloadData];
    [self n_uploadWithString:@"未填写"];
}

#pragma mark --- 上传服务器保存用户修改的资料
- (void)n_uploadWithString:(NSString *)contentStr {
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
    
#pragma mark --- 恋爱观
//    [NSURLObject addDataWithUploadStr:self.pickerArray[0] originalStr:contentStr variableDic:dicts aNum:@"a195"];
    [NSURLObject addWithNString:self.pickerArray[0] secStr:contentStr flashDic:indulgedDic  variableDic:dicts aNum:@"a195"];
#pragma mark --- 首次见面希望做的事
//    [NSURLObject addDataWithUploadStr:self.pickerArray[1] originalStr:contentStr variableDic:dicts aNum:@"a196"];
    [NSURLObject addWithNString:self.pickerArray[1] secStr:contentStr flashDic:meet_placeDic  variableDic:dicts aNum:@"a196"];
#pragma mark --- 爱爱地点
//    [NSURLObject addDataWithUploadStr:self.pickerArray[2] originalStr:contentStr variableDic:dicts aNum:@"a197"];
    [NSURLObject addWithNString:self.pickerArray[2] secStr:contentStr flashDic:love_placeDic  variableDic:dicts aNum:@"a197"];
#pragma mark --- 注册邮箱
    [NSURLObject addDataWithUploadStr:self.pickerArray[3] originalStr:contentStr variableDic:dicts aNum:@"a146"];
    
#pragma mark --- 交友目的

    [NSURLObject addWithNString:self.pickerArray[4] secStr:contentStr flashDic:dating_purposeDic  variableDic:dicts aNum:@"a194"];
//#pragma mark --- 注册意向
//    [NSURLObject addWithNString:self.pickerArray[1] secStr:contentStr flashDic:intentionDic variableDic:dicts aNum:@"a145"];
#pragma mark --- 婚姻状况
    [NSURLObject addWithNString:self.pickerArray[5] secStr:contentStr flashDic:marriageDic  variableDic:dicts aNum:@"a46"];
#pragma mark --- 是否有房
    [NSURLObject addWithNString:self.pickerArray[6] secStr:contentStr flashDic:homeDic  variableDic:dicts aNum:@"a32"];
#pragma mark --- 是否有车
    [NSURLObject addWithNString:self.pickerArray[7] secStr:contentStr flashDic:carDic variableDic:dicts aNum:@"a29"];
#pragma mark --- 魅力部位
    [NSURLObject addWithNString:self.pickerArray[8] secStr:contentStr flashDic:charmDic  variableDic:dicts aNum:@"a8"];
#pragma mark --- 是否接受异地恋
    [NSURLObject addWithNString:self.pickerArray[9] secStr:contentStr flashDic:relationDic  variableDic:dicts aNum:@"a31"];
#pragma mark --- 喜欢的异性类型
    if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {//男
        [NSURLObject addSexWithUploadStr:self.pickerArray[10] originalStr:contentStr sexNum:sexNum flashDic:typeBoyDic variableDic:dicts aNum:@"a45"];
    }else{//女
        [NSURLObject addSexWithUploadStr:self.pickerArray[10] originalStr:contentStr sexNum:sexNum flashDic:typeGrilDic variableDic:dicts aNum:@"a45"];
    }
#pragma mark --- 婚前性行为
    [NSURLObject addWithNString:self.pickerArray[11] secStr:contentStr flashDic:sexUalDic    variableDic:dicts aNum:@"a47"];
#pragma mark --- 和父母同住
    [NSURLObject addWithNString:self.pickerArray[12] secStr:contentStr flashDic:parentDic    variableDic:dicts aNum:@"a39"];
#pragma mark --- 是否要孩子
    [NSURLObject addWithNString:self.pickerArray[13] secStr:contentStr flashDic:childDic    variableDic:dicts aNum:@"a30"];

    [NSURLObject addWithVariableDic:dicts];
    self.totleDetailSum=dicts.count-3;
    [NSURLObject addWithdict:dicts urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTotleHobby" object:nil];
    
    
}

#pragma mark --- tempTable
- (void)layoutTempTable {
    
    tempTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tempTable.backgroundColor=kUIColorFromRGB(0xf0edf2);
    tempTable.separatorStyle = UITableViewCellEditingStyleNone;
    tempTable.delegate = self;
    tempTable.dataSource = self;
    [tempTable registerClass:[DetailCell class] forCellReuseIdentifier:KCell_A];
    [self.view addSubview:tempTable];
    [self n_acquisition];
}


#pragma mark - UITabelView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detaiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_A forIndexPath:indexPath];
    [cell addTxt:self.detaiArray[indexPath.row]];
    
    DHBasicModel *item = nil;
    if (self.dataArr.count > 0) {
        item = [self.dataArr objectAtIndex:0];
    }
    if (indexPath.row == 0) {
        cell.details.text = [item.indulged length] == 0?@"未填写":[NSString stringWithFormat:@"%@",item.indulged];
    }else if (indexPath.row == 1) {
        cell.details.text = [item.meet_place length] == 0?@"未填写":[NSString stringWithFormat:@"%@",item.meet_place];
    }else if (indexPath.row == 2) {
        cell.details.text = [item.love_place length] == 0?@"未填写":[NSString stringWithFormat:@"%@",item.love_place];
    }else if (indexPath.row == 3) {
        cell.details.text = [item.email length] == 0?@"未填写":item.email;
    }else if (indexPath.row == 4){
        cell.details.text = [item.dating_purpose length] == 0?@"未填写":[NSString stringWithFormat:@"%@",item.dating_purpose];
    }else if (indexPath.row == 5){
        cell.details.text = [item.marriage length] == 0?@"未填写":item.marriage;
    }else if (indexPath.row == 6){
        cell.details.text = [item.hasRoom length] == 0?@"未填写":[NSString stringWithFormat:@"%@", item.hasRoom];
    }else if (indexPath.row == 7){
        cell.details.text = [item.hasCar length] == 0?@"未填写": [NSString stringWithFormat:@"%@",item.hasCar];
    }else if (indexPath.row == 8){
        cell.details.text = [item.charmPart length] == 0?@"未填写":[NSString stringWithFormat:@"%@", item.charmPart];
    }else if (indexPath.row == 9){
        cell.details.text = [item.LoveOther length] == 0?@"未填写":[NSString stringWithFormat:@"%@异地恋",item.LoveOther];
    }else if (indexPath.row == 10){
        cell.details.text = [item.loveType length] == 0?@"未填写":item.loveType;
    }else if (indexPath.row == 11){
        cell.details.text = [NSString stringWithFormat:@"%@",[item.marrySex length] == 0?@"未填写":[NSString stringWithFormat:@"%@婚前性行为",item.marrySex]];
    }else if (indexPath.row == 12){
        cell.details.text = [NSString stringWithFormat:@"%@",[item.together length] == 0?@"未填写":[NSString stringWithFormat:@"%@和父母同住",item.together]];
    }else if (indexPath.row == 13){
        cell.details.text = [NSString stringWithFormat:@"%@",[item.hasChild length] == 0?@"未填写":[NSString stringWithFormat:@"%@孩子",item.hasChild]];
    }
    //画线
    if (indexPath.row == 0) {
        cell.upLine.frame   = CGRectMake( 0,  0, [[UIScreen mainScreen] bounds].size.width   , 0.5);
        cell.downLine.frame = CGRectMake(10, 39, [[UIScreen mainScreen] bounds].size.width-10, 0.5);
    }else if (indexPath.row == 13) {
        cell.downLine.frame = CGRectMake( 0, 39, [[UIScreen mainScreen] bounds].size.width   , 0.5);
    }else {
        cell.upLine.frame   = CGRectMake(10, 39, [[UIScreen mainScreen] bounds].size.width-10, 0.5);
    }
    
    return cell;
}

#pragma mark -------delegata Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return [DetailCell detaiCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return gotHeight(15);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, gotHeight(15))];
    view.backgroundColor=kUIColorFromRGB(0xf0edf2);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
        return 175;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 175)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
#pragma mark -----选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.detaPick.pickerView reloadAllComponents];
    indexPathItem = indexPath;
    indexCell = indexPath.item;
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self.detaPick.nextBtn setTitle:self.detaiArray[indexPath.row]];
    if (indexPath.row == 9) {
        self.detaPick.fixedTanhuang.width = ([[UIScreen mainScreen] bounds].size.width - 195)/2;
    }
    if (indexPath.section == 0) {
        
        switch (indexPath.row) { // 选择器
            case 0: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 1: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 2: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 3:
            {
                MailboxController *mail = [[MailboxController alloc] init];
                __weak DetailViewController *detailvc=self;
                DHBasicModel *item = nil;
                if (detailvc.dataArr.count > 0) {
                    item = [detailvc.dataArr objectAtIndex:0];
                    
                }
                mail.email=item.email;
                mail.mb = ^(NSString *s){
                    
                   NSString *mailbox = s;  // 上传邮箱
                    if (mailbox == nil && mailbox == NULL) {
                        
                    }else {
                        [DetailObject updateMailboxWithStr:mailbox]; // 存储
                        [item setValue:mailbox forKey:@"email"];
                        [detailvc n_acquisition];
                        [detailvc n_uploadWithString:@"未填写"];
                        [tempTable reloadData];
                    }

                };
                
                [self.navigationController pushViewController:mail animated:true];
            }
               break;
            case 4: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 5: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 6: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 7: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 8: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 9: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 10: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 11: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 12: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            default: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
        }
    }
}

/**
 *  show  显示picker
 */
- (void)show {
    
    self.detaPick.frame = CGRectMake(0,ZHHeight - ZHAllViewHeight-64-64, ZHWidth, ZHAllViewHeight);
}

#pragma mark ---- pickerDatagate
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    switch (indexCell) {
        case 0: {
            return self.indulgedA.count;
        }
            break;
        case 1: {
            return self.meet_placeA.count;
        }
            break;
        case 2: {
            return self.love_placeA.count;
        }
            break;
        case 4: {
            return self.dating_purposeA.count;
        }
            break;
        case 5: {
            return self.marriageAray.count;
        }
            break;
        case 6: {
            return self.homeAray.count;
        }
            break;
        case 7: {
            return self.carAray.count;
        }
            break;
        case 8: {
            return self.charmAray.count;
        }
            break;
        case 9: {
            return self.relationshipAray.count;
        }
            break;
        case 10: {
            if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {
                return self.typeArayboy.count;
            }else {
                return self.typeAraygril.count;
            }
        }
            break;
        case 11: {
            return self.sexualAray.count;
        }
            break;
        case 12: {
            return self.parentAray.count;
        }
            break;
        
        default: {
            return self.childAray.count;
        }
            break;
    }
}

// 选中传值
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    indexPathRow = row;
    switch (indexCell) {
        case 0: {
            if (row>(self.indulgedA.count-1)) {
                loveValueStr = [self.indulgedA lastObject];
            }else{
                loveValueStr = self.indulgedA[row];
            }
            
        }
            break;
        case 1: {
            if (row>(self.meet_placeA.count-1)) {
                meetingStr = [self.meet_placeA lastObject];
            }else{
                meetingStr = self.meet_placeA[row];
            }
            
        }
            break;
        case 2: {
            if (row>(self.love_placeA.count-1)) {
                makeLoveStr = [self.love_placeA lastObject];
            }else{
                makeLoveStr = self.love_placeA[row];
            }
            
        }
            break;
        case 4: {
//             intentionStr = self.intention[row];//注册意向
            
            if (row>(self.dating_purposeA.count-1)) {
                dating_purposeStr = [self.dating_purposeA lastObject];
            }else{
                dating_purposeStr=self.dating_purposeA[row];
            }
        }
            break;
        case 5: {
            if (row>(self.marriageAray.count-1)) {
                marriageStr = [self.marriageAray lastObject];
            }else{
                marriageStr = self.marriageAray[row];
            }
            
        }
            break;
        case 6: {
            if (row>(self.homeAray.count-1)) {
                houseStr = [self.homeAray lastObject];
            }else{
                houseStr = self.homeAray[row];
            }
            
        }
            break;
        case 7: {
            if (row>(self.carAray.count-1)) {
                CarStr = [self.carAray lastObject];
            }else{
                CarStr = self.carAray[row];
            }
            
        }
            break;
        case 8: {
            if (row>(self.charmAray.count-1)) {
                charmStr = [self.charmAray lastObject];
            }else{
                charmStr = self.charmAray[row];
            }
            
        }
            break;
        case 9: {
            if (row>(self.relationshipAray.count-1)) {
                relationStr = [self.relationshipAray lastObject];
            }else{
                relationStr = self.relationshipAray[row];
            }
            
        }
            break;
        case 10: {
            if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if (row>(self.typeArayboy.count-1)) {
                    specifBoy = [self.typeArayboy lastObject];
                }else{
                    specifBoy = self.typeArayboy[row];
                }
                
            }else {
                if (row>(self.typeAraygril.count-1)) {
                    specifGirl = [self.typeAraygril lastObject];
                }else{
                    specifGirl = self.typeAraygril[row];
                }
                
            }
        }
            break;
        case 11: {
            if (row>(self.sexualAray.count-1)) {
                sexUal = [self.sexualAray lastObject];
            }else{
                sexUal = self.sexualAray[row];
            }
            
        }
            break;
        case 12: {
            if (row>(self.parentAray.count-1)) {
                parentStr = [self.parentAray lastObject];
            }else{
                parentStr = self.parentAray[row];
            }
            
        }
            break;
         default: {
             if (row>(self.childAray.count-1)) {
                 childStr = [self.childAray lastObject];
             }else{
                 childStr = self.childAray[row];
             }
            
        }
            break;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (indexCell) {
        case 0: {
            return [self.indulgedA objectAtIndex:row];
        }
        case 1: {
            return [self.meet_placeA objectAtIndex:row];
        }
        case 2: {
            return [self.love_placeA objectAtIndex:row];
        }
        case 4: {
            return [self.dating_purposeA objectAtIndex:row];
        }
            break;
        case 5: {
            return [self.marriageAray objectAtIndex:row];
        }
            break;
        case 6: {
            return [self.homeAray objectAtIndex:row];
        }
            break;
        case 7: {
            return [self.carAray objectAtIndex:row];
        }
            break;
        case 8: {
            return [self.charmAray objectAtIndex:row];
        }
            break;
        case 9: {
           return [self.relationshipAray objectAtIndex:row];
        }
            break;
        case 10: {
            if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {
                return [self.typeArayboy objectAtIndex:row];
            }else {
                return [self.typeAraygril objectAtIndex:row];
            }
        }
            break;
        case 11: {
            return [self.sexualAray objectAtIndex:row];
        }
            break;
        case 12: {
            return [self.parentAray objectAtIndex:row];
        }
            break;
        case 13: {
                return [self.childAray objectAtIndex:row];
            }
            break;
        default: {
            return nil;
        }
            break;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
