//
//  XPQTreeNodeCell.h
//  XPQTree
//
//  Created by 谢攀琪 on 15/6/4.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPQTreeNodeData.h"
@class XPQTreeNodeCell;

typedef enum : NSUInteger {
    XPQTreeJointStyleNone,
    XPQTreeJointStyleDash,
    XPQTreeJointStyleSolid,
} XPQTreeJointStyle;

@protocol XPQTreeNodeDelegate <NSObject>
@optional
/**
 *  @brief  将要点击折叠图标，返回YES将执行，返回NO取消执行
 *  @param  tree    所在树
 *  @return YES-执行折叠展开操作，NO-不执行折叠展开操作
 */
-(BOOL)shouldClickFoldButtonAtNode:(XPQTreeNodeCell *)node;

/**
 *  @brief  点击折叠图标后要执行的操作
 *  @param  node    所在节点
 *  @return void
 */
-(void)didClickFoldButtonAtNode:(XPQTreeNodeCell *)node;

/**
 *  @brief  点击标题后要执行的操作
 *  @param  node    所在节点
 *  @return void
 */
-(void)didClickTitleAtNode:(XPQTreeNodeCell *)node;
@end

@interface XPQTreeNodeCell : UITableViewCell
@property (nonatomic) UIImage *foldImage;
@property (nonatomic) UIImage *expandImage;
@property (nonatomic) CGSize imageSize;
@property (nonatomic) UIColor *splitColor;
@property (nonatomic) UIColor *jointColor;
@property (nonatomic) XPQTreeJointStyle jointStyle;
@property (nonatomic, weak) XPQTreeNodeData *nodeData;
@property (nonatomic, weak) id<XPQTreeNodeDelegate> nodeDelegate;
@end
