Qt.include("Http.js");

var userFields = 'photo_id, verified, sex, bdate, city, country, home_town, has_photo, ' + 
				 'photo_50, photo_100, photo_200_orig, photo_200, photo_400_orig, photo_max, ' + 
				 'photo_max_orig, online, lists, domain, has_mobile, contacts, site, education, universities, ' + 
				 'schools, status, last_seen, followers_count, common_count, occupation, nickname, relatives, ' + 
				 'relation, personal, exports, activities, interests, music, movies, ' + 
				 'tv, books, games, about, quotes, screen_name, is_friend, friend_status, career, military';

function initService(store) {
	Http.init(store);
}

function getUrl(method) {
	return Http.vkApiUrl + "/" + method;
}

function post(method, params, callback) {
	Http.post(getUrl(method), {}, callback);
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