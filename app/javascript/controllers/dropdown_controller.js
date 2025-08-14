import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Bootstrap JavaScript の読み込みを待つ
    this.initializeDropdown()
  }

  initializeDropdown() {
    if (window.bootstrap && window.bootstrap.Dropdown) {
      const dropdownToggle = this.element.querySelector('[data-bs-toggle="dropdown"]')
      
      if (dropdownToggle) {
        // 既存のドロップダウンインスタンスがあれば削除
        const existingDropdown = window.bootstrap.Dropdown.getInstance(dropdownToggle)
        if (existingDropdown) {
          existingDropdown.dispose()
        }
        
        // 新しいドロップダウンを初期化
        new window.bootstrap.Dropdown(dropdownToggle)
      }
    } else {
      // Bootstrap が読み込まれるまで少し待って再試行
      setTimeout(() => this.initializeDropdown(), 100)
    }
  }

  disconnect() {
    const dropdownToggle = this.element.querySelector('[data-bs-toggle="dropdown"]')
    if (dropdownToggle && window.bootstrap && window.bootstrap.Dropdown) {
      const dropdown = window.bootstrap.Dropdown.getInstance(dropdownToggle)
      if (dropdown) {
        dropdown.dispose()
      }
    }
  }
}