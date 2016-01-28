"use strict";

Qt.include("Http.js");

var app;

var userFields = 'photo_id, verified, sex, bdate, city, country, home_town, has_photo, ' + 
				 'photo_50, photo_100, photo_200_orig, photo_200, photo_400_orig, photo_max, ' + 
				 'photo_max_orig, online, lists, domain, has_mobile, contacts, site, education, universities, ' + 
				 'schools, status, last_seen, followers_count, common_count, occupation, nickname, relatives, ' + 
				 'relation, personal, exports, activities, interests, music, movies, ' + 
				 'tv, books, games, about, quotes, screen_name, is_friend, friend_status, career, military';

function initService(_app) {
	app = _app;
	Http.init(app.http.accessToken, app.http.userId, app.http.apiVersion);
}

function getUrl(method) {
	return Http.vkApiUrl + "/" + method;
}

function post(method, params, callback) {
	Http.post(getUrl(method), params, callback);
}

function get(method, params, callback) {
	Http.get(getUrl(method), params, callback);
}

function loadData(callback) {
	post("execute.loadData", {}, function(response) {
		callback(JSON.parse(response).response);		
	});
}

var account = {
	getProfileInfo : function getProfileInfo(callback) {
		get("account.getProfileInfo", {}, function(response) {
			callback(JSON.parse(response).response);
		});
	}
};

var users = {
	getCurrent: function getCurrent(callback) {
		get("users.get", {fields: userFields.replaceAll('/"/g', '')}, function(response) {
			callback(JSON.parse(response).response[0]);
		});
	}
};

var messages = {
	deleteDialog: function deleteDialog(userId, callback) {
		post("messages.deleteDialog", {user_id: userId}, function(response) {
			callback(JSON.parse(response).response);
		});
	},
	
	getHistory: function getHistory(userId, callback) {
		get("messages.getHistory", {user_id: userId, count: 200, rev: 1}, function(response) {
			callback(JSON.parse(response).response);
		});
	},
	
	send: function send(userId, message, callback) {
		post("messages.send", {user_id: userId, message: message}, function(response) {
			callback(JSON.parse(response).response);
		});
	}
};