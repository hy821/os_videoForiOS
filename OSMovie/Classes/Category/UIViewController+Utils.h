//
//  UIViewController+Utils.h
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Utils)

/**
Whether or not to set ModelPresentationStyle automatically for instance, Default is [Class LL_automaticallySetModalPresentationStyle].

@return BOOL
*/
@property (nonatomic, assign) BOOL LL_automaticallySetModalPresentationStyle;

/**
 Whether or not to set ModelPresentationStyle automatically, Default is YES, but UIImagePickerController/UIAlertController is NO.

 @return BOOL
 */
+ (BOOL)LL_automaticallySetModalPresentationStyle;

@end

NS_ASSUME_NONNULL_END
