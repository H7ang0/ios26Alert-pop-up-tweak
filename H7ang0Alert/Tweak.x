#import <UIKit/UIKit.h>
#import "H7ang0Alert/H7ang0AlertManager.h"

static int demoIndex = 0;

%hook SBHomeScreenViewController

- (void)viewDidAppear:(BOOL)animated {
	%orig;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ios26_showDemo:)];
		lp.minimumPressDuration = 0.7;
		[((UIViewController *)self).view addGestureRecognizer:lp];
	});
}

%new
- (void)ios26_showDemo:(UILongPressGestureRecognizer *)gr {
	if (gr && gr.state != UIGestureRecognizerStateBegan) return;
	
	H7ang0ConfirmButtonStyle style = (H7ang0ConfirmButtonStyle)(demoIndex % 3);
	H7ang0AlertMode mode;
	NSString *title;
	NSString *message;
	NSString *correctPassword = nil;
	
	// 循环演示不同模式
	switch (demoIndex % 4) {
		case 0:
			mode = H7ang0AlertModeFinal;
			title = @"Test Alert (Final)";
			message = @"This is a final mode alert with single button.";
			break;
		case 1:
			mode = H7ang0AlertModeConfirm;
			title = @"Test Alert (Confirm)";
			message = @"This is a confirm mode alert with cancel and confirm buttons.";
			break;
		case 2:
			mode = H7ang0AlertModePassword;
			title = @"Test Alert (Password)";
			message = @"Please enter password '123' to continue.";
			correctPassword = @"123";
			break;
		case 3:
			mode = H7ang0AlertModePassword;
			title = @"Test Alert (Wrong Password)";
			message = @"Try entering wrong password to see error handling.";
			correctPassword = @"secret";
			break;
	}
	
	demoIndex++;
	
	[H7ang0AlertManager presentFromTopMostWithTitle:title
												 message:message
												 mode:mode
												 confirmStyle:style
										 correctPassword:correctPassword
												 completion:^(NSString *input, BOOL success) {
		if (mode == H7ang0AlertModePassword) {
			if (success) {
				NSLog(@"H7ang0Alert: Password correct: %@", input);
			} else {
				NSLog(@"H7ang0Alert: Password failed or cancelled");
			}
		} else {
			NSLog(@"H7ang0Alert: Alert dismissed with success: %d", success);
		}
	}];
}

%end

%ctor {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		// 自动弹一次，验证是否工作
		[H7ang0AlertManager presentFromTopMostWithTitle:@"Test Alert (Auto)"
													 message:@"This alert appeared automatically 3 seconds after SpringBoard loaded."
													 mode:H7ang0AlertModeFinal
													 confirmStyle:H7ang0ConfirmButtonStyleBlue
													 completion:^(NSString *input, BOOL success) {
			NSLog(@"H7ang0Alert: Auto alert dismissed");
		}];
	});
} 