//
//  XPQTreeNodeData.m
//  XPQTree
//
//  Created by 谢攀琪 on 15/6/4.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#import "XPQTreeNodeData.h"

@interface XPQTreeNodeData ()
/// 层级
@property (nonatomic) NSUInteger level;
/// 孩子节点
@property (nonatomic) NSMutableArray *child;
/// 父节点
@property (nonatomic, weak) XPQTreeNodeData *parent;
/// 兄弟节点
@property (nonatomic, weak) XPQTreeNodeData *brother;
@end

@implementation XPQTreeNodeData

-(instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        [self configSelf];
        self.title = title;
    }
    return self;
}

-(void)configSelf {
    self.expand = YES;
    self.level = 0;
    self.child = [NSMutableArray array];
    self.parent = nil;
    self.brother = nil;
}

-(NSUInteger)nodeCount {
    NSUInteger count = 1;
    if (self.isExpand) {
        for (XPQTreeNodeData* node in self.child) {
            count += node.nodeCount;
        }
    }   
    return count;
}


-(XPQTreeNodeData *)nextNode {
    if (self.isExpand && self.child.count != 0) {
        return self.child[0];
    }
    else {
        for (XPQTreeNodeData *node = self; node != nil; node = node.parent) {
            if (node.brother != nil) {
                return node.brother;
            }
        }
        return nil;
    }
}

-(NSArray *)nodeArray:(BOOL)includeRoot {
    NSMutableArray *array = [NSMutableArray array];
    if (includeRoot) {
        [array addObject:self];
        for (XPQTreeNodeData *node = [self nextNode]; node != nil && node.level > self.level; node = [node nextNode]) {
            [array addObject:node];
        }
    }
    else {
        for (XPQTreeNodeData *node = self.child[0]; node != nil && node.level > self.level; node = [node nextNode]) {
            [array addObject:node];
        }
    }
    return [NSArray arrayWithArray:array];
}

-(void)insertChild:(XPQTreeNodeData *)node {
    node.level = self.level + 1;
    node.parent = self;
    node.brother = nil;
    if (self.child.count > 0) {
        ((XPQTreeNodeData*)self.child[self.child.count - 1]).brother = node;
    }
    [self.child addObject:node];
}

-(void)insertChild:(XPQTreeNodeData *)node index:(NSUInteger)indexes {
    if (indexes >= self.child.count) {
        indexes = self.child.count - 1;
    }
    node.level = self.level + 1;
    node.parent = self;
    node.brother = self.child[indexes];
    if (indexes > 0) {
        ((XPQTreeNodeData*)self.child[indexes - 1]).brother = node;
    }
    [self.child insertObject:node atIndex:indexes];
}

-(BOOL)removeChild:(XPQTreeNodeData *)node {
    for (int i = 0; i < self.child.count; i++) {
        if ([node isEqual:self.child[i]]) {
            return [self removeChildAtIndexes:i];
        }
    }
    return NO;
}

-(BOOL)removeChildAtIndexes:(NSUInteger)indexes {
    if (indexes < self.child.count) {
        if (indexes > 0) {
            if (indexes < self.child.count - 1) {
                ((XPQTreeNodeData*)self.child[indexes - 1]).brother = self.child[indexes + 1];
            }
            else {
                ((XPQTreeNodeData*)self.child[indexes - 1]).brother = nil;
            }
        }
        [self.child removeObjectAtIndex:indexes];
        return YES;
    }
    else {
        return NO;
    }
}

-(XPQTreeNodeData *)rootNode {
    XPQTreeNodeData *node = self;
    while (node.parent != nil) {
        node = node.parent;
    }
    return node;
}

-(void)clear {
    [self.child removeAllObjects];
}
@end
