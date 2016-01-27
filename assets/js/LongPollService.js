"use strict";

Qt.include("Http.js");
Qt.include("FriendsService.js");
Qt.include("DialogsService.js");
Qt.include("Common.js");

var app;
var longPollServer = {};

var Status = {
	ONLINE : 1,
	OFFLINE : 0
};

var Action = {
	FRIEND_BECAME_ONLINE: 8,
	FRIEND_BECAME_OFFLINE: 9,
	MESSAGE_ADDED: 4
};

var Flag = {
	MESSAGE_BY_CURR_USER: 35
};

function start() {
	console.debug("long poll service started");
	Http.post(Http.vkApiUrl + "/messages.getLongPollServer", {
		use_ssl : 1,
		need_pts : 1
	}, function(response) {
		console.debug(response);
		longPollServer = JSON.parse(response).response;
		getLongPollHistory(longPollServer.ts);
	});
}

function getLongPollHistory(ts) {
	Http.post("http://" + longPollServer.server, {
		act : "a_check",
		key : longPollServer.key,
		ts : ts,
		wait : 25,
		mode : 2
	}, function(response) {
		console.debug(response);
		var responseObj = JSON.parse(response);
		if (responseObj.hasOwnProperty("failed")) {
			if (responseObj.failed === 2) {
				start();
			}
		} else {
			responseObj.updates.forEach(function(update) {
				var responseCode = update[0];
				if (responseCode === Action.FRIEND_BECAME_ONLINE) {
					friendOnlineChanged(-update[1], Status.ONLINE);
				} else if (responseCode === Action.FRIEND_BECAME_OFFLINE) {
					friendOnlineChanged(-update[1], Status.OFFLINE);
				} else if (responseCode === Action.MESSAGE_ADDED) {
					
					var newDialogs = app.dialogsService.dialogs.slice();
					var fromCurrUser = update[2] === Flag.MESSAGE_BY_CURR_USER;
					var userId = update[3];
					
					var dialog = findByUserId(newDialogs, userId);
					
					if (dialog) {
						dialog = updateDialogByUser(dialog, fromCurrUser, update[1], update[4], update[5], update[6], update[7]);
						
						app.dialogsService.dialogUpdated(dialog);
						app.dialogsService.setDialogs(newDialogs);
					} else {
						var friend = findUserById(app.friendsService.friends, userId);
						if (friend) {
							dialog = createDialog(friend, fromCurrUser, update[1], update[4], update[5], update[6], update[7]);
							
							newDialogs.push(dialog);
							
							app.dialogsService.dialogAdded(dialog);
							app.dialogsService.setDialogs(newDialogs);
							app.dialogsService.setCount(++app.dialogsService.count);
							app.dialogsService.setUnreadDialogs(++app.dialogsService.unreadDialogs);
						}
					}
				}
			});
			getLongPollHistory(responseObj.ts);
		}

	});
}

//    {"ts":1869517277,"updates":[[4,82033,33,214914887,1453116338," ... ","Дарова, лысый",{}],[80,3,0],[7,214914887,82032]]}


function friendOnlineChanged(userId, status) {
	var newFriendsList = app.friendsService.friends.slice();
	var friend = findUserById(newFriendsList, userId);
	friend.online = status;
	if (friend.online === 0) {
		friend.last_seen.time = new Date().getMilliseconds();
	}
	app.friendsService.friendOnlineChanged(friend);
	app.friendsService.setFriends(newFriendsList);
}

function init(_app) {
	app = _app;
	Http.init(app.http.accessToken, app.http.userId, app.http.apiVersion);
}