Qt.include("Common.js");

function fillDialogsList(dialogsArray, dialogs) {
	dialogsArray.clear();
	dialogsArray.append(dialogs);
}

function getUnread(dialogs) {
	return dialogs.filter(function(dialog) {
		return dialog.unread;
	});
}

function search(dialogs, textParts) {
	return dialogs.filter(function(dialog) {
		if (dialog.message.chat_id) {
			return startsWith(dialog.message.title, textParts.join(" "));
		} else {
			if (textParts.length === 1) {
				return startsWith(dialog.user.first_name, textParts[0]) || startsWith(dialog.user.last_name, textParts[0]);
			} else {
				return startsWith(dialog.user.first_name, textParts[0]) && startsWith(dialog.user.last_name, textParts[1]);
			}
		}
	});
}