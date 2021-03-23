const User = require("../../models/User");
const { decryptArea } = require("./utils");

const getArea = (req, res) => {
    User.findById(res.locals.user._id, 'area')
        .then((user) => {
            if (!user) throw new Error('User not found.');

            const area = [];

            for (const { _id, active, refreshTime, action, reaction } of user.area) {
                area.push({ _id, active, refreshTime, action: decryptArea(action), reaction: decryptArea(reaction) });
            }
            res.send({ status: true, data: area });
        })
        .catch((err) => res.send({ status: false, data: err.message }));
};

module.exports = getArea;