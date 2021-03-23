const jwt = require('jsonwebtoken');

const secretKey = process.env.JWT_SECRET_KEY || 'my_ultimate_secret_key';

const extractBearerToken = authorization => {
    if (typeof authorization !== 'string') return null;

    const matches = authorization.match(/(bearer)\s+(\S+)/i);

    return matches && matches.length > 2 ? matches[2] : null;
};

const checkToken = (req, res, next) => {
    const token = extractBearerToken(req.headers.authorization);

    if (!token) return res.send({status: false, data: 'Invalid token'});

    jwt.verify(token, secretKey, (err, decodedToken) => {
        if (err) return res.send({status: false, data: 'Invalid token'});

        res.locals.user = decodedToken;
        res.locals.token = token;
        next();
    });
};

module.exports = checkToken;