const mongoose = require('mongoose');

const Schema = mongoose.Schema;

const areaSchema = Schema({
    name: { type: String, required: true },
    areaID: { type: mongoose.Types.ObjectId, required: true },
    params: { type: String, required: false },
});

module.exports = mongoose.model('Area', areaSchema);
