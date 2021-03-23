const nodemailer = require('nodemailer');
const jwt = require('jsonwebtoken');

const appBaseURL = process.env.APP_BASE_URL || 'http://localhost:8081';
const secretKey = process.env.JWT_SECRET_KEY || 'my_ultimate_secret_key';
const expiresIn = process.env.JWT_EMAIL_DURATION || '15min';

const serviceEmail = process.env.NODEMAILER_SERVICE_EMAIL;

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: serviceEmail,
        pass: process.env.NODEMAILER_SERVICE_PASSWORD,
    },
});

const getConfirmationEmailText = (_id) => {
    const token = jwt.sign({ _id }, secretKey, { expiresIn });

    return `You can confirm your account through the link here :: ${appBaseURL}/confirm?code=${token}\nThis link expires in ${expiresIn}.`;
};

const sendConfirmationEmail = ({ _id, email }) => {
    return new Promise((resolve, reject) => {
        const text = getConfirmationEmailText(_id)

        transporter.sendMail({
            from: serviceEmail,
            subject: '[AREA Registration] Confirmation instructions',
            to: email,
            text,
        }, (error, info) => {
            if (error) {
                reject(error);
            } else {
                console.log(`Email sent from '${serviceEmail}' to '${email}'`);
                resolve(info);
            }
        });
    });
};

module.exports = sendConfirmationEmail;
