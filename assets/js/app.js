// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import {MDCTopAppBar} from '@material/top-app-bar/index';

// Instantiation
const topAppBarElement = document.querySelector('.mdc-top-app-bar');
const topAppBar = new MDCTopAppBar(topAppBarElement);

import { MDCTextField } from '@material/textfield';
const fieldSelector = document.querySelectorAll('.mdc-text-field');

if (fieldSelector) {
  [...fieldSelector].forEach(s => MDCTextField.attachTo(s));
}

import { MDCSnackbar, MDCSnackbarFoundation } from '@material/snackbar';
const snackbarSelector = document.querySelector('.mdc-snackbar');

if (snackbarSelector) {
  MDCSnackbar.attachTo(snackbarSelector);

  window.snackbar = new MDCSnackbar(snackbarSelector);
}

import { MDCDialog, MDCDialogFoundation, util } from '@material/dialog';
const dialogSelector = document.querySelector('#gk-error-dialog');

if (dialogSelector) {
  MDCDialog.attachTo(dialogSelector);

  const dialog = new MDCDialog(dialogSelector);
  dialog.show();
}

// Initialise toggles
const toggles = document.querySelectorAll('.gk-card__toggle');

toggles.forEach(toggle => {
  const icon = toggle.querySelector('.material-icons');
  const card = toggle.parentElement;
  const teaser = card.querySelector('.gk-card__toggle--teaser');
  const content = card.querySelector('.gk-card__toggle--content');

  const closedHeight = teaser.parentElement.clientHeight - content.clientHeight;
  const openedHeight = teaser.parentElement.clientHeight;
  card.style.maxHeight = `${closedHeight}px`;
  card.style.overflow = 'hidden';

  let collapsed = true;
  toggle.addEventListener('click', () => {
    collapsed = !collapsed;

    if (collapsed) {
      icon.innerHTML = 'keyboard_arrow_down';
      content.style.visibility = 'hidden';
      card.style.maxHeight = `${closedHeight}px`;
    } else {
      icon.innerHTML = 'keyboard_arrow_up';
      content.style.visibility = 'visible';
      card.style.maxHeight = `${openedHeight}px`;
    }
  });
});