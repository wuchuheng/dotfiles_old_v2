import * as std from "std"
import parseArgs from "./libs/quckjs_args_parser/dist/index.js";
import {readFile} from "./libs/std.mjs";
import {encodeBase64} from "./libs/base64.mjs";

const commandConf = {
    name: "qjs.encodeBase64",
    description: "Encode the file to base64",
    args: [
        {
            name: "file",
            description: "The file path to encode",
            type: "string",
        }
    ],
    options: [
        {
            name: "output",
            alias: "o",
            description: "The output file path",
            required: false,
            type: "string",
        }
    ]
}


parseArgs(commandConf, scriptArgs.slice(1)).then(result => {
    // read file
    const filePath = result.regularArgs[0]
    const fileContent = readFile(filePath)
    if (fileContent.length === 0) throw new Error("The file is empty")
    const encodedContent = encodeBase64(fileContent)
    console.log(encodedContent);
}).catch(err => {
    console.log(err)
    std.exit(1)
})