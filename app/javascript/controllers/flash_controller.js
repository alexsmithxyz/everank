import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = [ "dismiss" ]

  connect() {
    this.dismissTarget.classList.remove('hidden')

    this.dismissTarget.addEventListener('click', e => {
      e.target.parentElement.remove()
    })
  }
}
