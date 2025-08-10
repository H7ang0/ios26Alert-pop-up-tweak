#import "H7ang0AlertManager.h"

@implementation H7ang0AlertManager

+ (void)presentFromTopMostWithTitle:(NSString *)title
                             message:(NSString *)message
                                mode:(H7ang0AlertMode)mode
                        confirmStyle:(H7ang0ConfirmButtonStyle)confirmStyle
                     correctPassword:(NSString *)correctPassword
                          completion:(void (^)(NSString *input, BOOL success))completion {
    UIViewController *top = [self topMostViewController];
    if (!top) { return; }
    [self presentOn:top title:title message:message mode:mode confirmStyle:confirmStyle correctPassword:correctPassword completion:completion];
}

+ (void)presentFromTopMostWithTitle:(NSString *)title
                             message:(NSString *)message
                                mode:(H7ang0AlertMode)mode
                        confirmStyle:(H7ang0ConfirmButtonStyle)confirmStyle
                          completion:(void (^)(NSString *input, BOOL success))completion {
    [self presentFromTopMostWithTitle:title message:message mode:mode confirmStyle:confirmStyle correctPassword:nil completion:completion];
}

+ (void)presentOn:(UIViewController *)vc
           title:(NSString *)title
         message:(NSString *)message
            mode:(H7ang0AlertMode)mode
    confirmStyle:(H7ang0ConfirmButtonStyle)confirmStyle
 correctPassword:(NSString *)correctPassword
      completion:(void (^)(NSString *input, BOOL success))completion {
    H7ang0AlertController *ac = [[H7ang0AlertController alloc] initWithTitle:title message:message mode:mode confirmStyle:confirmStyle correctPassword:correctPassword completion:completion];
    [vc presentViewController:ac animated:YES completion:nil];
}

+ (UIViewController *)topMostViewController {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                for (UIWindow *w in ws.windows) {
                    if (w.isKeyWindow) { keyWindow = w; break; }
                }
                if (keyWindow) { break; }
            }
        }
    }
    if (!keyWindow) { return nil; }
    UIViewController *root = keyWindow.rootViewController;
    if (!root) return nil;
    UIViewController *top = root;
    while (top.presentedViewController) { top = top.presentedViewController; }
    if ([top isKindOfClass:[UINavigationController class]]) {
        top = [(UINavigationController *)top topViewController];
    }
    if ([top isKindOfClass:[UITabBarController class]]) {
        top = [(UITabBarController *)top selectedViewController];
    }
    return top;
}

@end 