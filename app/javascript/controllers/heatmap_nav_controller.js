import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["panel", "prevBtn", "nextBtn", "yearLabel"];
  static values = { years: Number };

  // Index of the currently visible panel (0 = oldest year, last = most recent)
  // Start at the most recent year (last index).
  get currentIndex() {
    return this._currentIndex ?? this.yearsValue - 1;
  }
  set currentIndex(val) {
    this._currentIndex = val;
  }

  connect() {
    this.updateUI();
  }

  prev() {
    if (this.currentIndex > 0) {
      this.currentIndex--;
      this.updateUI();
    }
  }

  next() {
    if (this.currentIndex < this.yearsValue - 1) {
      this.currentIndex++;
      this.updateUI();
    }
  }

  updateUI() {
    this.panelTargets.forEach((panel, i) => {
      panel.style.display = i === this.currentIndex ? "" : "none";
    });

    const visiblePanel = this.panelTargets[this.currentIndex];
    if (visiblePanel && this.hasYearLabelTarget) {
      this.yearLabelTarget.textContent = visiblePanel.dataset.year;
    }

    if (this.hasPrevBtnTarget) {
      this.prevBtnTarget.disabled = this.currentIndex === 0;
    }
    if (this.hasNextBtnTarget) {
      this.nextBtnTarget.disabled = this.currentIndex === this.yearsValue - 1;
    }
  }
}
