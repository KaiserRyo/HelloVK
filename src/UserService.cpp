/*
 * UserService.cpp
 *
 *  Created on: 24 янв. 2016 г.
 *      Author: misha
 */

#include "UserService.hpp"
#include <iostream>

using namespace std;

UserService::UserService(QObject* parent) : QObject(parent) {}

UserService::~UserService() {
    cout << "UserService destroyed" << endl;
}

QVariant UserService::user() const {
    return m_user;
}

void UserService::setUser(const QVariant& user) {
    if (m_user == user) return;

    cout << "User changed" << endl;

    m_user = user;
    emit userChanged();
}


