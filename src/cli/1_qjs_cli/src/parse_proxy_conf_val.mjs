import parseArgs from "./libs/quckjs_args_parser";
import * as std from "std"

const commandConf = {
    name: "qjs.parse_proxy_conf_val",
    description: "Parse the proxy conf variable",
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
            type: "string",
            required: true
        }
    ]
}
parseArgs(commandConf, scriptArgs.slice(1)).then(result => {
    console.log(result)
}).catch(err => {
    console.log(err)
    std.exit(1)
})