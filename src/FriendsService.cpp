/*
 * FriendsService.cpp
 *
 *  Created on: 15 янв. 2016 г.
 *      Author: misha
 */

#include "FriendsService.hpp"
#include <iostream>

using namespace std;

FriendsService::FriendsService(QObject* parent) : QObject(parent) {

}

FriendsService::~FriendsService() {

}

QVariant FriendsService::friends() const {
    return m_friends;
}

void FriendsService::setFriends(const QVariant& friends) {
    if (m_friends == friends) return;

    cout << "Friends changed" << endl;

    m_friends = friends;
    emit friendsChanged();
}


