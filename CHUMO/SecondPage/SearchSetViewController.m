//
//  SearchSetViewController.m
//  StrangerChat
//
//  Created by long on 15/11/11.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SearchSetViewController.h"
#import "SearchSetTableViewCell.h"
#import "HFVipViewController.h"
#import "BasicObject.h"
#import "YS_VipCenterViewController.h"
@interface SearchSetViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,assign) BOOL isVip;
@end

@implementation SearchSetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索条件";
    //是否是VIP
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    DHUserInfoModel *userInfo = [DHUserInfoDao getUserWithCurrentUserId:userId];
    self.isVip = [userInfo.b144 integerValue] == 1?YES:NO;
    //tableview布局
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [self setFootView];
    if (!self.isVip) {
        self.titleArray = [NSArray arrayWithObjects:@"年龄范围",@"身高范围",@"婚姻状况",@"学历",@"所在地区", nil];
    }else{
        self.titleArray = [NSArray arrayWithObjects:@"年龄范围",@"身高范围",@"婚姻状况",@"学历",@"所在地区",@"房产",@"车产",@"收入", nil];
    }
    
    [self.view addSubview:self.tableView];
    // 返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    // 重置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-Refresh.png"] style:UIBarButtonItemStyleDone target:self action:@selector(setAllBack)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

    
}
- (UIView *)setFootView{
    UIView *footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-5*40);
    //搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.backgroundColor = MainBarBackGroundColor;
    searchButton.frame = CGRectMake(got(30), gotHeight(32), got(260), gotHeight(40));
    [searchButton setTitle:@"搜 索" forState:UIControlStateNormal];
    [footView addSubview:searchButton];
    [searchButton setTitleColor:HexRGB(0XFFFFFF) forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:19];
    searchButton.layer.cornerRadius = gotHeight(40/2);
    searchButton.clipsToBounds = YES;
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.isVip) {
        UIButton *incomeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        incomeBtn.frame = CGRectMake(66, CGRectGetMaxY(searchButton.frame)+19, 42, 42);
        [incomeBtn setBackgroundImage:[UIImage imageNamed:@"icon-income.png"] forState:(UIControlStateNormal)];
        [incomeBtn addTarget:self action:@selector(gotoVipVc) forControlEvents:(UIControlEventTouchUpInside)];
        [footView addSubview:incomeBtn];
        
        UILabel *incomeLabel = [[UILabel alloc]init];
        incomeLabel.frame = CGRectMake(CGRectGetMinX(incomeBtn.frame), CGRectGetMaxY(incomeBtn.frame)+11, CGRectGetWidth(incomeBtn.frame), 20);
        incomeLabel.text = @"收入";
        incomeLabel.font = [UIFont systemFontOfSize:14];
        incomeLabel.textAlignment = NSTextAlignmentCenter;
        incomeLabel.textColor = HexRGB(0x323232);
        [footView addSubview:incomeLabel];
        
        UIButton *estateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        estateBtn.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-21, CGRectGetMinY(incomeBtn.frame), CGRectGetWidth(incomeBtn.frame), CGRectGetWidth(incomeBtn.frame));
        [estateBtn setBackgroundImage:[UIImage imageNamed:@"icon-Estate.png"] forState:(UIControlStateNormal)];
        [estateBtn addTarget:self action:@selector(gotoVipVc) forControlEvents:(UIControlEventTouchUpInside)];
        [footView addSubview:estateBtn];
        
        UILabel *estateLabel = [[UILabel alloc]init];
        estateLabel.frame = CGRectMake(CGRectGetMinX(estateBtn.frame), CGRectGetMaxY(estateBtn.frame)+11, CGRectGetWidth(estateBtn.frame), CGRectGetHeight(incomeLabel.frame));
        estateLabel.text = @"房产";
        estateLabel.font = [UIFont systemFontOfSize:14];
        estateLabel.textAlignment = NSTextAlignmentCenter;
        estateLabel.textColor = HexRGB(0x323232);
        [footView addSubview:estateLabel];
        
        UIButton *carBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        carBtn.frame = CGRectMake(CGRectGetMaxX([[UIScreen mainScreen] bounds])-66-42,CGRectGetMinY(incomeBtn.frame), CGRectGetWidth(incomeBtn.frame), CGRectGetWidth(incomeBtn.frame));
        [carBtn setBackgroundImage:[UIImage imageNamed:@"icon-car.png"] forState:(UIControlStateNormal)];
        [carBtn addTarget:self action:@selector(gotoVipVc) forControlEvents:(UIControlEventTouchUpInside)];
        [footView addSubview:carBtn];
        
        UILabel *carLabel = [[UILabel alloc]init];
        carLabel.frame = CGRectMake(CGRectGetMinX(carBtn.frame), CGRectGetMaxY(carBtn.frame)+11, CGRectGetWidth(carBtn.frame), CGRectGetHeight(incomeLabel.frame));
        carLabel.text = @"车产";
        carLabel.font = [UIFont systemFontOfSize:14];
        carLabel.textAlignment = NSTextAlignmentCenter;
        carLabel.textColor = HexRGB(0x323232);
        [footView addSubview:carLabel];
        
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lp_pay_way"];
        NSString *attr = [dict objectForKey:@"lp_pay_way_type_ios"];
        
        
        UIView *vipView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(carLabel.frame)+49, 160, 30)];
        vipView.centerX=footView.centerX;
        [footView addSubview:vipView];
        
        
        UILabel *becomeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        becomeLabel.textColor=kUIColorFromRGB(0x323232);
        becomeLabel.textAlignment=NSTextAlignmentRight;
        becomeLabel.text=@"成为";
        becomeLabel.font = [UIFont systemFontOfSize:13];
        [vipView addSubview:becomeLabel];
        
        UIImageView *vipImageV = [[UIImageView alloc]init];
        vipImageV.frame = CGRectMake(CGRectGetMaxX(becomeLabel.frame)+4, CGRectGetMinY(becomeLabel.frame)+2.5, 30, 15);
        vipImageV.image = [UIImage imageNamed:@"w_fx_cwvip.png"];
        UITapGestureRecognizer *gotoVipGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoVipVc)];
        vipImageV.userInteractionEnabled=YES;
        [vipImageV addGestureRecognizer:gotoVipGesture];
        [vipView addSubview:vipImageV];
        
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(CGRectGetMaxX(vipImageV.frame)+5, CGRectGetMinY(becomeLabel.frame), CGRectGetWidth(vipView.bounds)-CGRectGetMaxX(vipImageV.frame)-5, 20);
        label.text = @"搜索条件更丰富";
        label.textAlignment=NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = HexRGB(0x323232);
        [vipView addSubview:label];
    }
    
    return footView;
}
/**
 *  去到开通vip界面
 */
- (void)gotoVipVc{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lp_pay_way"];
//    NSString *attr = [dict objectForKey:@"lp_pay_way_type_ios"];
//    if (![attr isEqualToString:@"2,7"]) {
//        
//    }
#pragma mark 支付H5
//    HFVipViewController *vip = [[HFVipViewController alloc] init];
//    [self.navigationController pushViewController:vip animated:YES];
#pragma mark 支付原生
    YS_VipCenterViewController *vip = [[YS_VipCenterViewController alloc] init];
    vip.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vip animated:YES];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 重置
- (void)setAllBack
{
    NSMutableDictionary *searDict = [NSMutableDictionary dictionary];
    [NSGetTools updateSearchSetWithDict:searDict];
    [self.tableView reloadData];
    
}

// 点击搜索并返回
- (void)searchButtonAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchSetData" object:@YES];
    [self dismissViewControllerAnimated:true completion:nil]; // 收回提示页面
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- TableViewDelegate-------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return gotHeight(40);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier2";
    SearchSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SearchSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor=kUIColorFromRGB(0x323232);
    NSDictionary *dict = [NSGetTools getSearchSetDict];// 搜索条件
    if (indexPath.row == 0) {
        NSDictionary *infoDict = dict[@"年龄"];
        NSString *ageStr = [infoDict objectForKey:[[infoDict allKeys] objectAtIndex:0]];
        if (ageStr != nil) {
            cell->label2.text = ageStr;
        }else{
            cell->label2.text = @"不限制";
        }
    }else if (indexPath.row == 1){
        NSDictionary *infoDict = dict[@"身高"];
        NSString *bodyStr = [infoDict objectForKey:[[infoDict allKeys] objectAtIndex:0]];
//        NSString *bodyStr = dict[@"身高"];
        if (bodyStr != nil) {
            cell->label2.text = bodyStr;
        }else{
            cell->label2.text = @"不限制";
        }
    }else if (indexPath.row == 2){
        NSString *marrStr = dict[@"婚姻"];
        if (marrStr != nil) {
            cell->label2.text = marrStr;
        }else{
            cell->label2.text = @"不限制";
        }
        
    }else if (indexPath.row == 3){
        NSString *eduStr = dict[@"学历"];
        if (eduStr != nil) {
            cell->label2.text = eduStr;
        }else{
            cell->label2.text = @"不限制";
        }
        
    }else if (indexPath.row == 4){
        NSString *addressStr = dict[@"地区"];
        if (addressStr != nil) {
            cell->label2.text = addressStr;
        }else{
            cell->label2.text = @"不限制";
        }
        
    }else if (indexPath.row == 5){
        NSString *addressStr = dict[@"房产"];
        if (addressStr != nil) {
            cell->label2.text = addressStr;
        }else{
            cell->label2.text = @"不限制";
        }
        
    }else if (indexPath.row == 6){
        NSString *addressStr = dict[@"车产"];
        if (addressStr != nil) {
            cell->label2.text = addressStr;
        }else{
            cell->label2.text = @"不限制";
        }
        
    }else if (indexPath.row == 7){
        NSString *addressStr = dict[@"收入"];
        if (addressStr != nil) {
            cell->label2.text = addressStr;
        }else{
            cell->label2.text = @"不限制";
        }
        
    }
    cell->label2.font = [UIFont systemFontOfSize:13];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchSetTableViewCell * cell = (SearchSetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell becomeFirstResponder];
    
    if (indexPath.row == 0) {// 年龄
        cell.rowNum = indexPath.row;
        cell->province = [NSGetSystemTools getAgeData];
    }else if (indexPath.row == 1){// 身高
        cell.rowNum = indexPath.row;
        cell->province = [NSGetSystemTools getBodyHeightData];
    }else if (indexPath.row == 2){// 婚姻
        cell.rowNum = indexPath.row;
        NSDictionary *dict = [NSGetSystemTools getmarriageStatusInSearch];
        NSArray *allValues = [dict allValues];
        cell->province = allValues;
        cell->city = nil;
        
    }else if (indexPath.row == 3){// 学历
        NSMutableArray *sort = [NSMutableArray array];
        cell.rowNum = indexPath.row;
        NSDictionary *dict = [NSGetSystemTools geteducationLevel];
        NSMutableArray *allValues = [NSMutableArray array];
        
        NSMutableDictionary  *educationDic = [NSMutableDictionary dictionary];
        for (NSString *s in dict) {
            
            NSString *value = [dict objectForKey:s];  // 倒放字典方便上传
            [educationDic setValue:s forKey:value];
            
            int intString      = [s intValue];
            BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
            [sort addObject:basic];
            
        }
        [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
        for (BasicObject *b in sort) {
            NSString *numStr   = [NSString stringWithFormat:@"%@",b];
            NSString *valuestr = [dict objectForKey:numStr];
            [allValues addObject:valuestr];
            
        }

        cell->province = [NSArray arrayWithArray:allValues];
        cell->city = nil;
        
    }else if (indexPath.row == 4) {// 地区
        cell.rowNum = indexPath.row;
        
    }else if (indexPath.row == 5) {// 房产
        cell.rowNum = indexPath.row;
        NSMutableArray *sort = [NSMutableArray array];
        NSMutableArray *allValues = [NSMutableArray array];
        NSDictionary *dic  = [NSGetSystemTools gethasRoom];
        for (NSString *s in dic) {
            int intString = [s intValue];  // 排序
            BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
            [sort addObject:basic];
        }
        [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
        for (BasicObject *b in sort) {
            NSString *numStr = [NSString stringWithFormat:@"%@",b];
            NSString *valuestr = [dic objectForKey:numStr];
            [allValues addObject:valuestr];
        }
        
        cell->province = [NSArray arrayWithArray:allValues];
        
    }else if (indexPath.row == 6) {// 车产
        cell.rowNum = indexPath.row;
        
        NSMutableArray *sort = [NSMutableArray array];
        NSMutableArray *allValues = [NSMutableArray array];
        NSDictionary *dic  = [NSGetSystemTools gethasCar];
        for (NSString *s in dic) {
            int intString = [s intValue];  // 排序
            BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
            [sort addObject:basic];
        }
        [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
        for (BasicObject *b in sort) {
            NSString *numStr = [NSString stringWithFormat:@"%@",b];
            NSString *valuestr = [dic objectForKey:numStr];
            [allValues addObject:valuestr];
        }
        
        cell->province = [NSArray arrayWithArray:allValues];
        
    }else if (indexPath.row == 7) {// 收入
        cell.rowNum = indexPath.row;
        cell->province =[self nineArray];
        cell->city = [self tempPicker];
        cell->thirdArr = [self tempNine];
        
    }
    [cell->pickView reloadAllComponents];
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
