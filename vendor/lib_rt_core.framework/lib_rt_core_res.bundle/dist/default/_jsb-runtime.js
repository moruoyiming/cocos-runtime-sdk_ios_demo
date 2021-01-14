(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
"use strict";

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

(function () {
    var jsb_callback = require('./rt-callback.js');

    var rt = loadRuntime();

    rt.exitApplication = function (cb) {
        jsb_callback._pushCallback("exitApplication", cb);
        var data = cb.data;
        var dataType = typeof data === "undefined" ? "undefined" : _typeof(data);
        var dataStr = null;
        if (dataType === "string") {
            dataStr = data;
        } else if (dataType === "object" && data !== null) {
            try {
                dataStr = JSON.stringify(data);
            } catch (e) {}
        }
        if (dataStr !== null) {
            rt._exitApplication(dataStr);
        } else {
            rt._exitApplication();
        }
    };

    rt._onExitApplication = function (error) {
        var arr = jsb_callback._pickCallbackArray("exitApplication");
        if (error !== null && error != undefined) {
            jsb_callback._onCallback(arr, [error]);
        } else {
            jsb_callback._onCallback(arr);
        }
    };

    rt.getLaunchOptionsSync = function () {
        var optString = rt._getLaunchOptions();
        if (typeof optString === "string") {
            try {
                return JSON.parse(optString);
            } catch (e) {
                return optString;
            }
        }
        return optString;
    };

    rt.getSystemInfoSync = function () {
        var res = rt._getSystemInfoSync();

        if (typeof res === "string" && res.length > 0) {
            return JSON.parse(res);
        }
        return null;
    };

    rt.getSystemInfo = function (cb) {
        jsb_callback._pushCallback("getSystemInfo", cb);
        rt._getSystemInfo();
    };

    rt._OnGetSystemInfo = function (res) {
        var arr = jsb_callback._pickCallbackArray("getSystemInfo");
        if (arr === undefined) {
            return;
        }

        if (typeof res === "string" && res.length > 0) {
            var json = JSON.parse(res);
            jsb_callback._onCallback(arr, undefined, [json]);
        } else {
            var errorMsg = "getSystemInfo failed!";
            jsb_callback._onCallback(arr, [errorMsg]);
        }
    };

    require("./rt-device");

    rt.getUserInfo = function (cb) {
        jsb_callback._pushCallback("getUserInfo", cb);

        rt.authorize({
            scope: "userInfo",
            success: function success() {
                rt._getUserInfo();
            },
            fail: function fail() {
                var errorMsg = "without userinfo permission";
                var arr = jsb_callback._pickCallbackArray("getUserInfo");
                jsb_callback._onCallback(arr, [errorMsg]);
            }
        });
    };

    rt._onGetUserInfo = function (resultcode, data) {
        var arr = jsb_callback._pickCallbackArray("getUserInfo");
        if (resultcode == 0) {
            var jsonData = JSON.parse(data);
            jsb_callback._onCallback(arr, undefined, [jsonData]);
        } else if (resultcode == 1) {
            var errorMsg = "getUserInfo data fail";
            jsb_callback._onCallback(arr, [errorMsg]);
        } else if (resultcode == 2) {
            var errorMsg = "getUserInfo cancel by user";
            jsb_callback._onCallback(arr, [errorMsg]);
        }
    };

    rt.getLocation = function (cb) {
        jsb_callback._pushCallback("getLocation", cb);
        rt.authorize({
            scope: "location",
            success: function success() {
                var type = "wgs84";
                var altitude = false;
                if (cb.type === "gcj02" || cb.type === "bd09") {
                    type = cb.type;
                }
                if (typeof cb.altitude !== "undefined" && cb.altitude) {
                    altitude = true;
                }
                rt._getLocation(type, altitude);
            },
            fail: function fail() {
                var arr = jsb_callback._pickCallbackArray("getLocation");
                var errorMsg = "authorization failed!";
                jsb_callback._onCallback(arr, [errorMsg]);
            }
        });
    };

    rt._onGetLocation = function (info) {
        var arr = jsb_callback._pickCallbackArray("getLocation");
        if (info != null && info != undefined && info.length != 0) {
            var json = JSON.parse(info);
            jsb_callback._onCallback(arr, undefined, [json]);
        } else {
            var errorMsg = "getLocation failed!";
            jsb_callback._onCallback(arr, [errorMsg]);
        }
    };

    rt.onAudioInterruptionBegin = function (cb) {
        jsb_callback._pushFunctionCallback("onAudioInterruptionBegin", cb);
    };

    rt.offAudioInterruptionBegin = function (cb) {
        jsb_callback._removeFunctionCallback("onAudioInterruptionBegin", cb);
    };

    rt._onAudioInterrupted = function () {
        var cbArray = jsb_callback._getFunctionCallbackArray("onAudioInterruptionBegin");
        if (cbArray === undefined) {
            return;
        }
        jsb_callback._onFunctionCallback(cbArray);
    };

    rt.onAudioInterruptionEnd = function (cb) {
        jsb_callback._pushFunctionCallback("onAudioInterruptionEnd", cb);
    };

    rt.offAudioInterruptionEnd = function (cb) {
        jsb_callback._removeFunctionCallback("onAudioInterruptionEnd", cb);
    };

    rt._onAudioInterruptedEnd = function () {
        var cbArray = jsb_callback._getFunctionCallbackArray("onAudioInterruptionEnd");
        if (cbArray === undefined) {
            return;
        }
        jsb_callback._onFunctionCallback(cbArray);
    };

    rt.onError = function (cb) {
        jsb_callback._pushFunctionCallback("onError", cb);
    };

    rt.offError = function (cb) {
        jsb_callback._removeFunctionCallback("onError", cb);
    };

    rt._onErrorOccurred = function (location, message, stack) {
        var cbArray = jsb_callback._getFunctionCallbackArray("onError");
        if (cbArray === undefined) {
            return;
        }
        var params = {
            "message": location + "\n" + message + "\n" + stack
        };
        jsb_callback._onFunctionCallback(cbArray, params);
    };

    rt.onShow = function (cb) {
        jsb_callback._pushFunctionCallback("onShow", cb);
    };

    rt.offShow = function (cb) {
        jsb_callback._removeFunctionCallback("onShow", cb);
    };

    rt._onShown = function () {
        var cbArray = jsb_callback._getFunctionCallbackArray("onShow");
        if (cbArray === undefined) {
            return;
        }
        jsb_callback._onFunctionCallback(cbArray);
    };

    rt.onHide = function (cb) {
        jsb_callback._pushFunctionCallback("onHide", cb);
    };

    rt.offHide = function (cb) {
        jsb_callback._removeFunctionCallback("onHide", cb);
    };

    rt._onHidden = function () {
        var cbArray = jsb_callback._getFunctionCallbackArray("onHide");
        if (cbArray === undefined) {
            return;
        }
        jsb_callback._onFunctionCallback(cbArray);
    };

    require("./rt-auth");

    require("./rt-media-image");

    require("./rt-media-audio-engine");

    require("./rt-ui-keyboard");

    rt.getTextLineHeight = function (params) {
        jsb_callback._pushCallback("getTextLineHeight", params);
        var fontStyle = params["fontStyle"];
        if (typeof fontStyle !== "string" || fontStyle == "") {
            fontStyle = "normal";
        }
        var fontWeight = params["fontWeight"];
        if (typeof fontWeight !== "string" || fontWeight == "") {
            fontWeight = "normal";
        }
        var fontSize = params["fontSize"];
        if (typeof fontSize !== "number") {
            fontSize = 16;
        }
        var fontFamily = params["fontFamily"];
        if (typeof fontFamily !== "string") {
            fontFamily = "";
        }
        var content = params["text"];
        if (typeof content !== "string") {
            content = "";
        }
        var height = rt._getTextLineHeight(fontStyle, fontWeight, fontSize, fontFamily, content);
        return parseFloat(height.toFixed(3));
    };

    rt._OnGetTextLineHeight = function (height) {
        var arr = jsb_callback._pickCallbackArray("getTextLineHeight");
        if (arr === undefined) {
            return;
        }

        if (typeof height === "number" && height > 0) {
            jsb_callback._onCallback(arr, undefined, [height]);
        } else {
            var errorMsg = "getTextLineHeight failed!";
            jsb_callback._onCallback(arr, [errorMsg]);
        }
    };

    require("./rt-subpackage");

    require("./rt-file-system-manager");

    rt.getPerformance = function () {
        return performance;
    };

    rt.triggerGC = jsb.garbageCollect;

    rt.setPreferredFramesPerSecond = jsb.setPreferredFramesPerSecond;

    rt.setEnableDebug = function (params) {
        jsb_callback._pushCallback("setEnableDebug", params);
        var enableDebug = params["enableDebug"];
        if (typeof enableDebug !== "boolean") {
            var errorMsg = "invalid params!";
            jsb_callback._onCallback(params, [errorMsg]);
            return;
        }
        return rt._setEnableDebug(enableDebug);
    };
    rt._onSetEnableDebug = function (result) {
        var arr = jsb_callback._pickCallbackArray("setEnableDebug");
        if (arr === undefined) {
            return;
        }

        if (typeof result === "undefined") {
            jsb_callback._onCallback(arr, undefined);
        } else {
            var errorMsg = "setEnableDebug failed!";
            jsb_callback._onCallback(arr, [errorMsg]);
        }
    };

    jsb.onResize = function (size) {
        window.resize(size.width, size.height);
        var arr = jsb_callback._getFunctionCallbackArray("onWindowResize");
        if ((typeof arr === "undefined" ? "undefined" : _typeof(arr)) === undefined) {
            return;
        }
        jsb_callback._onFunctionCallback(arr, { windowWidth: size.width, windowHeight: size.height });
    };
    rt.onWindowResize = function (callback) {
        jsb_callback._pushFunctionCallback("onWindowResize", callback);
    };
    rt.offWindowResize = function (callback) {
        jsb_callback._removeFunctionCallback("onWindowResize", callback);
    };

    require("./rt-custom");

    delete jsb.inputBox;
    delete jsb.Device;
    delete jsb.garbageCollect;
    delete jsb.setPreferredFramesPerSecond;
})();
require('./rt-network.js');

require('./rt-adjust-ios.js');

},{"./rt-adjust-ios.js":2,"./rt-auth":4,"./rt-callback.js":5,"./rt-custom":6,"./rt-device":7,"./rt-file-system-manager":8,"./rt-media-audio-engine":9,"./rt-media-image":10,"./rt-network.js":11,"./rt-subpackage":12,"./rt-ui-keyboard":13}],2:[function(require,module,exports){
"use strict";

var rt = loadRuntime();
var keyArr = ["getRecorderManager", "_onRecorderStart", "_onRecorderResume", "_onRecorderPause", "_onRecorderStop", "_onRecorderFrameRecorded", "_onRecorderError", "createVideo"];
keyArr.forEach(function (element) {
    rt[element] = undefined;
});

},{}],3:[function(require,module,exports){
"use strict";

var rt = loadRuntime();
var jsb_callback = require("./rt-callback");

rt._onGetApiVersionComplete = function (name, version) {
    var key = "getApiVersion" + name;
    var arr = jsb_callback._pickFunctionCallbackArray(key);
    jsb_callback._onFunctionCallback(arr, version);
};
var _apiMap = {
    chooseImage: "chooseImage"
};

var _getApiVersion = rt._getApiVersion;
delete rt._getApiVersion;

var getApiVersion = function getApiVersion(name, cb) {
    var key = "getApiVersion" + name;
    jsb_callback._pushFunctionCallback(key, cb);
    _getApiVersion(name);
};

module.exports = {
    getApiVersion: getApiVersion,
    apiMap: _apiMap
};

},{"./rt-callback":5}],4:[function(require,module,exports){
"use strict";

(function () {
    var rt = loadRuntime();
    var jsb_callback = require("./rt-callback");

    rt.authorize = function (cb) {
        var scope = cb.scope;

        if (typeof scope !== 'string') {
            var errorMsg = "parameter.scope should be String";
            jsb_callback._onCallback([cb], [errorMsg]);
            return;
        }

        if (scope != "userInfo" && scope != "location" && scope != "record" && scope != "writePhotosAlbum" && scope != "camera") {
            var errorMsg = "authorize:fail invalid scope";
            jsb_callback._onCallback([cb], [errorMsg]);
            return;
        }

        jsb_callback._pushCallback("authorize", cb);

        var arr = jsb_callback._getCallbackArray("authorize");
        if (arr !== undefined && arr.length === 1) {
            rt._authorizeCallNative(cb);
        }
    };

    rt._authorizeCallNative = function (cb) {
        var auth = new Array();
        auth[0] = cb.scope;
        var str = JSON.stringify(auth);
        rt._authorizePermission(str);
    };

    rt._onAuthorize = function (data, deniedData, err) {
        var callbackArr = jsb_callback._getCallbackArray("authorize");
        if (callbackArr === undefined) {
            return;
        }
        var callBack = callbackArr.shift();
        if (callBack === undefined) {
            return;
        }
        var arr = [callBack];
        var granted = JSON.parse(data);
        var denied = JSON.parse(deniedData);

        if (typeof err === "string" && err.length > 0) {
            jsb_callback._onCallback(arr, [err]);
        } else if (denied.length) {
            jsb_callback._onCallback(arr, [denied], [granted]);
        } else {
            jsb_callback._onCallback(arr, undefined, [granted]);
        }

        if (callbackArr.length > 0) {
            var cb = callbackArr[0];
            rt._authorizeCallNative(cb);
        }
    };

    rt.getSetting = function (cb) {
        jsb_callback._pushCallback("getSetting", cb);
        rt._getSetting();
    };

    rt._onGetSetting = function (resultcode, data) {
        var arr = jsb_callback._pickCallbackArray("getSetting");
        if (resultcode == 0) {
            var jsonData = JSON.parse(data);
            var resultJson = {};
            resultJson.errMsg = "getSetting:ok";
            resultJson.authSetting = jsonData;
            jsb_callback._onCallback(arr, undefined, [resultJson]);
        } else if (resultcode == 1) {
            var jsonData = JSON.parse(data);
            var resultJson = {};
            resultJson.errMsg = "getSetting:fail";
            resultJson.authSetting = jsonData;
            jsb_callback._onCallback(arr, [jsonData]);
        }
    };

    rt.openSetting = function (cb) {
        var key = "openSetting";
        var arr = jsb_callback._getCallbackArray(key);
        if (arr === undefined || arr.length === 0) {
            jsb_callback._pushCallback(key, cb);
            rt._openSetting();
        } else {
            var errorMsg = "openSetting is being called ";
            jsb_callback._onCallback([cb], [errorMsg]);
        }
    };

    rt._onOpenSetting = function (resultcode, data) {
        var arr = jsb_callback._pickCallbackArray("openSetting");
        if (resultcode == 0) {
            var jsonData = JSON.parse(data);
            var resultJson = {};
            resultJson.errMsg = "openSetting:ok";
            resultJson.authSetting = jsonData;
            jsb_callback._onCallback(arr, undefined, [resultJson]);
        } else if (resultcode == 1) {
            var resultJson = {};
            resultJson.errMsg = "openSetting:fail";
            var errorMsg = "openSetting:fail";
            jsb_callback._onCallback(arr, [resultJson]);
        }
    };
})();

},{"./rt-callback":5}],5:[function(require,module,exports){
"use strict";

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var jsb_callback = {
    _cbArrayMap: {},
    _cbFunctionArrayMap: {},

    _pushCallback: function _pushCallback(name, cb) {
        if (typeof name !== "string" || (typeof cb === "undefined" ? "undefined" : _typeof(cb)) !== "object") {
            return;
        }
        var arr = this._cbArrayMap[name];
        if (!Array.isArray(arr)) {
            arr = [];
            this._cbArrayMap[name] = arr;
        }
        arr.push(cb);
    },

    _getCallbackArray: function _getCallbackArray(name) {
        var arr = this._cbArrayMap[name];
        if (arr === undefined) {
            return undefined;
        }
        return arr;
    },

    _pickCallbackArray: function _pickCallbackArray(name) {
        var arr = this._cbArrayMap[name];
        if (arr === undefined) {
            return undefined;
        }
        this._cbArrayMap[name] = [];
        return arr;
    },

    _onCallback: function _onCallback(cbArray, failArgs, succArgs, compArgs) {
        if (cbArray === undefined) {
            return;
        }
        var errArr = [];
        cbArray.forEach(function (cb) {
            try {
                if (failArgs !== undefined) {
                    if (typeof cb.fail === "function") {
                        cb.fail.apply(cb, failArgs);
                    }
                } else {
                    if (typeof cb.success == "function") {
                        cb.success.apply(cb, succArgs);
                    }
                }
            } catch (error) {
                errArr.push(error);
            }
            try {
                if (typeof cb.complete === "function") {
                    cb.complete.apply(cb, compArgs);
                }
            } catch (error) {
                errArr.push(error);
            }
        });
        if (errArr.length > 0) {
            throw errArr.join("\n");
        }
    },

    _pushFunctionCallback: function _pushFunctionCallback(name, cb) {
        if (typeof name !== "string" || typeof cb !== "function") {
            return;
        }
        var arr = this._cbFunctionArrayMap[name];
        if (!Array.isArray(arr)) {
            arr = [];
            this._cbFunctionArrayMap[name] = arr;
        }
        for (var i = 0; i < arr.length; ++i) {
            if (arr[i] === cb) {
                return;
            }
        }
        arr.push(cb);
    },

    _pickFunctionCallbackArray: function _pickFunctionCallbackArray(name) {
        var arr = this._cbFunctionArrayMap[name];
        if (arr === undefined) {
            return undefined;
        }
        this._cbFunctionArrayMap[name] = [];
        return arr;
    },

    _removeFunctionCallback: function _removeFunctionCallback(name, cb) {
        var arr = this._cbFunctionArrayMap[name];
        if (arr === undefined) {
            return;
        }
        for (var i = 0; i < arr.length; i++) {
            if (arr[i] === cb) {
                arr.splice(i, 1);
                break;
            }
        }
    },

    _getFunctionCallbackArray: function _getFunctionCallbackArray(name) {
        var arr = this._cbFunctionArrayMap[name];
        if (arr === undefined) {
            return undefined;
        }
        return arr;
    },

    _onFunctionCallback: function _onFunctionCallback(cbFunctionArray) {
        if (cbFunctionArray === undefined) {
            return;
        }
        var argc = arguments.length;
        var args = arguments;
        var errArr = [];
        cbFunctionArray.forEach(function (cb) {
            if (typeof cb !== "function") {
                return;
            }
            try {
                switch (argc) {
                    case 1:
                        cb();
                        break;
                    case 2:
                        cb(args[1]);
                        break;
                    case 3:
                        cb(args[1], args[2]);
                        break;
                    case 4:
                        cb(args[1], args[2], args[3]);
                        break;
                    case 5:
                        cb(args[1], args[2], args[3], args[4]);
                        break;
                    case 6:
                        cb(args[1], args[2], args[3], args[4], args[5]);
                        break;
                    case 7:
                        cb(args[1], args[2], args[3], args[4], args[5], args[6]);
                        break;
                    case 8:
                        cb(args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
                        break;
                    case 9:
                        cb(args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
                        break;
                    case 10:
                        cb(args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
                        break;
                }
            } catch (err) {
                errArr.push(err);
            }
        });
        if (errArr.length > 0) {
            throw errArr.join("\n");
        }
    }
};

module.exports = jsb_callback;

},{}],6:[function(require,module,exports){
"use strict";

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var rt = loadRuntime();
var jsb_callback = require("./rt-callback");
var _callCustomCommand = rt._callCustomCommand;
var _callCustomCommandCount = 0;
var _judge_base_type = function _judge_base_type(item) {
    var ret = undefined;
    var JSType = typeof item === "undefined" ? "undefined" : _typeof(item);
    if (JSType === "number") {
        if (Number.isInteger(item)) {
            ret = "long";
        } else {
            ret = "double";
        }
    } else if (JSType === "string") {
        ret = "string";
    } else if (JSType === "boolean") {
        ret = "boolean";
    }
    return ret;
};
rt.callCustomCommand = function (cb) {
    var len = arguments.length;
    if ((typeof cb === "undefined" ? "undefined" : _typeof(cb)) !== "object") {
        throw "call custom command fail first param is not object";
    }
    var keyCb = "callCustomCommand" + _callCustomCommandCount;
    jsb_callback._pushCallback(keyCb, cb);

    var typeArr = [];
    for (var i = 1; i < len; i++) {
        var item = arguments[i];

        var JSType = typeof item === "undefined" ? "undefined" : _typeof(item);
        var baseType = _judge_base_type(item);
        if (baseType !== undefined) {
            typeArr.push(baseType);
        } else if (item instanceof Int8Array) {
            typeArr.push("Int8Array");
        } else if (item instanceof Int16Array) {
            typeArr.push("Int16Array");
        } else if (item instanceof Int32Array) {
            typeArr.push("Int32Array");
        } else if (item instanceof Float32Array) {
            typeArr.push("Float32Array");
        } else if (item instanceof Float64Array) {
            typeArr.push("Float64Array");
        } else if (item instanceof Array) {
            if (item.length == 0) {
                typeArr.push("[number]");
                continue;
            }
            var arrType = _typeof(item[0]);
            if (arrType !== "boolean" && arrType !== "string" && arrType !== "number") {
                throw "call custom command fail unsupported type:" + JSType + " Array";
            }
            item.forEach(function (element) {
                var elementType = typeof element === "undefined" ? "undefined" : _typeof(element);
                if (elementType !== arrType) {
                    throw "call custom command fail the elements is not the same";
                }
            });
            typeArr.push("[" + arrType + "]");
        } else if (item === null) {
            typeArr.push("null");
        } else {
            throw "call custom command fail unsupported type:" + JSType;
        }
    }
    _callCustomCommand(_callCustomCommandCount++, typeArr, Array.prototype.slice.apply(arguments));
};

rt._onCallCunstomCommandComplete = function () {
    var errorMsg = "unknown error occurred";
    if (arguments.length < 2) {
        jsb_callback._onCallback(arr, [errorMsg]);
        return;
    }
    var identifier = arguments[0];
    if (typeof identifier !== "number") {
        jsb_callback._onCallback(arr, [errorMsg]);
        return;
    }
    var isSuccess = arguments[1];
    if (typeof isSuccess !== "boolean") {
        jsb_callback._onCallback(arr, [errorMsg]);
        return;
    }
    if (arguments.length > 2) {
        errorMsg = arguments[2];
    }
    var keyCb = "callCustomCommand" + identifier;
    var arr = jsb_callback._pickCallbackArray(keyCb);
    if (!isSuccess) {
        if (arguments.length > 3) {
            errorMsg = arguments[2];
        }
        jsb_callback._onCallback(arr, [errorMsg]);
    } else {
        var array = Array.prototype.slice.apply(arguments);
        jsb_callback._onCallback(arr, undefined, array.slice(2));
    }
};

},{"./rt-callback":5}],7:[function(require,module,exports){
"use strict";

(function () {
    var rt = loadRuntime();
    var jsb_callback = require("./rt-callback");

    rt.startAccelerometer = function (cb) {
        jsb_callback._pushCallback("startAccelerometer", cb);

        var periodMs = 200;
        if (cb.interval == "game") {
            periodMs = 20;
        } else if (cb.interval == "ui") {
            periodMs = 60;
        }
        rt._startAccelerometer(periodMs);
    };

    rt._onStartAccelerometer = function () {
        var arr = jsb_callback._pickCallbackArray("startAccelerometer");
        jsb_callback._onCallback(arr);
    };

    rt.stopAccelerometer = function (cb) {
        jsb_callback._pushCallback("stopAccelerometer", cb);
        jsb_callback._pickFunctionCallbackArray("onAccelerometerChange");
        rt._stopAccelerometer();
    };

    rt._OnStopAccelerometer = function () {
        var arr = jsb_callback._pickCallbackArray("stopAccelerometer");
        jsb_callback._onCallback(arr);
    };

    rt.onAccelerometerChange = function (cb) {
        jsb_callback._pushFunctionCallback("onAccelerometerChange", cb);
        rt._startAccelerometerChange();
    };

    rt._onAccelerometerChange = function (x, y, z) {
        var cbArray = jsb_callback._getFunctionCallbackArray("onAccelerometerChange");
        if (cbArray === undefined) {
            return;
        }

        var accelerometer = {
            "x": x,
            "y": y,
            "z": z
        };
        jsb_callback._onFunctionCallback(cbArray, accelerometer);
    };

    rt.getBatteryInfoSync = function () {
        var info = rt._getBatteryInfoSync();
        if (typeof info === 'string' && info.length > 0) {
            return JSON.parse(info);;
        }
        return null;
    };

    rt.getBatteryInfo = function (cb) {
        jsb_callback._pushCallback("getBatteryInfo", cb);
        rt._getBatteryInfo();
    };

    rt._onGetBatteryInfo = function (data) {
        var arr = jsb_callback._pickCallbackArray("getBatteryInfo");
        if (typeof data === 'string') {
            var jsonData = JSON.parse(data);
            jsb_callback._onCallback(arr, undefined, [jsonData]);
        } else {
            var errorMsg = "getBatteryInfo failed!";
            jsb_callback._onCallback(arr, [errorMsg]);
        }
    };

    rt.getClipboardData = function (cb) {
        jsb_callback._pushCallback("getClipboardData", cb);
        rt._getClipboardData();
    };

    rt._onGetClipboardData = function (res) {
        var arr = jsb_callback._pickCallbackArray("getClipboardData");
        if (res !== null && res !== undefined) {
            jsb_callback._onCallback(arr, undefined, [{ data: res }]);
        } else {
            var errorMsg = "getClipboardData failed!";
            jsb_callback._onCallback(arr, [errorMsg]);
        }
    };

    rt.setClipboardData = function (cb) {
        if (typeof cb.data === "string") {
            jsb_callback._pushCallback("setClipboardData", cb);
            rt._setClipboardData(cb.data);
        } else {
            if (typeof cb.fail === "function") {
                cb.fail.apply(cb, [{ errMsg: "setClipboardData:fail parameter error: parameter.data should be String" }]);
            }
        }
    };

    rt._onSetClipboardData = function () {
        var arr = jsb_callback._pickCallbackArray("setClipboardData");
        jsb_callback._onCallback(arr, undefined, [{ errMsg: "setClipboardData: ok" }]);
    };

    rt.startCompass = function (cb) {
        jsb_callback._pushCallback("startCompass", cb);
        rt._startCompass();
    };

    rt._onStartCompass = function () {
        var arr = jsb_callback._pickCallbackArray("startCompass");
        jsb_callback._onCallback(arr);
    };

    rt.stopCompass = function (cb) {
        jsb_callback._pushCallback("stopCompass", cb);
        jsb_callback._pickFunctionCallbackArray("onCompassChange");
        rt._stopCompass();
    };

    rt._onStopCompass = function () {
        var arr = jsb_callback._pickCallbackArray("stopCompass");
        jsb_callback._onCallback(arr);
    };

    rt.onCompassChange = function (cb) {
        jsb_callback._pushFunctionCallback("onCompassChange", cb);
        rt._startCompassChange();
    };

    rt._onCompassChange = function (res) {
        var cbArray = jsb_callback._getFunctionCallbackArray("onCompassChange");
        if (cbArray === undefined) {
            return;
        }
        if (res !== null && res != undefined) {
            var direction = {
                "direction": res
            };
            jsb_callback._onFunctionCallback(cbArray, direction);
        }
    };

    rt.getNetworkType = function (cb) {
        jsb_callback._pushCallback("getNetworkType", cb);
        rt._getNetworkType();
    };

    rt._onGetNetworkType = function (res) {
        var arr = jsb_callback._pickCallbackArray("getNetworkType");
        if (res !== null && res != undefined) {
            var json = JSON.parse(res);
            jsb_callback._onCallback(arr, undefined, [json]);
        } else {
            jsb_callback._onCallback(arr, [{
                errMsg: "getNetworkType:fail",
                networkType: "none"
            }]);
        }
    };

    rt.onNetworkStatusChange = function (cb) {
        jsb_callback._pushFunctionCallback("onNetworkStatusChange", cb);
    };

    rt.offNetworkStatusChange = function (cb) {
        jsb_callback._removeFunctionCallback("onNetworkStatusChange", cb);
    };

    rt._onNetworkStatusChange = function (res) {
        var cbArray = jsb_callback._getFunctionCallbackArray("onNetworkStatusChange");
        if (cbArray === undefined) {
            return;
        }
        if (res !== null && res != undefined) {
            var json = JSON.parse(res);
            jsb_callback._onFunctionCallback(cbArray, json);
        }
    };

    rt.getScreenBrightness = function (cb) {
        jsb_callback._pushCallback("getScreenBrightness", cb);
        rt._getScreenBrightness();
    };

    rt._onGetScreenBrightness = function (data) {
        var arr = jsb_callback._pickCallbackArray("getScreenBrightness");
        if (data !== null && data !== undefined) {
            var resFixed = data.toFixed(1);
            jsb_callback._onCallback(arr, undefined, [{ value: resFixed }]);
        } else {
            var errorMsg = "getScreenBrightness failed!";
            jsb_callback._onCallback(arr, [errorMsg]);
        }
    };

    rt.setScreenBrightness = function (cb) {
        if (!isNaN(cb.value)) {
            jsb_callback._pushCallback("setScreenBrightness", cb);
            rt._setScreenBrightness(cb.value);
        } else {
            if (typeof cb.fail === "function") {
                cb.fail.apply(cb);
            }
        }
    };

    rt._onSetScreenBrightness = function () {
        var arr = jsb_callback._pickCallbackArray("setScreenBrightness");
        jsb_callback._onCallback(arr);
    };

    rt.setKeepScreenOn = function (cb) {
        if (typeof cb.keepScreenOn === 'boolean') {
            jsb_callback._pushCallback("setKeepScreenOn", cb);
            rt._setKeepScreenOn(cb.keepScreenOn);
        } else {
            if (typeof cb.fail === "function") {
                cb.fail.apply(cb);
            }
        }
    };

    rt._onSetKeepScreenOn = function () {
        var arr = jsb_callback._pickCallbackArray("setKeepScreenOn");
        jsb_callback._onCallback(arr);
    };

    rt.vibrateShort = function (cb) {
        jsb_callback._pushCallback("setvibrate", cb);
        rt._setVibrate(0.04);
    };

    rt.vibrateLong = function (cb) {
        jsb_callback._pushCallback("setvibrate", cb);
        rt._setVibrate(0.4);
    };

    rt._onSetVibrate = function () {
        var arr = jsb_callback._pickCallbackArray("setvibrate");
        jsb_callback._onCallback(arr);
    };
})();

},{"./rt-callback":5}],8:[function(require,module,exports){
"use strict";

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

var rt = loadRuntime();
var fs = rt.getFileSystemManager();
var _nativeStat = fs.stat;
fs.stat = function (params) {
    _nativeStat({
        path: params.path,
        recursive: params.recursive,
        success: function success(res) {
            res.stats = res.stat;
            params.success(res);
        },

        fail: params.fail,
        complete: params.complete
    });
};
var _statSync = fs.statSync;
fs.statSync = function (path, recursive) {
    var result = _statSync.bind(this)(path, recursive);
    if (typeof result === "string") {
        throw result;
    }
    return result;
};
var _accessSync = fs.accessSync;
fs.accessSync = function (path) {
    var errMsg = _accessSync.bind(this)(path);
    if (errMsg !== "") {
        throw errMsg;
    }
};
var _mkdirSync = fs.mkdirSync;
fs.mkdirSync = function (path, recursive) {
    var errMsg = _mkdirSync.bind(this)(path, recursive);
    if (errMsg !== "") {
        throw errMsg;
    }
};
var _renameSync = fs.renameSync;
fs.renameSync = function (fromPath, toPath) {
    var errMsg = _renameSync.bind(this)(fromPath, toPath);
    if (errMsg !== "") {
        throw errMsg;
    }
};
var _unlinkSync = fs.unlinkSync;
fs.unlinkSync = function (filePath) {
    var errMsg = _unlinkSync.bind(this)(filePath);
    if (errMsg !== "") {
        throw errMsg;
    }
};
var _readdirSync = fs.readdirSync;
fs.readdirSync = function (dirPath) {
    var result = _readdirSync.bind(this)(dirPath);
    if (typeof result === "undefined") {
        return;
    }
    if (typeof result === "string") {
        throw result;
    }
    return result;
};
var _rmdirSync = fs.rmdirSync;
fs.rmdirSync = function (dirPath, recursive) {
    var errMsg = _rmdirSync.bind(this)(dirPath, recursive);
    if (errMsg !== "") {
        throw errMsg;
    }
};
var _saveFileSync = fs.saveFileSync;
fs.saveFileSync = function (tempFilePath, filePath) {
    var result = _saveFileSync.bind(this)(tempFilePath, filePath);
    var index = result.indexOf(rt.env.USER_DATA_PATH);
    if (index !== 0) {
        throw result;
    }
    return result;
};
var _writeFileSync = fs.writeFileSync;
fs.writeFileSync = function (path, data, encodeing, append) {
    if (data instanceof ArrayBuffer) {
        data = new Uint8Array(data);
    }
    var errMsg = _writeFileSync.bind(this)(path, data, encodeing, append);
    if (errMsg !== "") {
        throw errMsg;
    }
};
var _copyFileSync = fs.copyFileSync;
fs.copyFileSync = function (srcPath, destPath) {
    var errMsg = _copyFileSync.bind(this)(srcPath, destPath);
    if (errMsg !== "") {
        throw errMsg;
    }
};
var _readFileSync = fs.readFileSync;
fs.readFileSync = function (path, encoding) {
    var result = _readFileSync.bind(this)(path, encoding);
    if (typeof result === "undefined") {
        return;
    }
    if (typeof result.errMsg === "string" && result.errMsg !== "") {
        throw result.errMsg;
    }
    return result.data;
};
fs.appendFile = function (params) {
    var error = "";
    do {
        if ((typeof params === "undefined" ? "undefined" : _typeof(params)) !== "object") {
            error = "param is not a object";
            break;
        }
        var filePath = params.filePath;
        if (typeof filePath !== "string") {
            error = "filePath is not a string";
            break;
        }
        var isFile;
        try {
            var stat = fs.statSync(filePath);
            isFile = stat.isFile();
        } catch (error) {}
        if (!isFile) {
            error = "no such file or directory";
            break;
        }
    } while (0);
    if (error !== "") {
        var fail = params.fail;
        var complete = params.complete;
        var retObj = {
            errMsg: error
        };
        if (typeof fail === "function") {
            fail(retObj);
        }
        if (typeof complete === "function") {
            complete(retObj);
        }
        return;
    }
    params.append = true;
    fs.writeFile(params);
};
fs.appendFileSync = function (filePath, data, encoding) {
    if (typeof filePath !== "string") {
        throw "filePaht is not a string";
    }
    var stat = fs.statSync(filePath);
    var isFile = stat.isFile();
    if (!isFile) {
        throw "no such file or directory";
    }
    fs.writeFileSync(filePath, data, encoding, true);
};

},{}],9:[function(require,module,exports){
"use strict";

var rt = loadRuntime();
rt.AudioEngine = jsb.AudioEngine;
for (var Key in jsb.AudioEngine) {
    rt.AudioEngine[Key] = jsb.AudioEngine[Key];
}
rt.AudioEngine.play = rt.AudioEngine.play2d;

delete jsb.AudioEngine;

},{}],10:[function(require,module,exports){
"use strict";

var rt = loadRuntime();

var _chooseImage = rt._chooseImage;
delete rt._chooseImage;
var jsb_callback = require("./rt-callback");
var apiVersion = require("./rt-api-version");

rt.chooseImage = function (params) {
    var key = "chooseImage";
    var arr = jsb_callback._getCallbackArray(key);
    function success(version) {
        if (version === 2) {
            if (!params) {
                var errorMsg = "param is invalid";
                jsb_callback._onCallback([params], [errorMsg]);
                return;
            }
            var sourceType = params.sourceType;
            if (!sourceType) {
                sourceType = ["camera", "album"];
            }
            var index = sourceType.indexOf("camera");
            if (index > -1) {
                rt.authorize({
                    scope: "camera",
                    success: function success() {
                        if (arr === undefined || arr.length === 0) {
                            jsb_callback._pushCallback(key, params);
                            _chooseImage(params);
                        } else {
                            var errorMsg = "chooseImage is being called ";
                            jsb_callback._onCallback([params], [errorMsg]);
                        }
                    },
                    fail: function fail() {
                        var errorMsg = "get camera permission fail";
                        jsb_callback._onCallback([params], [errorMsg]);
                    }
                });
            } else {
                rt.authorize({
                    scope: "writePhotosAlbum",
                    success: function success() {
                        if (arr === undefined || arr.length === 0) {
                            jsb_callback._pushCallback(key, params);
                            _chooseImage(params);
                        } else {
                            var errorMsg = "chooseImage is being called ";
                            jsb_callback._onCallback([params], [errorMsg]);
                        }
                    },
                    fail: function fail() {
                        var errorMsg = "get album permission fail";
                        jsb_callback._onCallback([params], [errorMsg]);
                    }
                });
            }
        } else if (version === 1) {
            rt.authorize({
                scope: "camera",
                success: function success() {
                    if (arr === undefined || arr.length === 0) {
                        jsb_callback._pushCallback(key, params);
                        _chooseImage(params);
                    } else {
                        var errorMsg = "chooseImage is being called ";
                        jsb_callback._onCallback([params], [errorMsg]);
                    }
                },
                fail: function fail() {
                    var errorMsg = "get camera permission fail";
                    jsb_callback._onCallback([params], [errorMsg]);
                }
            });
        }
    }
    apiVersion.getApiVersion(apiVersion.apiMap.chooseImage, success);
};

rt._onChooseImageComplete = function (params) {
    var arr = jsb_callback._pickCallbackArray("chooseImage");
    if (typeof params === "undefined" || params === null || params === "") {
        var errorMsg = {
            "errMsg": "choose image failed! "
        };
        jsb_callback._onCallback(arr, [errorMsg]);
    } else {
        var jsonData = JSON.parse(params);
        jsb_callback._onCallback(arr, undefined, [jsonData]);
    }
};

rt.saveImageToPhotosAlbum = function (params) {
    jsb_callback._pushCallback("saveImageToPhotosAlbum", params);
    var filePath = params["filePath"];
    if (typeof filePath === "undefined" || filePath === null || filePath === "") {
        _onSaveImageComplete(false);
    } else {
        rt.authorize({
            scope: "writePhotosAlbum",
            success: function success() {
                rt._saveImageToPhotosAlbum(filePath);
            },
            fail: function fail() {
                rt._onSaveImageComplete(false);
            }
        });
    }
};

rt._onSaveImageComplete = function (isSuccess) {
    var arr = jsb_callback._pickCallbackArray("saveImageToPhotosAlbum");
    if (isSuccess === false) {
        var errorMsg = "save image failed!";
        jsb_callback._onCallback(arr, [errorMsg]);
    } else {
        jsb_callback._onCallback(arr, undefined, []);
    }
};

rt.previewImage = function (params) {
    var key = "previewImage";
    var arr = jsb_callback._getCallbackArray(key);
    if (arr === undefined || arr.length === 0) {
        jsb_callback._pushCallback(key, params);
        var current = params["current"];
        var urls = params["urls"];
        if (typeof params === "undefined" || urls.length <= 0) {
            _onPreviewImageComplete(false);
        } else {
            var index = urls.indexOf(current);
            if (index < 0) {
                index = 0;
            }
            rt._previewImage(index, urls);
        }
    } else {
        var errorMsg = "previewImage is being called ";
        jsb_callback._onCallback([params], [errorMsg]);
    }
};

rt._onPreviewImageComplete = function (isSuccess) {
    var arr = jsb_callback._pickCallbackArray("previewImage");
    if (isSuccess === false) {
        var errorMsg = "preview image failed!";
        jsb_callback._onCallback(arr, [errorMsg]);
    } else {
        jsb_callback._onCallback(arr, undefined, []);
    }
};

},{"./rt-api-version":3,"./rt-callback":5}],11:[function(require,module,exports){
"use strict";

(function () {
    var rt = loadRuntime();
    var jsb_callback = require("./rt-callback");

    if (typeof XMLHttpRequest !== "undefined") {
        var _xmlHttpRequestOpen = XMLHttpRequest.prototype.open;
        XMLHttpRequest.prototype.open = function () {
            if (arguments.length >= 2 && typeof arguments[1] === "string") {
                var url = arguments[1];
                url = decodeURIComponent(url);
                url = encodeURI(url);
                arguments[1] = url;
            }
            _xmlHttpRequestOpen.apply(this, arguments);
        };
    }

    if (typeof rt._downloadFile === "function") {
        var _downloadFile = rt._downloadFile;
        delete rt._downloadFile;
        rt.downloadFile = function (obj) {
            var url = obj.url;
            if (typeof url === "string") {
                url = url.trim();
                if (url.length == 0) {
                    obj.fail('invalid url');
                    return {};
                }

                url = decodeURIComponent(url);
                url = encodeURI(url);
            }
            var taskID = _downloadFile(obj, url);
            var task = {};
            task.abort = function () {
                rt._abort({
                    "taskId": taskID
                });
            };
            task.onProgressUpdate = function (cb) {
                var key = "downloadFile" + taskID;
                var objCb = {};
                objCb.progress = cb;
                jsb_callback._pushCallback(key, objCb);
            };
            return task;
        };

        rt._downloadOnProgressUpate = function (params) {
            var key = "downloadFile" + params["taskID"];
            var cbArray = jsb_callback._getCallbackArray(key);
            if (cbArray === undefined) {
                return;
            }
            cbArray.forEach(function (cb) {
                if (params !== undefined) {
                    if (typeof cb.progress === "function") {
                        cb.progress.apply(cb, [{
                            progress: params["progress"],
                            totalBytesWritten: params["totalBytesWritten"],
                            totalBytesExpectedToWrite: params["totalBytesExpectedToWrite"]
                        }]);
                    }
                }
            });
        };

        rt._onDownloadFileFinish = function (params) {
            var key = "downloadFile" + params;
            jsb_callback._cbArrayMap[key] = [];
        };
    }

    if (typeof rt._uploadFile === "function") {
        rt.uploadFile = function (obj) {
            var url = obj.url;
            if (typeof url === "string") {
                url = url.trim();
                if (url.length == 0) {
                    obj.fail('invalid url');
                    return {};
                }

                url = decodeURI(url);
                url = encodeURI(url);
                obj.url = url;
            }
            var taskID = rt._uploadFile(obj);
            var task = {};
            task.abort = function () {
                rt._abortUploadFileTask({
                    "taskId": taskID
                });
            };
            task.onProgressUpdate = function (cb) {
                var key = "uploadFile" + taskID;
                var objCb = {};
                objCb.progress = cb;
                jsb_callback._pushCallback(key, objCb);
            };
            return task;
        };

        rt._uploadOnProgressUpate = function (params) {
            var key = "uploadFile" + params["taskID"];
            var cbArray = jsb_callback._getCallbackArray(key);
            if (cbArray === undefined) {
                return;
            }
            cbArray.forEach(function (cb) {
                if (params !== undefined) {
                    if (typeof cb.progress === "function") {
                        cb.progress.apply(cb, [{
                            progress: params["progress"],
                            totalBytesSent: params["totalBytesSent"],
                            totalBytesExpectedToSend: params["totalBytesExpectedToSend"]
                        }]);
                    }
                }
            });
        };

        rt._onUploadFileFinish = function (params) {
            var key = "uploadFile" + params;
            jsb_callback._cbArrayMap[key] = [];
        };
    }
})();

},{"./rt-callback":5}],12:[function(require,module,exports){
"use strict";

var rt = loadRuntime();
var jsb_callback = require("./rt-callback");
rt.loadSubpackage = function (obj) {
    var keyProgress = "loadSubpackageProgress";
    var keyCb = "loadSubpackage";
    jsb_callback._cbArrayMap[keyProgress] = [];
    jsb_callback._pushCallback(keyCb, obj);
    var task = {};
    task.onProgressUpdate = function (cb) {
        var key = keyProgress;
        var objCb = {};
        objCb.progress = cb;
        jsb_callback._pushCallback(key, objCb);
        obj[keyProgress] = objCb;
    };

    var arr = jsb_callback._getCallbackArray(keyCb);
    if (arr !== undefined && arr.length === 1) {
        rt._loadSubpackage(obj);
    }
    return task;
};

rt._OnLoadSubpackageProgressUpate = function (params) {
    var cbArray = jsb_callback._getCallbackArray("loadSubpackage");
    if (cbArray === undefined) {
        return;
    }
    var cb = cbArray[0];
    var cbProgress = cb["loadSubpackageProgress"];
    if (params !== undefined && cbProgress !== undefined) {
        if (typeof cbProgress.progress === "function") {
            cbProgress.progress.apply(cbProgress, [{
                progress: params["progress"],
                totalBytesWritten: params["totalBytesWritten"],
                totalBytesExpectedToWrite: params["totalBytesExpectedToWrite"]
            }]);
        }
    }
};

rt._onLoadSubpackageFinished = function (params) {
    var callbackArr = jsb_callback._getCallbackArray("loadSubpackage");
    if (callbackArr === undefined) {
        return;
    }
    var callBack = callbackArr.shift();
    if (callBack === undefined) {
        return;
    }
    var arr = [callBack];
    var isSuccess = params["isSuccess"];
    var errMsg = params["errMsg"];
    if (isSuccess === true) {
        jsb_callback._onCallback(arr, undefined, [{ "errMsg": errMsg }]);
    } else {
        jsb_callback._onCallback(arr, [{ "errMsg": errMsg }]);
    }
    if (callbackArr.length > 0) {
        var cb = callbackArr[0];
        rt._loadSubpackage(cb);
    }
};

},{"./rt-callback":5}],13:[function(require,module,exports){
"use strict";

var rt = loadRuntime();
var jsb_callback = require("./rt-callback");
rt.showKeyboard = function (params) {
    jsb_callback._pushCallback("showKeyboard", params);
    var defaultValue = params["defaultValue"];
    if (typeof defaultValue !== 'string') {
        defaultValue = "";
    }
    var maxLength = params["maxLength"];
    if (typeof maxLength !== 'number' || isNaN(maxLength)) {
        maxLength = 100;
    }
    var multiple = params["multiple"];
    if (typeof multiple !== 'boolean') {
        multiple = false;
    }
    var confirmHold = params["confirmHold"];
    if (typeof confirmHold !== 'boolean') {
        confirmHold = true;
    }
    var confirmType = params["confirmType"];
    if (typeof confirmType !== 'string') {
        confirmType = "done";
    }

    var inputType = params["inputType"];
    if (typeof inputType !== 'string') {
        inputType = "text";
    }

    jsb.showInputBox({
        "defaultValue": defaultValue,
        "maxLength": maxLength,
        "multiple": multiple,
        "confirmHold": confirmHold,
        "confirmType": confirmType,
        "inputType": inputType,
        "originX": 0,
        "originY": 0,
        "width": 0,
        "height": 0
    });
    var arr = jsb_callback._pickCallbackArray("showKeyboard");
    jsb_callback._onCallback(arr);
};

rt.hideKeyboard = function (params) {
    jsb_callback._pushCallback("hideKeyboard", params);
    jsb.hideInputBox();
    var arr = jsb_callback._pickCallbackArray("hideKeyboard");
    jsb_callback._onCallback(arr);
};

var _updateKeyboard = rt._updateKeyboard;
delete rt._updateKeyboard;

rt.updateKeyboard = function (params) {
    jsb_callback._pushCallback("updateKeyboard", params);
    if (typeof params.value == 'undefined') {
        _updateKeyboard("");
    } else if (params.value == null) {
        _updateKeyboard("null");
    } else {
        _updateKeyboard(params.value.toString());
    }
};

rt._onUpdateKeyboard = function (success) {
    var arr = jsb_callback._pickCallbackArray("updateKeyboard");
    if (success === true) {
        jsb_callback._onCallback(arr, undefined, [{ errMsg: "updatekeyboard:ok" }]);
    } else {
        jsb_callback._onCallback(arr, [{ errMsg: "updatekeyboard:fail" }]);
    }
};

rt.onKeyboardConfirm = jsb.inputBox.onConfirm;

rt.offKeyboardConfirm = jsb.inputBox.offConfirm;

rt.onKeyboardComplete = jsb.inputBox.onComplete;

rt.offKeyboardComplete = jsb.inputBox.offComplete;

rt.onKeyboardInput = jsb.inputBox.onInput;

rt.offKeyboardInput = jsb.inputBox.offInput;

},{"./rt-callback":5}]},{},[1]);
