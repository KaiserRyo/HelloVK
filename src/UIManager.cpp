/*
 * UIManager.cpp
 *
 *  Created on: 25 янв. 2016 г.
 *      Author: misha
 */

#include "UIManager.hpp"
#include <iostream>

using namespace std;

UIManager::UIManager(QObject* parent) : QObject(parent), m_dialogBg("#ffc3daff") {}

UIManager::~UIManager() {
    cout << "UIManager destroyed" << endl;
}

QString UIManager::dialogBg() const {
    return m_dialogBg;
}

void UIManager::setDialogBg(const QString dialogBg) {
    if (m_dialogBg == dialogBg) return;

    cout << "Dialog background changed" << endl;

    m_dialogBg = dialogBg;
    emit dialogBgChanged();
}


