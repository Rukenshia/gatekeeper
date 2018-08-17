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
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import { MDCTextField } from '@material/textfield';
const fieldSelector = document.querySelector('.mdc-text-field');

if (fieldSelector) {
  MDCTextField.attachTo(fieldSelector);
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
