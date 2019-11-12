//
//  KSLayerAnimation.m
//


#import "KSLayerAnimation.h"
#import "AppDelegate.h"
static CGFloat duration = 0.4f;
@implementation KSLayerAnimation
+(void)animationWithTabbarIndex:(NSInteger)index type:(TabbarAnimationType)type
{
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    AppDelegate * app =  ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    for (UIView *tabBarButton in app.tabBarVC.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    UIView * tabbarBtn = tabbarbuttonArray[index];
    [KSLayerAnimation aniamtionWithTarBarView:tabbarBtn type:type];
    
}
+(void)aniamtionWithTarBarView:(UIView *)view type:(TabbarAnimationType)type
{
    __block UIImageView * imageV;
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImageView class]])
        {
            imageV = obj;
            *stop = YES;
            return ;
        }
    }];
    [imageV.layer removeAllAnimations];
    switch (type) {
        case RotationAnimationRound:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
            
            animation.values = @[@(0), @(M_PI_2), @(M_PI), @(M_PI * 2)];
            animation.duration = duration;
            animation.calculationMode = kCAAnimationCubic;
            
            [imageV.layer addAnimation:animation forKey:@"playRotaionAnimation"];
            
        }
            break;
        case RotationAnimationLeftRight:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.y"];
            
            animation.values = @[@(0), @(M_PI_2), @(M_PI), @(M_PI * 2)];
            animation.duration = duration;
            animation.calculationMode = kCAAnimationCubic;
            
            [imageV.layer addAnimation:animation forKey:@"playTransitionAnimation"];
            
        }
            break;
        case BounceAnimation:
        {
            CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pulse.duration = 0.15f;
            pulse.repeatCount= 1;
            pulse.autoreverses= YES;
            pulse.fromValue= [NSNumber numberWithFloat:0.9];
            pulse.toValue= [NSNumber numberWithFloat:1.1];
            [[imageV layer]
             addAnimation:pulse forKey:nil];
            
        }
            break;
        default:
            break;
    }
}
+(void)animationWithView:(UIView *)view type:(TabbarAnimationType)type repeatCount:(NSInteger)count duration:(NSInteger)dur
{
    //    [view.layer removeAllAnimations];
    switch (type) {
        case RotationAnimationRound:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
            
            animation.values = @[@(0), @(M_PI_2), @(M_PI), @(M_PI * 2)];
            animation.duration = duration;
            animation.calculationMode = kCAAnimationCubic;
            
            [view.layer addAnimation:animation forKey:@"playRotaionAnimation"];
            
        }
            break;
        case RotationAnimationLeftRight:
        {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.y"];
            
            animation.values = @[@(0), @(M_PI_2), @(M_PI), @(M_PI * 2)];
            animation.duration = duration;
            animation.calculationMode = kCAAnimationCubic;
            
            [view.layer addAnimation:animation forKey:@"playTransitionAnimation"];
            
        }
            break;
        case BounceAnimation:
        {
            CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pulse.duration = dur ? dur : 0.2f;
            pulse.repeatCount= count ? count : 1;
            pulse.autoreverses= YES;
            pulse.fromValue= [NSNumber numberWithFloat:0.7];
            pulse.toValue= [NSNumber numberWithFloat:1.3];
            [[view layer] addAnimation:pulse forKey:nil];
            
        }
            break;
        default:
            break;
    }
}
+(void)shakeAnimationForView:(UIView *) view

{
    // 获取到当前的View
    
    CALayer *viewLayer = view.layer;
    
    // 获取当前View的位置
    
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    
    CGPoint x = CGPointMake(position.x + 10, position.y);
    
    CGPoint y = CGPointMake(position.x - 10, position.y);
    
    // 设置动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    
    [animation setAutoreverses:YES];
    
    // 设置时间
    
    [animation setDuration:.06];
    
    // 设置次数
    
    [animation setRepeatCount:3];
    
    // 添加上动画
    
    [viewLayer addAnimation:animation forKey:nil];
    
}
@end
