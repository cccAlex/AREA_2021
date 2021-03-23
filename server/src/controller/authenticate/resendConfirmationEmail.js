const joi = require('../../plugins/joi');
const User = require('../../models/User');
const sendConfirmationEmail = require('../../utils/sendConfirmationEmail');

const resendConfirmationEmailSchema = joi.object({
    _id: joi.objectId().required(),
});

const resendConfirmationEmail = (req, res) => {
    const { error } = resendConfirmationEmailSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const { _id } = req.body;
    User.findById(_id, '-password -oauth2')
        .then(async (user) => {
            if (user.confirmed) throw new Error('User\'s registration already confirmed.');

            await sendConfirmationEmail(user);
            res.send({ status: true, data: user._doc });
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = resendConfirmationEmail;
