// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showOrHide(divId) {
  new Effect[
    Element.visible(divId) ? 'BlindUp' : 'BlindDown'](divId, {duration: 0.25})
}

function fieldReset(id) {
  document.getElementById(id).value = '';
}

// deal with comments navigation.

var lastHidden = new Array();

function hideFirstComment() {
	var comments = $$('.hidable_comment');
	for (i = 0; i < comments.length; i++) {
		if (i + 1 == comments.length) {
			return;
		}
		var id = comments[i].id;
		if (Element.visible(id)) { Effect.DropOut(id); lastHidden.push(id); return; }
	}
}

function showAllComments() {
	var comments = $$('.hidable_comment');
	for (i = 0; i < comments.length; i++) {
		var id = comments[i].id;
		if (!Element.visible(id)) { Effect.Appear(id); }
	}
}

function showLastHiddenComment() {
	if (lastHidden.length > 0) { Effect.Appear(lastHidden.pop()); }
}
