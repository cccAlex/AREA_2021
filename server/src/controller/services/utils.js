const User = require('../../models/User');
const joi = require('../../plugins/joi');
const { encryptParams } = require('../../utils/cryptParams');

const addServiceSchema = joi.object({
    name: joi.string().required(),
    params: joi.any().required(),
});

const addService = (userID, name, params) => {
    return new Promise((resolve, reject) => {
        const { error } = addServiceSchema.validate({ name, params });
        if (error) return reject(error);

        User.findById(userID, 'services')
            .exec()
            .then(async user => {
                if (!user) return reject(new Error('User not found.'));

                const encrypted = encryptParams(params);
                for (const service of user.services)
                    if (service.name === name) {
                        await User.updateOne({ _id: userID, "services.name": name }, { $set: { "services.$.params" : encrypted } }).exec();
                        return resolve();
                    }
                await User.updateOne({ _id: userID }, { $push: { services: { name, params: encrypted } } }).exec();
                resolve();
            })
            .catch((err) => reject(err));
    });
};

exports.addService = addService;
