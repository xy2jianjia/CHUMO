//
//  ConditionController.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "ConditionController.h"
#import "NConditionCell.h"
#import "BasicObject.h"
#import "Province.h"
#import "ConditionObject.h"
#import "RefreshController.h"
@interface ConditionController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ConditionDelegate>
{
    UITableView *paraTabelView;
    NSInteger cellIndex;
    NSInteger selectIndeRow;     // 记录当前选中数据
    NSMutableArray *multiArray;  // 月收入
    NSMutableArray *ageMuArray;
    NSMutableArray *heightMuArray;
    NSMutableDictionary *marriageDic;
    NSMutableDictionary *educationDic;
    
    NSString *ageStr;
    NSString *secAgeStr;
    NSString *heightStr;
    NSString *secHeightStr;
    NSString *marriageStr;
    NSString *educationStr;
    NSString *incomeStr;
    NSString *secIncomeStr;
    NSString *provinceStr;
    NSString *cityStr;
    
    NSInteger indexCity;   // 城市选中索引
    
}
@property (nonatomic,strong)NSMutableArray *allPickerArray;  // 存储所有的值

@property (nonatomic,strong)NSArray *typeArray;
@property (nonatomic,strong)NSArray *ageArray;
@property (nonatomic,strong)NSArray *secAgeArray;
@property (nonatomic,strong)NSArray *heightArray;
@property (nonatomic,strong)NSArray *secHeightArray;
@property (nonatomic,strong)NSMutableArray *marriageM;          // 婚姻
@property (nonatomic,strong)NSArray *marriageAray;
@property (nonatomic,strong)NSMutableArray *educationm;         // 学历
@property (nonatomic,strong)NSArray *educationArray;

@property (nonatomic,strong)NSArray *income;                    // 月收入
@property (nonatomic,strong)NSArray *incomeArray;
@property (nonatomic,strong)NSArray *incomeTo;

@property (nonatomic,strong)NSArray *provinces;                 // city
@property (nonatomic,assign)NSInteger indexOfProv;              //选中城市索引
@property (nonatomic,strong)NSArray *aboutTO;
@property (nonatomic,assign) BOOL isnetWroking;
@end

@implementation ConditionController

- (NSArray *)income {
    
    return @[@"1000",@"2000",@"3000",@"4000",@"5000",@"6000",@"7000",@"8000",@"9000",@"10000",@"11000",@"12000",@"13000",@"14000",@"15000",@"16000",@"17000",@"18000"];
}

- (NSArray *)incomeArray {
    
    return @[@"1000",@"2000",@"3000",@"4000",@"5000",@"6000",@"7000",@"8000",@"9000",@"10000",@"11000",@"12000",@"13000",@"14000",@"15000",@"16000",@"17000",@"18000"];
}
#pragma mark --- get
- (NSArray *)typeArray {
    
    return @[@"年龄范围",@"身高范围",@"婚姻状况",@"学历",@"月收入",@"所在地区"];

}

- (NSArray *)incomeTo {
    
    return @[@"至"];
}

- (NSArray *)aboutTO {
    
    return @[@"-"];
}
/**
 * 懒加载数据
 */
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


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allPickerArray = [NSMutableArray arrayWithObjects:@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写", nil];
    [self conditionRuqester];
    [self layoutParallax];
    [self n_conditionPick];
    // income
    multiArray = [NSMutableArray array];
    [multiArray addObject:self.income  ];
    [multiArray addObject:self.incomeTo];
    [multiArray addObject:self.incomeArray];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    self.navigationItem.title=@"择友条件";
    [Mynotification addObserver:self selector:@selector(conditionRuqester) name:@"reloadFriendData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havingNetworking:) name:@"AFNetworkReachabilityStatusYes" object:nil];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}

#pragma mark ----- b114择友条件记录a34
- (void)conditionRuqester {
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_110_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
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
            NSLog(@"字典-----:%@",dict2[@"b34"]);
            if ([dict2 objectForKey:@"b34"]) {
                [NSURLObject updateConditFriendWithStr:dict2[@"b34"]];
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
        //NSLog(@"---系统参数---%@",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"系统参数请求失败--%@-",error);
//        RefreshController *refre = [[RefreshController alloc] init];
//        [self presentViewController:refre animated:YES completion:nil];
    }];
    
}

- (void)n_pickerViewContents {

    // age
    ageMuArray       = [NSMutableArray array];
    self.ageArray    = [NSArray array];
    self.ageArray    = [NSGetSystemTools getAgeData];
    self.secAgeArray = [NSArray arrayWithArray:self.ageArray];
    [ageMuArray addObject:self.ageArray];
    [ageMuArray addObject:self.incomeTo];
    [ageMuArray addObject:self.secAgeArray];
    
    // height
    heightMuArray       = [NSMutableArray array];
    self.heightArray    = [NSArray array];
    self.heightArray    = [NSGetSystemTools getBodyHeightData];
    self.secHeightArray = [NSArray arrayWithArray:_heightArray];
    [heightMuArray addObject:_heightArray];
    [heightMuArray addObject:self.aboutTO];
    [heightMuArray addObject:self.secHeightArray];
    
    // marriage
    NSMutableArray *sort = [NSMutableArray array];
    self.marriageM    = [NSMutableArray array];
//    NSArray *arr = [DBManager asyncSystemDataWithB20_catagery:@"marriageStatus"];
//    for (DHSystemDataModel *item in arr) {
//        
//    }
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
    // education
    NSMutableArray *sortEducation = [NSMutableArray array];
    self.educationm   = [NSMutableArray array];
    NSDictionary *dicEducation  = [NSGetSystemTools geteducationLevel];
    educationDic = [NSMutableDictionary dictionary];
    for (NSString *s in dicEducation) {
        
        NSString *value = [dicEducation objectForKey:s];  // 倒放字典方便上传
        [educationDic setValue:s forKey:value];
        
        int intString = [s intValue];
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sortEducation addObject:basic];
    }
    [sortEducation sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sortEducation) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dicEducation objectForKey:numStr];
        [self.educationm addObject:valuestr];
    }
    self.educationArray = [NSArray arrayWithArray:self.educationm];
}

- (void)n_conditionPick {

    self.condition = [[ConditionPick alloc] initWithFrame:CGRectZero];
    self.condition.conditionDelegate     = self;
    self.condition.pickerView.delegate   = self;
    self.condition.pickerView.dataSource = self;
    [self.view addSubview:self.condition];
}

- (void)n_allPicker {
    
    [self replaceContentWithstring:[ConditionObject getAge]       number:0];
    [self replaceContentWithstring:[ConditionObject getHeight]    number:1];
    [self replaceContentWithstring:[ConditionObject getMarriage]  number:2];
    [self replaceContentWithstring:[ConditionObject getEducation] number:3];
    [self replaceContentWithstring:[ConditionObject getIncome]    number:4];
    [self replaceContentWithstring:[ConditionObject getProvinces] number:5];
    
}
/**
 *  Description
 *
 *  @param data   获取选择器的内容
 *  @param number 替换数组中的第几个
 */
- (void)replaceContentWithstring:(NSString *)data number:(int)number {
    
    if (data.length > 0) {
        self.allPickerArray[number] = data;
    }else {
        self.allPickerArray[number] = @"未填写";
    }
}

#pragma mark --- pick代理
- (void)conditionPickDonBtnHaveClick:(ConditionPick *)select {

    if (cellIndex == 0) {
        
        [self addWithString:ageStr inComponent:0];
//        [self addWithString:secAgeStr inComponent:2];
        [ConditionObject updateAgeWithStr:ageStr];
        
    }else if (cellIndex == 1) {
        
        [self addWithString:heightStr inComponent:0];
//        [self addWithString:secHeightStr inComponent:2];
        [ConditionObject updateHeightWithStr:heightStr];
        
    }else if (cellIndex == 2) {
        
        [self addWithString:marriageStr inComponent:0];
        [ConditionObject updateMarriageWithStr:marriageStr];
        
    }else if (cellIndex == 3) {
        
        [self addWithString:educationStr inComponent:0];
        [ConditionObject updateEducationWithStr:educationStr];
        
    }else if (cellIndex == 4) {
        if ([incomeStr integerValue]>[secIncomeStr integerValue]) {
            NSString *moneyStr=secIncomeStr;
            secIncomeStr=incomeStr;
            incomeStr=moneyStr;
        }
        [self addWithString:incomeStr inComponent:0];
        [self addWithString:secIncomeStr inComponent:2];
        [ConditionObject updateIncomeWithStr:[NSString stringWithFormat:@"%@至%@",incomeStr,secIncomeStr]];
        
    }else {
        
        if (provinceStr  == nil) {
            [self pickerView:self.condition.pickerView didSelectRow:self.indexOfProv inComponent:0];
        }
        if (cityStr  == nil) {
            [self pickerView:self.condition.pickerView didSelectRow:indexCity inComponent:1];
        }
        [ConditionObject updateProvincesWithStr:[NSString stringWithFormat:@"%@-%@",provinceStr,cityStr]];
    }
    [paraTabelView reloadData];
    [self n_allPicker];
    [self n_UploadDataOriginalStr:@"未填写"];
}

#pragma mark -- Upload上传数据
- (void)n_UploadDataOriginalStr:(NSString *)originalStr{

    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSMutableDictionary *uploadDic = [NSMutableDictionary dictionary];
    NSLog(@"年龄范围----》:%@",self.allPickerArray[0]);
#pragma mark  ---- 年龄
//    [NSURLObject addDataWithUploadStr:self.allPickerArray[0] originalStr:originalStr variableDic:uploadDic aNum:@"a1"];
    [NSURLObject addArrayWithNString:self.allPickerArray[0] secStr:originalStr flashDic:self.ageArray variableDic:uploadDic aNum:@"a1"];
#pragma mark  ---- 身高
//    [NSURLObject addDataWithUploadStr:self.allPickerArray[1] originalStr:originalStr variableDic:uploadDic aNum:@"a33"];
    [NSURLObject addArrayWithNString:self.allPickerArray[1] secStr:originalStr flashDic:self.heightArray variableDic:uploadDic aNum:@"a33"];
#pragma mark  ---- 婚姻
    [NSURLObject addWithNString:self.allPickerArray[2] secStr:originalStr flashDic:marriageDic  variableDic:uploadDic aNum:@"a46"];
#pragma mark  ---- 学历
    [NSURLObject addWithNString:self.allPickerArray[3] secStr:originalStr flashDic:educationDic variableDic:uploadDic aNum:@"a19"];
#pragma mark  ---- 月收入
    if (![self.allPickerArray[4] isEqualToString:originalStr]) {
        
        NSArray *incomeArray  = [self.allPickerArray[4] componentsSeparatedByString:@"至"];
        NSString *incomeStrs = [NSString stringWithFormat:@"%@-%@",incomeArray[0],incomeArray[1]];
        [uploadDic setObject:incomeStrs forKey:@"a85"];
    }
#pragma mark  ---- 地区
    [NSURLObject addWithLiveUploadStr:self.allPickerArray[5] originalStr:originalStr variableDic:uploadDic aNum:@"a67" acityNum:@"a9"];
    if ([NSURLObject getConditFriend]) {
        [uploadDic setObject:[NSURLObject getConditFriend] forKey:@"a34"];
    }
    
    NSLog(@"%@",[NSURLObject getConditFriend]);
#pragma mark  ---- 上传服务器
    [NSURLObject addWithdict:uploadDic urlStr:[NSString stringWithFormat:@"%@f_110_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];
    
}

/**
 *  Description
 *
 *  @param string    需要传的值
 *  @param component 分区数
 */
- (void)addWithString:(NSString *)string inComponent:(NSInteger)component {
    
    if (string  == nil) {
        [self pickerView:self.condition.pickerView didSelectRow:selectIndeRow inComponent:component];
    }
}

#pragma mark --- left点击事件
- (void)leftAction {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}
#pragma mark --- tabelView
- (void)layoutParallax
{
    paraTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    paraTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    paraTabelView.delegate = self;
    paraTabelView.dataSource = self;
    paraTabelView.backgroundColor = kUIColorFromRGB(0xEEEEEE);
    [paraTabelView registerClass:[NConditionCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:paraTabelView];
    [self n_allPicker];
    [self n_pickerViewContents];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell addTitletype:self.typeArray[indexPath.row]];
        [cell.contents setText:self.allPickerArray[indexPath.row]];
   
        if (indexPath.row == 0) {
            cell.upLine.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5);
            cell.allLine.frame = CGRectMake(20, 44.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        }else if (indexPath.row == 5) {
            cell.allLine.frame = CGRectMake(0, 44.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        }else {
            cell.allLine.frame = CGRectMake(20, 44.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        }
        return cell;
}

#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NConditionCell conditionCellHeight];
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return gotHeight(12);
}

#pragma mark --- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cellIndex = indexPath.item;
    [self.condition.pickerView reloadAllComponents];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self show];
        
    }else if (indexPath.row == 1){
        [self show];
        
    }else if (indexPath.row == 2){
        [self show];
        
    }else if (indexPath.row == 3){
        [self show];
        
    }else if (indexPath.row == 4){
        [self show];
       
    }else if (indexPath.row == 5){
        [self show];
    }
}

/**
 *  show  显示picker
 */
- (void)show {
    
    self.condition.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height - 240, [[UIScreen mainScreen] bounds].size.width, 240);
}


#pragma mark -- pickerView 
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (cellIndex == 4) {
        return 3;
    }else if (cellIndex == 0) {
        return 1;
    }else if (cellIndex == 1) {
        return 1;
    }else if (cellIndex == 5) {
        return 2;
    }else {
        return 1;
    }
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (cellIndex == 0) {
        NSMutableArray *item = ageMuArray[component];
        return item.count;
    }else if (cellIndex == 1) {
        NSMutableArray *item = heightMuArray[component];
        return item.count;
    }else if (cellIndex == 2) {
        return self.marriageAray.count;
    }else if (cellIndex == 3) {
        return self.educationArray.count;
    }else if (cellIndex == 4) {
        NSMutableArray *item = multiArray[component];
        return item.count;
    }else {
        if (component == 0) {
            // 返回省份的城市个数
            return self.provinces.count;
        }else{
            // 第2组返回的城市个数为 ”当前索引“ 所对应省份的个数
            Province *prov = self.provinces[self.indexOfProv];
            return prov.cities.count;
        }
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (cellIndex == 0) {
//        if (component == 0) {
//            NSDictionary *dict = [self.ageArray objectAtIndex:row];
//            
//            return [dict objectForKey:[[dict allKeys] objectAtIndex:0]];;
//        }if (component == 1){
//            return self.incomeTo[row];
//        }else {
//            return self.secAgeArray[row];
//        }
        NSDictionary *dict = [self.ageArray objectAtIndex:row];
        
        return [dict objectForKey:[[dict allKeys] objectAtIndex:0]];
        
    }else if (cellIndex == 1){
//        if (component == 0) {
//            NSDictionary *dict = [self.heightArray objectAtIndex:row];
//            
//            return [dict objectForKey:[[dict allKeys] objectAtIndex:0]];
////            self.heightArray[row];
//        }if (component == 1){
//            return self.aboutTO[row];
//        }else {
//            return self.secHeightArray[row];
//        }
        NSDictionary *dict = [self.heightArray objectAtIndex:row];
        
        return [dict objectForKey:[[dict allKeys] objectAtIndex:0]];
        
    }else if (cellIndex == 2){
        return self.marriageAray[row];
    }else if (cellIndex == 3){
        return self.educationArray[row];
    }else if (cellIndex == 4){
        if (component == 0) {
            return self.income[row];
        }if (component == 1){
            return self.incomeTo[row];
        }else {
            return self.incomeArray[row];
        }
    }else {
        if (component == 0) {
            Province *prov = self.provinces[row];
            return prov.name;
            NSLog(@"省份----%@",prov.name);
        }else{
            Province *prov = self.provinces[self.indexOfProv];
            NSLog(@"城市----%@",prov.cities[row]);
            cityStr = prov.cities[row];
            return prov.cities[row];
        }
    }
}

// 选中传值
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    selectIndeRow = row;
    if (cellIndex == 0) {
        NSDictionary *dict = ageMuArray[component][row];
//        NSString *content = [[dict allKeys] objectAtIndex:0];
        NSString *content =[dict objectForKey:[[dict allKeys] objectAtIndex:0]];
        switch (component) {
            case 0:
            {
                ageStr = content;
            }
                break;
            case 2:
            {
                secAgeStr = content;
            }
                break;
            default:
                break;
        }
        
    }else if (cellIndex == 1){
        NSDictionary *dict = heightMuArray[component][row];
        NSString *content =[dict objectForKey:[[dict allKeys] objectAtIndex:0]];
//        NSString *content = [[dict allKeys] objectAtIndex:0];
//        NSString *content = heightMuArray[component][row];
        switch (component) {
            case 0:
            {
                heightStr = content;
            }
                break;
            case 2:
            {
                secHeightStr = content;
            }
                break;
            default:
                break;
        }
        
    }else if (cellIndex == 2){
        marriageStr = self.marriageAray[row];
    }else if (cellIndex == 3){
        educationStr = self.educationArray[row];
    }else if (cellIndex == 4){
        NSString *content = multiArray[component][row];
        switch (component) {
            case 0:
            {
                incomeStr = content;
            }
                break;
            case 2:
            {
                secIncomeStr = content;
            }
                break;
            default:
                break;
        }
    }else {
        if (component == 0) {
            self.indexOfProv = row;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:true];
            Province *prov = self.provinces[row];
            provinceStr = prov.name;
            NSLog(@"省份----%@",prov.name);
        }else {
            indexCity = row;
            Province *prov = self.provinces[self.indexOfProv];
//            cityStr = prov.cities[row];
            
        }
    }

}
// 左右比例
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    if (cellIndex == 4) {
        return [[UIScreen mainScreen] bounds].size.width/3;
    }else if (cellIndex == 0) {
        return [[UIScreen mainScreen] bounds].size.width/3;
    }else if (cellIndex == 5) {
        return [[UIScreen mainScreen] bounds].size.width/2;
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


@end
