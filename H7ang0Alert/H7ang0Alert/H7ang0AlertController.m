#import "H7ang0AlertController.h"

@interface H7ang0AlertController () <UITextFieldDelegate>
@property (nonatomic, strong) UIVisualEffectView *backdropView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UILabel *errorLabel; // 错误提示
@end

@implementation H7ang0AlertController

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                         mode:(H7ang0AlertMode)mode
                 confirmStyle:(H7ang0ConfirmButtonStyle)confirmStyle
              correctPassword:(NSString *)correctPassword
                   completion:(void (^)(NSString *input, BOOL success))completion {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _titleText = [title copy];
        _messageText = [message copy];
        _mode = mode;
        _confirmStyle = confirmStyle;
        _correctPassword = [correctPassword copy];
        _completion = [completion copy];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    self.dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dimmingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [self.view addSubview:self.dimmingView];

    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial];
    self.backdropView = [[UIVisualEffectView alloc] initWithEffect:effect];

    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.containerView.layer.cornerRadius = 28.0;
    self.containerView.layer.cornerCurve = kCACornerCurveContinuous;
    self.containerView.clipsToBounds = YES;

    [self.view addSubview:self.containerView];

    // Apple logo for final mode (uses SF Symbols)
    UIImageSymbolConfiguration *logoConfig = [UIImageSymbolConfiguration configurationWithPointSize:44 weight:UIImageSymbolWeightSemibold];
    UIImage *appleLogo = [UIImage systemImageNamed:@"apple.logo" withConfiguration:logoConfig];
    self.logoView = [[UIImageView alloc] initWithImage:appleLogo];
    self.logoView.tintColor = [UIColor labelColor];
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = self.titleText;
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.numberOfLines = 0;

    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.text = self.messageText;
    self.messageLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.textColor = [UIColor secondaryLabelColor];
    self.messageLabel.numberOfLines = 0;

    self.passwordField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.placeholder = @"输入密码";
    self.passwordField.textContentType = UITextContentTypePassword;
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.backgroundColor = [UIColor tertiarySystemFillColor];
    self.passwordField.layer.cornerRadius = 14.0;
    self.passwordField.layer.cornerCurve = kCACornerCurveContinuous;
    self.passwordField.delegate = self;
    self.passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 1)];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;

    // 错误提示标签
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.text = @"";
    self.errorLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.errorLabel.textAlignment = NSTextAlignmentLeft;
    self.errorLabel.textColor = [UIColor systemRedColor];
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.alpha = 0.0;

    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.confirmButton setTitle:(self.mode == H7ang0AlertModeFinal ? @"好" : @"确认") forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    self.confirmButton.layer.cornerRadius = 16.0;
    self.confirmButton.layer.cornerCurve = kCACornerCurveContinuous;
    self.confirmButton.contentEdgeInsets = UIEdgeInsetsMake(14, 16, 14, 16);
    [self.confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];

    [self applyConfirmStyle];

    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    self.cancelButton.tintColor = [UIColor labelColor];
    [self.cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *vstack = [[UIStackView alloc] initWithFrame:CGRectZero];
    vstack.translatesAutoresizingMaskIntoConstraints = NO;
    vstack.axis = UILayoutConstraintAxisVertical;
    vstack.spacing = 12.0;

    // Top spacing + logo (final mode)
    UIView *spacer8 = [UIView new]; spacer8.translatesAutoresizingMaskIntoConstraints = NO; [spacer8.heightAnchor constraintEqualToConstant:8].active = YES;
    [vstack addArrangedSubview:spacer8];

    if (self.mode == H7ang0AlertModeFinal) {
        self.logoView.contentMode = UIViewContentModeScaleAspectFit;
        [vstack addArrangedSubview:self.logoView];
        [self.logoView.heightAnchor constraintEqualToConstant:52].active = YES;
    }

    [vstack addArrangedSubview:self.titleLabel];
    [vstack addArrangedSubview:self.messageLabel];

    if (self.mode == H7ang0AlertModePassword) {
        [vstack addArrangedSubview:self.passwordField];
        [self.passwordField.heightAnchor constraintEqualToConstant:44].active = YES;
        
        [vstack addArrangedSubview:self.errorLabel];
        [self.errorLabel.heightAnchor constraintEqualToConstant:20].active = YES;
    }

    UIStackView *buttons = [[UIStackView alloc] initWithFrame:CGRectZero];
    buttons.translatesAutoresizingMaskIntoConstraints = NO;
    buttons.axis = UILayoutConstraintAxisHorizontal;
    buttons.spacing = 10.0;
    buttons.distribution = UIStackViewDistributionFillEqually;

    if (self.mode == H7ang0AlertModeFinal) {
        [buttons addArrangedSubview:self.confirmButton];
    } else {
        [buttons addArrangedSubview:self.cancelButton];
        [buttons addArrangedSubview:self.confirmButton];
    }

    [vstack addArrangedSubview:buttons];

    [self.containerView addSubview:vstack];

    // Layout constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.dimmingView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.dimmingView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.dimmingView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.dimmingView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],

        [self.containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.containerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.containerView.widthAnchor constraintLessThanOrEqualToAnchor:self.view.widthAnchor constant:-48.0],
        [self.containerView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:24.0],
        [self.containerView.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor constant:-24.0],

        [vstack.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:20.0],
        [vstack.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:20.0],
        [vstack.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-20.0],
        [vstack.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-20.0],
    ]];

    self.containerView.transform = CGAffineTransformMakeScale(0.96, 0.96);
    self.containerView.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [gen impactOccurred];

    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.82 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.dimmingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
        self.containerView.transform = CGAffineTransformIdentity;
        self.containerView.alpha = 1.0;
    } completion:nil];
}

- (void)applyConfirmStyle {
    UIColor *fill;
    if (self.confirmStyle == H7ang0ConfirmButtonStyleGreen) {
        fill = [UIColor systemGreenColor];
    } else if (self.confirmStyle == H7ang0ConfirmButtonStylePink) {
        fill = [UIColor systemPinkColor];
    } else {
        fill = [UIColor systemBlueColor];
    }
    UIColor *text = [UIColor whiteColor];

    self.confirmButton.backgroundColor = fill;
    [self.confirmButton setTitleColor:text forState:UIControlStateNormal];
}

- (void)onConfirm {
    NSString *input = nil;
    BOOL success = YES;
    
    if (self.mode == H7ang0AlertModePassword) {
        input = self.passwordField.text ?: @"";
        
        // 验证密码
        if (self.correctPassword && ![input isEqualToString:self.correctPassword]) {
            success = NO;
            [self showPasswordError];
            return;
        }
    }
    
    if (self.completion) {
        self.completion(input, success);
    }
    [self dismissAnimated:YES];
}

- (void)showPasswordError {
    // 震动效果
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    [gen impactOccurred];
    
    // 显示错误提示
    self.errorLabel.text = @"密码错误，请重试";
    
    // 摇晃动画
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    shake.duration = 0.6;
    shake.values = @[@(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0)];
    [self.containerView.layer addAnimation:shake forKey:@"shake"];
    
    // 错误提示渐入
    [UIView animateWithDuration:0.3 animations:^{
        self.errorLabel.alpha = 1.0;
    }];
    
    // 清空密码输入框
    self.passwordField.text = @"";
    
    // 3秒后隐藏错误提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.errorLabel.alpha = 0.0;
        }];
    });
}

- (void)onCancel {
    if (self.completion) {
        self.completion(nil, NO);
    }
    [self dismissAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onConfirm];
    return YES;
}

- (void)dismissAnimated:(BOOL)animated {
    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [gen impactOccurred];

    NSTimeInterval dur = animated ? 0.25 : 0.0;
    [UIView animateWithDuration:dur animations:^{
        self.dimmingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.containerView.transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.containerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end 