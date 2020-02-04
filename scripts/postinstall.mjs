import fs from "fs";
import path from "path";

const moduleDir = path.resolve("./node_modules");
const inputViewPath = path.join(moduleDir, "react-native", "Libraries", "Text", "TextInput", "RCTBackedTextInputViewProtocol.h")
const inputView = fs.readFileSync(inputViewPath).toString();
if (!inputView.includes("@property (nonatomic, strong, nullable) UIView *inputView;")) {
    fs.writeFileSync(inputViewPath,
        inputView.replace(/(UIView \*inputAccessoryView;)/, "$1\n@property (nonatomic, strong, nullable) UIView *inputView;")
    );
}
console.log("react-native: set inputView writable");
//
