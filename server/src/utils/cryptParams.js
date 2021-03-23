const cryptoJS = require('crypto-js');

const servicesSecretKey = process.env.SERVICES_CRYPTO_SECRET_KEY;

const encryptParams = (params) => cryptoJS.AES.encrypt(JSON.stringify(params), servicesSecretKey).toString();
const decryptParams = (encrypted) => JSON.parse(cryptoJS.AES.decrypt(encrypted, servicesSecretKey).toString(cryptoJS.enc.Utf8));

exports.encryptParams = encryptParams;
exports.decryptParams =decryptParams;