//
//  DHLiveLayout.m
//  CHUMO
//
//  Created by xy2 on 16/7/6.
//  Copyright © 2016年 youshon. All rights reserved.
//

#import "DHLiveLayout.h"
@interface DHLiveLayout()
//用来保存每一个item计数好得属性(x,y,w,h)
@property (nonatomic,strong)NSMutableArray *itemAtrributes;
@end
@implementation DHLiveLayout
-(id)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
        self.itemAtrributes=[NSMutableArray array];
        
    }
    return self;
}


//准备布局
- (void)prepareLayout{
    
    //调用父类布局
    [super prepareLayout];
//    self.p_indexForLongestColumn=0;
    [self.itemAtrributes removeAllObjects];
    //获取item的数量
    NSUInteger numberOfItems=[self.collectionView numberOfItemsInSection:0];
    //为每一个item设置frame和indexPath
    for (int i=0; i<numberOfItems; i++) {
        //设置indexpath
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat width = (ScreenWidth-13)/2;
        attribute.size = CGSizeMake(width, width);
        if (indexPath.item % 2 == 0) {
            
        }
        
        //放入数组
        [self.itemAtrributes addObject:attribute];
        
    }
    
}
//计算contentView的大小
- (CGSize)collectionViewContentSize{
    //获取collectionView的size
    CGSize contentSize=self.collectionView.frame.size;
    return contentSize;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.itemAtrributes;;
}
@end
