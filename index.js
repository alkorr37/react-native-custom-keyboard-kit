import React, {Component, useEffect, useRef} from 'react';

import {
    NativeModules,
    TextInput,
    findNodeHandle,
    AppRegistry,
    View,
} from 'react-native';

const {CustomKeyboardKit} = NativeModules;

const {
    install, uninstall, kbChange,
    insertText, backSpace, doDelete,
    moveLeft, moveRight,
    switchSystemKeyboard,
    hideKeyboard, replaceText
} = CustomKeyboardKit;

export {
    install, uninstall, kbChange,
    insertText, backSpace, doDelete,
    moveLeft, moveRight,
    switchSystemKeyboard,
    hideKeyboard, replaceText
};

const keyboardTypeRegistry = {};

export function register(type, factory) {
    keyboardTypeRegistry[type] = factory;
}

const CustomKeyboardKitContainer = ({tag, type}) => {
    const factory = keyboardTypeRegistry[type];
    if (!factory) {
        console.warn(`Custom keyboard type ${type} not registered.`);
        return null;
    }
    const Comp = factory();
    return <Comp tag={tag}/>;
};

AppRegistry.registerComponent("CustomKeyboardKit", () => CustomKeyboardKitContainer);

export const CustomTextInput = ({customKeyboardType}) => {
    const ref = useRef(null);

    useEffect(() => {
        install(findNodeHandle(ref.current), customKeyboardType);
    }, [customKeyboardType]);

    return (
        <View>
            <TextInput ref={ref}/>
        </View>
    );
};
