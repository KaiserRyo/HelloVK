/*
 * FriendsService.hpp
 *
 *  Created on: 15 янв. 2016 г.
 *      Author: misha
 */

#ifndef FRIENDSSERVICE_HPP_
#define FRIENDSSERVICE_HPP_

class FriendsService : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariant friends READ friends WRITE setFriends NOTIFY friendsChanged)

public:
    FriendsService(QObject* parent = 0);
    virtual ~FriendsService();

    Q_INVOKABLE QVariant friends() const;
    Q_INVOKABLE void setFriends(const QVariant& friends);

signals:
    void friendsChanged();
    void friendOnlineChanged(const QVariant&);

private:
    QVariant m_friends;
};

#endif /* FRIENDSSERVICE_HPP_ */
