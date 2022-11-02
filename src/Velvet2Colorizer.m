#import "../headers/HeadersTweak.h"

@implementation Velvet2Colorizer

- (instancetype)initWithIdentifier:(NSString *)identifier {
    Velvet2Colorizer *colorizer = [super init];

    self.identifier = identifier;
    self.manager = [Velvet2PrefsManager sharedInstance];

    return colorizer;
}

- (UIColor*)iconColor {
    if (!_iconColor) {
        NSArray *iconColors = [[CCColorCube new] extractColorsFromImage:self.appIcon flags:CCAvoidWhite|CCOnlyBrightColors count:1];
        _iconColor = iconColors.count ? iconColors[0] : UIColor.clearColor;
    }

    return _iconColor;
}

- (void)colorBackground:(UIView *)backgroundView {
    UIColor *backgroundColor;

    BOOL backgroundEnabled = [[self.manager settingForKey:@"backgroundEnabled" withIdentifier:self.identifier] boolValue];

    if (backgroundEnabled) {
        NSString *backgroundType = [self.manager settingForKey:@"backgroundType" withIdentifier:self.identifier];
        
        if ([backgroundType isEqual:@"color"]) {
            backgroundColor = [self.manager colorForKey:@"backgroundColor" withIdentifier:self.identifier];
        } else if ([backgroundType isEqual:@"gradient"]) {
            NSArray *gradientColors = @[(id)[self.manager colorForKey:@"backgroundGradient1" withIdentifier:self.identifier].CGColor, (id)[self.manager colorForKey:@"backgroundGradient2" withIdentifier:self.identifier].CGColor];
            backgroundColor = [UIColor colorFromGradient:gradientColors withDirection:[self.manager settingForKey:@"backgroundGradientDirection" withIdentifier:self.identifier] inFrame:backgroundView.frame];
        } else if ([backgroundType isEqual:@"icon"]) {
            backgroundColor = [self.iconColor colorWithAlphaComponent:[self.manager alphaValueForKey:@"backgroundIconAlpha" withIdentifier:self.identifier]];
        }
    }

    backgroundView.backgroundColor = backgroundColor;
}

- (void)colorBorder:(UIView *)borderView {
    UIColor *borderColor;

    BOOL borderEnabled = [[self.manager settingForKey:@"borderEnabled" withIdentifier:self.identifier] boolValue];

    if (borderEnabled) {
        NSString *borderType = [self.manager settingForKey:@"borderType" withIdentifier:self.identifier];

        if ([borderType isEqual:@"color"]) {
            borderColor = [self.manager colorForKey:@"borderColor" withIdentifier:self.identifier];
        } else if ([borderType isEqual:@"gradient"]) {
            NSArray *gradientColors = @[(id)[self.manager colorForKey:@"borderGradient1" withIdentifier:self.identifier].CGColor, (id)[self.manager colorForKey:@"borderGradient2" withIdentifier:self.identifier].CGColor];
            borderColor = [UIColor colorFromGradient:gradientColors withDirection:[self.manager settingForKey:@"borderGradientDirection" withIdentifier:self.identifier] inFrame:borderView.frame];
        } else if ([borderType isEqual:@"icon"]) {
            borderColor = [self.iconColor colorWithAlphaComponent:[self.manager alphaValueForKey:@"borderIconAlpha" withIdentifier:self.identifier]];
        }
    }

    borderView.layer.borderWidth = borderColor ? [[self.manager settingForKey:@"borderWidth" withIdentifier:self.identifier] floatValue] : 0;
    borderView.layer.borderColor = borderColor ? borderColor.CGColor : nil;
}

- (void)colorShadow:(UIView *)shadowView {
    UIColor *shadowColor;

    BOOL shadowEnabled = [[self.manager settingForKey:@"shadowEnabled" withIdentifier:self.identifier] boolValue];

    if (shadowEnabled) {
        NSString *shadowType = [self.manager settingForKey:@"shadowType" withIdentifier:self.identifier];

        if ([shadowType isEqual:@"color"]) {
            shadowColor = [self.manager colorForKey:@"shadowColor" withIdentifier:self.identifier];
        } else if ([shadowType isEqual:@"icon"]) {
            shadowColor = [self.iconColor colorWithAlphaComponent:[self.manager alphaValueForKey:@"shadowIconAlpha" withIdentifier:self.identifier]];
        }
    }

    shadowView.layer.shadowRadius = shadowColor ? [[self.manager settingForKey:@"shadowWidth" withIdentifier:self.identifier] floatValue] : 0;
    shadowView.layer.shadowOffset = CGSizeZero;
    shadowView.layer.shadowColor = shadowColor ? shadowColor.CGColor : nil;
    shadowView.layer.shadowOpacity = 1;
}

@end