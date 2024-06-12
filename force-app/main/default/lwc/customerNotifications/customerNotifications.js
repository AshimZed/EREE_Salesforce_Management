import { LightningElement, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getNotifications from '@salesforce/apex/CompanyPortalController.getNotifications';
import setNotificationAsSeen from '@salesforce/apex/CompanyPortalController.setNotificationAsSeen';

export default class CustomerNotifications extends LightningElement {

    notifications = [];
    userId = Id;

    @wire(getNotifications, { userId: '$userId' })
    wiredNotifications({ error, data }) {
        if (data) {
            this.notifications = data.map(notification => ({
                id: notification.Id,
                title: notification.Subject__c,
                detail: notification.Detail__c,
                seen: notification.Seen__c
            }));
        } else if (error) {
            console.error('Error fetching notifications:', error);
        }
    }

    get notificationsToDisplay() {
        return this.notifications.filter(notification => !notification.seen);
    }

    dismissNotification(event) {
        const notificationId = event.currentTarget.dataset.id;
        console.log('Dismissing notification:', notificationId)
        setNotificationAsSeen({ notificationId: notificationId })
            .then(() => {
                // Successfully marked as seen, update local state
                this.notifications = this.notifications.map(notification => 
                    notification.id === notificationId ? { ...notification, seen: true } : notification
                );
                console.log('Notification marked as seen.');
            })
            .catch(error => {
                console.error('Error marking notification as seen:', error);
            });
    }
}