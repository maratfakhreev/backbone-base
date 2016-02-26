import Marionette from 'backbone.marionette';
import user from 'helpers/user';
import template from 'templates/comments/item';
import { props } from 'decorators';

@props({
  template,
  className: 'media',
  templateHelpers: { user }
})
export default class CommentsItemView extends Marionette.ItemView {}
