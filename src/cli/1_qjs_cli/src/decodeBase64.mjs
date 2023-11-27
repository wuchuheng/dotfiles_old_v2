import {decodeBase64} from "./libs/base64.mjs";
import * as std from 'std';
import parseArgs, {ErrorType} from "./libs/quckjs_args_parser/dist/index.js";

parseArgs({
    name: "qjs.decodeBase64",
    description: "Decode the base64 string",
    args: [
        {
            name: "base64String",
            type: String,
            description: "The base64 string to decode",
            required: true
        }
    ],
    options: []
}, scriptArgs.slice(1)).then(result => {
    const [encodedString] = result.regularArgs
    const decodedString= decodeBase64(encodedString)
    console.log(decodedString)
}).catch(err => {
    if (err.message !== ErrorType.PRINT_HELP) {
        console.log(err)
        std.exit(1);
    }
})