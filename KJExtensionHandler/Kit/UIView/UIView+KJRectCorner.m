//
//  UIView+KJRectCorner.m
//  CategoryDemo
//
//  Created by 杨科军 on 2018/7/12.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJExtensionHandler

#import "UIView+KJRectCorner.h"
#import <objc/runtime.h>

@implementation UIView (KJRectCorner)
- (CGFloat)kj_radius{
    return [objc_getAssociatedObject(self, @selector(kj_radius)) floatValue];
}
- (void)setKj_radius:(CGFloat)kj_radius{
    CGFloat r = [objc_getAssociatedObject(self, @selector(kj_radius)) floatValue];
    if (r != kj_radius) {
        objc_setAssociatedObject(self, @selector(kj_radius), @(kj_radius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self kj_setRoundWithRadius:kj_radius RectCorner:self.kj_rectCorner];
    }
}
- (UIRectCorner)kj_rectCorner{
    return (UIRectCorner)objc_getAssociatedObject(self, @selector(kj_rectCorner));
}
- (void)setKj_rectCorner:(UIRectCorner)kj_rectCorner{
    objc_setAssociatedObject(self, @selector(kj_rectCorner), @(kj_rectCorner), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kj_setRoundWithRadius:self.kj_radius RectCorner:kj_rectCorner];
}
/// 设置圆角
- (void)kj_setRoundWithRadius:(CGFloat)radius RectCorner:(UIRectCorner)corner{
    if (radius == 0) radius = 5;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - 边框相关
- (UIColor*)kj_borderColor{
    return objc_getAssociatedObject(self, @selector(kj_borderColor));
}
- (void)setKj_borderColor:(UIColor*)kj_borderColor{
    objc_setAssociatedObject(self, @selector(kj_borderColor), kj_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kj_setBorderWithWidth:self.kj_borderWidth BorderColor:kj_borderColor BorderOrientation:self.kj_borderOrientation];
}
- (CGFloat)kj_borderWidth{
    return [objc_getAssociatedObject(self, @selector(kj_borderWidth)) floatValue];
}
- (void)setKj_borderWidth:(CGFloat)kj_borderWidth{
    objc_setAssociatedObject(self, @selector(kj_borderWidth), @(kj_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kj_setBorderWithWidth:kj_borderWidth BorderColor:self.kj_borderColor BorderOrientation:self.kj_borderOrientation];
}
- (KJBorderOrientationType)kj_borderOrientation{
    return (KJBorderOrientationType)objc_getAssociatedObject(self, @selector(kj_borderOrientation));
}
- (void)setKj_borderOrientation:(KJBorderOrientationType)kj_borderOrientation{
    objc_setAssociatedObject(self, @selector(kj_borderOrientation), @(kj_borderOrientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self kj_setBorderWithWidth:self.kj_borderWidth BorderColor:self.kj_borderColor BorderOrientation:kj_borderOrientation];
}
/// 设置边框
- (void)kj_setBorderWithWidth:(CGFloat)width BorderColor:(UIColor*)color BorderOrientation:(KJBorderOrientationType)orientation{
    if (orientation == UIRectEdgeNone) return;
    if (width == 0) width = 1.;
    if (color == nil) color = UIColor.blackColor;
    if (orientation == 1 || (orientation & KJBorderOrientationTypeTop)) {
        [self kj_setTag:520001 BorderColor:color Rect:CGRectMake(0, 0, self.frame.size.width, width)];
    }
    if (orientation == 2 || (orientation & KJBorderOrientationTypeBottom)) {
        [self kj_setTag:520002 BorderColor:color Rect:CGRectMake(0, self.frame.size.height-width, self.frame.size.width, width)];
    }
    if (orientation == 3 || (orientation & KJBorderOrientationTypeLeft)) {
        [self kj_setTag:520003 BorderColor:color Rect:CGRectMake(0, 0, width, self.frame.size.height)];
    }
    if (orientation == 4 || (orientation & KJBorderOrientationTypeRight)) {
        [self kj_setTag:520004 BorderColor:color Rect:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height)];
    }
}
- (void)kj_setTag:(NSInteger)tag BorderColor:(UIColor*)color Rect:(CGRect)rect{
    __block BOOL boo = NO;
    [self.layer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.kTag == tag) {
            boo = YES;
            obj.frame = rect;
            obj.backgroundColor = color.CGColor;
            *stop = YES;
        }
    }];
    if (boo == NO) {
        CALayer *layer = [CALayer layer];
        layer.kTag = tag;
        layer.frame = rect;
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
}

@end
