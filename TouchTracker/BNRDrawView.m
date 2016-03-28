//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by hello on 16/3/20.
//  Copyright © 2016年 hello. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView ()

//@property (nonatomic, strong)BNRLine *currentLine;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong)NSMutableArray *finishedLines;

@end


@implementation BNRDrawView

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        
        
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}

-(void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

-(void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] set];  //黑色绘制已经完成的
    for (BNRLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    //红色绘制正在画的线条
    [[UIColor redColor] set];
    
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
//    if (self.currentLine) {
//        [[UIColor redColor] set];
//        [self strokeLine:self.currentLine];
//    }
}

- (void)doubleTap:(UIGestureRecognizer *)gr
{
    
    NSLog(@"Recognized Double Tap");
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Recognized Tap");
}

#pragma mark - touch methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue  *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    
//    self.currentLine = [[BNRLine alloc] init];
//    self.currentLine.begin = location;
//    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        line.end = [t locationInView:self];
    }
//    UITouch *t = [touches anyObject];
//    CGPoint location = [t locationInView:self];
//    
//    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch * t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    
//    [self.finishedLines addObject:self.currentLine];
//    self.currentLine = nil;
    
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
