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

function findByUserId(dialogs, userId) {
	return dialogs.filter(function(dialog) {
		return dialog.message.user_id === userId;
	})[0];
}

function updateDialogByUser(dialog, update) {
	dialog.unread = isPropExists(dialog, "unread") ? (dialog.unread + 1) : 1;
	dialog.message.id = update[1];
	dialog.message.date = update[4];
	dialog.message.title = update[5];
	dialog.message.body = update[6];
	dialog.message.attachments = update[7];
	return dialog;
}

function deleteDialog(dialogs, dialog) {
	return dialogs.filter(function(_dialog) {
		return _dialog.user.id !== dialog.user.id;
	});
}