import { Controller } from "stimulus";

export default class extends Controller {
  confirmDelete() {
    if (!window.confirm("Are you sure you want to delete this record?")) {
      event.preventDefault();
    }
  }
}
