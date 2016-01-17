Qt.include("Common.js");

function search(friendsList, textParts) {
    return friendsList.filter(function(friend) {
        if (textParts.length === 1) {
        	return startsWith(friend.first_name, textParts[0]) || startsWith(friend.last_name, textParts[0]);
        } else {
        	return startsWith(friend.first_name, textParts[0]) && startsWith(friend.last_name, textParts[1]);
        }
    });
}

function fillFriendsList(friendsArrayComponent, friendsList) {
	friendsArrayComponent.clear();
    for (var i = 0; i < friendsList.length; i ++) {
    	friendsArrayComponent.insert(friendsList[i]);
    }
}

function getOnline(friendsList) {
	return friendsList.filter(function(friend) {
		return friend.online === 1;
	});
}

function getLinks(str) {
	return str.split(" ").filter(function(s) {
        return s;
    }).map(function(s) {
        return createHTMLlink(s);
    }).reduce(function(s1, s2) {
        return s1 + "\n" + s2;
    });
}

function createHTMLlink(str) {
	return "<a href=\"" + (Common.contains(str, "http://") || Common.contains(str, "https://") ? str : "http://" + str) + "\">" + str + "</a>";
}

function findById(friendsList, userId) {
	return friendsList.filter(function(friend) {
		return friend.id === userId;
	})[0];
}