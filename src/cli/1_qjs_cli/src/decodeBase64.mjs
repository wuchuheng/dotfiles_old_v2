import {decodeBase64} from "./libs/base64.mjs";

if (scriptArgs.length !== 2) {
    console.log("Please input one argument with qjs!")
    std.exit(1);
}

const base64String = scriptArgs[1];
const encodedStr = decodeBase64(base64String);
console.log(encodedStr);