#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, H7ang0AlertMode) {
    H7ang0AlertModeConfirm = 0,    // 标准确认
    H7ang0AlertModePassword = 1,   // 输入密码
    H7ang0AlertModeFinal = 2       // 结束模式（单按钮"好"）
};

typedef NS_ENUM(NSInteger, H7ang0ConfirmButtonStyle) {
    H7ang0ConfirmButtonStyleBlue = 0,  // 蓝色确认
    H7ang0ConfirmButtonStyleGreen = 1, // 绿色确认
    H7ang0ConfirmButtonStylePink = 2   // 粉红色确认
};

@interface H7ang0AlertController : UIViewController

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, assign) H7ang0AlertMode mode;
@property (nonatomic, assign) H7ang0ConfirmButtonStyle confirmStyle;
@property (nonatomic, copy) NSString *correctPassword; // 正确密码
@property (nonatomic, copy) void (^completion)(NSString *input, BOOL success);

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                         mode:(H7ang0AlertMode)mode
                 confirmStyle:(H7ang0ConfirmButtonStyle)confirmStyle
              correctPassword:(NSString *)correctPassword
                   completion:(void (^)(NSString *input, BOOL success))completion;

@end 