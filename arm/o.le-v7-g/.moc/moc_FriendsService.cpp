/****************************************************************************
** Meta object code from reading C++ file 'FriendsService.hpp'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/FriendsService.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'FriendsService.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_FriendsService[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       1,   34, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: signature, parameters, type, tag, flags
      16,   15,   15,   15, 0x05,
      33,   15,   15,   15, 0x05,

 // methods: signature, parameters, type, tag, flags
      72,   15,   63,   15, 0x02,
      90,   82,   15,   15, 0x02,

 // properties: name, type, flags
      82,   63, 0xff495103,

 // properties: notify_signal_id
       0,

       0        // eod
};

static const char qt_meta_stringdata_FriendsService[] = {
    "FriendsService\0\0friendsChanged()\0"
    "friendOnlineChanged(QVariant)\0QVariant\0"
    "friends()\0friends\0setFriends(QVariant)\0"
};

void FriendsService::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        FriendsService *_t = static_cast<FriendsService *>(_o);
        switch (_id) {
        case 0: _t->friendsChanged(); break;
        case 1: _t->friendOnlineChanged((*reinterpret_cast< const QVariant(*)>(_a[1]))); break;
        case 2: { QVariant _r = _t->friends();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        case 3: _t->setFriends((*reinterpret_cast< const QVariant(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData FriendsService::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject FriendsService::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_FriendsService,
      qt_meta_data_FriendsService, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &FriendsService::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *FriendsService::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *FriendsService::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_FriendsService))
        return static_cast<void*>(const_cast< FriendsService*>(this));
    return QObject::qt_metacast(_clname);
}

int FriendsService::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QVariant*>(_v) = friends(); break;
        }
        _id -= 1;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setFriends(*reinterpret_cast< QVariant*>(_v)); break;
        }
        _id -= 1;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 1;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void FriendsService::friendsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void FriendsService::friendOnlineChanged(const QVariant & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_END_MOC_NAMESPACE
