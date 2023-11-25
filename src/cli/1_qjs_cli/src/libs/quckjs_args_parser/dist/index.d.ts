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
declare function parseArguments(command: CommandType, args: string[]): Promise<OutputType>;
export { parseArguments };
