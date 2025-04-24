import Rails from "@rails/ujs";
import { Controller } from "@hotwired/stimulus"
import {useDebounce} from 'stimulus-use'

export default class extends Controller {
  static targets = ["input"]
  static debounces = ['search']

  connect() {
    useDebounce(this, { wait: 500 })
  }

  search(event) {
    Rails.fire(this.element, 'submit');
    // this.element.requestSubmit()
    event.preventDefault()
  }
}