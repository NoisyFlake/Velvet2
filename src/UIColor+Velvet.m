#import <UIKit/UIKit.h>
#import "../headers/Velvet2/UIColor+Velvet.h"

@implementation UIColor (Velvet)
+ (UIColor *)colorFromGradient:(NSArray*)colors withDirection:(enum Direction)direction inFrame:(CGRect)frame {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.startPoint = direction == DirectionCorner ? CGPointMake(0,1) : CGPointMake(0, 0); // Corner is flipped because CGContext renders upside-down
    gradientLayer.endPoint = direction == DirectionCorner ? CGPointMake(1,0) : direction == DirectionBottom ? CGPointMake(0,1) : CGPointMake(1,0);
    gradientLayer.colors = colors;

    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:gradientLayer.frame.size];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [gradientLayer renderInContext:context.CGContext];
    }];

    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)colorFromP3String:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@" "];
    return [UIColor colorWithDisplayP3Red:[components[0] floatValue] green:[components[1] floatValue] blue:[components[2] floatValue] alpha:[components[3] floatValue]];
}
@end