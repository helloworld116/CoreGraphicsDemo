//
//  GraphicsView.m
//  CoreGraphicsDemo
//
//  Created by 文正光 on 14-8-23.
//  Copyright (c) 2014年 文正光. All rights reserved.
//

#import "GraphicsView.h"
//#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)
#define str(index)                                                             \
  [NSString                                                                    \
      stringWithFormat:@"%.f",                                                 \
                       [[self.values objectAtIndex:(index)] floatValue] *      \
                           kYScale]

@interface GraphicsView ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSMutableArray *points;
@end

@implementation GraphicsView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

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
  //    self.timer
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
  //  CGContextSetLineCap(context, kCGLineCapSquare);
  CGContextSetLineJoin(context, kCGLineJoinRound);
  CGContextSetLineWidth(context, 1);
  CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);

  CGContextSetFillColorWithColor(context,
                                 [UIColor colorWithWhite:1 alpha:0.8].CGColor);

  //创建句柄
  CGMutablePathRef pathRef = CGPathCreateMutable();

  int maxValue = [[self.points valueForKeyPath:@"@max.self"] integerValue];
  CGFloat height = rect.size.height - 10;
  CGFloat scaleY = 1;
  if (maxValue > height) {
    scaleY = height / maxValue;
  }
  CGFloat textOffset = 0;
  CGFloat scaleX = 42;
  for (int i = 0; i < self.points.count; i++) {
    double point = [[self.points objectAtIndex:i] doubleValue];
    CGFloat x = scaleX * i, y = height - (point * scaleY);
    double r1 = 1.5f * 1;               //小圆半径
    double r2 = 3.0f * 1;               //大圆半径
    double t1 = (1 - 1 / M_SQRT2) * r2; //进入连接点相对圆点的偏离距离
    double t2 = r2 - t1; //离开连接点相对圆点的偏离距离
    CGContextAddEllipseInRect(context,
                              CGRectMake(x - r1, y - r1, 2 * r1, 2 * r1));
    CGContextAddEllipseInRect(context,
                              CGRectMake(x - r2, y - r2, 2 * r2, 2 * r2));

    double xOffset1 = t1 - r2;
    double yOffset1;
    if (i == 0) {
      yOffset1 = r2 - t1;
      CGPathMoveToPoint(pathRef, NULL, x + xOffset1, y + yOffset1);

      CGPathAddLineToPoint(pathRef, NULL, x + r2, y);
    } else {
      double prePoint = [[self.points objectAtIndex:i - 1] doubleValue];
      if (prePoint <= point) {
        yOffset1 = -t1 + r2;
      } else {
        yOffset1 = t1 - r2;
      }
      CGPathAddLineToPoint(pathRef, NULL, x + xOffset1, y + yOffset1);

      double xOffset2 = t2;
      double yOffset2;
      if (i == self.points.count - 1) {
        textOffset = 16.f;
      } else {
        textOffset = 8.f;
        double nextPoint = [[self.points objectAtIndex:i + 1] doubleValue];
        if (nextPoint <= point) {
          yOffset2 = t2;
        } else {
          yOffset2 = -t2;
        }
      }
      CGPathAddLineToPoint(pathRef, NULL, x + xOffset2, y + yOffset2);
    }

    CGPoint cPoint =
        CGPointMake(scaleX * i - textOffset, height - (point * scaleY));
    [self drawAtPoint:cPoint withStr:[NSString stringWithFormat:@"%.f", point]];
  }

  //填充颜色
  CGPathAddLineToPoint(pathRef, NULL, (scaleX * self.points.count - 1), height);
  CGPathAddLineToPoint(pathRef, NULL, 0, height);
  CGPathCloseSubpath(pathRef);

  //将path添加到上下文
  CGContextAddPath(context, pathRef);
  //  CGContextStrokePath(context);
  //  CGContextFillPath(context);
  CGContextDrawPath(context, kCGPathEOFillStroke);

  CGPathRelease(pathRef);
}

- (void)drawAtPoint:(CGPoint)point withStr:(NSString *)str {
  //  [str drawAtPoint:point
  //      withAttributes:@{
  //                       NSFontAttributeName : [UIFont systemFontOfSize:10],
  //                       NSStrokeColorAttributeName : [UIColor yellowColor],
  //                     }];
}
@end
