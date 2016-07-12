//
//  HobbyViewController.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "HobbyViewController.h"
#import "HobbyCell.h"
#import "HeaderReusableView.h"
#import "FootReusableView.h"
#import "DHBasicModel.h"
@interface HobbyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    
    NSInteger integer;
    NSInteger secIntger;
    UICollectionView *collectionViews;
    NSIndexPath *cellIndexPaht;
    
    NSMutableDictionary *flashLity;   // 倒序放的个性特征
    NSMutableDictionary *flashInter;  // 倒序放的兴趣爱好
    
}
@property (nonatomic,strong)NSMutableArray *personalitym;  // 个性 (总数 删除后只剩后面几个（需要更新）)
@property (nonatomic,strong)NSArray *personalityArray;
@property (nonatomic,strong)NSMutableArray *beforeNine;    // 前12个个性

@property (nonatomic,strong)NSMutableArray *interestm;     // 兴趣 (总数 删除后只剩后面几个（需要更新）)
@property (nonatomic,strong)NSArray *interestArray;
@property (nonatomic,strong)NSMutableArray *beforeinter;   // 前12个兴趣



@property (nonatomic,strong)NSMutableArray *keyArray;
@property (nonatomic,strong)NSMutableArray *valueArray;
@property (nonatomic,strong)NSMutableArray *keyBreak;     // 刷新后的数据
@property (nonatomic,strong)NSMutableArray *valueBreak;
@property (nonatomic,strong)NSMutableArray *keyErgodic;
@property (nonatomic,strong)NSMutableArray *valueErgodic;


@property (nonatomic,strong)NSMutableArray *secKeyArray;
@property (nonatomic,strong)NSMutableArray *secValueArray;
@property (nonatomic,strong)NSMutableArray *secKeyBreak;     // 刷新后的数据
@property (nonatomic,strong)NSMutableArray *secValueBreak;
@property (nonatomic,assign)NSInteger totleBasicSum;
@end

@implementation HobbyViewController

static NSString *kcellIdentifier   = @"collectionCellID";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kfooterIdentifier = @"footerIdentifier";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIView *view in collectionViews.subviews) {
        [view removeFromSuperview];
    }
//    [ makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void)viewDidLoad {
     [super viewDidLoad];
    self.view.backgroundColor=kUIColorFromRGB(0xf0edf2);
     [Mynotification addObserver:self selector:@selector(reloadCollectionView:) name:@"reloadCollectionView" object:nil];
    self.keyArray      = [NSMutableArray array];
    self.valueArray    = [NSMutableArray array];
    self.keyBreak      = [NSMutableArray array];
    self.valueBreak    = [NSMutableArray array];
    self.keyErgodic    = [NSMutableArray array];
    self.valueErgodic  = [NSMutableArray array];
    
    self.secKeyArray   = [NSMutableArray array];
    self.secValueArray = [NSMutableArray array];
    self.secKeyBreak   = [NSMutableArray array];
    self.secValueBreak = [NSMutableArray array];
    [self set_data];
     [self setcollectio];
     [self n_personality];
     [self n_interst];
    
    
    
}
- (void)set_data{
    DHBasicModel *item = nil;
    if (_dataArr.count > 0) {
        item = [self.dataArr objectAtIndex:0];
    }
    NSString *favoritCode = item.favorite;
//    NSLog(@"%@",favoritCode);
    if ([favoritCode length] == 0) {
        
    }else{
        self.secValueBreak = [favoritCode componentsSeparatedByString:@"-"].mutableCopy;
        if ([self.secValueBreak containsObject:@""]) {
            [self.secValueBreak removeLastObject];
        }
    }
    NSString *kidneyCode = item.kidney;
//    NSLog(@"%@",kidneyCode);
    if ([kidneyCode length] == 0) {
        
    }else{
        self.valueBreak = [kidneyCode componentsSeparatedByString:@"-"].mutableCopy;
        if ([self.valueBreak containsObject:@""]) {
            [self.valueBreak removeLastObject];
        }
    }
}
#pragma mark --- 个性特征
- (void)n_personality {
    
    flashLity = [NSMutableDictionary dictionary];
    self.personalitym = [NSMutableArray array];
    self.beforeNine   = [NSMutableArray array];
    NSNumber *sexNum = [NSGetTools getUserSexInfo];
    if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {  // 男
        
        NSDictionary *dic = [NSGetSystemTools getkidney1];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];
            [self.personalitym addObject:value];
            [flashLity setObject:s forKey:value];
        }
        self.personalityArray = [NSArray arrayWithArray:self.personalitym];
        for (int i = 0; i <= 11; i++) { // 前12个
            NSString *str = [self.personalityArray objectAtIndex:i];
            [self.beforeNine addObject:str];
        }
        [self.personalitym removeObjectsInArray:self.beforeNine];  // 后面的
        
    }else {  // 女
        
        NSDictionary *dic = [NSGetSystemTools getkidney2];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];
            [self.personalitym addObject:value];
            [flashLity setObject:s forKey:value];
        }
        self.personalityArray = [NSArray arrayWithArray:self.personalitym];
        for (int i = 0; i <= 11; i++) { // 前12个
            NSString *str = [self.personalityArray objectAtIndex:i];
            [self.beforeNine addObject:str];
        }
       [self.personalitym removeObjectsInArray:self.beforeNine];  // 后面的
        
    }
}

#pragma mark --- 兴趣爱好
- (void)n_interst {
    
    flashInter         = [NSMutableDictionary dictionary];
    self.interestm     = [NSMutableArray array];
    self.beforeinter   = [NSMutableArray array];
    NSNumber *sexNum = [NSGetTools getUserSexInfo];
    if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {  // 男
        
        NSDictionary *dic  = [NSGetSystemTools getfavorite1];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];
            [self.interestm addObject:value];
            [flashInter setObject:s forKey:value];
        }
        self.interestArray = [NSArray arrayWithArray:self.interestm];
        for (int i = 0; i <= 11; i++) { // 前12个
            
            NSString *str = [self.interestArray objectAtIndex:i];
            [self.beforeinter addObject:str];
        }
        [self.interestm removeObjectsInArray:self.beforeinter];  // 删除前面12个元素
        
    }else { // 女
        
        NSDictionary *dic  = [NSGetSystemTools getfavorite2];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];
            [self.interestm addObject:value];
            [flashInter setObject:s forKey:value];
            
        }
        self.interestArray = [NSArray arrayWithArray:self.interestm];
        for (int i = 0; i <= 11; i++) { // 前12个
            
            NSString *str = [self.interestArray objectAtIndex:i];
            [self.beforeinter addObject:str];
        }
        [self.interestm removeObjectsInArray:self.beforeinter];  // 删除前面12个元素
    }
}
#pragma mark -- collectionViews
- (void)setcollectio {
    self.view.backgroundColor=kUIColorFromRGB(0xf0edf2);
    UIView *titleV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, ScreenWidth-20, 20)];
    titleLabel.backgroundColor=kUIColorFromRGB(0xf0edf2);
    titleLabel.font=[UIFont systemFontOfSize:12.0];
    titleLabel.textColor=kUIColorFromRGB(0x666666);
    titleLabel.text=@"选择个性爱好,快速建立个人印象标签";
    [titleV addSubview:titleLabel];
    [self.view addSubview:titleV];
#pragma mark -- layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];  // item大小
    layout.itemSize = CGSizeMake((WIDTH-SizeNum*2)/4.5, 25);  // w  h
    layout.minimumLineSpacing = 10;  //  上下间距
    layout.minimumInteritemSpacing = 10;  // 左右
    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 设置滚动方向
    layout.sectionInset = UIEdgeInsetsMake(20, SizeNum, 20, SizeNum);
    
    collectionViews = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth, ScreenHeight-35) collectionViewLayout:layout];
    collectionViews.backgroundColor = [UIColor whiteColor];
    // 数据源和代理
    collectionViews.dataSource = self;
    collectionViews.delegate   = self;
    [self.view addSubview:collectionViews];
    
#pragma mark -- 注册cell视图
    [collectionViews registerClass:[HobbyCell class] forCellWithReuseIdentifier:kcellIdentifier];
#pragma mark -- 注册头部视图
    [collectionViews registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
#pragma mark -- 注册尾部视图
    [collectionViews registerClass:[FootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
}

#pragma mark dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (integer == 1) {
            return self.personalitym.count;
        }else {
            return self.beforeNine.count;
        }
        
    }else {
        
        if (secIntger == 1) {
            return self.interestm.count;
        }else {
            return self.beforeinter.count;
        }
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HobbyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
//    NSMutableArray *codeArr = nil;
//    DHBasicModel *item = nil;
//    if (_dataArr.count > 0) {
//       item = [self.dataArr objectAtIndex:0];
//    }
    if (indexPath.section == 0) {
        if (integer == 1) {
            NSString *labelText = self.personalitym[indexPath.row];
            cell.collectionLabel.text = labelText;
            NSString *keycode = [flashLity objectForKey:self.personalitym[indexPath.row]];
//            NSString *intreCode = item.kidney;
//            if ([intreCode length] == 0) {
//                
//            }else{
//                codeArr = [intreCode componentsSeparatedByString:@"-"].mutableCopy;
//                if ([codeArr containsObject:@""]) {
//                    [codeArr removeLastObject];
//                }
//            }
//            NSArray *codeArr = [intreCode componentsSeparatedByString:@"-"];
            if ([self.valueBreak containsObject:keycode]) {
//                NSLog(@"1=2%@---%@",labelText,indexPath);
//                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
                
                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0.576 green:0.298 blue:0.898 alpha:1.000]CGColor];
                cell.collectionLabel.textColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
                cell.collectionLabel.backgroundColor=[UIColor whiteColor];
                cell.selectedImage.hidden=NO;
            }else{
                cell.selectedImage.hidden=YES;
                cell.collectionLabel.layer.borderColor = [[UIColor colorWithWhite:0.898 alpha:1.000]CGColor];
                cell.collectionLabel.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
                cell.collectionLabel.textColor = [UIColor colorWithWhite:0.196 alpha:1.000];

            }
        }else {
            NSString *labelText = self.beforeNine[indexPath.row];
            cell.collectionLabel.text = labelText;
            NSString *keycode = [flashLity objectForKey:self.beforeNine[indexPath.row]];
            
            if ([self.valueBreak containsObject:keycode]) {
//                NSLog(@"1=1%@---%@",labelText,indexPath);
//                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0.576 green:0.298 blue:0.898 alpha:1.000]CGColor];
                cell.collectionLabel.textColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
                cell.collectionLabel.backgroundColor=[UIColor whiteColor];
                cell.selectedImage.hidden=NO;
            }else{
                cell.selectedImage.hidden=YES;
                cell.collectionLabel.layer.borderColor = [[UIColor colorWithWhite:0.898 alpha:1.000]CGColor];
                cell.collectionLabel.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
                cell.collectionLabel.textColor = [UIColor colorWithWhite:0.196 alpha:1.000];
            }
        }
        
    }else {
       if (secIntger == 1) {
           NSString *labelText = self.interestm[indexPath.row];
           
           cell.collectionLabel.text = labelText;
           NSString *keycode = [flashInter objectForKey:self.interestm[indexPath.row]];
#pragma mark zjy
           if ([self.secValueBreak containsObject:keycode]) {
//               NSLog(@"2=2%@---%@",labelText,indexPath);
//               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
               
               cell.selectedImage.hidden=NO;
               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0.576 green:0.298 blue:0.898 alpha:1.000]CGColor];
               cell.collectionLabel.textColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
               cell.collectionLabel.backgroundColor=[UIColor whiteColor];
           }else{
               cell.selectedImage.hidden=YES;
               cell.collectionLabel.layer.borderColor = [[UIColor colorWithWhite:0.898 alpha:1.000]CGColor];
               cell.collectionLabel.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
               cell.collectionLabel.textColor = [UIColor colorWithWhite:0.196 alpha:1.000];
           }
       }else {
//           cell.collectionLabel.text = self.beforeinter[indexPath.row];
           NSString *labelText = self.beforeinter[indexPath.row];
           
           cell.collectionLabel.text = labelText;
           NSString *keycode = [flashInter objectForKey:self.beforeinter[indexPath.row]];
#pragma mark zjy
           if ([self.secValueBreak containsObject:keycode]) {
//               NSLog(@"2=1%@---%@",labelText,indexPath);
//               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
               cell.selectedImage.hidden=NO;
               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0.576 green:0.298 blue:0.898 alpha:1.000]CGColor];
               cell.collectionLabel.textColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
               cell.collectionLabel.backgroundColor=[UIColor whiteColor];
           }else{
               cell.selectedImage.hidden=YES;
               cell.collectionLabel.layer.borderColor = [[UIColor colorWithWhite:0.898 alpha:1.000]CGColor];
               cell.collectionLabel.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
               cell.collectionLabel.textColor = [UIColor colorWithWhite:0.196 alpha:1.000];
           }
       }
    }
    return cell;
}


//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
 #pragma mark -- 定制头部视图的内容
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderReusableView *headerV = (HeaderReusableView *)[collectionViews dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0 ) {
//            [headerV setHeaderTitle:@"选择个性爱好,快速建立个人印象标签"];
            headerV.nameLabel.text = @"个性特征";
            [headerV.footButton setHidden:true];
            [headerV.secFootButton setHidden:true];
            if (integer == 1) {
                [self setbutton:headerV.secUpdate secButton:headerV.update selector:@selector(secheaderupdateAction:)];
            }else {
                [self setbutton:headerV.update secButton:headerV.secUpdate selector:@selector(headerupdateAction:)];
            }
            
        }else {
            
            headerV.nameLabel.text = @"兴趣爱好";
            [headerV.update setHidden:true];
            [headerV.secUpdate setHidden:true];
            if (secIntger == 1) {
                [self setbutton:headerV.secFootButton secButton:headerV.footButton selector:@selector(secFootButtonAction:)];
            }else {
                [self setbutton:headerV.footButton secButton:headerV.secFootButton selector:@selector(footButtonAction:)];
            }
        }
        
        reusableView = headerV;
   }
    
#pragma mark -- 定制尾部视图的内容
    if (kind == UICollectionElementKindSectionFooter){
        FootReusableView *footerV = (FootReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerV.view.text = @"";
        reusableView = footerV;
    }
    return reusableView;
}

/**
 *  Description
 *
 *  @param button    显示button
 *  @param secbutton 隐藏button
 *  @param selector  点击事件
 */
- (void)setbutton:(UIButton *)button secButton:(UIButton *)secbutton selector:(SEL)selector {
    
    [button setHidden:false];
    [secbutton setHidden:true];
    [button setImage:[UIImage imageNamed:@"btn-refresh-n"] forState:(UIControlStateNormal)];
    [button addTarget:self action:selector forControlEvents:(UIControlEventTouchUpInside)];
}


#pragma mark --- 第一分区
- (void)headerupdateAction:(UIButton *)sender {
    
    integer = 1;
//    [collectionViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self viewWillAppear:YES];
    [collectionViews reloadData];
   
}

- (void)secheaderupdateAction:(UIButton *)sender {
    integer = 2;
    [self viewWillAppear:YES];
    [collectionViews reloadData];
}

- (void)footButtonAction:(UIButton *)sender {
    secIntger = 1;
//    for (UIView *aview in collectionViews.subviews) {
//        [aview removeFromSuperview];
//    }
    [self viewWillAppear:YES];
    [collectionViews reloadData];
}

- (void)secFootButtonAction:(UIButton *)sender {
    secIntger = 2;
//    for (UIView *aview in collectionViews.subviews) {
//        [aview removeFromSuperview];
//    }
    [self viewWillAppear:YES];
    [collectionViews reloadData];
}



//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 50);
    return size;

}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 0);
        return size;
    }else {
        CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 170);
        return size;
    }
    
}
- (void)reloadCollectionView:(NSNotification *)notifi{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [collectionViews reloadData];
//    });
}
#pragma mark --- 选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    cellIndexPaht = indexPath;
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    if (indexPath.section == 0) {
        
        if (integer == 1) {
           
            [self addWithCharacterStr:self.personalitym[indexPath.item] integerNum:indexPath.section secInteger:indexPath.item variableKey:flashLity variableValue:self.valueBreak];
            
        }else {
            
            [self addWithCharacterStr:self.beforeNine[indexPath.item] integerNum:indexPath.section secInteger:indexPath.item variableKey:flashLity variableValue:self.valueBreak];
            
         }
        NSMutableDictionary *dics = [NSMutableDictionary dictionary];
        NSMutableString *str = [[NSMutableString alloc]init];
        for (int i=0; i<self.valueBreak.count; i++) {
            if (i==self.valueBreak.count-1) {
                [str appendString:[NSString stringWithFormat:@"%@",self.valueBreak[i]]];
            }else{
                [str appendString:[NSString stringWithFormat:@"%@-",self.valueBreak[i]]];
            }
            
        }
        
        [dics setObject:str forKey:@"a37"];
        if (flashLity==nil) {
            NSLog(@"*****************************************************%@",str);
        }
        
        [NSURLObject addWithVariableDic:dics];
        [NSURLObject addWithdict:dics urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
        
    }else {
    
        if (secIntger == 1) {
            
            [self addWithCharacterStr:self.interestm[indexPath.item] integerNum:indexPath.section secInteger:indexPath.item variableKey:flashInter variableValue:self.secValueBreak];
            
        }else {
            
            [self addWithCharacterStr:self.beforeinter[indexPath.item] integerNum:indexPath.section secInteger:indexPath.item variableKey:flashInter variableValue:self.secValueBreak];

        }
        NSMutableDictionary *dics = [NSMutableDictionary dictionary];
        NSMutableString *str = [[NSMutableString alloc]init];
        for (int i=0; i<self.secValueBreak.count; i++) {
            if (i==self.secValueBreak.count-1) {
                [str appendString:[NSString stringWithFormat:@"%@",self.secValueBreak[i]]];
            }else{
                [str appendString:[NSString stringWithFormat:@"%@-",self.secValueBreak[i]]];
            }
            
        }
        [dics setObject:str forKey:@"a24"];
        //            NSLog(@"$$$$$$$$$$$$%@",str);
        [NSURLObject addWithVariableDic:dics];
        [NSURLObject addWithdict:dics urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
    }
    self.totleHobbySum=0;
    if (self.secValueBreak.count>0) {
        self.totleHobbySum+=1;
    }
    if (self.valueBreak.count>0) {
        self.totleHobbySum+=1;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTotleHobby" object:nil];
}






/**
 *  Description
 *
 *  @param character     所有的内容
 *  @param integerNum    分区
 *  @param secInteger    选中的cellItem
 *  @param variable      字典中找到value
 *  @param variableValue value
 */
- (void)addWithCharacterStr:(NSString *)character integerNum:(NSInteger)integerNum secInteger:(NSInteger)secInteger variableKey:(NSMutableDictionary *)variable variableValue:(NSMutableArray *)variableValue{

    NSString *str = [variable objectForKey:character];
//    NSString *str2 = [NSString stringWithFormat:@"%ld:%ld",(long)integerNum,(long)secInteger];
    
    if (![variableValue containsObject:str]) {
//        [variable  addObject:str2];
        [variableValue addObject:str];
        HobbyCell *clearColorCell = (HobbyCell *)[collectionViews cellForItemAtIndexPath:[NSIndexPath indexPathForItem:secInteger inSection:integerNum]];
        clearColorCell.selectedImage.hidden=NO;
        clearColorCell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0.576 green:0.298 blue:0.898 alpha:1.000]CGColor];
        clearColorCell.collectionLabel.textColor = [UIColor colorWithRed:0.576 green:0.302 blue:0.902 alpha:1.000];
        clearColorCell.collectionLabel.backgroundColor=[UIColor whiteColor];
    }else{
        
        HobbyCell *clearColorCell = (HobbyCell *)[collectionViews cellForItemAtIndexPath:[NSIndexPath indexPathForItem:secInteger inSection:integerNum]];

        clearColorCell.collectionLabel.layer.borderColor = [[UIColor colorWithWhite:0.898 alpha:1.000]CGColor];
        clearColorCell.collectionLabel.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
        clearColorCell.collectionLabel.textColor = [UIColor colorWithWhite:0.196 alpha:1.000];
        clearColorCell.selectedImage.hidden=YES;
//        [variable   removeObject:str2];
        [variableValue removeObject:str];
//        NSIndexPath *path= [NSIndexPath indexPathForItem:integerNum inSection:integerNum];
//        [collectionViews reloadItemsAtIndexPaths:@[path]];
        
    }
//    [self addWithArray:variable value:variableValue];

}

/**
 *  Description
 *
 *  @param keyArray   存储key的数组
 *  @param valueArray 存储value的数组
 */
//- (void)addWithArray:(NSMutableArray *)keyArray value:(NSMutableArray *)valueArray {
//
//    if (keyArray.count == 4 || valueArray.count == 4) {
//        
//        NSString *keyStr = keyArray[0];
//        NSArray *tempArr = [keyStr componentsSeparatedByString:@":"];
//        HobbyCell *clearColorCell = (HobbyCell *)[collectionViews cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[tempArr[1] integerValue] inSection:[tempArr[0] integerValue]]];
//        clearColorCell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
//        [keyArray   removeObjectAtIndex:0];
//        [valueArray removeObjectAtIndex:0];
//        
//    }
//}

/**
 *  Description
 *
 *  @param array        需要遍历的数组
 *  @param ergodicArray 遍历后取出重复元素的数组
 */
- (void)ergodicWithArray:(NSMutableArray *)array  ergodicArray:(NSMutableArray *)ergodicArray{

    [array enumerateObjectsUsingBlock:^(NSString *heroString, NSUInteger idx, BOOL *stop) {
        
        __block BOOL isContain = NO;
        
        [ergodicArray enumerateObjectsUsingBlock:^(NSString *desString, NSUInteger idx, BOOL *stop) {
            
            if (NSOrderedSame == [heroString compare:desString options:NSCaseInsensitiveSearch]) {
                
                isContain = YES;
                
            }}];
        
        if (NO == isContain) {
            
            [ergodicArray addObject:heroString];
            
        }}];

}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
