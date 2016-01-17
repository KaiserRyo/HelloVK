Qt.include("Http.js");
Qt.include("FriendsService.js");
Qt.include("Common.js");

var app;
var longPollServer = {};
var Status = {
	online : 1,
	offline : 0
};

function start() {
	console.debug("long poll service started");
	Http.post(Http.vkApiUrl + "/messages.getLongPollServer", {
		use_ssl : 1,
		need_pts : 1
	}, function(response) {
		console.debug(response);
		longPollServer = JSON.parse(response).response;

		console.debug("key" + longPollServer.key);
		console.debug("server: " + longPollServer.server);
		console.debug("ts: " + longPollServer.ts);

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
				if (update[0] === 8) {
					friendOnlineChanged(-update[1], Status.online);
				} else if (update[0] === 9) {
					friendOnlineChanged(-update[1], Status.offline);
				}
			});
			getLongPollHistory(responseObj.ts);
		}

	});
}

function friendOnlineChanged(userId, status) {
	var newFriendsList = app.friendsService.friends.slice();
	var friend = findById(newFriendsList, userId);
	friend.online = status;
	if (friend.online === 0) {
		friend.last_seen.time = new Date().getMilliseconds();
	}
	app.friendsService.friendOnlineChanged(friend);
	app.friendsService.setFriends(newFriendsList);
}

function init(store, _app) {
	Http.init(store);
	app = _app;
}