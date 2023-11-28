/**
 *  The Json query tool.
 *  @author wuchuheng<root@wuchuheng.com>
 *  @use qjs boot_config_parser.mjs -c "config.json" -m "<cpuHardwareType>" -o "<OS name>" -cli_name <cli name> -p <prefix path for the command json> -output_file <output file>
 *  @print <the bin path>
 *  @date 2023/11/26 21:27
 */
import parseArgs from "./libs/quckjs_args_parser/dist/index.js";
import * as std from 'std';
import JSON5 from "./libs/json5.mjs";

const commandConfigs = {
    name: "qjs.json_query",
    description: "Json query tool",
    args: [
        {
            name: "jsonString",
            type: "string",
            description: "the json string",
        }
    ],
    options: [
        {
            type: "string",
            name: "query",
            alias: "q",
            required: true,
            description: "the query chart, like: obj.keyName",
        },
        {
            type: "string",
            name: "lengthCount",
            alias: "l",
            required: false,
            description: "get the length by query language",
        },
        {
            type: "string",
            name: "keyList",
            alias: "k",
            required: false,
            description: "get the list of key with query",
        },
    ],
};
const args = scriptArgs.slice(1)
parseArgs(commandConfigs, args).then(result => {
    const jsonTxt = result.regularArgs[0]
    const jsonObj = JSON5.parse(jsonTxt)
    // the key name path like: key1.subKey2.key3
    const keyNamePath = result.options.query
    let resultValue = keyNamePath.split(".").reduce((obj, keyName) => {
        if (obj[keyName] === undefined) {
            throw Error(`the key name ${keyNamePath} is not exist in the json string`)
        }
        return obj[keyName]
    }, jsonObj)

    // if the length option is set, then get the length of the result value
    if (result.options.lengthCount !== undefined) {
        const l = Object.keys(resultValue).length
        console.log(l)
    } else if (result.options.keyList !== undefined) {
        // else if the keys option is set, then get the list of keys of the result value
        const keysString = Object.keys(resultValue).join(" ")
        console.log(keysString)
    } else {
        // else get the result value
        // if the result value is a string, then print it directly
        if (typeof resultValue === "string") {
            console.log(resultValue)
        } else {
            console.log(JSON5.stringify(resultValue))
        }
    }
    std.exit(0); // Replace 1 with your desired error code
}).catch((err) => {
    console.log(err)
    std.exit(1); // Replace 1 with your desired error code
})