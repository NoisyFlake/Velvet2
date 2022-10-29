#import "../../headers/HeadersPreferences.h"

@implementation Velvet2Slider
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self) {
        if (specifier.properties[@"label"]) {
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 0, 0)];
            self.nameLabel.text = specifier.properties[@"label"];
            [self.nameLabel sizeToFit];
            [self.contentView insertSubview:self.nameLabel atIndex:0];
        }
        
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.nameLabel) {
        [self.control setFrame:CGRectMake(self.control.frame.origin.x + self.nameLabel.frame.size.width + 10, self.control.frame.origin.y, self.control.frame.size.width - self.nameLabel.frame.size.width - 10, self.control.frame.size.height)];
    }

    if (![self.specifier.properties[@"showValue"] boolValue]) return;

    [self.control setFrame:CGRectMake(self.control.frame.origin.x, self.control.frame.origin.y, self.control.frame.size.width - 7, self.control.frame.size.height)];

    UISlider *slider = (UISlider *)self.control;
    UIView *visualElement = slider.subviews[0];
    for (UIView *subview in visualElement.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UILabel")]) {
            UILabel *label = (UILabel *)subview;
            label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width + 15, label.frame.size.height);
        }
    }


}
@end