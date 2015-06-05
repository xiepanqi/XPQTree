//
//  ViewController.m
//  XPQTree
//
//  Created by 谢攀琪 on 15/6/4.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    XPQTreeNodeData *node00 = [[XPQTreeNodeData alloc] initWithTitle:@"节点0-0"];
    
    XPQTreeNodeData *node10 = [[XPQTreeNodeData alloc] initWithTitle:@"节点1-0"];
    XPQTreeNodeData *node11 = [[XPQTreeNodeData alloc] initWithTitle:@"节点1-1"];
    XPQTreeNodeData *node12 = [[XPQTreeNodeData alloc] initWithTitle:@"节点1-2"];
    
    XPQTreeNodeData *node20 = [[XPQTreeNodeData alloc] initWithTitle:@"节点2-0"];
    XPQTreeNodeData *node21 = [[XPQTreeNodeData alloc] initWithTitle:@"节点2-1"];
    
    [node00 insertChild:node10];
    [node00 insertChild:node11];
    [node00 insertChild:node12];
    
    [node10 insertChild:node20];
    [node10 insertChild:node21];
    
    self.testTree.nodeData = node00;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
