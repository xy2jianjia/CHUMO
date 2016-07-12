//
//  DHLayout.m
//  Collection
//
//  Created by xy2 on 16/3/15.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHLayout.h"

#define ITEM_SIZE 50
#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

#define colletionCell 2  //设置具体几列
//#define KcellHeight  got(95.0) // cell最小高
//#define KcellSpace got(10) // cell之间的间隔
#define KcellHeight  gotiphon6(115.0) // cell最小高
#define KcellBigHeight  gotiphon6(117.5) // cell最小高
#define KcellSpace gotiphon6(10) // cell之间的间隔
@interface DHLayout()
//用来保存每一个item计数好得属性(x,y,w,h)
@property (nonatomic,strong)NSMutableArray *itemAtrributes;
//获取最长列的索引
@property (nonatomic,assign)CGFloat p_indexForLongestColumn;

@end
@implementation DHLayout

-(id)init
{
    self = [super init];
    if (self) {
//        self.itemSize = CGSizeMake(KcellHeight, KcellHeight);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
//        self.minimumLineSpacing = 50.0;
        self.p_indexForLongestColumn=0;
        self.itemAtrributes=[NSMutableArray array];
        
    }
    return self;
}


//准备布局
- (void)prepareLayout{
    
    //调用父类布局
    [super prepareLayout];
    self.p_indexForLongestColumn=0;
    [self.itemAtrributes removeAllObjects];
    //获取item的数量
    NSUInteger numberOfItems=[self.collectionView numberOfItemsInSection:0];
    //为每一个item设置frame和indexPath
    for (int i=0; i<numberOfItems; i++) {
        //设置indexpath
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat currentWidth = KcellHeight;
        CGFloat currentHeight = KcellHeight;
        
        CGFloat currentWidthB = KcellBigHeight*2;
        CGFloat cellHeightB = currentWidthB;
        
        NSInteger xNum = i/9;
        
        CGFloat firstY = cellHeightB  + KcellSpace *14 + KcellBigHeight*2;
        
        if (i%9 == 0) {
            attribute.frame = CGRectMake(KcellSpace, xNum*(firstY)+KcellSpace,currentWidthB,cellHeightB+6*KcellSpace);
            self.p_indexForLongestColumn=KcellSpace/2+CGRectGetMaxY(attribute.frame);
        }
        if (i%9 == 1){
            attribute.frame = CGRectMake(0+KcellBigHeight*2+KcellSpace+KcellSpace/2, xNum*(firstY)+KcellSpace,currentWidth,currentHeight+3*KcellSpace);
        }
        if (i%9 == 2){
            attribute.frame = CGRectMake(0+KcellBigHeight*2+KcellSpace+KcellSpace/2, xNum*(firstY)+currentHeight+4*KcellSpace+KcellSpace/2,currentWidth,currentHeight+3*KcellSpace);
        }
        if (i%9 == 3) {
            attribute.frame = CGRectMake(0*currentWidth+KcellSpace, xNum*(firstY)+2*currentHeight+8*KcellSpace,currentWidth,currentHeight+3*KcellSpace);
            self.p_indexForLongestColumn=5.0+CGRectGetMaxY(attribute.frame);
        }
        if (i%9 == 4) {
            attribute.frame = CGRectMake(1*currentWidth+KcellSpace+KcellSpace/2, xNum*(firstY)+2*currentHeight+8*KcellSpace,currentWidth,currentHeight+3*KcellSpace);
        }
        
        if (i%9 == 5) {
            attribute.frame = CGRectMake(2*currentWidth+KcellSpace+2*(KcellSpace/2), xNum*(firstY)+2*currentHeight+8*KcellSpace,currentWidth,currentHeight+3*KcellSpace);
        }
        if (i%9 == 6) {
            attribute.frame = CGRectMake(0*currentWidth+KcellSpace, xNum*(firstY)+3*currentHeight+12*KcellSpace,currentWidth,currentHeight+3*KcellSpace);
            self.p_indexForLongestColumn=5.0+CGRectGetMaxY(attribute.frame);
            
        }
        if (i%9 == 7) {
            attribute.frame = CGRectMake(1*currentWidth+KcellSpace+KcellSpace/2, xNum*(firstY)+3*currentHeight+12*KcellSpace,currentWidth,currentHeight+3*KcellSpace);
            
        }
        if (i%9 == 8) {
            attribute.frame = CGRectMake(2*currentWidth+KcellSpace+2*(KcellSpace/2), xNum*(firstY)+3*currentHeight+12*KcellSpace,currentWidth,currentHeight+3*KcellSpace);
        }
        
        //放入数组
        [self.itemAtrributes addObject:attribute];
        
    }

}
//计算contentView的大小
- (CGSize)collectionViewContentSize{
    //获取collectionView的size
    CGSize contentSize=self.collectionView.frame.size;
    //最大高度+bottom
    contentSize.height=self.p_indexForLongestColumn;
    return contentSize;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    
//    NSMutableArray *arr = [NSMutableArray array];
//    NSInteger count = [self.collectionView numberOfItemsInSection:0];
//    for (int i = 0; i < count; i ++) {
//        UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            [arr addObject:attributes];
//        }
//    }
    
    return self.itemAtrributes;;
}
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    CGFloat currentWidth = KcellHeight;
//    CGFloat currentHeight = KcellHeight;
//
//    CGFloat currentWidthB = KcellHeight*2+KcellHeight/8.0;
//    CGFloat cellHeightB = currentWidthB;
//    
//    NSInteger xNum = indexPath.row/9;
//    
//    CGFloat firstY = cellHeightB + gotHeight(20)*2 + KcellSpace *3 + currentHeight*2;
//    
//    if (indexPath.row%9 == 0) {
//        attribute.frame = CGRectMake(KcellSpace, xNum*(firstY)+KcellSpace,currentWidthB,cellHeightB+4*KcellSpace);
//    }
//    if (indexPath.row%9 == 1){
//        attribute.frame = CGRectMake(0+KcellHeight*2+3*KcellSpace, xNum*(firstY)+KcellSpace,currentWidth,currentHeight+2*KcellSpace);
//    }
//    if (indexPath.row%9 == 2){
//        attribute.frame = CGRectMake(0+KcellHeight*2+3*KcellSpace, xNum*(firstY)+currentHeight+4*KcellSpace,currentWidth,currentHeight+2*KcellSpace);
//    }
//    if (indexPath.row%9 == 3) {
//        attribute.frame = CGRectMake(0*currentWidth+KcellSpace, xNum*(firstY)+2*currentHeight+7*KcellSpace,currentWidth,currentHeight);
//    }
//    if (indexPath.row%9 == 4) {
//        attribute.frame = CGRectMake(1*currentWidth+2*KcellSpace, xNum*(firstY)+2*currentHeight+7*KcellSpace,currentWidth,currentHeight);
//    }
//    
//    if (indexPath.row%9 == 5) {
//        attribute.frame = CGRectMake(2*currentWidth+3*KcellSpace, xNum*(firstY)+2*currentHeight+7*KcellSpace,currentWidth,currentHeight);
//    }
//    if (indexPath.row%9 == 6) {
//        attribute.frame = CGRectMake(0*currentWidth+KcellSpace, xNum*(firstY)+3*currentHeight+8*KcellSpace,currentWidth,currentHeight);
//        
//    }
//    if (indexPath.row%9 == 7) {
//        attribute.frame = CGRectMake(1*currentWidth+2*KcellSpace, xNum*(firstY)+3*currentHeight+8*KcellSpace,currentWidth,currentHeight);
//        
//    }
//    if (indexPath.row%9 == 8) {
//        attribute.frame = CGRectMake(2*currentWidth+3*KcellSpace, xNum*(firstY)+3*currentHeight+8*KcellSpace,currentWidth,currentHeight);
//    }
//    return attribute;
//}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
//    
//    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
//    
//    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
//        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
//        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
//            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
//        }
//    }
//    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//}

@end
