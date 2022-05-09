import Notification from './Notification';

const Notifications = (props) => {
  return (
    <div style={{ border: '1px solid #ccc', display: 'inline-block', padding: '8px', borderRadius: '4px' }}>
      {props.notifications.map(notification => {
        return <Notification key={notification.id} message={notification.message} />
      })}
    </div>
  )
}

export default Notifications;
