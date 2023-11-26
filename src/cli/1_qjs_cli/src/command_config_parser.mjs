/**
 *  get the bin path with the cli name
 *  @author wuchuheng<root@wuchuheng.com>
 *  @use qjs command_config_parser.mjs -c "config.json" -m "<cpuHardwareType>" -o "<OS name>" -cli_name <cli name> -p <prefix path for the command json> -output_file <output file>
 *  @print <the bin path>
 *  @date 2023/11/19 03:46
 */
import parseArgs  from "./libs/quckjs_args_parser/dist/index.js";
import * as std from 'std';
import JSON5 from "./libs/json5.mjs";

/**
 *
 *read file with a file name and return the content
 * @param filename
 * @returns string
 */
const readFile = (filename) => {
    let file = std.open(filename, 'r');
    if (file) {
        let contents = file.readAsString();
        file.close();
        return contents;
    } else {
        throw new Error(`Could not open file: ${filename}`);
    }
}

/**
 * get the CommandConfig object
 * @param configJsonPath
 * @return {String}
 */
function getCommandConfig(inputJson5File, inputOSName, inputMachineName, inputCliRootPath) {
    let jsonTxt = readFile(inputJson5File)
    jsonTxt = JSON.stringify(JSON5.parse(jsonTxt))
    // instead of the CLI_ROOT_PATH with inputCliRootPath
    jsonTxt = jsonTxt.replace(/\${ *CLI_ROOT_PATH *}/g, inputCliRootPath);
    // instead of the OS_NAME with inputOSName
    jsonTxt = jsonTxt.replace(/\${ *OS_NAME *}/g, inputOSName);
    // instead of the MACHINE_NAME with inputMachineName
    jsonTxt = jsonTxt.replace(/\${ *MACHINE_NAME *}/g, inputMachineName);

    // Collect the remaining variable names
    const regex = /\${\s*(\w+\.\w+)\s*}/g;
    const matches = jsonTxt.match(regex);
    const  variableNames = matches && matches.map((m) => m.replace(/\${\s*|\s*}/g, ''));
    // Remove the remaining variable names and save them in a set
    const variableNameSet = new Set(variableNames);
    // Remove the variable name that do not exist in the json5 file
    const jsonObj = JSON5.parse(jsonTxt);
    variableNameSet.forEach((name) => {
        let isRemove = false;
        name.split('.').reduce((o, i) => {
            if (o[i] === undefined) {
                isRemove = true;
                return;
            }
            return o[i];
        }, jsonObj);

        isRemove && variableNameSet.delete(name);
    });
    // Replace the variable name with the value in the json5 file
    variableNameSet.forEach((name) => {
        const value = name.split('.').reduce((o, i) => o[i], jsonObj);
        const keyNameInRegex = name.replace('.', '\\.');
        const regexPattern = `\\$\\{\\s*(${keyNameInRegex})\\s*\\}`
        const keyNameRegex = new RegExp(regexPattern, 'g');
        jsonTxt = jsonTxt.replace(keyNameRegex, value);
    });

    const result = JSON.parse(jsonTxt);
    return result
}

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
            name: "OS_name",
            alias: "OS",
            required: true,
            description: "The system OS name, like: Darwin, Linux, etc",
        },
        {
            type: "string",
            name: "machine_name",
            alias: "m",
            required: true,
            description: "The cpu hardware machine name, like: x86_64, arm64, etc",
        },
        {
            type: "string",
            name: "cli_root_path",
            alias: "c",
            required: true,
            description: "The cli root path",
        },
    ],
};
const args = scriptArgs.slice(1)
parseArgs(commandConfigs, args).then(result => {
    const options = result.options
    const jsonObj = getCommandConfig(result.regularArgs[0], options.OS_name, options.machine_name, options.cli_root_path)
    console.log(JSON.stringify(jsonObj))
    std.exit(0); // Replace 1 with your desired error code
}).catch((err) => {
    console.log(err)
    std.exit(1); // Replace 1 with your desired error code
})