/*
 * UIManager.hpp
 *
 *  Created on: 25 янв. 2016 г.
 *      Author: misha
 */

#ifndef UIMANAGER_HPP_
#define UIMANAGER_HPP_

class UIManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString dialogBg READ dialogBg WRITE setDialogBg NOTIFY dialogBgChanged)

public:
    UIManager(QObject* parent = 0);
    virtual ~UIManager();

    Q_INVOKABLE QString dialogBg() const;
    Q_INVOKABLE void setDialogBg(const QString dialogBg);

signals:
    void dialogBgChanged();

private:
    QString m_dialogBg;
};



#endif /* UIMANAGER_HPP_ */
