@interface Velvet2AppearanceCell : PSTableCell
@property(nonatomic, retain) UIStackView *containerStackView;
@property(nonatomic, retain) NSArray *options;
- (void)updateSelected:(NSString *)type;
@end

@interface Velvet2AppearanceStackView : UIStackView
@property(nonatomic, retain) Velvet2AppearanceCell *hostController;
@property(nonatomic, retain) PSSpecifier *specifier;

@property(nonatomic, retain) UIImageView *iconView;
@property(nonatomic, retain) UILabel *captionLabel;
@property(nonatomic, retain) UIButton *checkmarkButton;

@property(nonatomic, retain) UIImpactFeedbackGenerator *feedbackGenerator;
@property(nonatomic, retain) UILongPressGestureRecognizer *tapGestureRecognizer;

@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *defaultsIdentifier;
@property(nonatomic, retain) NSString *postNotification;
@property(nonatomic, retain) NSString *key;
@property(nonatomic, retain) NSUserDefaults *defaults;

- (Velvet2AppearanceStackView *)initWithType:(NSString *)type forController:(Velvet2AppearanceCell *)controller withImage:(UIImage *)image andText:(NSString *)text andSpecifier:(PSSpecifier *)specifier;
- (void)buttonTapped:(UILongPressGestureRecognizer *)sender;
@end