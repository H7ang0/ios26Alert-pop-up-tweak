#import <UIKit/UIKit.h>
#import "H7ang0AlertController.h"

@interface H7ang0AlertManager : NSObject

+ (void)presentFromTopMostWithTitle:(NSString *)title
                             message:(NSString *)message
                                mode:(H7ang0AlertMode)mode
                        confirmStyle:(H7ang0ConfirmButtonStyle)confirmStyle
                     correctPassword:(NSString *)correctPassword
                          completion:(void (^)(NSString *input, BOOL success))completion;

+ (void)presentOn:(UIViewController *)vc
           title:(NSString *)title
         message:(NSString *)message
            mode:(H7ang0AlertMode)mode
    confirmStyle:(H7ang0ConfirmButtonStyle)confirmStyle
 correctPassword:(NSString *)correctPassword
      completion:(void (^)(NSString *input, BOOL success))completion;

// 便捷方法：无密码验证（用于确认和结束模式）
+ (void)presentFromTopMostWithTitle:(NSString *)title
                             message:(NSString *)message
                                mode:(H7ang0AlertMode)mode
                        confirmStyle:(H7ang0ConfirmButtonStyle)confirmStyle
                          completion:(void (^)(NSString *input, BOOL success))completion;

@end 