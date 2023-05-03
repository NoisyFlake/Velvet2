#import <UIKit/UIKit.h>
#import "Velvet2PrefsManager.h"

@interface Velvet2Colorizer : NSObject

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) Velvet2PrefsManager *manager;
@property (nonatomic, retain) UIImage *appIcon;
@property (nonatomic, retain) UIColor *iconColor;

- (instancetype)initWithIdentifier:(NSString *)identifier;
- (void)colorBackground:(UIView *)backgroundView;
- (void)setBackgroundBlur:(UIView *)materialView;
- (void)colorBorder:(UIView *)borderView;
- (void)colorShadow:(UIView *)shadowView;
- (void)colorLine:(UIView *)lineView inFrame:(CGRect)frame;
- (void)colorTitle:(UILabel*)title;
- (void)colorMessage:(UILabel*)message;
- (void)colorDate:(UILabel*)date;
- (void)setAppIconCornerRadius:(UIView*)appIcon;
- (void)setAppearance:(UIView*)view;
- (void)toggleAppIconVisibility:(UIView*)appIcon withTitle:(UILabel*)title message:(UILabel*)message footer:(UILabel*)footer alwaysUpdate:(BOOL)alwaysUpdate;

@end