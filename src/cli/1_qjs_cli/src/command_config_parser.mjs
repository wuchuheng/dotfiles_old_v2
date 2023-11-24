/**
 *  get the bin path with the cli name
 *  @author wuchuheng<root@wuchuheng.com>
 *  @use qjs command_config_parser.mjs -c "config.json" -m "<cpuHardwareType>" -o "<OS name>" -cli_name <cli name> -p <prefix path for the command json> -output_file <output file>
 *  @print <the bin path>
 *  @date 2023/11/19 03:46
 */

import * as std from 'std';

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
 *
 * Parsing command line arguments and storing them in an object
 * @returns {*}
 */
const parseArgs = () => {
    const args = scriptArgs.slice(1).reduce((acc, arg, index, array) => {
        if (arg.startsWith('-')) {
            const key = arg.substring(1); // Remove the '-' from the flag
            const value = array[index + 1] && !array[index + 1].startsWith('-') ? array[index + 1] : true;
            acc[key] = value;
        }

        return acc;
    }, {});
    return args;
}

/**
 * get the CommandConfig object
 * @param configJsonPath
 * @return {String}
 */
function getCommandConfig(inputConfigJsonPath, inputPrefixPath, inputHardwareName, inputOSName) {
    let jsonTxt = readFile(inputConfigJsonPath)
    jsonTxt = jsonTxt.replace(/\${{ *prefix *}}/g, inputPrefixPath);

    // if jsonTxt was included the ${{ default }} and then replace it with the default value
    if (/\$\{\{ *default *\}\}/g.test(jsonTxt)) {
        const defaultCli = (JSON.parse(jsonTxt)).default[inputOSName][inputHardwareName]
        jsonTxt = jsonTxt.replace(/\$\{\{ *default *\}\}/g, defaultCli);
    }

    const jsonObj = JSON.parse(jsonTxt)

    return jsonObj
}

/**
 * write the result to the output file
 * @type {*}
 */
function writeResultToFile(result, outputFilePath) {
    const file = std.open(outputFilePath, 'w');
    if (!file) {
        throw new Error(`Failed to open file: ${filePath}`);
    }
    file.puts(result); // Write text to file
    file.close();    // Close the file
}

const args=parseArgs()
const jsonObj = getCommandConfig(args.c, args.p, args.m, args.o)
if ( jsonObj.commandLines.hasOwnProperty(args.cli_name)) {
    const result = jsonObj.commandLines[args.cli_name]
    writeResultToFile(result, args.output_file)
} else {
    console.log(JSON.stringify(args))
    console.error(`${JSON.stringify(args)} not found in the config file`)
}
