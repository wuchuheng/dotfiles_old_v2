function getChars() {
   return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
}

function decodeBase64(base64String) {
    const chars = getChars();
    let output = "";
    for (let bc = 0, bs, buffer, i = 0;
         buffer = base64String.charAt(i++);
         ~buffer && (bs = bc % 4 ? bs * 64 + buffer : buffer,
         bc++ % 4) ? output += String.fromCharCode(255 & bs >> (-2 * bc & 6)) : 0) {
        buffer = chars.indexOf(buffer);
    }

    return output;
}

function encodeBase64(str) {
    const chars = getChars();
    const charCodes = str.split('').map(c => c.charCodeAt(0));
    const binStr = charCodes.map(c => c.toString(2).padStart(8, '0')).join('');
    const chunks = binStr.match(/.{1,6}/g).map(bin => parseInt(bin, 2));
    const padding = '=='.slice(0, (3 - str.length % 3) % 3);
    const base64Str = chunks.map(c => chars[c]).join('') + padding;

    return base64Str;
}


export {decodeBase64, encodeBase64}