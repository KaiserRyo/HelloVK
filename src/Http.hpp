/*
 * Http.hpp
 *
 *  Created on: 22 янв. 2016 г.
 *      Author: misha
 */

#ifndef HTTP_HPP_
#define HTTP_HPP_

class Http : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString accessToken READ accessToken WRITE setAccessToken NOTIFY accessTokenChanged)
    Q_PROPERTY(QString userId READ userId WRITE setUserId NOTIFY userIdChanged)
    Q_PROPERTY(QString apiVersion READ apiVersion WRITE setApiVersion NOTIFY apiVersionChanged)

public:
    Http(QObject* parent = 0);
    virtual ~Http();

    Q_INVOKABLE QString accessToken() const;
    Q_INVOKABLE void setAccessToken(const QString& accessToken);

    Q_INVOKABLE QString userId() const;
    Q_INVOKABLE void setUserId(const QString& userId);

    Q_INVOKABLE QString apiVersion() const;
    Q_INVOKABLE void setApiVersion(const QString& apiVersion);

    Q_INVOKABLE void init(const QString& accessToken, const QString& userId, const QString& apiVersion);

signals:
    void accessTokenChanged();
    void userIdChanged();
    void apiVersionChanged();

private:
    QString m_accessToken;
    QString m_userId;
    QString m_apiVersion;
};

#endif /* HTTP_HPP_ */
