//
//  GraphicsView5.m
//  CoreGraphicsDemo
//
//  Created by 文正光 on 14-8-23.
//  Copyright (c) 2014年 文正光. All rights reserved.
//

#import "GraphicsView5.h"
#define kLineColor [UIColor redColor]
#define kFillColor [UIColor greenColor]
#define kBigRoundStrokeColor [UIColor blueColor]
#define kBigRoundFillColor [UIColor whiteColor]
#define kTextColor [UIColor yellowColor]
#define str(value) [NSString stringWithFormat:@"%.fw", value]

@interface GraphicsView5 ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSMutableArray *points;
@end
@implementation GraphicsView5
- (void)awakeFromNib {
  self.points = [@[] mutableCopy];

  __weak id weakSelf = self;
  double delayInSeconds = 1;
  self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                      dispatch_get_main_queue());
  dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),
                            (unsigned)(delayInSeconds * NSEC_PER_SEC), 0);
  dispatch_source_set_event_handler(_timer, ^{ [weakSelf updateView]; });
  dispatch_resume(_timer);
}

- (void)updateView {
  //随机取0到2000的值
  int value = (arc4random() % 2000);
  //  int value = 2000;
  //  NSLog(@"next value is %d", value);
  [self.points addObject:@(value)];
  //最大显示个数
  static int count = 8;
  if (self.points.count > count) {
    [self.points removeObjectAtIndex:0];
  }
  [self setNeedsDisplay];
}

- (void)dealloc {
  dispatch_source_cancel(self.timer);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

  if (self.points.count == 0) {
    return;
  }

  // Drawing code
  CGContextRef context = UIGraphicsGetCurrentContext();

  //创建句柄
  CGMutablePathRef pathRef = CGPathCreateMutable();
  CGContextSetLineCap(context, kCGLineCapRound);
  CGContextSetLineJoin(context, kCGLineJoinRound);
  CGContextSetLineWidth(context, 1);
  CGContextSetStrokeColorWithColor(context, kLineColor.CGColor);
  CGContextSetFillColorWithColor(context, kFillColor.CGColor);
  int maxValue = [[self.points valueForKeyPath:@"@max.self"] integerValue];
  CGFloat height = rect.size.height - 10;
  CGFloat scaleY = 1;
  if (maxValue > height) {
    scaleY = height / maxValue;
  }
  CGFloat scaleX = 42;
  for (int i = 0; i < self.points.count; i++) {
    double point = [[self.points objectAtIndex:i] doubleValue];
    CGFloat x = scaleX * i, y = height - (point * scaleY);
    if (i == 0) {
      CGPathMoveToPoint(pathRef, NULL, x, y);
    } else {
      CGPathAddLineToPoint(pathRef, NULL, x, y);
    }
  }

  //填充颜色
  CGPathAddLineToPoint(pathRef, NULL, (scaleX * self.points.count - 1), height);
  CGPathAddLineToPoint(pathRef, NULL, 0, height);
  CGPathCloseSubpath(pathRef);
  //将path添加到上下文
  CGContextAddPath(context, pathRef);
  CGContextDrawPath(context, kCGPathEOFillStroke);
  CGPathRelease(pathRef);

  pathRef = CGPathCreateMutable();
  CGContextSetLineWidth(context, 1);
  CGContextSetStrokeColorWithColor(context, kFillColor.CGColor);
  CGPathMoveToPoint(pathRef, NULL, 0, height);
  CGPathAddLineToPoint(pathRef, NULL, scaleX * self.points.count, height);
  CGContextAddPath(context, pathRef);
  CGContextStrokePath(context);
  CGPathRelease(pathRef);

  pathRef = CGPathCreateMutable();
  CGContextSetStrokeColorWithColor(context, kBigRoundStrokeColor.CGColor);
  CGContextSetFillColorWithColor(context, kBigRoundFillColor.CGColor);
  for (int i = 0; i < self.points.count; i++) {
    double point = [[self.points objectAtIndex:i] doubleValue];
    CGFloat x = scaleX * i, y = height - (point * scaleY);
    double bigRoundRadius = 3.0f * 1; //大圆半径
    double smallRoundRadius = 1.f;    //小圆半径
    CGContextAddEllipseInRect(
        context, CGRectMake(x - bigRoundRadius, y - bigRoundRadius,
                            2 * bigRoundRadius, 2 * bigRoundRadius));
    CGContextAddEllipseInRect(
        context, CGRectMake(x - smallRoundRadius, y - smallRoundRadius,
                            2 * smallRoundRadius, 2 * smallRoundRadius));
  }
  CGContextAddPath(context, pathRef);
  CGContextDrawPath(context, kCGPathEOFillStroke);
  CGPathRelease(pathRef);

  CGContextSaveGState(context);
  CGContextSetFillColorWithColor(context, kTextColor.CGColor);
  //  [kTextColor set];
  for (int i = 0; i < self.points.count; i++) {
    double point = [[self.points objectAtIndex:i] doubleValue];
    CGFloat textOffset;
    if (i == 0) {
      textOffset = 0.f;
    } else if (i == self.points.count - 1) {
      textOffset = -16.f;
    } else {
      textOffset = -8.f;
    }
    CGPoint cPoint =
        CGPointMake(scaleX * i + textOffset, height - (point * scaleY));
    [self drawAtPoint:cPoint withStr:str(point)];
  }
  CGContextRestoreGState(context);
}

- (void)drawAtPoint:(CGPoint)point withStr:(NSString *)str {
  [str drawAtPoint:point withFont:[UIFont systemFontOfSize:10]];
  //  [str drawAtPoint:point
  //      withAttributes:@{
  //                       NSFontAttributeName : [UIFont systemFontOfSize:10],
  //                       NSForegroundColorAttributeName : kTextColor
  //                     }];
}

@end
