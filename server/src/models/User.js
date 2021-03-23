const mongoose = require('mongoose');
const uniqueValidator = require('mongoose-unique-validator');

const Schema = mongoose.Schema;

const userSchema = Schema({
    username: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: false, default: '' },
    oauth2: { type: Boolean, required: false, default: false },
    confirmed: { type: Boolean, required: true },
    services: [ {
        name: { type: String, required: true },
        params: { type: String, required: true },
    } ],
    area: [ {
        active: { type: String, required: true },
        refreshTime: { type: String, required: true },
        action: {
            name: { type: String, required: true },
            params: { type: String, required: false },
            serviceName: { type: String, required: true },
            serviceParams: { type: String, required: true },
        },
        reaction: {
            name: { type: String, required: true },
            params: { type: String, required: false },
            serviceName: { type: String, required: true },
            serviceParams: { type: String, required: true },
        }
    } ],
});

userSchema.plugin(uniqueValidator);

module.exports = mongoose.model('User', userSchema);
