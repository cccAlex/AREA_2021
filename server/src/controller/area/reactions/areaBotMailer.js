const nodemailer = require('nodemailer');

const botEmail = process.env.NODEMAILER_BOT_EMAIL;

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: botEmail,
        pass: process.env.NODEMAILER_BOT_PASSWORD,
    },
});

const areaBotMailer = (areaID, { params }, data) => {
    return new Promise((resolve, reject) => {
        transporter.sendMail({
            from: botEmail,
            subject: '[AREA] Mailer',
            to: params.email,
            text: JSON.stringify(data),
        }, (error, info) => {
            if (error) {
                reject(error);
            } else {
                console.log(`Email sent from '${botEmail}' to '${email}'`);
                resolve(info);
            }
        });
    });
};

module.exports = areaBotMailer;
