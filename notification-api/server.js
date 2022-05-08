'use strict';

const express = require('express');
const session = require('express-session');

const PORT = 3000;
const HOST = '0.0.0.0';

const fetchAllNotifications = () => {
  return [
    { id: 1, org_id: 1, user_id: 1, message: '通知メッセージ1'  },
    { id: 2, org_id: 1, user_id: 1, message: '通知メッセージ2'  },
    { id: 3, org_id: 1, user_id: 1, message: '通知メッセージ3'  },
    { id: 4, org_id: 1, user_id: 1, message: '通知メッセージ4'  },
    { id: 5, org_id: 1, user_id: 1, message: '通知メッセージ5'  },
    { id: 6, org_id: 2, user_id: 1, message: '通知メッセージ6'  },
    { id: 7, org_id: 2, user_id: 1, message: '通知メッセージ7'  },
    { id: 8, org_id: 2, user_id: 1, message: '通知メッセージ8'  },
    { id: 9, org_id: 3, user_id: 2, message: '通知メッセージ9'  },
    { id: 10, org_id: 3, user_id: 2, message: '通知メッセージ10'  },
  ]
}

const app = express();
app.set('trust proxy', 1);
app.use(session({
  secret: 'secret',
  resave: false,
  saveUninitialized: true,
  cookie: {
    secure: true,
    httpOnly: true
  }
}));

app.get('/health', (req, res) => {
  res.send('OK');
});
app.post('/session', (req, res) => {
  req.session.user_id = req.body.user_id;
  req.session.org_id = req.body.org_id;
});
app.get('/notifications', (req, res) => {
  if (!req.session.user_id && !req.session.org_id) {
    res.status(401).send('Unauthorized');
    return
  }
  const notifications = fetchAllNotifications();
  const filteredNotifications = notifications.filter((n) => {
    return n.user_id.toString() === req.session.user_id && n.org_id.toString() === req.session.org_id;
  });
  res.json(filteredNotifications);
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
