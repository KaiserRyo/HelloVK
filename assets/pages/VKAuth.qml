/*
 * Copyright (c) 2011-2015 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.4

Sheet {
    id: authPage
    
    property string clientId: "5217342"
    property string display: "mobile"
    property string responseType: "token"
    property string apiVersion: "5.44"
    property string scope: "scope=messages,friends,offline,notifications"
    
    signal accessTokenAndUserIdReceived(string accessToken, string userId, string apiVersion)
    
    content: Page {
        Container {
            WebView {
                url: "https://oauth.vk.com/authorize?client_id=" + clientId + "&display=" + display + "&response_type=" + responseType 
                + "&v=" + apiVersion + "&" + scope
                
                onUrlChanged: {
                    console.debug(url);
                    var urlStr = url + "";
                    if (urlStr.indexOf("blank.html#access_token") !== -1) {
                        var queryArray = urlStr.split("#")[1].split("&");
                        authPage.accessTokenAndUserIdReceived(queryArray[0].split("=")[1], queryArray[2].split("=")[1], apiVersion);
                    }
                }
            }
        }
    }    
}
