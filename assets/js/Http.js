var Http = {
		vkApiUrl: 'https://api.vk.com/method',
		store: {},

		request: function request(httpMethod, url, paramsStr, onSuccess, onError) {
			var _req = new XMLHttpRequest();

			_req.open(httpMethod, url, true);
			_req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

			_req.onreadystatechange = function() {
				if (_req.readyState === 4) {
					if (_req.status === 200) {
						onSuccess(_req.responseText);
					} else {
						console.debug(_req.responseText);
					}
				}
			};

			_req.onerror = function() {
				console.debug('Network Error');
			};

			_req.send(paramsStr || null);
		},

		stringifyParams: function stringifyParams(paramsObj) {
			var data = paramsObj ? paramsObj : {};
			
			data.access_token = this.store.accessToken;
			data.user_id = this.store.userId;
			data.v = this.store.apiVersion;
			
			var strinigfiedParams = '';
			for ( var param in data) {
				strinigfiedParams = strinigfiedParams.concat(param).concat('=').concat(
						data[param]).concat('&');
			}
			return strinigfiedParams.substr(0, strinigfiedParams.lastIndexOf('&'));
		},

		get: function get(methodName, paramsObj, onSuccess, onError) {
			this.request('get', methodName + '?' + this.stringifyParams(paramsObj), null,
					onSuccess, onError);
		},

		post: function post(methodName, paramsObj, onSuccess, onError) {
			this.request('post', methodName, this.stringifyParams(paramsObj), onSuccess,
					onError);
		},

		init: function init(store) {
			this.store = store;
		}
};