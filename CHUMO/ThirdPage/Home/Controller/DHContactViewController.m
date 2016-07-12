//
//  DHContactViewController.m
//  StrangerChat
//
//  Created by xy2 on 16/1/14.
//  Copyright © 2016年 long. All rights reserved.
//

#import "DHContactViewController.h"
#import "DHContactCell.h"
#import "ChatController.h"
#import "Homepage.h"
#import "JYNavigationController.h"
@interface DHContactViewController ()
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation DHContactViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"联系人";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self setupData];
}
- (void)leftAction {
    [self.navigationController popToRootViewControllerAnimated:true];
}
- (void)setupData{
    self.dataArr = [NSMutableArray array];
    for (DHMessageModel *message in self.contactArr) {
        DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:message.targetId];
        if (userinfo) {
           [self.dataArr addObject:userinfo];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DHContactCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHContactCell" owner:self options:nil] lastObject];
    DHUserInfoModel *userinfo = [self.dataArr objectAtIndex:indexPath.row];
    [cell.headerImageV sd_setImageWithURL:[NSURL URLWithString:userinfo.b57] placeholderImage:[UIImage imageNamed:@"list_item_icon"]];
    cell.userNameLabel.text = [userinfo.b52 length] == 0?@"昵称":userinfo.b52;
    if ([userinfo.b144 integerValue] == 1) {
      cell.vipIcon.image = [UIImage imageNamed:@"icon-name-vip"];
        cell.userNameLabel.textColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
    }else{
        cell.vipIcon.image = nil;
    }
    cell.headerImageV.userInteractionEnabled = YES;
    cell.headerImageV.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserDetail:)];
    [cell.headerImageV addGestureRecognizer:tap];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏对象的小红点
    DHMessageModel *item=self.contactArr[indexPath.row];
    DHUserInfoModel *userinfo = [DHUserInfoDao getUserWithCurrentUserId:item.targetId];
    ChatController *chat=[[ChatController alloc]init];
    chat.item = item;
    chat.userInfo = userinfo;
    [self.navigationController pushViewController:chat animated:YES];
    
    
    
}
- (void)showUserDetail:(UITapGestureRecognizer *)sender{
    Homepage *otherVC = [[Homepage alloc]init];
    DHUserInfoModel *userinfo = [self.dataArr objectAtIndex:sender.view.tag];
    otherVC.touchP2 = userinfo.b80;
    otherVC.item = userinfo;
    JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:otherVC];
    [self presentViewController:nav animated:YES completion:nil];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
