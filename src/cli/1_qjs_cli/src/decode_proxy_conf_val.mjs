import parseArgs, {ErrorType} from "./libs/quckjs_args_parser/dist/index.js";
import * as std from "std"
import {readFile} from "./libs/std.mjs";
import JSON5 from "./libs/json5.mjs";
import {convertVariableNameJson5} from "./libs/convert_variable_name_json5.mjs";

const commandConf = {
    name: "qjs.decodeProxyConfVal",
    description: "decode the proxy conf variable",
    args: [
        {
            name: "json_file",
            description: "the json file that include variable names",
            type: "string",
            required: true
        },
    ],
    options: [
        {
            name: "CLI_ROOT_PATH",
            description: "the cli root path",
            alias: "c",
            type: "string",
            required: true
        }
    ]
}
parseArgs(commandConf, scriptArgs.slice(1)).then(result => {
    const jsonPath = result.regularArgs[0];
    const  json5Txt= readFile(jsonPath)
    const  jsonText = convertVariableNameJson5(json5Txt, result.options)
    console.log(jsonText)
}).catch(err => {
    if (ErrorType.PRINT_HELP !== err.message) {
        console.log(err.message)
        std.exit(1)
    }
})