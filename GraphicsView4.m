//
//  GraphicsView4.m
//  CoreGraphicsDemo
//
//  Created by 文正光 on 14-8-23.
//  Copyright (c) 2014年 文正光. All rights reserved.
//

#import "GraphicsView4.h"

@implementation GraphicsView4

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

  CGMutablePathRef pathRef = CGPathCreateMutable();

  CGPathMoveToPoint(pathRef, NULL, 20, 20);
  CGPathAddLineToPoint(pathRef, NULL, 300, 20);
  CGPathAddLineToPoint(pathRef, NULL, 300, 100);
  CGPathCloseSubpath(pathRef);

  CGContextSaveGState(context);
  CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
  CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
  CGContextSetLineJoin(context, kCGLineJoinRound);
  CGContextAddPath(context, pathRef);
  CGContextDrawPath(context, kCGPathFillStroke);
  CGContextRestoreGState(context);

  CGPathMoveToPoint(pathRef, NULL, 20, 50);
  CGPathAddLineToPoint(pathRef, NULL, 20, 150);
  CGPathAddLineToPoint(pathRef, NULL, 300, 150);
  CGPathCloseSubpath(pathRef);

  CGContextSaveGState(context);
  CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
  CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
  CGContextAddPath(context, pathRef);
  CGContextDrawPath(context, kCGPathEOFillStroke);
  CGContextRestoreGState(context);

  CGPathRelease(pathRef);
}

@end
