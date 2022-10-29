enum Direction {DirectionRight, DirectionBottom, DirectionCorner};

@interface UIColor (Velvet)
+ (UIColor *)colorFromGradient:(NSArray*)colors withDirection:(enum Direction)direction inFrame:(CGRect)frame;
@end