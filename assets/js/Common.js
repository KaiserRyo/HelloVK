'use strict';

function startsWith(sourceString, searchString) {
	return sourceString.toLowerCase().lastIndexOf(searchString.toLowerCase(), 0) === 0;
}

function contains(str, regex) {
    return str.indexOf(regex) !== -1;
}

function assign(target, firstSource) {
	if (target === undefined || target === null) {
		throw new TypeError('Cannot convert first argument to object');
	}

	var to = Object(target);
	for (var i = 1; i < arguments.length; i++) {
		var nextSource = arguments[i];
		if (nextSource === undefined || nextSource === null) {
			continue;
		}

		var keysArray = Object.keys(Object(nextSource));
		for (var nextIndex = 0, len = keysArray.length; nextIndex < len; nextIndex++) {
			var nextKey = keysArray[nextIndex];
			var desc = Object.getOwnPropertyDescriptor(nextSource, nextKey);
			if (desc !== undefined && desc.enumerable) {
				to[nextKey] = nextSource[nextKey];
			}
		}
	}
	return to;
};

function isPropExists(obj, propName) {
    return obj.hasOwnProperty(propName) && obj[propName] !== "";
}
