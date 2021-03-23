const User = require('../../models/User');

const findUserById = (_id, fields = '-password -oauth2') => User.findById(_id, fields).exec();

exports.findUserById = findUserById;