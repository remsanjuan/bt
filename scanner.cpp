#include "scanner.h"
#include <QThread>
#include <QDebug>

Scanner::Scanner(QObject *parent) : QObject(parent),stopped(false)
{
    t7interface = new T7Interface();

    //connect(t7worker, &T7Worker::hasReadSome, this, &Calibrator::receivedSomething);
    connect(t7interface, &T7Interface::statusChanged, this, &Scanner::setStatus);

   // connectSignalsSlots();
    scannerStarted();
}

bool Scanner::getStatus()
{
    return t7interface->getStatus();
}

void Scanner::setStatus(bool status)
{
    newStatus = status;
    if (newStatus)
        { emit statusChanged("CONNECTED!"); }
    else
    { emit statusChanged("DISCONNECTED!"); }
}

void Scanner::scannerStarted()
{
    QThread *t7interfaceThread;

    t7interfaceThread = new QThread;

    t7interface->moveToThread(t7interfaceThread);
    connect(t7interfaceThread, SIGNAL(started()), t7interface, SLOT(connect()));
    connect(t7interface, SIGNAL(finished()), t7interfaceThread, SLOT(quit()));
    connect(t7interface, SIGNAL(finished()), t7interface, SLOT(deleteLater()));
    connect(this, SIGNAL(startscanning()), t7interface, SLOT(scan()));

    connect(t7interface, SIGNAL(finished()), this, SLOT(scannerFinished()));
    connect(t7interfaceThread, SIGNAL(finished()), t7interface, SLOT(deleteLater()));
    connect(t7interface, SIGNAL(updateScanner(double)), this, SLOT(updateScanner(double)));
    connect(t7interface, SIGNAL(updateScan(QList<int>)), this, SLOT(updateScan(QList<int>)));
    connect(t7interface, SIGNAL(updateMatInfo(QList<QString>)), this, SLOT(updateMatInfo(QList<QString>)));
     connect(t7interface, SIGNAL(updateStatistics(QList<QString>)), this, SLOT(updateStatistics(QList<QString>)));
   // connect(this, SIGNAL(initializeGui(double, double,double,bool)), this, SLOT(updatePressure(double, double,double,bool)));

    t7interfaceThread->start();
}

void Scanner::startClicked()
{
    if(t7interface->getStatus()){
       emit startscanning();
    }
}

void Scanner::updateScanner(double w)
{
    emit scannerUpdated(w);
}

void Scanner::updateScan(QList<int> i_val)
{
    emit scanUpdated(i_val);
}

void Scanner::updateMatInfo(QList<QString> info)
{
    emit matInfoUpdated(info);
}

void Scanner::updateStatistics(QList<QString> stat)
{
    emit statisticsUpdated(stat);
}

void Scanner::stopClicked()
{
    qDebug() << "stopClicked";
 //   stopped = true;
    t7interface->disconnect();
}


