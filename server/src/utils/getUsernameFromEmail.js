const User = require('../models/User');

const getUsernameFromEmail = async (email, suffix = 0) => {
    const username = suffix > 0 ? `${email.split('@')[0]}${suffix}` : email.split('@')[0];
    const userExists = await User.exists({ username });

    return userExists ? (await getUsernameFromEmail(email, suffix + 1)) : username;
};

module.exports = getUsernameFromEmail;