"use strict";

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

function createDialog(user, fromCurrUser, messageId, date, title, body, attachments) {
	return { user: user, unread: (fromCurrUser ? "" : 1), message: createMessage(messageId, date, title, body, attachments, 0, user.id, 0) };
}

function updateDialogByUser(dialog, fromCurrUser, messageId, date, title, body, attachments) {
	if (isPropExists(dialog, "unread")) {
		if (!fromCurrUser) {
			dialog.unread++;
		} else {
			delete dialog.unread;
		}
	} else {
		if (!fromCurrUser) {
			dialog.unread = 1;
		}
	}
	
	dialog.message = createMessage(messageId, date, title, body, attachments, dialog.message.out, dialog.message.user_id, dialog.message.read_state);
	return dialog;
}

function createMessage(messageId, date, title, body, attachments, out, userId, readState) {
	return { id: messageId, date: date, title: title, body: body, attachments: attachments, out: out, user_id: userId, read_state: readState };
}

function deleteDialog(dialogs, dialog) {
	return dialogs.filter(function(_dialog) {
		return _dialog.user.id !== dialog.user.id;
	});
}

function findMessageById(messages, messageId) {
	return messages.filter(function(message) {
		return message.id === messageId;
	})[0];
}