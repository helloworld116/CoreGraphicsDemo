//
//  GraphicsView2.m
//  CoreGraphicsDemo
//
//  Created by 文正光 on 14-8-23.
//  Copyright (c) 2014年 文正光. All rights reserved.
//

#import "GraphicsView2.h"

@implementation GraphicsView2

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
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSaveGState(context);
  CGMutablePathRef pathRef = CGPathCreateMutable();
  CGContextSetLineWidth(context, 1);
  CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
  CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

  //画五角星
  CGPathMoveToPoint(pathRef, NULL, 20, 120);
  CGPathAddLineToPoint(pathRef, NULL, 300, 120);
  CGPathAddLineToPoint(pathRef, NULL, 50, 320);
  CGPathAddLineToPoint(pathRef, NULL, 160, 20);
  CGPathAddLineToPoint(pathRef, NULL, 270, 320);
  CGPathCloseSubpath(pathRef);
  CGContextAddPath(context, pathRef);
  CGContextDrawPath(context, kCGPathFillStroke);
  CGPathRelease(pathRef);
  CGContextRestoreGState(context);

  CGContextSaveGState(context);
  pathRef = CGPathCreateMutable();
  CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
  CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
  //设置画笔的起始位置
  CGPathMoveToPoint(pathRef, NULL, 20, 20);
  //画线
  CGPathAddLineToPoint(pathRef, NULL, 300, 40);
  CGPathAddLineToPoint(pathRef, NULL, 130, 80);
  CGPathAddLineToPoint(pathRef, NULL, 150, 120);
  CGPathCloseSubpath(pathRef);
  CGContextAddPath(context, pathRef);
  CGContextDrawPath(context, kCGPathFillStroke);
  CGPathRelease(pathRef);
  CGContextRestoreGState(context);
}

@end
