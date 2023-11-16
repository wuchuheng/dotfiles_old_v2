function decodeBase64(base64String) {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    let output = "";

    for (let bc = 0, bs, buffer, i = 0;
         buffer = base64String.charAt(i++);
         ~buffer && (bs = bc % 4 ? bs * 64 + buffer : buffer,
         bc++ % 4) ? output += String.fromCharCode(255 & bs >> (-2 * bc & 6)) : 0) {
        buffer = chars.indexOf(buffer);
    }

    return output;
}

if (scriptArgs.length !== 2) {
    console.log("Please input one argument with qjs!")
    std.exit(1);
}

const base64String = scriptArgs[1];
const encodedStr = decodeBase64(base64String);
console.log(encodedStr);