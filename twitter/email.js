const sendmail = require('sendmail')({silent: true, secure: true});

module.exports = options => {

    // (email_options) Options for email
    options = options || {};
    options.mail_from = options.user || process.env.EMAIL_FROM;
    options.mail_to = options.mail_to || process.env.EMAIL_TO;

    // (email_send) Create function to send email
    const send = (msg, type, subject, from, to, tag, before, after) => {

        // (email_send_vars) Initial variables
        subject = subject || options.mail_subject;
        msg = msg || options.mail_message;
        type = type || options.mail_type || 'LOG';
        from = from || options.mail_from;
        to = to || options.mail_to;
        tag = tag || options.mail_subject_tag;
        before = before || options.mail_before_message;
        after = after || options.mail_after_message;

        // (email_send_mail) Send email
        var results = sendmail({
            from: from,
            to: to,
            subject: `${tag} [${type}] ${subject}`,
            html: `${before}${msg}${after}`
        }, function (err, reply) {
            if (err) {
                console.error(`Error: Email from ${from} to ${to} was not sent.`);
                console.error(err.message);
            } else {
                console.log(`Sent ${type} email from ${from} to ${to}!`);
            }
        });
    };

    // (email_return) Return email object
    out = {};
    out.send = send;
    return out;
}