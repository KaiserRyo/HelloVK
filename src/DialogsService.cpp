/*
 * DialogsService.cpp
 *
 *  Created on: 17 янв. 2016 г.
 *      Author: misha
 */

#include "DialogsService.hpp"
#include <iostream>

using namespace std;

DialogsService::DialogsService(QObject* parent) : QObject(parent), m_count(0), m_unreadDialogs(0) {
    cout << "DialogsService created" << endl;
}

DialogsService::~DialogsService() {
    cout << "DialogsService destroyed" << endl;
}

int DialogsService::count() const {
    return m_count;
}

void DialogsService::setCount(int count) {
    if (m_count == count) return;

    cout << "Dialogs count changed" << endl;

    m_count = count;
    emit countChanged();
}

int DialogsService::unreadDialogs() const {
    return m_unreadDialogs;
}

void DialogsService::setUnreadDialogs(int unreadDialogs) {
    if (m_unreadDialogs == unreadDialogs) return;

    cout << "Unread dialogs changed" << endl;

    m_unreadDialogs = unreadDialogs;
    emit unreadDialogsChanged();
}

QVariant DialogsService::dialogs() const {
    return m_dialogs;
}

void DialogsService::setDialogs(const QVariant& dialogs) {
    if (m_dialogs == dialogs) return;

    cout << "Dialogs changed" << endl;

    m_dialogs = dialogs;
    emit dialogsChanged();
}

QVariant DialogsService::dialogsUsers() const {
    return m_dialogsUsers;
}

void DialogsService::setDialogsUsers(const QVariant& dialogsUsers) {
    if (m_dialogsUsers == dialogsUsers) return;

    cout << "DialogsUsers changed" << endl;

    m_dialogsUsers = dialogsUsers;
    emit dialogsUsersChanged();
}


