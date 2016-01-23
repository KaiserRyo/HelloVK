/*
 * Http.cpp
 *
 *  Created on: 22 янв. 2016 г.
 *      Author: misha
 */

#include "Http.hpp"
#include <iostream>

using namespace std;

Http::Http(QObject* parent) : QObject(parent) {

}

Http::~Http() {

}

QString Http::accessToken() const {
    return m_accessToken;
}

void Http::setAccessToken(const QString& accessToken) {
    if (m_accessToken == accessToken) return;

    cout << "Access token changed" << endl;

    m_accessToken = accessToken;
//    emit accessTokenChanged();
}

QString Http::userId() const {
    return m_userId;
}

void Http::setUserId(const QString& userId) {
    if (m_userId == userId) return;

    cout << "User ID changed" << endl;

    m_userId = userId;
//    emit userIdChanged();
}

QString Http::apiVersion() const {
    return m_apiVersion;
}

void Http::setApiVersion(const QString& apiVersion) {
    if (m_apiVersion == apiVersion) return;

    cout << "Api version changed" << endl;

    m_apiVersion = apiVersion;
//    emit apiVersionChanged();
}

void Http::init(const QString& accessToken, const QString& userId, const QString& apiVersion) {
    m_accessToken = accessToken;
    m_userId = userId;
    m_apiVersion = apiVersion;
    cout << "Http object initialized" << endl;
}
