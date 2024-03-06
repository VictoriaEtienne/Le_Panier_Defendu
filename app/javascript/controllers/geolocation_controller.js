// app/javascript/controllers/geolocation_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("click", this.getGeolocation.bind(this));
  }

  getGeolocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(this.handlePosition.bind(this), this.handleError.bind(this));
    } else {
      console.error("Geolocation is not supported by this browser.");
    }
  }

  handlePosition(position) {
    const latitudeField = document.getElementById('user_latitude');
    const longitudeField = document.getElementById('user_longitude');

    latitudeField.value = position.coords.latitude;
    longitudeField.value = position.coords.longitude;
  }

  handleError(error) {
    console.error(`Error getting geolocation: ${error.message}`);
  }
}