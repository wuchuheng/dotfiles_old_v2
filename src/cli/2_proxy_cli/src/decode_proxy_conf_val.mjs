import parseArgs, {
  ErrorType,
} from "../../1_qjs_cli/src/libs/quckjs_args_parser/dist/index.js";
import * as std from "std";
import { readFile } from "../../1_qjs_cli/src/libs/std.mjs";
import { convertVariableNameJson5 } from "../../1_qjs_cli/src/libs/convert_variable_name_json5.mjs";

const commandConf = {
  name: "proxy.decodeProxyConfVal",
  description: "decode the proxy conf variable",
  args: [
    {
      name: "json_file",
      description: "the json file that include variable names",
      type: "string",
      required: true,
    },
  ],
  options: [
    {
      name: "ERROR_LOG_FILE_PATH",
      description: "the error log file path",
      alias: "e",
      type: "string",
      required: true,
    },
    {
      name: "SUCCESSFUL_LOG_FILE_PATH",
      description: "successful log file path",
      alias: "s",
      type: "string",
      required: true,
    },
  ],
};
parseArgs(commandConf, scriptArgs.slice(1))
  .then((result) => {
    const jsonPath = result.regularArgs[0];
    const json5Txt = readFile(jsonPath);
    const jsonText = convertVariableNameJson5(json5Txt, result.options);
    console.log(jsonText);
  })
  .catch((err) => {
    if (ErrorType.PRINT_HELP !== err.message) {
      console.log(err.message);
      std.exit(1);
    }
  });
