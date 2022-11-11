@interface UIColor (Velvet)
+ (UIColor *)colorFromGradient:(NSArray*)colors withDirection:(NSString *)direction inFrame:(CGRect)frame flipY:(BOOL)flipY;
+ (UIColor *)colorFromGradient:(NSArray *)colors withDirection:(NSString *)direction inFrame:(CGRect)frame;
+ (UIColor *)colorFromP3String:(NSString *)string;
@end