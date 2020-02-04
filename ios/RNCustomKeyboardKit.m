
#import <React/RCTRootView.h>
#import "RNCustomKeyboardKit.h"
#import "React/RCTUIManager.h"
#import <React/RCTSinglelineTextInputView.h>

@implementation RNCustomKeyboardKit

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE(CustomKeyboardKit)

RCT_EXPORT_METHOD(install:(nonnull NSNumber *)reactTag withType:(nonnull NSString *)keyboardType)
{
  RCTRootView* inputView = [[RCTRootView alloc] initWithBridge:_bridge moduleName:@"CustomKeyboardKit" initialProperties:
      @{
        @"tag": reactTag,
        @"type": keyboardType
      }
    ];

  inputView.sizeFlexibility= RCTRootViewSizeFlexibilityHeight;
  inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  RCTSinglelineTextInputView *view = (RCTSinglelineTextInputView *)[_bridge.uiManager viewForReactTag:reactTag];

  [view.backedTextInputView setInputView:inputView];

  [view reloadInputViews];
}

RCT_EXPORT_METHOD(uninstall:(nonnull NSNumber *)reactTag)
{
  RCTSinglelineTextInputView *inputView = (RCTSinglelineTextInputView*)[_bridge.uiManager viewForReactTag:reactTag];
  UITextField* view = (UITextField *)inputView.backedTextInputView;

  [view setInputView:nil];
  [view reloadInputViews];
}

RCT_EXPORT_METHOD(replaceText:(nonnull NSNumber *)reactTag withText:(NSString*)text) {
  RCTSinglelineTextInputView *inputView = (RCTSinglelineTextInputView*)[_bridge.uiManager viewForReactTag:reactTag];
  UITextField* view = (UITextField *)inputView.backedTextInputView;
  [view replaceRange:view.selectedTextRange withText:text];
}

RCT_EXPORT_METHOD(insertText:(nonnull NSNumber *)reactTag withText:(NSString*)text) {
  RCTSinglelineTextInputView *inputView = (RCTSinglelineTextInputView*)[_bridge.uiManager viewForReactTag:reactTag];
  UITextField* view = (UITextField *)inputView.backedTextInputView;
  [view replaceRange:view.selectedTextRange withText:text];
}

RCT_EXPORT_METHOD(backSpace:(nonnull NSNumber *)reactTag) {
  RCTSinglelineTextInputView *inputView = (RCTSinglelineTextInputView*)[_bridge.uiManager viewForReactTag:reactTag];
  UITextField* view = (UITextField *)inputView.backedTextInputView;
  UITextRange* range = view.selectedTextRange;
  if ([view comparePosition:range.start toPosition:range.end] == 0) {
    range = [view textRangeFromPosition:[view positionFromPosition:range.start offset:-1] toPosition:range.start];
  }
  [view replaceRange:range withText:@""];
}

RCT_EXPORT_METHOD(doDelete:(nonnull NSNumber *)reactTag) {
  RCTSinglelineTextInputView *inputView = (RCTSinglelineTextInputView*)[_bridge.uiManager viewForReactTag:reactTag];
  UITextField* view = (UITextField *)inputView.backedTextInputView;

  UITextRange* range = view.selectedTextRange;
  if ([view comparePosition:range.start toPosition:range.end] == 0) {
    range = [view textRangeFromPosition:range.start toPosition:[view positionFromPosition: range.start offset: 1]];
  }
  [view replaceRange:range withText:@""];
}

RCT_EXPORT_METHOD(moveLeft:(nonnull NSNumber *)reactTag) {
  RCTSinglelineTextInputView *inputView = (RCTSinglelineTextInputView*)[_bridge.uiManager viewForReactTag:reactTag];
  UITextField* view = (UITextField *)inputView.backedTextInputView;

  UITextRange* range = view.selectedTextRange;
  UITextPosition* position = range.start;

  if ([view comparePosition:range.start toPosition:range.end] == 0) {
      position = [view positionFromPosition:position offset:-1];
  }

  view.selectedTextRange = [view textRangeFromPosition: position toPosition:position];
}

RCT_EXPORT_METHOD(moveRight:(nonnull NSNumber *)reactTag) {
  RCTSinglelineTextInputView *inputView = (RCTSinglelineTextInputView*)[_bridge.uiManager viewForReactTag:reactTag];
  UITextField* view = (UITextField *)inputView.backedTextInputView;

  UITextRange* range = view.selectedTextRange;
  UITextPosition* position = range.end;

  if ([view comparePosition:range.start toPosition:range.end] == 0) {
    position = [view positionFromPosition: position offset: 1];
  }

  view.selectedTextRange = [view textRangeFromPosition: position toPosition:position];
}

RCT_EXPORT_METHOD(switchSystemKeyboard:(nonnull NSNumber*) reactTag) {
  RCTSinglelineTextInputView* view = (RCTSinglelineTextInputView*)[_bridge.uiManager viewForReactTag:reactTag];
  UIView* inputView = view.inputView;
  [view.backedTextInputView setInputAccessoryView:nil];
  [view reloadInputViews];
  [view.backedTextInputView setInputAccessoryView:inputView];
}

RCT_EXPORT_METHOD(hideKeyboard:(nonnull NSNumber*) reactTag) {
  RCTSinglelineTextInputView* view = (RCTSinglelineTextInputView*)[_bridge.uiManager viewForReactTag:reactTag];
  [view.backedTextInputView resignFirstResponder];
}

@end
