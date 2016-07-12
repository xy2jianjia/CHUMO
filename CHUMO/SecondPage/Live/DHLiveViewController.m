//
//  DHLiveViewController.m
//  CHUMO
//
//  Created by xy2 on 16/7/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHLiveViewController.h"
#import "DHLiveCell.h"
#import "DHLiveInfoViewController.h"
#import "DHHostLiveInfoViewController.h"
@interface DHLiveViewController ()
@property (nonatomic,strong)UIButton *anchorbtn;

@property (nonatomic,strong) NSMutableArray *liveList;

@end

@implementation DHLiveViewController

static NSString * const reuseIdentifier = @"Cell";
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [self configAnchorEntrance];
}

- (void)configLiveList{
    [HttpOperation asyncLive_GetChanelListWithCurPage:1 pageSize:20 queue:nil completed:^(NSArray *chanelList, NSInteger code) {
        _liveList = [chanelList mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self dismissAnchorEntrance];
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"直播";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    // Register cell classes
    [self.collectionView registerClass:[DHLiveCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self configLiveList];
    // Do any additional setup after loading the view.
}
/**
 *  配置主播入口
 */
- (void)configAnchorEntrance{
    _anchorbtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _anchorbtn.frame = CGRectMake(ScreenWidth-32-48, ScreenHeight - 32 - 48, 48, 48);
    [_anchorbtn addTarget:self action:@selector(openAnchor) forControlEvents:(UIControlEventTouchUpInside)];
    [_anchorbtn setBackgroundImage:[UIImage imageNamed:@"kaizhibo"] forState:(UIControlStateNormal)];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:_anchorbtn];
}
- (void)dismissAnchorEntrance{
    [_anchorbtn removeFromSuperview];
}
/**
 *  主播入口
 */
- (void)openAnchor{
    
    DHHostLiveInfoViewController *vc = [[DHHostLiveInfoViewController alloc]init];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _liveList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DHLiveInfoModel *item = [_liveList objectAtIndex:indexPath.item];
    DHLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setDHLiveInfoModel:item];
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DHLiveInfoModel *item = [_liveList objectAtIndex:indexPath.item];
    DHLiveInfoViewController *vc = [[DHLiveInfoViewController alloc]init];
    vc.isAnchor = NO;
    vc.liveInfoModel = item;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
