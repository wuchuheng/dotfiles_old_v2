type CommandType = {
  name: string;
  description: string;
  args: {
    name: string;
    type: "string" | "boolean";
    description: string;
  }[];
  options: {
    name: string;
    alias: string;
    type: "string" | "boolean";
    description: string;
  }[];
};

type OutputType = {
  regularArgs: string[];
  options: Record<string, boolean | string>;
};

enum ErrorType {
  PRINT_HELP = "print help",
}
class PrintHelpError extends Error {
  message = ErrorType.PRINT_HELP;
}

function printHelp(command: CommandType) {
  console.log(`${command.name}: ${command.description}`);
  console.log("");
  console.log("Options:");
  command.options.forEach((option) => {
    console.log(`  --${option.name}\t${option.description}`);
  });
}

async function parseArguments(
  command: CommandType,
  args: string[]
): Promise<OutputType> {
  const options: Record<string, boolean | string> = {};
  const regularArgs = [];
  let currentOption = "";

  // if the args include the --help option, print the help message and exit.
  if (args.includes("--help")) {
    printHelp(command);
    throw new PrintHelpError();
  }

  // Mapping of the alias name to the long name in the command options list
  const aliasMap: Record<string, string> = {};
  for (
    let optionIndex = 0;
    optionIndex < command.options.length;
    optionIndex++
  ) {
    const optionName = command.options[optionIndex].name;
    const alias = command.options[optionIndex].alias;
    aliasMap[alias] = optionName;
  }

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];

    if (arg.startsWith("--")) {
      currentOption = arg.substring(2);
      options[currentOption] = true; // Set a default value
    } else if (arg.startsWith("-")) {
      const aliasName = arg.substring(1);
      currentOption = aliasMap[aliasName];
      options[currentOption] = true; // Set a default value
    } else {
      if (currentOption.length !== 0) {
        // Assign the value to the last option
        options[currentOption] = arg;
        currentOption = "";
      } else {
        // Regular argument
        regularArgs.push(arg);
      }
    }
  }

  return { regularArgs, options };
}
// const args = [
//   "command1",
//   "arg1",
//   "arg2",
//   "--option1",
//   "option1 value",
//   "--option2",
//   "option2 value",
//   "-a",
//   "option3 value",
//   "-c",
//   "option4 config file",
//   "--help",
// ];
// const commandConfigs: CommandType = {
//   name: "qjs.base64Decode",
//   description: "qjs.base64Decode <arg1: base64 encode string> [options]",
//   args: [
//     {
//       name: "arg1",
//       type: "string",
//       description: "Argument 1 description",
//     },
//     {
//       name: "arg2",
//       type: "string",
//       description: "Argument 2 description",
//     },
//   ],
//   options: [
//     {
//       type: "string",
//       name: "option1",
//       alias: "o1",
//       description: "option 1",
//     },
//     {
//       type: "string",
//       name: "option2",
//       alias: "o2",
//       description: "option 1",
//     },
//     {
//       type: "string",
//       name: "option3",
//       alias: "a",
//       description: "option 1",
//     },
//     {
//       type: "string",
//       name: "option4",
//       alias: "c",
//       description: "option 1",
//     },
//   ],
// };
// parseArguments(commandConfigs, args)
//   .then(({ options, regularArgs }) => {
//     console.log("Regular Arguments:", regularArgs);
//     console.log("Options:", options);
//   })
//   .catch((err) => {
//     if (err.message !== ErrorType.PRINT_HELP) {
//       console.log(
//         `\n${commandConfigs.name}: try '${commandConfigs.name} --help' for more information`
//       );
//     }
//   });
//
export { parseArguments };
