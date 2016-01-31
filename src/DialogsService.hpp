/*
 * DialogsService.hpp
 *
 *  Created on: 17 янв. 2016 г.
 *      Author: misha
 */

#ifndef DIALOGSSERVICE_HPP_
#define DIALOGSSERVICE_HPP_

class DialogsService : public QObject {
    Q_OBJECT
    Q_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)
    Q_PROPERTY(int unreadDialogs READ unreadDialogs WRITE setUnreadDialogs NOTIFY unreadDialogsChanged)
    Q_PROPERTY(QVariant dialogs READ dialogs WRITE setDialogs NOTIFY dialogsChanged)
    Q_PROPERTY(QVariant dialogsUsers READ dialogsUsers WRITE setDialogsUsers NOTIFY dialogsUsersChanged)

public:
    DialogsService(QObject* parent = 0);
    virtual ~DialogsService();

    Q_INVOKABLE int count() const;
    Q_INVOKABLE void setCount(const int count);

    Q_INVOKABLE int unreadDialogs() const;
    Q_INVOKABLE void setUnreadDialogs(const int unreadDialogs);

    Q_INVOKABLE QVariant dialogs() const;
    Q_INVOKABLE void setDialogs(const QVariant& dialogs);

    Q_INVOKABLE QVariant dialogsUsers() const;
    Q_INVOKABLE void setDialogsUsers(const QVariant& dialogsUsers);

signals:
    void countChanged();
    void unreadDialogsChanged();
    void dialogsChanged();
    void dialogsUsersChanged();
    void dialogUpdated(const QVariant&, const bool);
    void dialogAdded(const QVariant&);
    void dialogDeleted(const QVariant&);
    void outgoingMessagesReaded(const QVariant&);

private:
    int m_count;
    int m_unreadDialogs;
    QVariant m_dialogs;
    QVariant m_dialogsUsers;
};

#endif /* DIALOGSSERVICE_HPP_ */
