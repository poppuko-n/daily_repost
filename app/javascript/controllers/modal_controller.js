import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form"]

  connect() {
    if (window.bootstrap && window.bootstrap.Modal) {
      this.modal = new window.bootstrap.Modal(this.modalTarget)
    }
  }

  open() {
    if (this.modal) {
      this.modal.show()
    }
  }

  close() {
    if (this.modal) {
      this.modal.hide()
    }
  }

  resetForm() {
    if (this.hasFormTarget) {
      this.formTarget.reset()
      const errorElements = this.element.querySelectorAll('.alert-danger')
      errorElements.forEach(element => element.remove())
    }
  }

  disconnect() {
    if (this.modal) {
      this.modal.dispose()
    }
  }
}