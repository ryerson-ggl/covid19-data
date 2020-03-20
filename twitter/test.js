const sendmail = require('sendmail')();

sendmail({
  from: 'ggl.spatial.dev@gmail.com',
  to: 'rrwen.dev@gmail.com',
  subject: 'Hello World',
  html: 'Hooray NodeJS!!!'
}, function (err, reply) {
  console.log(err && err.stack)
  console.dir(reply)
})