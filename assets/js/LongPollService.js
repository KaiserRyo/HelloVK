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
					var userId = update[3];
					
					var dialog = findByUserId(newDialogs, userId);
					
					if (dialog) {
						app.dialogsService.dialogUpdated(updateDialogByUser(dialog, update));
						app.dialogsService.setDialogs(newDialogs);
					} else {
						var friend = findUserById(app.friendsService.friends, userId);
						if (friend) {
							dialog = {};
							dialog.user = friend;
							dialog.unread = 1;
							
							var message = {};
							message.id = update[1];
							message.out = 0;
							message.user_id = friend.id;
							message.read_state = 0;
							message.date = update[4];
							message.title = update[5];
							message.body = update[6];
							
							dialog.message = message;
							
//							newDialogs.splice(0, 0, dialog);
							newDialogs.push(dialog);
							
							app.dialogsService.setDialogs(newDialogs);
							app.dialogsService.setCount(++app.dialogsService.count);
							app.dialogsService.setUnreadDialogs(++app.dialogsService.unreadDialogs);
							app.dialogsService.dialogAdded(dialog);
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