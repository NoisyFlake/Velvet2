#import <UIKit/UIKit.h>
#import "Headers/UIColor+Velvet.h"

@implementation UIColor (Velvet)
+ (UIColor *)colorFromGradient:(NSArray*)colors withEndpoint:(CGPoint)endPoint inFrame:(CGRect)frame {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = endPoint;
    gradientLayer.colors = colors;

    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:gradientLayer.frame.size];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [gradientLayer renderInContext:context.CGContext];
    }];

    return [UIColor colorWithPatternImage:image];
}
@end