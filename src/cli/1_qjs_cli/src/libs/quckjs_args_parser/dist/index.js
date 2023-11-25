"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseArguments = void 0;
var ErrorType;
(function (ErrorType) {
    ErrorType["PRINT_HELP"] = "print help";
})(ErrorType || (ErrorType = {}));
class PrintHelpError extends Error {
    constructor() {
        super(...arguments);
        this.message = ErrorType.PRINT_HELP;
    }
}
function printHelp(command) {
    console.log(`${command.name}: ${command.description}`);
    console.log("");
    console.log("Options:");
    command.options.forEach((option) => {
        console.log(`  --${option.name}\t${option.description}`);
    });
}
function parseArguments(command, args) {
    return __awaiter(this, void 0, void 0, function* () {
        const options = {};
        const regularArgs = [];
        let currentOption = "";
        // if the args include the --help option, print the help message and exit.
        if (args.includes("--help")) {
            printHelp(command);
            throw new PrintHelpError();
        }
        // Mapping of the alias name to the long name in the command options list
        const aliasMap = {};
        for (let optionIndex = 0; optionIndex < command.options.length; optionIndex++) {
            const optionName = command.options[optionIndex].name;
            const alias = command.options[optionIndex].alias;
            aliasMap[alias] = optionName;
        }
        for (let i = 0; i < args.length; i++) {
            const arg = args[i];
            if (arg.startsWith("--")) {
                currentOption = arg.substring(2);
                options[currentOption] = true; // Set a default value
            }
            else if (arg.startsWith("-")) {
                const aliasName = arg.substring(1);
                currentOption = aliasMap[aliasName];
                options[currentOption] = true; // Set a default value
            }
            else {
                if (currentOption.length !== 0) {
                    // Assign the value to the last option
                    options[currentOption] = arg;
                    currentOption = "";
                }
                else {
                    // Regular argument
                    regularArgs.push(arg);
                }
            }
        }
        return { regularArgs, options };
    });
}
exports.parseArguments = parseArguments;
