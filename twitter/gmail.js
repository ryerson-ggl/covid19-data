const { google } = require('googleapis');
const { OAuth2 } = google.auth;
const nodemailer = require('nodemailer');

module.exports = options => {

    // (email_options) Options for email
    options = options || {};
    options.user = options.user || process.env.GMAIL_USER;
    options.mail_to = options.mail_to || process.env.GMAIL_TO;
    options.client_id = options.client_id || process.env.GMAIL_CLIENT_ID;
    options.client_secret = options.client_secret || process.env.GMAIL_CLIENT_SECRET;
    options.refresh_token = options.refresh_token || process.env.GMAIL_REFRESH_TOKEN;
    options.redirect_uri = options.redirect_uri || process.env.GMAIL_REDIRECT_URI;

    // (email_auth) Authenticate gmail
    const oauth2_client = new OAuth2(
        options.client_id,
        options.client_secret,
        options.redirect_uri
    );

    // (email_send) Create function to send email
    const send = async (msg, type, subject, from, to, tag, before, after) => {

        // (email_send_vars) Initial variables
        subject = subject || options.mail_subject;
        msg = msg || options.mail_message;
        type = type || options.mail_type || 'LOG';
        from = from || options.user;
        to = to || options.mail_to;
        tag = tag || options.mail_subject_tag;
        before = before || options.mail_before_message;
        after = after || options.mail_after_message;

        // (email_token) Get token
        oauth2_client.setCredentials({
            refresh_token: options.refresh_token,
        });
        const access_token = await oauth2_client.getAccessToken();

        // (email_transporter) Setup gmail transporter
        var transporter = await nodemailer.createTransport({
            service: 'Gmail',
            auth: {
                type: 'OAuth2',
                user: options.user,
                clientId: options.client_id,
                clientSecret: options.client_secret,
                refreshToken: options.refresh_token,
                accessToken: access_token.token
            }
        });

        // (email_send_mail) Create mail object
        var mail = {
            from: from,
            to: to,
            subject: `${tag} [${type}] ${subject}`,
            html: `${before}${msg}${after}`
        };

        // (email_send_transport) Send the email
        return transporter.sendMail(mail, function (err, info) {
            if (err) {
                console.error('Error: Email was not sent.');
                console.error(err);
            } else {
                console.log(`${type} email sent to ${to} with message ID ${info.messageId}`);
            }
        });
    };

    // (email_return) Return email object
    out = {};
    out.send = send;
    return out;
}