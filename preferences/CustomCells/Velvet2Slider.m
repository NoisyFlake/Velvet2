#import "../../headers/HeadersPreferences.h"

@implementation Velvet2Slider
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self) {
        [((PSSegmentableSlider *)[self control]) setMinimumTrackTintColor:kVelvetColor];

        if (specifier.properties[@"label"]) {
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(specifier.properties[@"systemIcon"] ? 60 : 15, 11, 0, 0)];
            self.nameLabel.text = specifier.properties[@"label"];
            [self.nameLabel sizeToFit];
            [self.contentView insertSubview:self.nameLabel atIndex:0];
        }

        if (specifier.properties[@"systemIcon"]) {
            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithFont:[UIFont systemFontOfSize:25]];
            UIImage *image = [UIImage systemImageNamed:specifier.properties[@"systemIcon"] withConfiguration:config];
            [specifier setProperty:image forKey:@"iconImage"];

            self.imageView.tintColor = kVelvetColor;
        }

        // iOS 16 fix
        for (NSLayoutConstraint *c in self.control.constraints) {
            [self.control removeConstraint:c];
        }

        [self.control layoutIfNeeded];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    PSListController *controller = [self _viewControllerForAncestor];
    if ([controller isKindOfClass:NSClassFromString(@"Velvet2PreviewController")]) {
        Velvet2PreviewController *previewController = (Velvet2PreviewController *)controller;

        if (previewController.identifier && [previewController appSettingForKeyExists:self.specifier.properties[@"key"]]) {
            self.backgroundColor = [kVelvetColor colorWithAlphaComponent:0.3];
        }
    }

    // Before iOS 16, we could simply set the frame of the control. However, iOS 16 introduces constraints that don't seem to be easily fixable, so instead we
    // modify the subview (visualElement), since it isn't affected by these constraints

    UISlider *slider = (UISlider *)self.control;
    UIView *visualElement = slider.subviews[0];
    
    if (self.nameLabel) {
        self.nameLabel.frame = CGRectMake(self.specifier.properties[@"systemIcon"] ? 60 : 15, self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
        [visualElement setFrame:CGRectMake(0 + self.nameLabel.frame.size.width + (self.specifier.properties[@"systemIcon"] ? 60 : 10), visualElement.frame.origin.y, slider.frame.size.width - self.nameLabel.frame.size.width - (self.specifier.properties[@"systemIcon"] ? 60 : 10), visualElement.frame.size.height)];
    }

    if (![self.specifier.properties[@"showValue"] boolValue]) return;

    [visualElement setFrame:CGRectMake(visualElement.frame.origin.x, visualElement.frame.origin.y, visualElement.frame.size.width - 7, visualElement.frame.size.height)];
    
    for (UIView *subview in visualElement.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UILabel")]) {
            UILabel *label = (UILabel *)subview;
            label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width + 15, label.frame.size.height);
        }
    }

}
@end