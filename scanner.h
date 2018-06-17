#ifndef SCANNER_H
#define SCANNER_H
//test
#include <QObject>
#include "t7interface.h"

class Scanner : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool currentStatus READ getStatus NOTIFY statusChanged)
public:
    explicit Scanner(QObject *parent = nullptr);
    bool getStatus();

signals:
    void statusChanged(QString newStatus);
    void startscanning();
    void scanUpdated(QList<int> i_val);
    void scannerUpdated(double weight);
    void matInfoUpdated(QList<QString> info);
    void statisticsUpdated(QList<QString> stat);


public slots:
    void setStatus(bool status);
    void scannerStarted();
    void startClicked();
    void updateScanner(double w);
    void updateScan(QList<int> i_val);
    void updateMatInfo(QList<QString> info);
    void updateStatistics(QList<QString> stat);
    void stopClicked();


private:
    T7Interface *t7interface;

    bool newStatus;
    bool stopped;

};

#endif // SCANNER_H
