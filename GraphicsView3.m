//
//  GraphicsView3.m
//  CoreGraphicsDemo
//
//  Created by 文正光 on 14-8-23.
//  Copyright (c) 2014年 文正光. All rights reserved.
//

#import "GraphicsView3.h"

@implementation GraphicsView3

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // Drawing code
  //  CGContextRef context = UIGraphicsGetCurrentContext();

  UIBezierPath *path = [UIBezierPath bezierPath];

  [path moveToPoint:CGPointMake(20, 20)];
  [path addLineToPoint:CGPointMake(300, 20)];
  [path addLineToPoint:CGPointMake(300, 100)];
  [path closePath];
  [[UIColor redColor] setFill];
  [path fill];
  [[UIColor greenColor] setStroke];
  [path stroke];

  [path moveToPoint:CGPointMake(20, 50)];
  [path addLineToPoint:CGPointMake(20, 150)];
  [path addLineToPoint:CGPointMake(300, 150)];
  [path closePath];
  [[UIColor blueColor] setStroke];
  [[UIColor yellowColor] setFill];
  [path stroke];
  [path fill];

  path = [UIBezierPath bezierPath];
  [path moveToPoint:CGPointMake(20, 160)];
  [path addLineToPoint:CGPointMake(300, 160)];
  [[UIColor orangeColor] setStroke];
  [path stroke];
}

@end
