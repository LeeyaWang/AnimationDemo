//
//  StaticView.m
//  AnimationDemo
//
//  Created by wangliya on 2017/4/6.
//  Copyright © 2017年 wangliya. All rights reserved.
//

#import "StaticView.h"

#define Size [[UIScreen mainScreen] bounds].size


@implementation StaticView

-(void)drawRect:(CGRect)rect
{
    //创建圆
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(Size.width/2 - 50, Size.height/2 - 50, 100, 100) cornerRadius:50];
    [[UIColor redColor] setStroke];
    [[UIColor redColor] setFill];
    [circlePath stroke];
    [circlePath fill];
    
    //创建点
    UIBezierPath * pointPathLeft = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(Size.width/2 - 30, Size.height/2 - 20, 8, 8) cornerRadius:4];
    [[UIColor yellowColor] setStroke];
    [[UIColor yellowColor] setFill];
    [pointPathLeft stroke];
    [pointPathLeft fill];
    
    UIBezierPath * pointPathRight = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(Size.width/2 + 22, Size.height/2 - 20, 8, 8) cornerRadius:4];
    [[UIColor yellowColor] setStroke];
    [[UIColor yellowColor] setFill];
    [pointPathRight stroke];
    [pointPathRight fill];
    
    //画1/4圆
    UIBezierPath * semicirclePath = [UIBezierPath bezierPath];
    [semicirclePath addArcWithCenter:CGPointMake(Size.width/2, Size.height/2) radius:26 startAngle:M_PI * 2 endAngle:M_PI * 3 clockwise:YES];
    semicirclePath.lineWidth = 8;
    [[UIColor yellowColor] setStroke];
    [semicirclePath stroke];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
