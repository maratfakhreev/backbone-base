import Marionette from 'backbone.marionette';
import App from 'application';
import template from 'templates/notifications/notification';
import { props } from 'decorators';

@props({
  template,

  ui: {
    closeButton: '.close'
  },

  events: {
    'click @ui.closeButton': 'hideNofitication'
  }
})
export default class NotificationView extends Marionette.ItemView {
  hideNofitication(event) {
    event.preventDefault();
    App.vent.trigger('notification:hide');
  }

  serializeData() {
    const { message, type } = this.options;

    return { message, type };
  }
}