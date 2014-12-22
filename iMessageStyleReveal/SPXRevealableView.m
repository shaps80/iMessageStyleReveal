/*
   Copyright (c) 2014 Snippex. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY Snippex `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Snippex OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SPXRevealableView.h"

@interface SPXRevealableView ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation SPXRevealableView

- (instancetype)init
{
  self = [super init];
  if (!self) return nil;
  [self configureTextField];
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (!self) return nil;
  [self configureTextField];
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (!self) return nil;
  [self configureTextField];
  return self;
}

- (void)setCustom:(BOOL)custom
{
  _custom = custom;
  [self configureTextField];
}

- (void)setFont:(UIFont *)font
{
  _font = font;
  [self configureTextField];
}

- (void)setText:(NSString *)text
{
  _text = text;
  [self configureTextField];
}

- (void)setTintColor:(UIColor *)tintColor
{
  [super setTintColor:tintColor];
  [self configureTextField];
}

- (void)setRightAlign:(BOOL)rightAlign
{
  _rightAlign = rightAlign;
  [self configureTextField];
}

- (void)setTextPadding:(NSUInteger)textPadding
{
  _textPadding = textPadding;
  [self configureTextField];
}

- (void)configureTextField
{
  if (self.custom) {
    [self.textLabel removeFromSuperview];
    self.textLabel = nil;
    return;
  }
  
  if (!self.textLabel) {
    self.textLabel = [UILabel new];
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.textLabel];
  }
  
  self.textLabel.text = self.text;
  self.textLabel.font = self.font;
  self.textLabel.textColor = self.tintColor;
  self.textLabel.textAlignment = self.rightAlign ? NSTextAlignmentRight : NSTextAlignmentLeft;
  [self layoutTextLabel];
}

- (void)layoutTextLabel
{
  CGRect rect = self.bounds;
  
  if (self.rightAlign) {
    rect.origin.x -= self.textPadding;
  } else {
    rect.origin.x += self.textPadding;
  }
  
  self.textLabel.frame = rect;
}

@end
