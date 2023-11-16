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

// Example usage:
const vmessUrl="ewogICJ2IjogIjIiLAogICJwcyI6ICJud2VtZSIsCiAgImFkZCI6ICJid2cud3VjaHVoZW5nLmNvbSIsCiAgInBvcnQiOiA2MDAwMiwKICAiaWQiOiAiYjQ0MzcxNGYtMjU4My00ZTUzLWQ4MGItYzM4YTViZmZlMWRhIiwKICAiYWlkIjogMCwKICAibmV0IjogInRjcCIsCiAgInR5cGUiOiAiaHR0cCIsCiAgImhvc3QiOiAiIiwKICAicGF0aCI6ICIvIiwKICAidGxzIjogInRscyIKfQ=="
const decoded = decodeBase64(vmessUrl);
console.log(decoded); // Outputs: Hello World!