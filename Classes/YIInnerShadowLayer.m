//
//  YIInnerShadowLayer.m
//  YIInnerShadowView
//
//  Created by Yasuhiro Inami on 2012/10/14.
//  Copyright (c) 2012年 Yasuhiro Inami. All rights reserved.
//

#import "YIInnerShadowLayer.h"

@implementation YIInnerShadowLayer

#pragma mark - Lifecycle

- (id)init
{
    if (self = [super init])
    {
        self.needsDisplayOnBoundsChange = YES;
        self.masksToBounds              = YES;
        self.shouldRasterize            = YES;
        
        // Standard shadow stuff
        [self setShadowColor:[[UIColor colorWithWhite:0 alpha:1] CGColor]];
        [self setShadowOffset:CGSizeMake(0.0f, 0.0f)];
        [self setShadowOpacity:1.0f];
        [self setShadowRadius:5];
        
        // Causes the inner region in this example to NOT be filled.
        self.fillRule   = kCAFillRuleEvenOdd;
        self.shadowMask = YIInnerShadowMaskAll;
    }
    return self;
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    
    CGFloat top    = (self.shadowMask & YIInnerShadowMaskTop    ? self.shadowRadius : 0);
    CGFloat bottom = (self.shadowMask & YIInnerShadowMaskBottom ? self.shadowRadius : 0);
    CGFloat left   = (self.shadowMask & YIInnerShadowMaskLeft   ? self.shadowRadius : 0);
    CGFloat right  = (self.shadowMask & YIInnerShadowMaskRight  ? self.shadowRadius : 0);
    
    CGRect largerRect = CGRectMake(CGRectGetMinX  (self.bounds) - left,
                                   CGRectGetMinY  (self.bounds) - top,
                                   CGRectGetWidth (self.bounds) + left + right,
                                   CGRectGetHeight(self.bounds) + top  + bottom);
    
    // Create the larger rectangle path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, largerRect);
    
    // Add the inner path so it's subtracted from the outer path.
    // someInnerPath could be a simple bounds rect, or maybe
    // a rounded one for some extra fanciness.
    CGFloat cornerRadius = self.cornerRadius;
    UIBezierPath *bezier;
    if (cornerRadius)
    {
        bezier = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    } else {
        bezier = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    CGPathAddPath(path, NULL, bezier.CGPath);
    CGPathCloseSubpath(path);
    
    [self setPath:path];
    
    CGPathRelease(path);
}

#pragma mark - Accessors

- (void)setShadowMask:(YIInnerShadowMask)shadowMask
{
    _shadowMask = shadowMask;
    [self setNeedsLayout];
}

- (void)setShadowColor:(CGColorRef)shadowColor
{
    [super setShadowColor:shadowColor];
    [self setNeedsLayout];
}

- (void)setShadowOpacity:(float)shadowOpacity
{
    [super setShadowOpacity:shadowOpacity];
    [self setNeedsLayout];
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    [super setShadowOffset:shadowOffset];
    [self setNeedsLayout];
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    [super setShadowRadius:shadowRadius];
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    [super setCornerRadius:cornerRadius];
    [self setNeedsLayout];
}

@end
