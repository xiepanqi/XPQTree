//
//  XPQTreeNodeCell.m
//  XPQTree
//
//  Created by 谢攀琪 on 15/6/4.
//  Copyright (c) 2015年 谢攀琪. All rights reserved.
//

#import "XPQTreeNodeCell.h"

@interface XPQTreeNodeCell ()
@property (nonatomic) UIButton *foldButton;
@property (nonatomic) UIButton *titleButton;
@end

@implementation XPQTreeNodeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSelf];
    }
    return self;
}

-(void)configSelf {
    
}

#pragma mark - 属性
-(void)setSplitColor:(UIColor *)splitColor {
    if (_splitColor != splitColor) {
        _splitColor = splitColor;
        [self setNeedsDisplay];
    }
}

-(void)setJointColor:(UIColor *)jointColor {
    if (_jointColor != jointColor) {
        _jointColor = jointColor;
        [self setNeedsDisplay];
    }
}

-(void)setJointStyle:(XPQTreeJointStyle)jointStyle {
    if (_jointStyle != jointStyle) {
        _jointStyle = jointStyle;
        [self setNeedsDisplay];
    }
}

-(void)setNodeData:(XPQTreeNodeData *)nodeData {
    _nodeData = nodeData;
    [self configFoldButton];
    [self configTitleButton];
}

#pragma mark - 折叠按钮
-(void)configFoldButton {
    if (self.nodeData.child.count > 0) {
        if (self.foldButton == nil) {
            self.foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.foldButton addTarget:self action:@selector(actionFoldButton:) forControlEvents:UIControlEventTouchUpInside];
            // 设置图标
            if (self.foldImage == nil) {
                [self.foldButton setTitle:@"➕" forState:UIControlStateNormal];
                [self.foldButton setImage:nil forState:UIControlStateNormal];
            }
            else {
                [self.foldButton setTitle:@"" forState:UIControlStateSelected];
                [self.foldButton setImage:self.foldImage forState:UIControlStateSelected];
            }
            if (self.expandImage == nil) {
                [self.foldButton setTitle:@"➖" forState:UIControlStateSelected];
                [self.foldButton setImage:nil forState:UIControlStateSelected];
            }
            else {
                [self.foldButton setTitle:@"" forState:UIControlStateNormal];
                [self.foldButton setImage:self.expandImage forState:UIControlStateNormal];
            }
            [self addSubview:self.foldButton];
        }
        self.foldButton.selected = self.nodeData.expand;
        self.foldButton.frame = CGRectMake(self.nodeData.level * self.imageSize.width, 0, self.imageSize.width, self.imageSize.height);
    }
    else {
        [self.foldButton removeFromSuperview];
        self.foldButton = nil;
    }
}

-(void)actionFoldButton:(UIButton *)sender {
    if ([self.nodeDelegate respondsToSelector:@selector(shouldClickFoldButtonAtNode:)]) {
        if ([self.nodeDelegate shouldClickFoldButtonAtNode:self] == NO) {
            return;
        }
    }
    
    sender.selected = ! sender.selected;
    self.nodeData.expand = sender.selected;
    
    if ([self.nodeDelegate respondsToSelector:@selector(didClickFoldButtonAtNode:)]) {
        [self.nodeDelegate didClickFoldButtonAtNode:self];
    }
}

#pragma mark - 标题按钮
-(void)configTitleButton {
    [self.titleButton removeFromSuperview];
    self.titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.foldButton addTarget:self action:@selector(actionTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.titleButton];
    [self.titleButton setTitle:self.nodeData.title forState:UIControlStateNormal];
    
    CGFloat x = self.nodeData.level * self.imageSize.width;
    if (self.nodeData.child.count > 0) {
        x += self.imageSize.width;
    }
    else {
        x += (self.imageSize.width / 3);
    }
    self.titleButton.frame = CGRectMake(x, 0, self.frame.size.width - x + 22, self.imageSize.height);
}

-(void)actionTitleButton:(UIButton *)sender {
    if ([self.nodeDelegate respondsToSelector:@selector(didClickTitleAtNode:)]) {
        [self.nodeDelegate didClickTitleAtNode:self];
    }
}

#pragma mark - 画线
-(void)drawRect:(CGRect)rect {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 1.0;
    // 画实线
    CGContextRef solidLine = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(solidLine, 1);
    [self.splitColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(solidLine, red, green, blue, alpha);//线条颜色
    // 节点上面的分割线
    CGContextMoveToPoint(solidLine, self.nodeData.level * self.imageSize.width, 0);
    CGContextAddLineToPoint(solidLine, self.frame.size.width, 0);
    // 尾节点下面的线
    if ([self.nodeData nextNode] == nil) {
        CGContextMoveToPoint(solidLine, 0, self.imageSize.height);
        CGContextAddLineToPoint(solidLine, self.frame.size.width, self.imageSize.height);
    }
    CGContextStrokePath(solidLine);
    
    if (self.jointStyle != XPQTreeJointStyleNone) {
        // 画虚线
        CGContextRef dashLine = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(dashLine, 1);
        if (self.jointStyle == XPQTreeJointStyleDash) {
            // 为了让各个cell中的虚线看起来像是一条连起来的虚线，一个cell应该刚好显示完整的虚线段
            int lineNum = self.imageSize.height / 5.0;
            CGFloat lineLenth = self.imageSize.height / (CGFloat)lineNum;
            CGFloat lengths[] = {lineLenth, lineLenth};
            CGContextSetLineDash(dashLine, 0, lengths, 2);
        }
        [self.jointColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBStrokeColor(dashLine, red, green, blue, alpha);//线条颜色
        
        if (self.nodeData.level > 0) {
            CGFloat x = self.nodeData.level * self.imageSize.width;
            // 竖线
            CGContextMoveToPoint(dashLine, x - (self.imageSize.width / 2), 0);
            if (self.nodeData.brother == nil) {
                CGContextAddLineToPoint(dashLine, x - (self.imageSize.width / 2), self.imageSize.height / 2);
            }
            else {
                CGContextAddLineToPoint(dashLine, x - (self.imageSize.width / 2), self.imageSize.height);
            }
            // 横线
            CGContextMoveToPoint(dashLine, x - (self.imageSize.width / 2), self.imageSize.height / 2);
            CGContextAddLineToPoint(dashLine, x, self.imageSize.height / 2);
        }
        
        for (XPQTreeNodeData *node = self.nodeData.parent; node != nil; node = node.parent) {
            if (node.brother != nil) {
                CGContextMoveToPoint(dashLine, node.level * self.imageSize.width - (self.imageSize.width / 2), 0);
                CGContextAddLineToPoint(dashLine, node.level * self.imageSize.width - (self.imageSize.width / 2), self.imageSize.height);
            }
        }
        CGContextStrokePath(dashLine);
    }
}

@end
