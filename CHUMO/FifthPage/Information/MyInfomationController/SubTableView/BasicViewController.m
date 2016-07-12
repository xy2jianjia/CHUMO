//
//  BasicViewController.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "BasicViewController.h"
#import "BasicCell.h"
#import "BasicThirCell.h"
#import "BasicNineCell.h"
#import "Province.h"
#import "BasicObject.h"
#import "DHBasicModel.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoAssets.h"
#import "BasicContactController.h"
#import "RefreshController.h"
#import "UpdataNikeNameViewController.h"
#define KCell_A @"cell_1"
#define KCell_B @"cell_2"
#define KCell_C @"cell_3"
@interface BasicViewController ()<UITableViewDataSource,UITableViewDelegate,BasicSelectorDelegate,UIPickerViewDataSource,UIPickerViewDelegate,DatePickViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate> {
    
    int age;  // 根据时间戳算出年龄
    NSIndexPath *indexPathItem;
    NSInteger cellIndex;
    NSInteger selectIndeRow;     // 记录当前选中数据
    NSInteger firstIndeRow;      // 记录第一列选中的数据
    NSInteger secondIndeRow;     // 记录第二列选中数据
    UITableView *tempTable;
    NSMutableArray *multiArray;  // 多行数据
    
    NSString *multiStr;          // 月薪1-1
    NSString *multiStrs;         // 月薪1-2
    NSString *singleStr;
    NSString *provincesStr;
    NSString *cityStr;
    
    NSString *liveStr;
    NSString *starStr;
    NSString *bloodStr;
    NSString *heightStr;
    NSString *weightStr;
    NSString *educatStr;
    NSString *occupaStr;
    
    NSMutableDictionary *starDic;  // 倒放key方便上传
    NSMutableDictionary *bloodDic;
    NSMutableDictionary *educationDic;
    NSMutableDictionary *occupationDic;
    
    NSUInteger y_indexCity;
    
}

@property (nonatomic,strong)NSArray *provinces;
@property (nonatomic,assign)NSInteger indexOfProv;         //选中城市索引
@property (nonatomic,strong)NSArray *examples;
@property (nonatomic,strong)NSArray *selectorTool;
@property (nonatomic,strong)NSArray *tempNine;             // 月收入
@property (nonatomic,strong)NSArray *nineArray;
@property (nonatomic,strong)NSArray *tempPicker;
@property (nonatomic,strong)NSMutableArray *constellation; // 星座
@property (nonatomic,strong)NSArray *star;                 // 星座
@property (nonatomic,strong)NSMutableArray *mgetblood;     // 血型
@property (nonatomic,strong)NSArray *getbloodArray;          // 血型
@property (nonatomic,strong)NSArray *heightArray;            // 身高
@property (nonatomic,strong)NSArray *weightArray;            // 体重
@property (nonatomic,strong)NSMutableArray *educationm;    // 学历
@property (nonatomic,strong)NSArray *educationArray;         // 学历
@property (nonatomic,strong)NSMutableArray *occupationm;   // 职业
@property (nonatomic,strong)NSArray *occupationArray;        // 职业
@property (nonatomic,strong)NSMutableArray *allPickerArray;  // 存储所有的值
@property (nonatomic,strong)NSMutableArray *headerArray;     // 存储昵称 性别 年龄的可变数组
@property (nonatomic,assign) BOOL isnetWroking;

@end

@implementation BasicViewController

/**
 *懒加载数据
 */
-(NSArray *)provinces{
    
    if (!_provinces) {
        //plist文件路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NewCountry.plist" ofType:nil];
        NSArray *provincePlist = [NSArray arrayWithContentsOfFile:filePath];
        
        NSMutableArray *provinceM = [NSMutableArray array];
        
        for (NSDictionary *dic in provincePlist) {
            for (NSString *key in dic) {
                NSMutableArray *cityArrayss = [NSMutableArray array];
                Province *prov = [[Province alloc] init];
                NSLog(@"省份:%@",key);
                NSDictionary *valueDic = [dic objectForKey:key];
                for (NSString *keys in valueDic) {
                    NSDictionary *citysdic = [valueDic objectForKey:keys];
                    prov.name = key;
                    for (NSString *lastKey in citysdic) {
                        
                        [cityArrayss addObject:lastKey];
                        prov.cities = cityArrayss;
                    }
                }
                [provinceM addObject:prov];
            }
        }
        _provinces = provinceM;
    }
    return _provinces;
}
/**
 *  获取城市名字
 *
 *  @param code
 *
 *  @return
 */
- (NSString *)getCityNameWithCode:(NSString *)code{
    NSString *cityName = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"provinceCode.plist" ofType:nil];
    NSDictionary *provincePlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
    for (NSString *akey in provincePlist.allKeys) {
        NSDictionary *dict = [provincePlist objectForKey:akey];
        if ([code isEqualToString:[dict objectForKey:@"provence_code"]]) {
            cityName = [dict objectForKey:@"province_name"];
            break;
        }
        
    }
    return cityName;
}
/**
 *  星座
 *
 *  @param code
 *
 *  @return
 */
//- (NSString *)getCityNameWithCode:(NSString *)code{
//    NSString *cityName = nil;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"provinceCode.plist" ofType:nil];
//    NSDictionary *provincePlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    for (NSString *akey in provincePlist.allKeys) {
//        NSDictionary *dict = [provincePlist objectForKey:akey];
//        if ([code isEqualToString:[dict objectForKey:@"provence_code"]]) {
//            cityName = [dict objectForKey:@"province_name"];
//            break;
//        }
//
//    }
//    return cityName;
//}

#pragma mark  ---- get
- (NSArray *)examples {
    
    //    return @[@"昵称",@"ID",@"性别"];
    return @[@"昵称",@"性别"];
}

- (NSArray *)selectorTool { // picker头文字
    //#warning 修改
    //    return @[@"出生日期",@"居住地",@"星座",@"血型",@"身高",@"体重",@"学历",@"职业",@"月收入",@"QQ",@"微信"];
    return @[@"出生日期",@"居住地",@"星座",@"血型",@"身高",@"体重",@"学历",@"职业",@"月收入"];
}
- (NSArray *)nineArray {
    
    return @[@"1000",@"2000",@"3000",@"4000",@"5000",@"6000",@"7000",@"8000",@"9000",@"10000",@"11000",@"12000",@"13000",@"14000",@"15000",@"16000",@"17000",@"18000"];
}

- (NSArray *)tempNine {
    
    return @[@"1000",@"2000",@"3000",@"4000",@"5000",@"6000",@"7000",@"8000",@"9000",@"10000",@"11000",@"12000",@"13000",@"14000",@"15000",@"16000",@"17000",@"18000"];
}
- (NSArray *)tempPicker {
    
    return @[@"至"];
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
#warning 修改
    self.allPickerArray = [NSMutableArray arrayWithObjects:@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写", nil];
    //    self.allPickerArray = [NSMutableArray arrayWithObjects:@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写", nil];
    self.view.backgroundColor=kUIColorFromRGB(0xf0edf2);
    self.headerArray = [NSMutableArray array];
    [self afnet];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
    
}
#pragma mark --- 数据
- (void)afnet {
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSString *p2 = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    if ([p1 length] == 0 || [p1 isEqualToString:@"(null)"] || [p2 length] == 0 || [p2 isEqualToString:@"(null)"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
        p2 = [dict objectForKey:@"userId"];
        p1 = [dict objectForKey:@"sessionId"];
    }
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
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
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
            for (NSString *key in dict2) {
#pragma mark -----  b112大部分的内容
                if ([key isEqualToString:@"b112"]) {
                    NSDictionary *Valuedic = [dict2 objectForKey:key];
                    DHBasicModel *homeModel = [[DHBasicModel alloc] init];
                    homeModel.weight     = Valuedic[@"b88"];    // b88  体重
                    homeModel.height     = Valuedic[@"b33"];    // b33  身高
                    homeModel.wageMax    = Valuedic[@"b86"];    // b86  月收入最大值
                    homeModel.wageMin    = Valuedic[@"b87"];    // b87  月收入最小值
                    homeModel.photoUrl   = Valuedic[@"b57"];    // 头像
                    homeModel.photoStatus= Valuedic[@"b142"];   // 头像审核  1通过 2等待审核 3未通过
                    homeModel.age        = Valuedic[@"b1"];     // 年龄
                    homeModel.vip        = Valuedic[@"b144"];   // vip 1yes 2no
                    
                    homeModel.describe   = Valuedic[@"b17"];    // 交友宣言
                    homeModel.d1Status   = Valuedic[@"b118"];   // 交友宣言审核  1通过 2等待审核 3未通过
                    homeModel.systemName = Valuedic[@"b152"];   // 用户系统编号
                    homeModel.id         = Valuedic[@"b34"];    // ID
                    homeModel.nickName   = Valuedic[@"b52"];    // b52  昵称
                    homeModel.status     = Valuedic[@"b75"];   // 昵称审核  1通过 2等待审核 3未通过
                    homeModel.userId     = Valuedic[@"b80"];    // b80  用户id 不能为空
                    //#warning 修改
                    //                    homeModel.wx = Valuedic[@"b157"];//微信
                    //                    homeModel.wxStatus=Valuedic[@"b159"];//微信状态
                    //                    homeModel.qq = Valuedic[@"b156"];//qq
                    //                    homeModel.qqStatus = Valuedic[@"b158"];//QQ显示状态  1:显示 2：隐藏
                    
                    if ([Valuedic[@"b69"] intValue] == 1) {  // b69  性别 1 男 2女
                        homeModel.sex = @"男";
                    }else {
                        homeModel.sex = @"女";
                    }
                    
                    
                    if (Valuedic[@"b4"] == nil) { // b4   出生日期
                        homeModel.birthday = @"未填写";
                    }else {
                        NSString *bornDay    = Valuedic[@"b4"];
                        NSArray *yearArray   = [bornDay componentsSeparatedByString:@"-"];
                        homeModel.birthday   = [NSString stringWithFormat:@"%@年%@月%@日",yearArray[0],yearArray[1],yearArray[2]];
                    }
                    
                    NSString *logTime    = Valuedic[@"b44"];    // b44  登陆时间
                    NSArray *loginArray  = [logTime componentsSeparatedByString:@":"];
                    homeModel.loginTime  = [NSString stringWithFormat:@"%@:%@",loginArray[0],loginArray[1]];
                    
                    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
                    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
                    
                    NSString *sexNum = userInfo.b69;
                    if ([sexNum integerValue] == 1) { // 1男2女
                        homeModel.loveType  = [self addWithVariable:[NSGetSystemTools getloveType1] keyStr:Valuedic[@"b45"]]; // b45  喜欢异性的类型
                        homeModel.kidney    = Valuedic[@"b37"]; // b37 个性特征
                        homeModel.favorite  = Valuedic[@"b24"]; // b24  兴趣爱好
                    }else {
                        homeModel.loveType  = [self addWithVariable:[NSGetSystemTools getloveType2] keyStr:Valuedic[@"b45"]]; // b45  喜欢异性的类型
                        homeModel.kidney    = Valuedic[@"b37"]; // b37 个性特征
                        homeModel.favorite  = Valuedic[@"b24"]; // b24  兴趣爱好
                    }
                    homeModel.charmPart = [self addWithVariable:[NSGetSystemTools getcharmPart] keyStr:Valuedic[@"b8"]];  // b8   魅力部位
                    if (Valuedic[@"b39"] == nil) { // b39  和父母同住
                        homeModel.together = @"";
                    }else {
                        homeModel.together = [NSString stringWithFormat:@"%@和父母同住",[self addWithVariable:[NSGetSystemTools getliveTogether]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b39"]]]];
                    }
                    if (Valuedic[@"b47"] == nil) { // b47  婚姻性行为
                        homeModel.marrySex = @"";
                    }else {
                        homeModel.marrySex = [NSString stringWithFormat:@"%@婚前性行为",[self addWithVariable:[NSGetSystemTools getmarrySex] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b47"]]]];
                    }
                    homeModel.marriage   = [self addWithVariable:[NSGetSystemTools getmarriageStatus] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b46"]]]; // b46  婚姻状况
                    homeModel.education  = [self addWithVariable:[NSGetSystemTools geteducationLevel] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b19"]]]; // b19  学历
                    homeModel.star       = [self addWithVariable:[NSGetSystemTools getstar]           keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b74"]]]; // b74  星座 1-12
                    if (Valuedic[@"b30"] == nil) {
                        homeModel.hasChild = @"";
                    }else {
                        homeModel.hasChild = [NSString stringWithFormat:@"%@孩子",[self addWithVariable:[NSGetSystemTools gethasChild]       keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b30"]]]];
                    } // b30  是否想要小孩
                    if (Valuedic[@"b31"] == nil) {
                        homeModel.LoveOther = @"";
                    }else {
                        homeModel.LoveOther = [NSString stringWithFormat:@"%@异地恋",[self addWithVariable:[NSGetSystemTools gethasLoveOther]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b31"]]]];
                    }
                    homeModel.hasRoom    = [self addWithVariable:[NSGetSystemTools gethasRoom]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b32"]]]; // b32  是否有房
                    homeModel.hasCar     = [self addWithVariable:[NSGetSystemTools gethasCar]         keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b29"]]]; // b29  是否有车
                    homeModel.profession = [self addWithVariable:[NSGetSystemTools getprofession]     keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b62"]]]; // b62  职业
                    homeModel.blood      = [self addWithVariable:[NSGetSystemTools getblood]          keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b5"]]];  // b5   血型
                    homeModel.city     = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b9"]]];  // b9   居住地(市)
                    homeModel.province = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b67"]]]; // b67  居住地(省)
                    
                    [self.headerArray removeAllObjects];
                    [self.headerArray addObject:homeModel];
                }
                // ======
            }
        }else if([infoDic[@"code"] integerValue] == 500){
            if (self.isnetWroking) {
                RefreshController *refre = [[RefreshController alloc] init];
                [self presentViewController:refre animated:YES completion:nil];
            }else{
                [self showHint:@"没有网络,还怎么浪~~"];
            }
//            RefreshController *refre = [[RefreshController alloc] init];
//            [self presentViewController:refre animated:YES completion:nil];
        }
        [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"NO"];
        [tempTable reloadData];
        [self layoutTempTable];
        //        [self selectorView];
        //        [self n_datePicker];
        [self n_NSMutableArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"系统参数请求失败--%@-",error);
        //        RefreshController *refre = [[RefreshController alloc] init];
        //        [self presentViewController:refre animated:YES completion:nil];
    }];
}

/**
 *  Description
 *
 *  @param variable 不可变字典
 *  @param keystr   根据key取值
 *
 *  @return 结果
 */
- (NSString *)addWithVariable:(NSDictionary *)variable keyStr:(NSString *)keystr {
    
    NSDictionary *flashdic = variable;
    return [flashdic objectForKey:keystr];
}

/**
 *  Description
 *
 *  @param VariDic 倒叙的城市/省份 字典
 *  @param keystr  key取值
 *
 *  @return 结果
 */
- (NSString *)addWithVariDic:(NSDictionary *)VariDic keyStr:(NSString *)keystr {
    
    
    NSDictionary *cityDic = VariDic;    // 市
    NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
    for (NSString *cityKey in cityDic) {
        NSString *cityValue = [cityDic objectForKey:cityKey];
        [cityDict setObject:cityKey forKey:cityValue];
    }
    return [cityDict objectForKey:[NSString stringWithFormat:@"%@",keystr]];
}

- (void)n_allPicker {
    DHBasicModel *item = nil;
    
    if (self.headerArray.count > 0) {
        item = [self.headerArray objectAtIndex:0];
        [self replaceContentWithstring:[item birthday]       number:0];
        if ([item.province length]>0&&nil!=item.province && [item.city length]>0&&nil !=item.city) {
            [self replaceContentWithstring:[NSString stringWithFormat:@"%@-%@",item.province,item.city]          number:1];
        }
        if (item.star>0&&item.star!=nil) {
            [self replaceContentWithstring:[item star] number:2];
        }
        if (item.blood>0&&item.blood!=nil) {
            [self replaceContentWithstring:[item blood] number:3];
        }
        
        if (item.height>0&&item.height!=nil) {
            [self replaceContentWithstring:[NSString stringWithFormat:@"%@",item.height] number:4];
        }
        if (item.weight>0&&nil!=item.weight) {
            [self replaceContentWithstring:[NSString stringWithFormat:@"%@",item.weight] number:5];
        }
        if (item.education>0&&nil!=item.education) {
            [self replaceContentWithstring:[item education] number:6];
        }
        if (item.profession>0&&nil!=item.profession) {
            [self replaceContentWithstring:[item profession] number:7];
        }
        if (item.wageMax>0&&nil!=item.wageMax && item.wageMin>0&&nil !=item.wageMin) {
            [self replaceContentWithstring:[NSString stringWithFormat:@"%@至%@",item.wageMax,item.wageMin] number:8];
        }
        //#warning 修改
        //
        //        if (item.qq.length>0&&nil!=item.qq) {
        //            [self replaceContentWithstring:[NSString stringWithFormat:@"%@ %@",item.qq,item.qqStatus] number:9];
        //        }
        //        if (item.wx.length>0&&nil!=item.wx) {
        //            [self replaceContentWithstring:[NSString stringWithFormat:@"%@ %@",item.wx,item.wxStatus] number:10];
        //        }
        
    }else{
        [self replaceContentWithstring:[BasicObject getbornDay]       number:0];
        [self replaceContentWithstring:[BasicObject getlive]          number:1];
        [self replaceContentWithstring:[BasicObject getconstellation] number:2];
        [self replaceContentWithstring:[BasicObject getblood]         number:3];
        [self replaceContentWithstring:[BasicObject getheight]        number:4];
        [self replaceContentWithstring:[BasicObject getweiht]         number:5];
        [self replaceContentWithstring:[BasicObject getEducation]     number:6];
        [self replaceContentWithstring:[BasicObject getOccupation]    number:7];
        [self replaceContentWithstring:[BasicObject getIncome]        number:8];
    }
    
}

/**
 *  Description
 *
 *  @param data   获取选择器的内容
 *  @param number 替换数组中的第几个
 */
- (void)replaceContentWithstring:(NSString *)data number:(int)number {
    
    if (data.length > 0 && data!=nil) {
        self.allPickerArray[number] = data;
    }else {
        self.allPickerArray[number] = @"未填写";
    }
}

#pragma mark --- 血型
- (void)n_getBoold {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.mgetblood       = [NSMutableArray array];
    NSDictionary *dic    = [NSGetSystemTools getblood];
    bloodDic             = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [bloodDic setValue:s forKey:value];
        
        int intString      = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr   = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.mgetblood addObject:valuestr];
    }
    self.getbloodArray = [NSArray arrayWithArray:self.mgetblood];
}

#pragma mark --- 职业
- (void)n_getoccupation {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.occupationm     = [NSMutableArray array];
    NSDictionary *dic    = [NSGetSystemTools getprofession];
    occupationDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [occupationDic setValue:s forKey:value];
        
        int intString      = [s intValue];
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr   = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.occupationm addObject:valuestr];
    }
    self.occupationArray = [NSArray arrayWithArray:self.occupationm];
    
}
/**
 *  Description
 *
 *  @param array    初始化的可变数组
 *  @param diction  请求的字典
 *  @param tableDic 倒叙的字典后期上传用
 *  @param result   需要返回的数组
 *
 *  @return 返回的数组
 */
- (NSArray *)addWithObjicArray:(NSMutableArray *)array ObjicDic:(NSDictionary *)diction ObjicTableDic:(NSMutableDictionary *)tableDic  resultArray:(NSArray *)result {
    
    NSMutableArray *sort = [NSMutableArray array];
    array     = [NSMutableArray array];
    NSDictionary *dic    = diction;
    tableDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [tableDic setValue:s forKey:value];
        
        int intString      = [s intValue];
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    NSLog(@"倒叙字典:%@",tableDic);
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr   = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [array addObject:valuestr];
    }
    result = [NSArray arrayWithArray:array];
    NSLog(@"数组:%@",result);
    return result;
}
#pragma mark --- 学历
- (void)n_geteducation {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.educationm      = [NSMutableArray array];
    NSDictionary *dic    = [NSGetSystemTools geteducationLevel];
    educationDic         = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [educationDic setValue:s forKey:value];
        
        int intString      = [s intValue];
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
        
    }
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr   = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.educationm addObject:valuestr];
        
    }
    self.educationArray = [NSArray arrayWithArray:self.educationm];
}
#pragma mark --- 体重
- (void)n_getweight {
    
    self.weightArray = [NSArray array];
    self.weightArray = [NSGetSystemTools getWeight];
}
#pragma mark --- 身高
- (void)n_getheight {
    
    self.heightArray = [NSArray array];
    self.heightArray = [NSGetSystemTools getBodyOneHeightData];
}
#pragma mark --- 星座
- (void)n_star {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.constellation   = [NSMutableArray array];
    NSDictionary *dic    = [NSGetSystemTools getstar];
    starDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];
        [starDic setObject:s forKey:value];
        
        int intString      = [s intValue];
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr   = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.constellation addObject:valuestr];
    }
    self.star = [NSArray arrayWithArray:self.constellation];
}
#pragma mark --- NSMutableArray （月收入）
- (void)n_NSMutableArray {
    
    multiArray = [NSMutableArray array];
    [multiArray addObject:self.tempNine  ];
    [multiArray addObject:self.tempPicker];
    [multiArray addObject:self.nineArray ];
}
#pragma mark --- datePick
- (void)n_datePicker {
    
    self.datePickers = [[DatePickView alloc] initWithFrame:CGRectZero];
    self.datePickers.backgroundColor  = [UIColor whiteColor];
    self.datePickers.datePickDelegate = self;
    [self.view addSubview:self.datePickers];
}
#pragma mark  ---- sellector
- (void)selectorView {
    
    self.selector = [[BasicSelector alloc] initWithFrame:CGRectZero];
    self.selector.backgroundColor       = [UIColor whiteColor];
    self.selector.NDelegate             = self;
    self.selector.pickerView.delegate   = self;
    self.selector.pickerView.dataSource = self;
    [self.view addSubview:self.selector];
}
#pragma mark --- datePickdatagate 自定义代理
- (void)datepickerDonBtnHaveClick:(DatePickView *)select resultString:(NSString *)resultString {
    
    if ([resultString isEqualToString:@"done"]) {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat       = @"yyyy年MM月dd日";
        NSString *str = [dateFormater stringFromDate:self.datePickers.datePicker.date];
        [BasicObject updatebornDayWithStr:str];
        DHBasicModel *item = nil;
        
        if (self.headerArray.count > 0) {
            item = [self.headerArray objectAtIndex:0];
        }
        item.birthday=str;
        [tempTable reloadData];
        [self n_allPicker];
        [self n_uploadWithOriginalStr:@"未填写"];    // 上传数据
    }
}
#pragma mark --- selectorPick自定义代理
/**
 *  Description
 *
 *  @param didSelectRow     当前列的行数（记录上次的数据取值）
 *  @param inComponent      当前行的第几列
 */
- (void)pickerDonBtnHaveClick:(BasicSelector *)select resultString:(NSString *)resultString {
    
    //    BasicNineCell * cell=[tempTable cellForRowAtIndexPath:indexPathItem];
    DHBasicModel *item = nil;
    
    if (self.headerArray.count > 0) {
        item = [self.headerArray objectAtIndex:0];
    }
    if (cellIndex == 1) { // 居住地
        
        [BasicObject updateliveWithStr:[NSString stringWithFormat:@"%@-%@",provincesStr,cityStr]];
        item.province=provincesStr;
        item.city=cityStr;
        //        self.indexOfProv=0;
        
    }else if (cellIndex == 2) {  // 星座
        
        [BasicObject updateconstellationWithStr:starStr];
        item.star=starStr;
        
    }else if (cellIndex == 3) {  // 血型
        
        item.blood=bloodStr;
        [BasicObject updatebloodWithStr:bloodStr];
        
    }else if (cellIndex == 4) {  // 身高
        
        [BasicObject updateheightWithStr:heightStr];
        item.height=heightStr;
        
    }else if (cellIndex == 5) {  // 体重
        
        [BasicObject updateweihtWithStr:weightStr];
        item.weight=weightStr;
        
    }else if (cellIndex == 6) {  // 学历
        
        [BasicObject updateEducationWithStr:educatStr];
        item.education=educatStr;
        
    }else if (cellIndex == 7) {  // 职业
        
        [BasicObject updateOccupationWithStr:occupaStr];
        item.profession=occupaStr;
        
    }else {  // 月收入
        if (multiStr  == nil) {
            [self pickerView:self.selector.pickerView didSelectRow:firstIndeRow inComponent:0];
        }
        if (multiStrs == nil) {
            [self pickerView:self.selector.pickerView didSelectRow:secondIndeRow inComponent:2];
        }
        
        if ([multiStr integerValue]>[multiStrs integerValue]) {
            NSString *moneyStr=multiStrs;
            multiStrs=multiStr;
            multiStr=moneyStr;
        }
        [BasicObject updateincomeWithStr:[NSString stringWithFormat:@"%@至%@",multiStr,multiStrs]];
        item.wageMin=[NSNumber numberWithInteger:[multiStr integerValue]];
        item.wageMax=[NSNumber numberWithInteger:[multiStrs integerValue]];
    }
    [tempTable reloadData];
    [self n_allPicker];
    [self n_uploadWithOriginalStr:@"未填写"];    // 上传数据
}

/**
 *  Description
 *
 *  @param string    需要传的值
 *  @param component 分区数
 */
- (void)addWithString:(NSString *)string inComponent:(NSInteger)component {
    
    if (string  == nil) {
        [self pickerView:self.selector.pickerView didSelectRow:selectIndeRow inComponent:component];
    }
}

#pragma mark --- temptableView
- (void)layoutTempTable {
    
    tempTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tempTable.separatorStyle = UITableViewCellEditingStyleNone;
    tempTable.backgroundColor=kUIColorFromRGB(0xf0edf2);
    tempTable.delegate   = self;
    tempTable.dataSource = self;
    [tempTable registerClass:[BasicCell class] forCellReuseIdentifier:KCell_A];
    [tempTable registerClass:[BasicThirCell class] forCellReuseIdentifier:KCell_B];
    [tempTable registerClass:[BasicNineCell class] forCellReuseIdentifier:KCell_C];
    [self.view addSubview:tempTable];
    [self n_allPicker];
    [self n_getBoold];
    [self n_star];
    [self n_getheight];
    [self n_getweight];
    [self n_geteducation];
    [self n_getoccupation];
    
}

#pragma mark --- 上传服务器保存用户修改的资料
- (void)n_uploadWithOriginalStr:(NSString *)originalStr {
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
#pragma mark --- 出生日期
    [NSURLObject addWithhBronUploadStr:self.allPickerArray[0] originalStr:originalStr variableDic:allDict aNum:@"a4"];
#pragma mark --- 居住地
    [NSURLObject addWithLiveUploadStr:self.allPickerArray[1] originalStr:originalStr variableDic:allDict aNum:@"a67" acityNum:@"a9"];
#pragma mark --- 星座
    [NSURLObject addWithNString:self.allPickerArray[2] secStr:originalStr flashDic:starDic  variableDic:allDict aNum:@"a74"];
#pragma mark --- 血型
    [NSURLObject addWithNString:self.allPickerArray[3] secStr:originalStr flashDic:bloodDic variableDic:allDict aNum:@"a5"];
#pragma mark --- 身高
    [NSURLObject addDataWithUploadStr:self.allPickerArray[4] originalStr:originalStr variableDic:allDict aNum:@"a33"];
#pragma mark --- 体重
    [NSURLObject addDataWithUploadStr:self.allPickerArray[5] originalStr:originalStr variableDic:allDict aNum:@"a88"];
#pragma mark --- 学历
    [NSURLObject addWithNString:self.allPickerArray[6] secStr:originalStr flashDic:educationDic variableDic:allDict aNum:@"a19"];
#pragma mark --- 职业
    [NSURLObject addWithNString:self.allPickerArray[7] secStr:originalStr flashDic:occupationDic variableDic:allDict aNum:@"a62"];
#pragma mark --- 月收入
    [NSURLObject addWithIncomeUploadStr:self.allPickerArray[8] originalStr:originalStr variableDic:allDict maxNum:@"a86" minNum:@"a87"];
    
    
#pragma mark --- 年龄
    
    if (![self.allPickerArray[0] isEqualToString:@"未填写"]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateStr =[formatter stringFromDate:date];
        NSArray *yearArray  = [dateStr       componentsSeparatedByString:@"年"];
        NSArray *mouthArray = [yearArray[1]  componentsSeparatedByString:@"月"];
        NSArray *bronYear  = [self.allPickerArray[0] componentsSeparatedByString:@"年"];
        NSArray *bronMouth = [bronYear[1]            componentsSeparatedByString:@"月"];
        
        int Nowmouth  = [mouthArray[0] intValue];
        int NowYear   = [yearArray[0]  intValue];
        int longmouth = [bronMouth[0]  intValue];
        int longYear  = [bronYear[0]   intValue];
        if (Nowmouth >= longmouth) {
            if (NowYear > longYear) {
                age =  NowYear - longYear;
            }
        }else {
            if (NowYear > longYear) {
                age =  NowYear - longYear - 2;
            }
        }
        if (age > 0) {
            [allDict setObject:[NSString stringWithFormat:@"%d",age] forKey:@"a1"];
            
        }
    }
    DHBasicModel *homeModel = nil;
    if (self.headerArray.count > 0) {
        homeModel = self.headerArray[0];
    }
    
    [allDict setObject:[[NSString stringWithFormat:@"%@",homeModel.nickName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"a52"];
    //统计
    self.totleBasicSum=0;
    for (int i=0; i<self.allPickerArray.count; i++) {
        if(![self.allPickerArray[i]isEqualToString:@"未填写"]){
            self.totleBasicSum++;
        }
    }
    self.totleBasicSum+=2;//加性别和昵称
    [allDict setObject:[NSGetTools getUserSexInfo] forKey:@"a69"];  // 性别
    [allDict setObject:[NSGetTools getB34] forKey:@"a34"];          // a34 ID
    [NSURLObject addWithdict:allDict urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeNickNameNotification" object:[NSString stringWithFormat:@"%@",homeModel.nickName]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTotleHobby" object:nil];
}

#pragma mark - UITabelView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTIONNUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        
        return self.examples.count;
    }else {
        
        return self.selectorTool.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DHBasicModel *homeModel = nil;
    if (self.headerArray.count > 0) {
        homeModel = self.headerArray[0];
    }
    if (indexPath.section == 0) {
        BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_A forIndexPath:indexPath];
        [cell addWithText:@"头像" portrait:[NSURL URLWithString:homeModel.photoUrl] arrow:@"List-arrow-normal"];
        return cell;
    }else if (indexPath.section == 1) {
        BasicThirCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_B forIndexPath:indexPath];
        [cell addTxt:self.examples[indexPath.row]];
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.details.text = homeModel.nickName;
            cell.oneLine.frame = CGRectMake(0, 0,   [[UIScreen mainScreen] bounds].size.width   , 0.5);
            cell.lines.frame   = CGRectMake(10, 40, [[UIScreen mainScreen] bounds].size.width-10, 0.5);
        }else if (indexPath.section == 1 && indexPath.row == 1){
            cell.details.text = homeModel.sex;
            cell.oneLine.frame = CGRectMake(0, 39,  [[UIScreen mainScreen] bounds].size.width   , 0.5);
            cell.lines.frame   = CGRectMake(10, 0,  [[UIScreen mainScreen] bounds].size.width-10, 0.5);
        }
        return cell;
        
    }else {  // picker content
        
        BasicNineCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_C forIndexPath:indexPath];
        [cell addTxtleft:self.selectorTool[indexPath.row]];
        DHBasicModel *item = nil;
        
        if (self.headerArray.count > 0) {
            item = [self.headerArray objectAtIndex:0];
        }
        if (indexPath.row == 0) {
            cell.rightLabel.text = [item.birthday length] == 0?@"未填写":item.birthday;
        }else if (indexPath.row == 1){
            cell.rightLabel.text = [item.city length] == 0?@"未填写":item.city;
        }else if (indexPath.row == 2){
            cell.rightLabel.text = [item.star length] == 0?@"未填写":item.star;
        }else if (indexPath.row == 3){
            cell.rightLabel.text = [item.blood length] == 0?@"未填写":[NSString stringWithFormat:@"%@ 型", item.blood];
        }else if (indexPath.row == 4){
            cell.rightLabel.text = [item.height integerValue] == 0?@"未填写":[NSString stringWithFormat:@"%@cm",item.height];
        }else if (indexPath.row == 5){
            cell.rightLabel.text = [item.weight integerValue] == 0?@"未填写": [NSString stringWithFormat:@"%@kg",item.weight];
            
        }else if (indexPath.row == 6){
            cell.rightLabel.text = [item.education length] == 0?@"未填写":item.education;
        }else if (indexPath.row == 7){
            cell.rightLabel.text = [item.profession length] == 0?@"未填写":item.profession;
        }else if (indexPath.row == 8){
            cell.rightLabel.text = [NSString stringWithFormat:@"%@~%@",[item.wageMin integerValue] == 0?@"未填写":item.wageMin,[item.wageMax integerValue] == 0?@"未填写":item.wageMax];
        }
        
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            cell.upLine.frame   = CGRectMake( 0,  0, [[UIScreen mainScreen] bounds].size.width   , 0.5);
            cell.downLine.frame = CGRectMake(10, 39, [[UIScreen mainScreen] bounds].size.width-10, 0.5);
        }else if (indexPath.section == 2 && indexPath.row == 10){
            cell.upLine.frame   = CGRectMake( 0, 39, [[UIScreen mainScreen] bounds].size.width   , 0.5);
        }else {
            cell.downLine.frame = CGRectMake(10, 39, [[UIScreen mainScreen] bounds].size.width-10, 0.5);
        }
        return cell;
    }
}

#pragma mark -------delegata Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [BasicCell basicCellHeight];
    }else {
        return [BasicThirCell basicThirCellHeight];
    }
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
    
    if (section == 2) {
        return 175;
    }else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 175)];
        view.backgroundColor=[UIColor clearColor];
        return view;
    }else {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
        view.backgroundColor=kUIColorFromRGB(0xf0edf2);
        return view;
    }
}
#pragma mark -----选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cellIndex = indexPath.item;
    indexPathItem = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.selector.nextBtn setTitle:self.selectorTool[indexPath.row]];   // 选择器--头名称
    
    if (indexPath.section == 0) {
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本地相册",nil];
        [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            DHBasicModel *homeModel = nil;
            if (self.headerArray.count > 0) {
                homeModel = self.headerArray[0];
            }
            
            UpdataNikeNameViewController *updateVC=[[UpdataNikeNameViewController alloc]init];
            updateVC.currentName=homeModel.nickName;
            updateVC.UB=^(NSString *nickName){
                if (nil==nickName|| NULL==nickName || [nickName isKindOfClass:[NSNull class]] ||[[nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
                    
                }else{
                    [NSGetTools updateUserNickName:nickName];
                    [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:@"nickName"];
                    [homeModel setValue:nickName forKey:@"nickName"];
                    [tempTable reloadData];
                    [self n_allPicker];
                    [self n_uploadWithOriginalStr:@"未填写"];    // 上传数据
                }
                
            };
            [self.navigationController pushViewController:updateVC animated:YES];
        }
    }
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            [self showdataPick];
        }else {
            
            [self.datePickers removeFromSuperview];
            [self selectorView];
            [self.selector.pickerView selectRow:0 inComponent:0 animated:NO];
            [self.selector.pickerView reloadAllComponents];
            if (indexPath.row==1 &&indexPath.section==2) {
                
                
                [self.selector.pickerView selectRow:y_indexCity inComponent:0 animated:NO];
                [self show];
                return;
            }
            
            [self.selector.pickerView reloadAllComponents];
            [self show];
            
            
            
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self openCamera];
            break;
        case 1:  //打开本地相册
            [self openLocalPhoto];
            break;
    }
}
#pragma mark - 拍照
- (void)openCamera{
    NSUInteger sourceType = 0;
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    // 拍照
    sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSArray *arr = [NSArray arrayWithObject:image];
    picker.allowsEditing = YES;
    [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"YES"];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self uploadImageTosever:arr];
        
    }];
    
    
}

/**
 *  上传头像
 *
 *  @param assets 图片数组LP-file-msc/f_107_10_2.service？a102：图片文件流
 */
- (void)uploadImageTosever:(NSArray *)assets{
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessonId = [NSGetTools getUserSessionId];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    if ([userId length] == 0 || [userId isEqualToString:@"(null)"] || [sessonId length] == 0 || [sessonId isEqualToString:@"(null)"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
        userId = [dict objectForKey:@"userId"];
        sessonId = [dict objectForKey:@"sessionId"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@f_107_10_2.service?p1=%@&p2=%@&%@",kServerAddressTest3,sessonId,userId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    for (int i = 0; i < assets.count;  i ++) {
        
        UIImage *image=[DHTool fixOrientation:assets[i]];
        NSData *data = UIImageJPEGRepresentation(image, 1);
        float index = 1.0;
        NSInteger dataLength=data.length;
        while (dataLength > 1024*500) {
            index = index - 0.1;
            dataLength*=index;
        }
        
        data = UIImageJPEGRepresentation(image, index);
        NSMutableData *myRequestData=[NSMutableData data];
        //分界线 --AaB03x
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableString *imgbody = [[NSMutableString alloc] init];
        ////添加分界线，换行
        [imgbody appendFormat:@"%@\r\n",MPboundary];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmsssss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@", str];
        //声明pic字段，文件名为数字.png，方便后面使用
        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",@"a102",fileName];
        //声明上传文件的格式
        //            [imgbody appendFormat:@"Content-Type: image/png\r\n\r\n"];
        [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
        //声明myRequestData，用来放入http body
        
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [request addRequestHeader:@"Content-Type" value:content];
        //设置http body
        [request setPostBody:myRequestData];
        [request setRequestMethod:@"POST"];
        [request setTimeOutSeconds:1200];
        [request setDelegate:self];
        [request startSynchronous];
        NSData *resultData = request.responseData;
        NSInteger responseCode = [request responseStatusCode];
        NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if (responseCode == 200 && [codeNum integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:@"上传成功!"];
                self.otherSum=1;
                NSDictionary *imageDic=infoDic[@"body"][0];
                
                NSString *imageUrl = imageDic[@"b57"];
                DHBasicModel *homeModel = nil;
                if (self.headerArray.count > 0) {
                    homeModel = self.headerArray[0];
                    [homeModel setValue:imageUrl forKey:@"photoUrl"];
                    [tempTable reloadData];
                }
                //通知主页修改头像
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeHeadImageNotification" object:imageUrl];
                //通知修改统计数目
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTotleHobby" object:nil];
                //通知上传中
                
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *msg = [infoDic objectForKey:@"msg"];
                if (msg) {
                    [self showHint:msg];
                }else{
                    [self showHint:@"上传失败，请反馈给我们或者重新登录~"];
                }
                
            });
        }
        [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"NO"];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"NO"];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - 本地相册
- (void)openLocalPhoto{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选9张图片
    pickerVc.maxCount = 1;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:self];
    
    __weak typeof(self) weakSelf = self;
    [Mynotification postNotificationName:@"NotificationUploadShowHudsever" object:@"YES"];
    pickerVc.callBack = ^(NSArray *assets){
        //        [weakSelf.imageArr addObjectsFromArray:assets];
        NSMutableArray *imageArr=[NSMutableArray array];
        for (int i = 0;i <assets.count; i ++) {
            UIImage *originImage= [assets[i] originImage];
            [imageArr addObject:originImage];
        }
        [self uploadImageTosever:imageArr];
        //        [weakSelf.collectionView reloadData];
    };
    
    
}
/**
 *  show  显示picker
 */
- (void)show {
    
    self.selector.frame = CGRectMake(0,ZHHeight - ZHAllViewHeight-64-64, ZHWidth, ZHAllViewHeight);
    //    [self pickerView:self.selector.pickerView didSelectRow:0 inComponent:0];
}

- (void)showdataPick {
    [self n_datePicker];
    self.datePickers.frame = CGRectMake(0,ZHHeight - ZHAllViewHeight-64-64, ZHWidth, ZHAllViewHeight);
}

#pragma mark ---- picker
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (cellIndex == 1) {
        return 2;
    }else if (cellIndex == 8) {
        return 3;
    }else {
        return 1;
    }
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (cellIndex == 1) {
        if (component == 0) {
            // 返回省份的城市个数
            return self.provinces.count;
        }else{
            // 第2组返回的城市个数为 ”当前索引“ 所对应省份的个数
            Province *prov = self.provinces[self.indexOfProv];
            return prov.cities.count;
        }
    }else if (cellIndex == 2) { // 星座
        return self.star.count;
    }else if (cellIndex == 3) { // 血型
        return self.getbloodArray.count;
    }else if (cellIndex == 4) { // 身高
        return self.heightArray.count;
    }else if (cellIndex == 5) { // 体重
        return self.weightArray.count;
    }else if (cellIndex == 6) { // 学历
        return self.educationArray.count;
    }else if (cellIndex == 7) { // 职业
        return self.occupationArray.count;
    }else {
        NSMutableArray *item = multiArray[component];
        return item.count;
    }
}

// 选中传值
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    selectIndeRow = row;
    if (cellIndex == 1) {
        if (component == 0) {
            self.indexOfProv = row;
            y_indexCity=row;
            
            [pickerView reloadComponent:1];
            Province *prov = self.provinces[row];
            provincesStr = prov.name;
        }else {
            //            _indexOfProv = row;
            Province *prov = self.provinces[self.indexOfProv];
            cityStr = prov.cities[row];
            
        }
    }else if (cellIndex == 2) {  // 星座
        starStr = self.star[row];
    }else if (cellIndex == 3) {  // 血型
        bloodStr = self.getbloodArray[row];
    }else if (cellIndex == 4) {  // 身高
        heightStr = self.heightArray[row];
    }else if (cellIndex == 5) {  // 体重
        weightStr = self.weightArray[row];
    }else if (cellIndex == 6) {  // 学历
        educatStr = self.educationArray[row];
    }else if (cellIndex == 7) {  // 职业
        occupaStr = self.occupationArray[row];
    }else {
        NSString *content = multiArray[component][row];
        switch (component) {
            case 0:
            {
                multiStr = content;
                firstIndeRow = row;
            }
                break;
            case 1:
            {
                NSLog(@"我是至  月薪一项");
            }
                break;
            case 2:
            {
                multiStrs = content;
                secondIndeRow = row;
            }
                break;
                
            default:
                break;
        }
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (cellIndex == 1) {
        if (component == 0) {
            Province *prov = self.provinces[row];
            provincesStr = prov.name;
            return prov.name;
        }else{
            Province *prov = self.provinces[self.indexOfProv];
            cityStr = prov.cities[row];
            return prov.cities[row];
        }
        
    }else if (cellIndex == 2) {  // 星座
        starStr = self.star[row];
        return self.star[row];
    }else if (cellIndex == 3) {  // 血型
        bloodStr = self.getbloodArray[row];
        return self.getbloodArray[row];
    }else if (cellIndex == 4) {  // 身高
        heightStr = self.heightArray[row];
        return self.heightArray[row];
    }else if (cellIndex == 5) {  // 体重
        weightStr = self.weightArray[row];
        return self.weightArray[row];
    }else if (cellIndex == 6) {  // 学历
        educatStr = self.educationArray[row];
        return self.educationArray[row];
    }else if (cellIndex == 7) {  // 职业
        occupaStr = self.occupationArray[row];
        return self.occupationArray[row];
    }else {
        if (component == 0) {
            return self.tempNine[row];
        }if (component == 1){
            return self.tempPicker[row];
        }else {
            return self.nineArray[row];
        }
    }
}

// 左右比例
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (cellIndex == 1) {
        return [[UIScreen mainScreen] bounds].size.width/2;
    }else if (cellIndex == 8) {
        return [[UIScreen mainScreen] bounds].size.width/3;
    }else {
        return [[UIScreen mainScreen] bounds].size.width;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 实时检测网络
-(void)havingNetworking:(NSNotification *)isNetWorking{
    NSString *sender = isNetWorking.object;
    self.isnetWroking=[sender boolValue];
    
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
