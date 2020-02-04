import React, { Component, useEffect, useRef } from 'react';

import {
  NativeModules,
  TextInput,
  findNodeHandle,
  AppRegistry,
  View,
} from 'react-native';

const { CustomKeyboardKit} = NativeModules;

const {
  install, uninstall,
  insertText, backSpace, doDelete,
  moveLeft, moveRight,
  switchSystemKeyboard,
  hideKeyboard,
} = CustomKeyboardKit;

export {
  install, uninstall,
  insertText, backSpace, doDelete,
  moveLeft, moveRight,
  switchSystemKeyboard,
  hideKeyboard,
};

const keyboardTypeRegistry = {};

export function register(type, factory) {
  keyboardTypeRegistry[type] = factory;
}

class CustomKeyboardKitContainer extends Component {
  render() {
    const {tag, type} = this.props;
    const factory = keyboardTypeRegistry[type];
    if (!factory) {
      console.warn(`Custom keyboard type ${type} not registered.`);
      return null;
    }
    const Comp = factory();
    return <Comp tag={tag} />;
  }
}

AppRegistry.registerComponent("CustomKeyboardKit", () => CustomKeyboardKitContainer);

export const CustomTextInput = ({customKeyboardType, ...others}) => {
  const ref = useRef(null);

  useEffect(() => {
    install(findNodeHandle(ref.current), customKeyboardType);
  }, [customKeyboardType]);

  return (
      <View>
        <TextInput {...others} ref={ref} />
      </View>
  );
};
