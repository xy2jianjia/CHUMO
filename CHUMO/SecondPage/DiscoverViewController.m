//
//  DiscoverViewController.m
//  CHUMO
//
//  Created by 朱瀦潴 on 16/5/21.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DiscoverViewController.h"
#import "SearchViewController.h"
#import "DHWelfareViewController.h"
#import "DHLiveViewController.h"
#import "DHLiveLayout.h"
#import "DHYinlianWebViewController.h"

#define SearchCell @"SearchCell"

@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *discoverTable;
@end

@implementation DiscoverViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"发现";
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.discoverTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:(UITableViewStylePlain)];
    self.discoverTable.delegate=self;
    self.discoverTable.dataSource=self;
    [self.discoverTable registerClass:[UITableViewCell class] forCellReuseIdentifier:SearchCell];
    self.discoverTable.backgroundColor=[UIColor whiteColor];
    self.discoverTable.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_discoverTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SearchCell forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.imageView.image=[UIImage imageNamed:@"w_discover_search"];
        cell.textLabel.text=@"搜索";
    }else if (indexPath.section == 1){
        cell.imageView.image=[UIImage imageNamed:@"w_wo_lqfl"];
        cell.textLabel.text=@"福利专区";
        cell.detailTextLabel.text = @"话费、会员等你来领";
    }else if (indexPath.section == 2){
        cell.imageView.image=[UIImage imageNamed:@"zhibo"];
        cell.textLabel.text=@"直播";
    }else if (indexPath.section == 3){
        cell.imageView.image=[UIImage imageNamed:@"zhibo"];
        cell.textLabel.text=@"银联";
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SearchViewController *searchVC=[[SearchViewController alloc]init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }else if (indexPath.section == 1){
        DHWelfareViewController *vc = [[DHWelfareViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置cell的尺寸
        CGFloat width = (ScreenWidth-13)/2;
        layout.itemSize = CGSizeMake(width, width);
        // 设置滚动的方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 行间距
        layout.minimumLineSpacing = 4;
        // 设置cell之间的间距
        layout.minimumInteritemSpacing = 4;
        layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
        DHLiveViewController *vc = [[DHLiveViewController alloc]initWithCollectionViewLayout:layout];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3){
        DHYinlianWebViewController *vc = [[DHYinlianWebViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.discoverTable deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
