//
//  VipController.m
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "VipController.h"
#import "HeaderView.h"
#import "VipViewCell.h"
#import "OtherCell.h"
#import "HeaderViewController.h"
#import "BecomeVipCell.h"
#import "TempHFController.h"
#define KCell_A @"kcell_1"
#define KCell_B @"kcell_2"
#define KCell_C @"kcell_3"
@interface VipController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tempTableView;
    NSArray *nameArr;
    NSArray *ageArr;
}
@property (nonatomic,strong)HeaderView *header;
@property (nonatomic,strong)HeaderViewController *headerController;

@property (nonatomic,strong)NSArray *examples;
@property (nonatomic,strong)NSArray *nineArray;

@property (nonatomic,strong)NSArray *section;
@property (nonatomic,strong)NSArray *tsection;

@end

@implementation VipController



#pragma mark  ---- get
- (NSArray *)examples {
    
    return @[@"",@"专属会员标示",@"更多展示机会",@"更多展示机会"];
}

- (NSArray *)nineArray {
    
    return @[@"",@"icon-vip",@"ico-display",@"ico-recommend"];
}

- (NSArray *)section {
    
    return @[@"",@"更多搜索条件",@"查看谁关注我",@"查看访客记录",@"查看登陆时间"];
}

- (NSArray *)tsection{
    
    return @[@"",@"ico-search-criteria",@"ico-attention-to-my",@"ico-record",@"ico-login-time"];
}



-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutTempTableView];
     
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
}

- (void)leftAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfosWhenUpdate" object:nil];
    [self.navigationController popToRootViewControllerAnimated:true];
}
- (void)layoutTempTableView
{
    tempTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    tempTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    [tempTableView registerClass:[VipViewCell class] forCellReuseIdentifier:KCell_A];
    [tempTableView registerClass:[OtherCell class] forCellReuseIdentifier:KCell_B];
    [tempTableView registerClass:[BecomeVipCell class] forCellReuseIdentifier:KCell_C];
    [self.view addSubview:tempTableView];
    self.header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    tempTableView.tableHeaderView = _header;
#pragma mark ---add tabelView
    _headerController = [[HeaderViewController alloc] init];
    _headerController.view.backgroundColor = [UIColor purpleColor];
    _headerController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    [self addChildViewController:_headerController];
    [_header addSubview:_headerController.view];
}


#pragma mark - UITabelView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.examples.count;
    }else if (section == 2) {
        return 1;
    }else {
        return 5;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            VipViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_A forIndexPath:indexPath];
            [cell addTheme:@"荣耀特权"];
            return cell;
            
        }else {
            OtherCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_B forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            [cell addWithImage:self.nineArray[indexPath.row] label:self.examples[indexPath.row]];
            if (indexPath.row == 3) {
                cell.lines.frame = CGRectMake(0, 49, [[UIScreen mainScreen] bounds].size.width, 0.5);
            }else {
                cell.lines.frame = CGRectMake(65, 50, [[UIScreen mainScreen] bounds].size.width-65, 0.5);
            }
            return cell;
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            VipViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_A forIndexPath:indexPath];
            [cell addTheme:@"能力特权"];
            return cell;
            
        }else {
        
            OtherCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_B forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            [cell addWithImage:self.tsection[indexPath.row] label:self.section[indexPath.row]];
            if (indexPath.row == 4) {
                cell.lines.frame = CGRectMake(0, 49, [[UIScreen mainScreen] bounds].size.width, 0.5);
            }else {
                cell.lines.frame = CGRectMake(65, 50, [[UIScreen mainScreen] bounds].size.width-65, 0.5);
            }
            return cell;
        }
        
    }else {
    
        BecomeVipCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_C forIndexPath:indexPath];
        [cell addWithimage:@"icon-vip-1" title:@"成为会员"];
        return cell;
    }
}

#pragma mark -------delegata Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        return [BecomeVipCell becomeVipCellHeight];
    }else {
        return [VipViewCell VipViewCellHeight];
    }
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return gotHeight(35);
    }
    return gotHeight(12);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
