import parseArgs, {ErrorType} from "../../1_qjs_cli/src/libs/quckjs_args_parser/dist/index.js";
import * as std from "std"
import {readFile, writeFile} from "../../1_qjs_cli/src/libs/std.mjs";
import {encodeBase64} from "../../1_qjs_cli/src/libs/base64.mjs";

const updateEnv =({configPath, envPath, key}) => {
    // 1 get the boot config content with the config file path
    const configContent = readFile(configPath)
    // 2 convert the config content to a base64 string
    const configBase64Str = encodeBase64(configContent)
    // 3 update the env file with the key and base64 string
    // 3.1 get the env file content
    let envContent = readFile(envPath)
    // 3.2 update the env content with the key and base64 string
    const regexPattern = new RegExp(`${key}=.*`, 'g')
    envContent = envContent.replace(regexPattern, `${key}='${configBase64Str}'`)
    // 4 write the env file content to the env file
    writeFile(envPath, envContent)
    console.log(`update the .env file success`)
}

parseArgs({
    name: "proxy.updateConfigToEnv",
    description: "update the boot config to the env",
    args: [],
    // options${QJS_BIN_PATH} ${ CLI_ROOT_PATH }/src/updateConfigToEnv.js  --config-path ${ APP_BASE_PATH }/boot_config.json5 --env-path ${ APP_BASE_PATH }/.env --update-config-name PROXY_CLI_CONFIG : [
    options: [
        { name: 'config-path', description: 'the proxy cli config path', required: true, alias: 'c', type: 'string' },
        { name: 'env-path', description: 'the env file path', required: true, alias: 'e', type: 'string' },
        { name: 'key', description: 'the key name in the env file will be update', required: true, alias: 'u', type: 'string' },
    ]
}, scriptArgs.slice(1)).then(result => {
    updateEnv({
        configPath: result.options['config-path'],
        envPath: result.options['env-path'],
        key: result.options['key'],
    })
}).catch(err => {
    if (err.message !== ErrorType.PRINT_HELP) {
        console.log(err.message)
        std.exit(1)
    }
})