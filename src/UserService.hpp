/*
 * UserService.hpp
 *
 *  Created on: 24 янв. 2016 г.
 *      Author: misha
 */

#ifndef USERSERVICE_HPP_
#define USERSERVICE_HPP_

class UserService : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariant user READ user WRITE setUser NOTIFY userChanged)

public:
    UserService(QObject* parent = 0);
    virtual ~UserService();

    Q_INVOKABLE QVariant user() const;
    Q_INVOKABLE void setUser(const QVariant& user);

signals:
    void userChanged();

private:
    QVariant m_user;
};



#endif /* USERSERVICE_HPP_ */
