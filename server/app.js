require('dotenv').config();
const express = require('express');
const cors = require('cors');

const router = require('./src/router');
const initDb = require('./src/db');
const about = require('./src/controller/about');
const { recoverTasks } = require('./src/controller/area/utils');

initDb()
    .then(async () => {
        await recoverTasks();

        const app = express();

        app.use(cors());
        app.use(express.urlencoded({ extended: false })); // to parse application/x-www-form-urlencoded
        app.use(express.json()); // to parse application/json

        app.get('/about.json', about);
        app.use('/api', router);

        const port = process.env.PORT || process.env.APP_PORT || 8080;
        app.listen(port, () => console.log(`The magic port is ${port}`));
    })
    .catch(() => process.exit(1));
