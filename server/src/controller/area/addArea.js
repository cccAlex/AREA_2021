const mongoose = require('mongoose');

const User = require('../../models/User');
const joi = require('../../plugins/joi');
const { pushArea, createTask, encryptArea } = require('./utils');

const areaSchema = joi.object({
    name: joi.string().required(),
    params: joi.any(),
    serviceName: joi.string().required(),
    serviceParams: joi.any().required(),
});

const addAreaSchema = joi.object({
    refreshTime: joi.string().required(),
    action: areaSchema.required(),
    reaction: areaSchema.required(),
});

const addArea = (req, res) => {
    const { error } = addAreaSchema.validate(req.body);
    if (error) return res.send({ status: false, data: error.message });

    const _id = new mongoose.Types.ObjectId();
    const { refreshTime, action, reaction } = req.body;
    const area = {
        _id,
        active: true,
        refreshTime,
        action: encryptArea(action),
        reaction: encryptArea(reaction),
    };

    User.updateOne({ _id: res.locals.user._id }, { $push: { area } })
        .exec()
        .then((result) => {
            if (!result.n) throw new Error('User not found.');

            const task = createTask(_id, refreshTime, action, reaction);

            pushArea(area, task);
            task.start();
            res.send({ status: true, data: 'Ok' });
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = addArea;