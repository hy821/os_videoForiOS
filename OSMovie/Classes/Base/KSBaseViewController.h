//
//  KSBaseViewController.h

#import <UIKit/UIKit.h>
@interface KSBaseViewController : UIViewController
/** * 设置导航栏名字 */
-(UILabel*)setTitleName:(NSString*)name andFont:(CGFloat)fontH;
/** * 设置导航按钮(有字)(无字) */
-(UIButton*)setNavButtonImageName:(NSString*)imageName andIsLeft:(BOOL)isLeft andTarget:(id)target andAction:(SEL)selector;
//带有pagecontroller的跳转
-(void)pushController:(UIViewController *)view;
//presend
-(void)presentController:(UIViewController*)view;
-(void)setNoNavBarBackBtn;
//present过来的界面
-(void)setPresentVCBackBtn;
#pragma mark--处理导航栏按钮间距
-(void)resoleBarItemForSpaceWithItem:(UIBarButtonItem *)item andIsLeft:(BOOL)isLeft;
#pragma mark--导航栏按钮纯文字
-(UIButton*)setNavWithTitle:(NSString *)title Font:(CGFloat)font andTextColor:(NSString*)color andIsLeft:(BOOL)isLeft andTarget:(id)target andAction:(SEL)selector;

/**
 * 切换页面时mjReresh 还存在的解决方案
 **/
-(void)endRefreshPulling:(UIScrollView*)scrollView;

@property (nonatomic,assign) SSNetState isNetError;

//下载缓存页:  运行中  已完成 共同父类属性
@property (nonatomic,assign) NSInteger pageViewIndex;

@end
