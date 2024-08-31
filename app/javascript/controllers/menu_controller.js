import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
    console.log("Controller connected");

    const isCollapsed = localStorage.getItem('menu-collapsed') === 'true';

    if (isCollapsed) {
      this.collapseMenu(false);
    } else {
      this.expandMenu(false);
    }
  }

  toggle() {
    if (this.isToggling) return;
    this.isToggling = true;

    setTimeout(() => {
      this.isToggling = false;
    }, 300);

    const $navigation = $(this.element).find('[data-menu-target="navigation"]');
    const $icon = $(this.element).find('[data-menu-target="icon"]');

    if ($navigation.hasClass("collapsed")) {
      this.expandMenu(true, $navigation, $icon);
    } else {
      this.collapseMenu(true, $navigation, $icon);
    }
  }

  collapseMenu(withTransition = true, $navigation = null, $icon = null) {
    if (!withTransition) $(this.element).addClass('no-transition');

    $navigation = $navigation || $(this.element).find('[data-menu-target="navigation"]');
    $icon = $icon || $(this.element).find('[data-menu-target="icon"]');

    $navigation.addClass("collapsed");
    $icon.removeClass("fa-chevron-left").addClass("fa-chevron-right");

    localStorage.setItem('menu-collapsed', true);

    if (!withTransition) setTimeout(() => $(this.element).removeClass('no-transition'), 10);
  }

  expandMenu(withTransition = true, $navigation = null, $icon = null) {
    if (!withTransition) $(this.element).addClass('no-transition');

    $navigation = $navigation || $(this.element).find('[data-menu-target="navigation"]');
    $icon = $icon || $(this.element).find('[data-menu-target="icon"]');

    $navigation.removeClass("collapsed");
    $icon.removeClass("fa-chevron-right").addClass("fa-chevron-left");

    localStorage.setItem('menu-collapsed', false);

    if (!withTransition) setTimeout(() => $(this.element).removeClass('no-transition'), 10);
  }


  toggleMenuIfNotDisabled() {
    const $disableElements = $(this.element).find('[data-disable="true"]');
    const $allElements = $(this.element).find('[data-menu-target="navigation"], [data-menu-target="icon"]');

    if ($disableElements.length === 0 || !$allElements.hasClass('collapsed')) {
      this.toggle();
    }
  }
}