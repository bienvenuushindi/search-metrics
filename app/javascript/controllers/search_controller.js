import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    console.log("Search controller connected")
  }

  search() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      const query = this.inputTarget.value.trim()

      if (query.length > 0) {
        fetch(`/articles/search?query=${encodeURIComponent(query)}`)
            .then(response => response.text())
            .then(html => {
              this.resultsTarget.innerHTML = html
            })
      } else {
        this.resultsTarget.innerHTML = ""
      }
    }, 300) // 300ms debounce
  }
}