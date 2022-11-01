#import <UIKit/UIKit.h>

@interface UIViewController (Private)
@property (assign,setter=_setContentOverlayInsets:,nonatomic) UIEdgeInsets _contentOverlayInsets;
@end

@interface UINavigationController (Private)
@property (nonatomic,readonly) UIViewController * previousViewController;
@end