"use strict";

var accessToken = "", userId = "", apiVersion = "";

function init(_accessToken, _userId, _apiVersion) {
	console.debug("access_token: " + _accessToken);
    console.debug("userId: " + _userId);
    console.debug("apiVersion: " + _apiVersion);
	accessToken = _accessToken;
	userId = _userId;
	apiVersion = _apiVersion;
}

function create() {
	return { accessToken: accessToken, userId: userId, apiVersion: apiVersion };
}