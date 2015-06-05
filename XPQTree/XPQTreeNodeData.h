//
//  XPQTreeNodeData.h
//  XPQTree
//
//  Created by 谢攀琪 on 15/6/4.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPQTreeNodeData : NSObject
/// 节点内容
@property (nonatomic) NSString *title;
/// 节点是否展开
@property (nonatomic, getter=isExpand) BOOL expand;
/// 节点数，如果节点折叠则只算一个
@property (nonatomic, readonly) NSUInteger nodeCount;
/// 层级
@property (nonatomic, readonly) NSUInteger level;
/// 孩子节点
@property (nonatomic, readonly) NSMutableArray *child;
/// 父节点
@property (nonatomic, weak, readonly) XPQTreeNodeData *parent;
/// 兄弟节点
@property (nonatomic, weak, readonly) XPQTreeNodeData *brother;

-(instancetype)initWithTitle:(NSString *)title;

/**
 *  @brief  用于遍历时返回下一个展开的节点。
 *  @detail 如果自己是展开的并且有子节点，则返回第一个子节点；否则返回下一个兄弟节点，如果没有兄弟节点则递归往上返回父节点的兄弟节点，直至到根节点
 *  @return 下一个节点数据
 */
-(XPQTreeNodeData *)nextNode;

/**
 *  @brief  返回需要显示的节点数组
 *  @param  includeRoot 是否包含根节点
 *  @return 节点数组
 */
-(NSArray*)nodeArray:(BOOL)includeRoot;

/**
 *  @brief  在最后位置插入一个子节点
 *  @param  node    要插入的节点
 *  @return void
 */
-(void)insertChild:(XPQTreeNodeData *)node;

/**
 *  @brief  在指定位置插入一个子节点，如果indexes大于子节点数则插入在最后位置
 *  @param  node    要插入的节点
 *  @param  indexes 插入的位置
 *  @return void
 */
-(void)insertChild:(XPQTreeNodeData *)node index:(NSUInteger)indexes;

/**
 *  @brief  移除一个子节点
 *  @param  node    要移除的子节点
 *  @return YES-成功移除，NO-移除失败（没有找到此子节点）
 */
-(BOOL)removeChild:(XPQTreeNodeData *)node;

/**
 *  @brief  移除指定位置的子节点
 *  @param  indexes 要移除的子节点的索引
 *  @return YES-成功移除，NO-移除失败（不是有效索引）
 */
-(BOOL)removeChildAtIndexes:(NSUInteger)indexes;

/**
 *  @brief  根节点
 */
-(XPQTreeNodeData *)rootNode;

/**
 *  @brief  清除所有子节点
 *  @return void
 */
-(void)clear;
@end
