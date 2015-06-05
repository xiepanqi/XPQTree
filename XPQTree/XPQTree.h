//
//  XPQTree.h
//  XPQTree
//
//  Created by 谢攀琪 on 15/6/4.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPQTreeNodeData.h"
#import "XPQTreeNodeCell.h"

@class XPQTree;

@protocol XPQTreeDelegate <NSObject>
@optional
/**
 *  @brief  将要点击折叠图标，返回YES将执行，返回NO取消执行
 *  @param  tree    所在树
 *  @param  node    所在节点
 *  @return YES-执行折叠展开操作，NO-不执行折叠展开操作
 */
-(BOOL)tree:(XPQTree *)tree shouldClickFoldButtonAtNode:(XPQTreeNodeCell *)node;

/**
 *  @brief  点击折叠图标后要执行的操作
 *  @param  tree    所在树
 *  @param  node    所在节点
 *  @return void
 */
-(void)tree:(XPQTree *)tree didClickFoldButtonAtNode:(XPQTreeNodeCell *)node;

/**
 *  @brief  点击标题后要执行的操作
 *  @param  tree    所在树
 *  @param  node    所在节点
 *  @return void
 */
-(void)tree:(XPQTree *)tree didClickTitleAtNode:(XPQTreeNodeCell *)node;
@end

@interface XPQTree : UITableView <UITableViewDelegate, UITableViewDataSource, XPQTreeNodeDelegate>
/// 折叠时显示图标，默认
@property (nonatomic) IBInspectable UIImage *foldImage;
/// 展开时显示图标，默认
@property (nonatomic) IBInspectable UIImage *expandImage;
/// 图标大小，最小30*30，图标高为行高
@property (nonatomic) IBInspectable CGSize imageSize;
/// 分割线颜色
@property (nonatomic) IBInspectable UIColor *splitColor;
/// 连接线颜色
@property (nonatomic) IBInspectable UIColor *jointColor;
/// 连接线风格
@property (nonatomic) XPQTreeJointStyle jointStyle;
/// 节点数据资源
@property (nonatomic) XPQTreeNodeData *nodeData;
/// 代理
@property (nonatomic, weak) id<XPQTreeDelegate> treeDelegate;
@end
