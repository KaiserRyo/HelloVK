"use strict";

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

function fillFriendsList(friendsArray, friends) {
	friendsArray.clear();
    for (var i = 0; i < friends.length; i ++) {
    	friendsArray.insert(friends[i]);
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

function findUserById(friendsList, userId) {
	return friendsList.filter(function(friend) {
		return friend.id === userId;
	})[0];
}

function getCurrentJob(friend) {
    if (friend.career && friend.career.length > 0 && friend.career[0]) {
        var currentJob = friend.career[friend.career.length - 1];
        var result = "";
        if (currentJob.position) {
            result = currentJob.position;
        }
        if (currentJob.company) {
            result += " (" + currentJob.company + ") ";
        }
        return result;
    } else {
        return "";
    }
}

function getMobilePhone(friend) {
	return getProp(friend, "mobile_phone");
}

function getSites(friend) {
	return isPropExists(friend, "site") ? getLinks(friend.site) : "";
}

function getSkype(friend) {
	return getProp(friend, "skype");
}

function getBdate(friend) {
	return getProp(friend, "bdate");
}

function getEducation(friend) {
    return isPropExists(friend, "university_name") ? friend.university_name + (friend.graduation !== 0 ? qsTr(" in ") + friend.graduation : "") : "";
}

function getCity(friend) {
    return isPropExists(friend, "city") ? friend.city.title + (friend.country ? " (" + friend.country.title + ")" : "") : "";
}

function getProp(friend, propName) {
	return isPropExists(friend, propName) ? friend[propName] : "";
}

function isPropExists(obj, propName) {
    return obj.hasOwnProperty(propName) && obj[propName] !== "";
}