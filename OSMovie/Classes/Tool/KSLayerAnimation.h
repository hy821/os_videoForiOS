//
//  KSLayerAnimation.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TabbarAnimationType) {
    RotationAnimationRound = 0,//旋转360
    BounceAnimation = 1,//放大缩小
    RotationAnimationLeftRight = 2,//左右翻转
};

@interface KSLayerAnimation : NSObject
+(void)animationWithTabbarIndex:(NSInteger)index type:(TabbarAnimationType)type;
+(void)aniamtionWithTarBarView:(UIView*)view type:(TabbarAnimationType)type;
+(void)animationWithView:(UIView *)view type:(TabbarAnimationType)type repeatCount:(NSInteger)count duration:(NSInteger)dur;
+(void)shakeAnimationForView:(UIView *) view;
@end
