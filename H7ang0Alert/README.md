# H7ang0Alert

iOS26-style alert component for iOS 14–18, designed for jailbreak tweaks. Includes three modes with password validation and multiple button colors.

## Features

### Alert Modes
- **Confirm**: Standard alert with cancel and confirm buttons
- **Password**: Secure password input with validation and error handling
- **Final**: Single button alert with Apple logo (iOS26-style)

### Button Colors
- 🔵 Blue (`H7ang0ConfirmButtonStyleBlue`)
- 🟢 Green (`H7ang0ConfirmButtonStyleGreen`) 
- 🩷 Pink (`H7ang0ConfirmButtonStylePink`)

### Password Validation
- Set correct password via `correctPassword` parameter
- Visual error feedback with shake animation
- Auto-clear input field on wrong password
- Haptic feedback and red error message

## Build

Requires Theos. For rootless packaging, export `THEOS_PACKAGE_SCHEME=rootless` when building.

```sh
make clean package
# or rootless
THEOS_PACKAGE_SCHEME=rootless make clean package
```

## Install

Install the generated `.deb` then respring.

A demo is available on SpringBoard: long-press on the home screen empty area to cycle through different alert modes.

## Public API

```objc
#import "H7ang0Alert/H7ang0AlertManager.h"

// Standard alert (confirm/final modes)
[H7ang0AlertManager presentFromTopMostWithTitle:@"Title"
                                         message:@"Message content"
                                            mode:H7ang0AlertModeConfirm
                                    confirmStyle:H7ang0ConfirmButtonStyleBlue
                                      completion:^(NSString *input, BOOL success) {
    if (success) {
        NSLog(@"User confirmed");
    } else {
        NSLog(@"User cancelled");
    }
}];

// Password validation alert
[H7ang0AlertManager presentFromTopMostWithTitle:@"Enter Password"
                                         message:@"Please enter your password"
                                            mode:H7ang0AlertModePassword
                                    confirmStyle:H7ang0ConfirmButtonStyleGreen
                                 correctPassword:@"123456"
                                      completion:^(NSString *input, BOOL success) {
    if (success) {
        NSLog(@"Password correct: %@", input);
    } else {
        NSLog(@"Password wrong or cancelled");
    }
}];
```

## Demo Modes

Long-press the home screen to cycle through:
1. Final mode (single "好" button)
2. Confirm mode (cancel + confirm)
3. Password mode (password: "123")
4. Wrong password demo (password: "secret")

## Development

- **Developed by**: Yuayu (山东青岛)
- **Published by**: H7ang0 (韩国京畿道)
- **Design**: iOS26-style with modern blur effects and smooth animations

## License

MIT 