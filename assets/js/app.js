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
import { MDCTopAppBar } from '@material/top-app-bar/index';

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

import { MDCTextFieldHelperText } from '@material/textfield/helper-text';

const textFieldHelperSelector = document.querySelectorAll('.mdc-text-field-helper-text');

if (textFieldHelperSelector) {
  textFieldHelperSelector.forEach(s => {
    new MDCTextFieldHelperText(s);
  });
}

import { MDCTabBar } from '@material/tab-bar';

const tabBarSelector = document.querySelectorAll('.mdc-tab-bar');

if (tabBarSelector) {
  textFieldHelperSelector.forEach(s => {
    new MDCTabBar(s);
  });
}


// Initialise toggles
const toggles = document.querySelectorAll('.gk-card__toggle');

toggles.forEach(toggle => {
  const icon = toggle.querySelector('.material-icons');
  const card = toggle.parentElement;
  const teaser = card.querySelector('.gk-card__toggle--teaser');
  const content = card.querySelector('.gk-card__toggle--content');

  const openedHeight = content.scrollHeight;
  content.style.height = 0;

  let collapsed = true;
  toggle.addEventListener('click', () => {
    collapsed = !collapsed;

    if (collapsed) {
      icon.innerHTML = 'keyboard_arrow_down';
      content.style.height = 0;
    } else {
      icon.innerHTML = 'keyboard_arrow_up';
      content.style.height = `${openedHeight}px`;
    }
  });
});

// Form validation: reset when changin data
document.querySelectorAll('.gk-validation--failed').forEach(validation => {
  // find input
  const input = validation.querySelector('input,textarea');
  const message = validation.querySelector('.mdc-text-field-helper-text');

  if (!input) {
    return;
  }

  input.addEventListener('focus', () => {
    validation.classList.remove('gk-validation--failed');

    if (message) {
      message.classList.remove('mdc-text-field-helper-text--persistent');
    }
  });
});