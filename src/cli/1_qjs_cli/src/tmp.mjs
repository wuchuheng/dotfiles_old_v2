import yargs from './libs/yargs'
import { hideBin } from './libs/yargs/helpers'

yargs(hideBin(process.argv))
    .command('qjs.base64Decode <base64String>', 'Decode the base64 string', () => {}, (argv) => {
        console.info(argv)
    })
    .demandCommand(1)
    .parse()