import Notifications from './components/Notifications';

const App = () => {
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
  const notifications = fetchAllNotifications();

  return (
    <div className="App">
      <Notifications notifications={notifications} />
    </div>
  );
}

export default App;
