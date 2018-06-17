#ifndef T7INTERFACE_H
#define T7INTERFACE_H

#include <QObject>
#include "fsa.h"

class T7Interface : public QObject
{
    Q_OBJECT
public:
    explicit T7Interface(QObject *parent = nullptr);
    bool getStatus();

signals:
    void statusChanged(bool status);
    void finished();
    void updateScan(QList<int> i_val);
    void updateScanner(double w);
    void updateMatInfo(QList<QString> info);
    void updateStatistics(QList<QString> stat);


public slots:
    bool connect();
    void scan();
    void disconnect();

private slots:
    void connected();


private:
    FSAT7 t7;
    bool status;
    bool m_running;
    bool calculateWeight();

    //Mat properties
    double m_sensorArea, m_sensingArea;
    double m_averagepressure;
    int m_rows, m_columns;
    double m_width, m_height;

    float *m_values;
    double m_weight_sum;
    int m_counter;
    int m_minimum = 5;
    double m_maximum = 0;

};

#endif // T7INTERFACE_H
