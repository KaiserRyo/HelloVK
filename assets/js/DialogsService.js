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
		return dialog.user.id === userId;
	})[0];
}

function createEmptyDialog(user) {
	return { user: user, message: {}, messages: []};
}

function createDialog(user, fromCurrUser, messageId, date, title, body, attachments, currUserId) {
	var readState = 0;
	var out = fromCurrUser ? 1 : 0;
	var fromId = fromCurrUser ? currUserId : user.id;
	var unread = fromCurrUser ? "" : 1;
	
	return { user: user, unread: unread,
			 message: createDialogMessage(messageId, date, title, body, attachments, out, user.id, readState),
			 messages: [createMessage(messageId, body, user.id, fromId, date, readState, out, attachments)]};
}

function updateDialogByUser(dialog, fromCurrUser, messageId, date, title, body, attachments, currUserId) {
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
	
	var readState = 0;
	var out = fromCurrUser ? 1 : 0;
	var fromId = fromCurrUser ? currUserId : dialog.message.user_id;
		
	dialog.message = createDialogMessage(messageId, date, title, body, attachments, out, dialog.message.user_id, readState);
	
	var newMessage = createMessage(messageId, body, dialog.message.user_id, fromId, date, readState, out, attachments);
	if (dialog.messages) {
		if (!findMessageById(dialog.messages, messageId)) {
			dialog.messages.push(newMessage);
		}
	} else {
		dialog.messages = [newMessage];
	}
	
	return dialog;
}

function createDialogMessage(messageId, date, title, body, attachments, out, userId, readState) {
	return { id: messageId, date: date, title: title, body: body, attachments: attachments, out: out, user_id: userId, read_state: readState };
}

function createMessage(messageId, body, userId, fromId, date, readState, out, attachments) {
	return { id: messageId, body: body, user_id: userId, from_id: fromId, date: date, read_state: readState, out: out, attachments: attachments };
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

function findMessagesByUserId(messages, userId) {
	return messages.filter(function(m) {
		return m.from_id === userId;
	});
}

function findUnreadMessages(messages) {
	return messages.filter(function(m) {
		return m.read_state === 0 || m.read_state === 2;
	});
}