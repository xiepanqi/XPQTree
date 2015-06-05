//
//  XPQTree.m
//  XPQTree
//
//  Created by 谢攀琪 on 15/6/4.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#import "XPQTree.h"
#import "XPQTreeNodeCell.h"

@interface XPQTree ()
@property (nonatomic) NSArray *nodeArray;
@end

@implementation XPQTree
#pragma mark - 初始化函数
-(instancetype)init {
    self = [super init];
    if (self) {
        [self configSelf];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configSelf];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSelf];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self configSelf];
    }
    return self;
}

-(void)configSelf {
    self.dataSource = self;
    self.delegate = self;
    self.jointStyle = XPQTreeJointStyleDash;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(CGSize)imageSize {
    if (_imageSize.height < 30.0) {
        _imageSize.height = 30.0;
    }
    if (_imageSize.width < 30.0) {
        _imageSize.width = 30.0;
    }
    return _imageSize;
}

#pragma mark - 表格代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.nodeArray = [self.nodeData nodeArray:YES];
    return self.nodeArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.imageSize.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XPQTreeNodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nodeCell"];
    if (cell == nil) {
        cell = [[XPQTreeNodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nodeCell"];
    }
    cell.imageSize = self.imageSize;
    cell.foldImage = self.foldImage;
    cell.expandImage = self.expandImage;
    cell.splitColor = self.splitColor;
    cell.jointColor = self.jointColor;
    cell.jointStyle = self.jointStyle;
    cell.nodeDelegate = self;
    cell.nodeData = self.nodeArray[indexPath.row];
    // 强制刷新，主要是为了刷新那些自画线条
    [cell setNeedsDisplay];
    return cell;
}

#pragma mark - node代理
-(BOOL)shouldClickFoldButtonAtNode:(XPQTreeNodeCell *)node {
    if ([self.treeDelegate respondsToSelector:@selector(tree:shouldClickFoldButtonAtNode:)]) {
        return [self.treeDelegate tree:self shouldClickFoldButtonAtNode:node];
    }
    else {
        return YES;
    }
}

-(void)didClickFoldButtonAtNode:(XPQTreeNodeCell *)node {
    // 获取变动的行索引
    NSUInteger beginIndex = [self.nodeArray indexOfObject:node.nodeData] + 1;
    NSUInteger indexCount = [[node.nodeData nodeArray:NO] count];
    NSMutableArray *indexArray = [NSMutableArray array];
    for (int i = 0; i < indexCount; i++) {
        [indexArray addObject:[NSIndexPath indexPathForRow:beginIndex + i inSection:0]];
    }
    // 用插入和删除函数就会产生动画
    if (node.nodeData.isExpand == NO) {
        [self deleteRowsAtIndexPaths:indexArray withRowAnimation:(UITableViewRowAnimationTop)];
    }
    else {
        [self insertRowsAtIndexPaths:indexArray withRowAnimation:(UITableViewRowAnimationBottom)];
    }
    
    if (beginIndex == 1) {
         [node setNeedsDisplay];
    }
   
    
    if ([self.treeDelegate respondsToSelector:@selector(tree:didClickFoldButtonAtNode:)]) {
        [self.treeDelegate tree:self didClickFoldButtonAtNode:node];
    }
}

-(void)didClickTitleAtNode:(XPQTreeNodeCell *)node {
    if ([self.treeDelegate respondsToSelector:@selector(tree:didClickTitleAtNode:)]) {
        [self.treeDelegate tree:self didClickTitleAtNode:node];
    }
}
@end
