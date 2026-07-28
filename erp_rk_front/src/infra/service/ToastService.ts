import Vue from "vue";

export default class ToastService {
  private static get toast() {
    return Vue.prototype.$toast;
  }

  static showSuccess(message: string) {
    this.toast.success(message);
  }

  static showError(message: string) {
    this.toast.error(message);
  }

  static showInfo(message: string) {
    this.toast.info(message);
  }

  static showWarning(message: string) {
    this.toast.warning(message);
  }
}
