/*******************************************************************************
Xiamen Yaji Software Co., Ltd., (the “Licensor”) grants the user (the “Licensee”
) non-exclusive and non-transferable rights to use the software according to
the following conditions:
a.  The Licensee shall pay royalties to the Licensor, and the amount of those
    royalties and the payment method are subject to separate negotiations
    between the parties.
b.  The software is licensed for use rather than sold, and the Licensor reserves
    all rights over the software that are not expressly granted (whether by
    implication, reservation or prohibition).
c.  The open source codes contained in the software are subject to the MIT Open
    Source Licensing Agreement (see the attached for the details);
d.  The Licensee acknowledges and consents to the possibility that errors may
    occur during the operation of the software for one or more technical
    reasons, and the Licensee shall take precautions and prepare remedies for
    such events. In such circumstance, the Licensor shall provide software
    patches or updates according to the agreement between the two parties. the
    Licensor will not assume any liability beyond the explicit wording of this
    Licensing Agreement.
e.  Where the Licensor must assume liability for the software according to
    relevant laws, the Licensor’s entire liability is limited to the annual
    royalty payable by the Licensee.
f.  The Licensor owns the portions listed in the root directory and subdirectory
    (if any) in the software and enjoys the intellectual property rights over
    those portions. As for the portions owned by the Licensor, the Licensee
    shall not:
    i.  Bypass or avoid any relevant technical protection measures in the
        products or services;
    ii. Release the source codes to any other parties;
    iii.Disassemble, decompile, decipher, attack, emulate, exploit or
        reverse-engineer these portion of code;
    iv. Apply it to any third-party products or services without Licensor’s
        permission;
    v.  Publish, copy, rent, lease, sell, export, import, distribute or lend any
        products containing these portions of code;
    vi. Allow others to use any services relevant to the technology of these
        codes; and
    vii.Conduct any other act beyond the scope of this Licensing Agreement.
g.  This Licensing Agreement terminates immediately if the Licensee breaches
    this Agreement. The Licensor may claim compensation from the Licensee where
    the Licensee’s breach causes any damage to the Licensor.
h.  The laws of the People's Republic of China apply to this Licensing Agreement.
i.  This Agreement is made in both Chinese and English, and the Chinese version
    shall prevail the event of conflict.

*******************************************************************************/


#import "ToastView.h"
#import <UIKit/UIKit.h>

#define TOAST_TAG 1024

@implementation ToastView

+ (void)showToast:(NSString *)message withDuration:(NSUInteger)duration {
    [self dismissToast];
    
    UILabel *toast = [[UILabel alloc] init];
    toast.text = message;
    toast.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
    toast.textColor = [UIColor whiteColor];
    toast.numberOfLines = 0;
    toast.textAlignment = NSTextAlignmentCenter;
    toast.lineBreakMode = NSLineBreakByWordWrapping;
    toast.tag = TOAST_TAG;
    toast.layer.cornerRadius = 6.0;
    toast.layer.masksToBounds = YES;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGSize sizeToFit = [toast sizeThatFits:CGSizeMake(screenWidth, screenHeight)];
    CGFloat verticalMargin = 4;
    CGFloat horizontalMargin = 8;
    CGFloat toastWidth = horizontalMargin * 2 + sizeToFit.width;
    CGFloat toastHeight = verticalMargin * 2 + sizeToFit.height;
    
    toast.frame = CGRectMake((screenWidth - toastWidth) / 2.0, (screenHeight - toastHeight) / 2.0, toastWidth, toastHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:toast];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self dismissToast];
    });
}

+ (void)dismissToast {
    UIView *topView = [UIApplication sharedApplication].keyWindow.subviews.lastObject;
    if (topView.tag == TOAST_TAG) {
        [topView removeFromSuperview];
    }
}

@end
