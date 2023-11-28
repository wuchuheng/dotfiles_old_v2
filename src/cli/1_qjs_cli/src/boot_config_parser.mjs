/**
 *  get the bin path with the cli name
 *  @author wuchuheng<root@wuchuheng.com>
 *  @use qjs boot_config_parser.mjs -c "config.json" -m "<cpuHardwareType>" -o "<OS name>" -cli_name <cli name> -p <prefix path for the command json> -output_file <output file>
 *  @print <the bin path>
 *  @date 2023/11/19 03:46
 */
import parseArgs from "./libs/quckjs_args_parser/dist/index.js";
import * as std from 'std';
import {readFile} from "./libs/std.mjs";
import {convertVariableNameJson5} from "./libs/convert_variable_name_json5.mjs";

const commandConfigs = {
    name: "qjs.convert_json5_config",
    description: "Convert the variable name in the json5 file with the input variables",
    args: [
        {
            name: "json5File",
            type: "string",
            description: "The config json5 file name",
        }
    ],
    options: [
        {
            type: "string",
            name: "OS_NAME",
            alias: "OS",
            required: true,
            description: "The system OS name, like: Darwin, Linux, etc",
        },
        {
            type: "string",
            name: "MACHINE_NAME",
            alias: "m",
            required: true,
            description: "The cpu hardware machine name, like: x86_64, arm64, etc",
        },
        {
            type: "string",
            name: "CLI_ROOT_PATH",
            alias: "c",
            required: true,
            description: "The cli root path",
        },
        {
            type: "string",
            name: "APP_BASE_PATH",
            alias: "a",
            required: true,
            description: "The app base path",
        },
        {
            type: "string",
            name: "QJS_BIN_PATH",
            alias: "q",
            required: true,
            description: "the qjs bin path",
        }
    ],
};
const args = scriptArgs.slice(1)
parseArgs(commandConfigs, args).then(result => {
    const jsonPath = result.regularArgs[0];
    const  json5txt= readFile(jsonPath)
    const  jsonText = convertVariableNameJson5(json5txt, result.options)
    console.log(jsonText)
    std.exit(0); // Replace 1 with your desired error code
}).catch((err) => {
    console.log(err)
    std.exit(1); // Replace 1 with your desired error code
})