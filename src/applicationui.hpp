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

#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QObject>
#include "FriendsService.hpp"
#include "DialogsService.hpp"
#include "UserService.hpp"
#include "Http.hpp"
#include "UIManager.hpp"

namespace bb
{
    namespace cascades
    {
        class LocaleHandler;
    }
}

class QTranslator;

/*!
 * @brief Application UI object
 *
 * Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class ApplicationUI : public QObject
{
    Q_OBJECT
    Q_PROPERTY(FriendsService* friendsService READ friendsService CONSTANT)
    Q_PROPERTY(DialogsService* dialogsService READ dialogsService CONSTANT)
    Q_PROPERTY(UserService* userService READ userService CONSTANT)
    Q_PROPERTY(Http* http READ http CONSTANT)
    Q_PROPERTY(UIManager* uiManager READ uiManager CONSTANT)
public:
    ApplicationUI();
    virtual ~ApplicationUI() {}
private slots:
    void onSystemLanguageChanged();
private:
    QTranslator* m_pTranslator;
    bb::cascades::LocaleHandler* m_pLocaleHandler;
    FriendsService* friendsService();
    FriendsService* m_friendsService;

    DialogsService* dialogsService();
    DialogsService* m_dialogsService;

    UserService* m_userService;
    UserService* userService();

    Http* http();
    Http* m_http;

    UIManager* uiManager();
    UIManager* m_uiManager;
};

#endif /* ApplicationUI_HPP_ */
