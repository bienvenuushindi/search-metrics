import {get} from "@rails/request.js";
import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="query-log"
export default class extends Controller {
  static targets = ["queryLog","generalSection", "ipSection"]

  connect() {
    this.token = document.querySelector(
        'meta[name="csrf-token"]'
    ).content
    console.log("hello world");
  }

  toggle(event) {
    const value = event.target.value
    if (value === "general") {
      this.generalSectionTarget.classList.remove("hidden")
      this.ipSectionTarget.classList.add("hidden")
    } else {
      this.generalSectionTarget.classList.add("hidden")
      this.ipSectionTarget.classList.remove("hidden")
    }
  }

  async loadLogs(ev ){
    const source = ev.target
    let url = source.getAttribute('data-url')
    await get(url, {
      'X-CSRF-Token': this.token,
      contentType: 'application/json',
      credentials: 'same-origin',
      responseKind: 'turbo-stream'
    }).then(response => response.text)
        .then(html => {
          return Turbo.renderStreamMessage(html)
        });
    ev.preventDefault()
  }

  async loadbyuser(ev){
    const source = ev.target
    let url = source.getAttribute('data-url')
    await get(url+"?ip="+ev.target.value, {
      'X-CSRF-Token': this.token,
      contentType: 'application/json',
      credentials: 'same-origin',
      responseKind: 'turbo-stream'
    }).then(response => response.text)
        .then(html => {
          return Turbo.renderStreamMessage(html)
        });
    ev.preventDefault()
  }
}

