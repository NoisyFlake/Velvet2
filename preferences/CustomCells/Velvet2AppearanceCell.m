#import "../../headers/HeadersPreferences.h"

@implementation Velvet2AppearanceStackView

- (Velvet2AppearanceStackView *)initWithType:(NSString *)type forController:(Velvet2AppearanceCell *)controller withImage:(UIImage *)image andText:(NSString *)text andSpecifier:(PSSpecifier *)specifier {
    self = [super init];
    if (self) {
        self.type = type;
        self.hostController = controller;

        self.key = specifier.properties[@"key"];
        self.postNotification = specifier.properties[@"PostNotification"];
        self.specifier = specifier;

        self.feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [self.feedbackGenerator prepare];

        self.axis = UILayoutConstraintAxisVertical;
        self.alignment = UIStackViewAlignmentCenter;
        self.distribution = UIStackViewDistributionEqualSpacing;
        self.spacing = 8;
        self.translatesAutoresizingMaskIntoConstraints = false;

        self.iconView = [[UIImageView alloc] init];
        self.iconView.clipsToBounds = YES;
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.translatesAutoresizingMaskIntoConstraints = false;
        self.iconView.image = image;
        self.iconView.tintColor = self.checkmarkButton.selected ? kVelvetColor : UIColor.systemGrayColor;

        [self addArrangedSubview:self.iconView];
        [self.iconView.widthAnchor constraintEqualToConstant:60].active = true;

        self.captionLabel = [[UILabel alloc] init];
        self.captionLabel.text = text;
        self.captionLabel.textColor = UIColor.labelColor;
        [self.captionLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [self.captionLabel.heightAnchor constraintEqualToConstant:20].active = true;

        [self addArrangedSubview:self.captionLabel];

        self.checkmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkmarkButton.translatesAutoresizingMaskIntoConstraints = false;
        
        [self.checkmarkButton.heightAnchor constraintEqualToConstant:22].active = true;
        [self.checkmarkButton.widthAnchor constraintEqualToConstant:22].active = true;

        [self.checkmarkButton setImage:[[UIImage kitImageNamed:@"UIRemoveControlMultiNotCheckedImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.checkmarkButton setImage:[[UIImage kitImageNamed:@"UITintedCircularButtonCheckmark.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
        [self.checkmarkButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addArrangedSubview:self.checkmarkButton];

        self.tapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];
        self.tapGestureRecognizer.minimumPressDuration = 0;
        [self setUserInteractionEnabled:true];
        [self addGestureRecognizer:self.tapGestureRecognizer];
    }

    return self;
}

- (void)buttonTapped:(UILongPressGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0.5;
        } completion:^(BOOL finished) {}];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1;
            [self.hostController updateSelected:self.type];
        } completion:^(BOOL finished) {}];

        [self.feedbackGenerator impactOccurred];

        PSViewController *psController = (PSViewController*)[self _viewControllerForAncestor];
        [psController setPreferenceValue:self.type specifier:self.specifier];
    }
}

@end

@implementation Velvet2AppearanceCell

- (Velvet2AppearanceCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self) {
        self.options = specifier.properties[@"options"];

        self.containerStackView = [[UIStackView alloc] init];
        self.containerStackView.axis = UILayoutConstraintAxisHorizontal;
        self.containerStackView.alignment = UIStackViewAlignmentCenter;
        self.containerStackView.distribution = UIStackViewDistributionEqualSpacing;
        self.containerStackView.spacing = 25;
        self.containerStackView.translatesAutoresizingMaskIntoConstraints = false;

        for (NSDictionary *option in self.options) {
            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithFont:[UIFont systemFontOfSize:35]];
            UIImage *image = [UIImage systemImageNamed:option[@"systemIcon"] withConfiguration:config];

            Velvet2AppearanceStackView *stackView = [[Velvet2AppearanceStackView alloc] initWithType:option[@"value"]
                                                                                  forController:self 
                                                                                  withImage:image
                                                                                  andText:option[@"text"]
                                                                                  andSpecifier:specifier];
            [self.containerStackView addArrangedSubview:stackView];
            [stackView.topAnchor constraintEqualToAnchor:self.containerStackView.topAnchor constant:16].active = true;
            [stackView.bottomAnchor constraintEqualToAnchor:self.containerStackView.bottomAnchor constant:-16].active = true;
        }

        [self.contentView addSubview:self.containerStackView];

        [self.containerStackView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = true;
        [self.containerStackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
        [self.containerStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;

        
        self.detailTextLabel.text = nil;
    }

    return self;
}

- (void)updateSelected:(NSString *)value {
    for (Velvet2AppearanceStackView *subview in self.containerStackView.arrangedSubviews) {
        subview.checkmarkButton.selected = [subview.type isEqual:value];
        subview.checkmarkButton.tintColor = subview.checkmarkButton.selected ? kVelvetColor : UIColor.systemGrayColor;
        subview.iconView.tintColor = subview.checkmarkButton.selected ? kVelvetColor : UIColor.systemGrayColor;
    }
}

-(void)didMoveToSuperview {
    [super didMoveToSuperview];

    // Hide value label
    self.detailTextLabel.text = nil;

    PSViewController *psController = (PSViewController*)[self _viewControllerForAncestor];
    NSString *value = [psController readPreferenceValue:self.specifier];

    [self updateSelected:value];
}

@end