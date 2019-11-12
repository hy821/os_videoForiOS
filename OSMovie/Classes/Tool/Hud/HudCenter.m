//
//  HudCenter.m
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "HudCenter.h"
#import <SDWebImageManager.h>
#import <SDWebImageCompat.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import <AVFoundation/AVFoundation.h>
#import "MMMaterialDesignSpinner.h"

/** 颜色(RGB) */
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


@implementation HudCenter

//+ (void)load
//{
//    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, 0.8)];
//    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setInfoImage:nil];
//}

void ShowSuccessStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:statues];
        });
    }else{
        [MBProgressHUD showSuccess:statues];
    }
}


void ShowErrorStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:statues];
        });
    }else{
        [MBProgressHUD showError:statues];
    }
}

/*-----------MB-----------*/
void SSMBToast(NSString *text,UIView * view)
{
    if(![text isEqualToString:@"不支持的 URL"] && text.length>0)
    {
        if(!view)
        {
            view = MainWindow;
        }
        if (![NSThread isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showText:text toView:view];
            });
        }else{
            [MBProgressHUD showText:text toView:view];
        }
    }
}
void  SSDissMissMBHud(UIView * view,BOOL isAnimated)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:isAnimated];
        });
    }else{
        [MBProgressHUD hideHUDForView:view animated:isAnimated];
    }
}
void SSSuccessOrErrorToast(NSString *statues,UIView * view,BOOL isSuccess)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isSuccess)
            {
                [MBProgressHUD showSuccess:statues toView:view];
            }else
            {
                [MBProgressHUD showError:statues toView:view];
            }
        });
    }else{
        if(isSuccess)
        {
            [MBProgressHUD showSuccess:statues toView:view];
        }else
        {
            [MBProgressHUD showError:statues toView:view];
        }
    }
}
void SSHudShow(UIView * view,NSString * text)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.color = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.9f];
            if(text){
                hud.detailsLabelText = text;
            }
        });
    }else{
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.color = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.9f];
        if(text){
            hud.detailsLabelText = text;
        }
    }
}
extern void SSCustomViewShow(UIView * view,UIView * contentView)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:contentView animated:YES];
            hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            hud.customView = view;
            hud.mode = MBProgressHUDModeCustomView;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5f];
        });
    }else{
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:contentView animated:YES];
        hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        hud.customView = view;
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5f];
    }
}
extern void SSGifShow(UIView * view,NSString * text)
{
    
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            MMMaterialDesignSpinner * _activity = [[MMMaterialDesignSpinner alloc] init];
            _activity.lineWidth = 2.f;
            _activity.duration  = 1.f;
            _activity.mj_size = CGSizeMake(20, 20);
            //[[UIColor whiteColor] colorWithAlphaComponent:0.9];
            _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
            [_activity startAnimating];
            hud.customView = _activity;
            hud.color = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.9f];
            hud.mode = MBProgressHUDModeCustomView;
            if(text){
                hud.detailsLabelText = text;
            }
        });
    }else{
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        MMMaterialDesignSpinner * _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 2.f;
        _activity.duration  = 1.f;
        //[[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];;
        _activity.mj_size = CGSizeMake(20, 20);
        [_activity startAnimating];
        hud.customView = _activity;
        hud.mode = MBProgressHUDModeCustomView;
        hud.color = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.9f];
        if(text){
            hud.detailsLabelText = text;
        }
    }
}
extern void SSDissMissGifHud(UIView * view,BOOL isAnimated)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:isAnimated];
        });
    }else{
        [MBProgressHUD hideHUDForView:view animated:isAnimated];
    }
}
extern void SSDissMissAllGifHud(UIView * view,BOOL isAnimated)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:view animated:isAnimated];
        });
    }else{
        [MBProgressHUD hideAllHUDsForView:view animated:isAnimated];
    }
}
extern void SSCustomViewHud(UIView * view,CGFloat height)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [[MBProgressHUD alloc]initWithView:view];
            hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            hud.color = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
            MMMaterialDesignSpinner * _activity = [[MMMaterialDesignSpinner alloc] init];
            _activity.lineWidth = 1.5f;
            _activity.duration  = 0.8f;
            _activity.tintColor =ThemeColor;
            _activity.mj_size = CGSizeMake(20, 20);
            [_activity startAnimating];
            hud.customView = _activity;
            hud.mode = MBProgressHUDModeCustomView;
            hud.removeFromSuperViewOnHide = YES;
            hud.yOffset = -((height)/2.0-20);
            hud.cornerRadius = 18.f;
            [view addSubview:hud];
            [hud show:YES];
        });
    }else{
        MBProgressHUD * hud = [[MBProgressHUD alloc]initWithView:view];
        hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        hud.color = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
        MMMaterialDesignSpinner * _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1.5f;
        _activity.duration  = 0.8f;
        _activity.tintColor = ThemeColor;
        _activity.mj_size = CGSizeMake(16, 16);
        [_activity startAnimating];
        hud.customView = _activity;
        hud.yOffset = -((height)/2.0-20);
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        hud.cornerRadius = 18.f;
        [view addSubview:hud];
        [hud show:YES];
    }
}
extern void SSCustomViewShowHud(UIView * view,NSString * text)
{
    if(!view)
    {
        view = MainWindow;
    }
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD * hud = [[MBProgressHUD alloc]initWithView:view];
            hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
             hud.color = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
            MMMaterialDesignSpinner * _activity = [[MMMaterialDesignSpinner alloc] init];
            _activity.lineWidth = 1.5f;
            _activity.duration  = 0.8f;
            _activity.tintColor =ThemeColor;
            _activity.mj_size = CGSizeMake(20, 20);
            [_activity startAnimating];
            hud.customView = _activity;
            if(text!=nil){
                hud.labelText = text;
                hud.labelColor = [UIColor lightGrayColor];
            }
            hud.mode = MBProgressHUDModeCustomView;
            hud.removeFromSuperViewOnHide = YES;
            hud.yOffset = -((ScreenHeight-42-hud.contentOffset-49)/2.0-20);
            hud.cornerRadius = 18.f;
            [view addSubview:hud];
            [hud show:YES];
        });
    }else{
        MBProgressHUD * hud = [[MBProgressHUD alloc]initWithView:view];
        hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        hud.color = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
        MMMaterialDesignSpinner * _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1.5f;
        _activity.duration  = 0.8f;
        _activity.tintColor = ThemeColor;
        _activity.mj_size = CGSizeMake(16, 16);
        [_activity startAnimating];
        hud.customView = _activity;
        if(text!=nil){
        hud.labelText = text;
        hud.labelColor = [UIColor lightGrayColor];
        }
        hud.yOffset = -((ScreenHeight-42-hud.contentOffset-49)/2.0-20);
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        hud.cornerRadius = 18.f;
        [view addSubview:hud];
        [hud show:YES];
    }
}
/*-----------MYH-MB--------------*/
@end
