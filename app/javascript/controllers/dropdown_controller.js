import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Bootstrap dropdownの初期化
    if (window.bootstrap && window.bootstrap.Dropdown) {
      const dropdownToggle = this.element.querySelector('[data-bs-toggle="dropdown"]')
      if (dropdownToggle) {
        new window.bootstrap.Dropdown(dropdownToggle)
      }
    }
  }
}