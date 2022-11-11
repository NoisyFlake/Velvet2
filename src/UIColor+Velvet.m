#import "../headers/HeadersTweak.h"

@implementation UIColor (Velvet)
+ (UIColor *)colorFromGradient:(NSArray*)colors withDirection:(NSString *)direction inFrame:(CGRect)frame flipY:(BOOL)flipY {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.colors = colors;

    gradientLayer.startPoint = [direction isEqual:@"cornerTop"] ? CGPointMake(0,1) : CGPointMake(0, 0);
    gradientLayer.endPoint = [direction isEqual:@"cornerBottom"] ? CGPointMake(1,1) : [direction isEqual:@"cornerTop"] ? CGPointMake(1,0) : [direction isEqual:@"bottom"] ? CGPointMake(0,1) : CGPointMake(1,0);
    
    // FlipY is necessary when working directly on a CALayer, since CoreAnimation renders upside-down
    if (flipY) {
        gradientLayer.startPoint = CGPointMake(gradientLayer.startPoint.x, gradientLayer.startPoint.y == 0 ? 1 : 0);
        gradientLayer.endPoint = CGPointMake(gradientLayer.endPoint.x, gradientLayer.endPoint.y == 0 ? 1 : 0);
    }

    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:gradientLayer.frame.size];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [gradientLayer renderInContext:context.CGContext];
    }];

    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)colorFromGradient:(NSArray*)colors withDirection:(NSString *)direction inFrame:(CGRect)frame {
    return [UIColor colorFromGradient:colors withDirection:direction inFrame:frame flipY:NO];
}

+ (UIColor *)colorFromP3String:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@" "];
    if ([components count] != 4) return UIColor.clearColor;

    return [UIColor colorWithDisplayP3Red:[components[0] floatValue] green:[components[1] floatValue] blue:[components[2] floatValue] alpha:[components[3] floatValue]];
}
@end