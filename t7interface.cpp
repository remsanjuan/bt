#include "t7interface.h"
#include <QDebug>
#include <QString>
#include <QList>

T7Interface::T7Interface(QObject *parent) : QObject(parent)
{
    status = false;
    m_running = true;
}

bool T7Interface::getStatus()
{
    return status;
}

bool T7Interface::connect()
{
    char* serial;
    char* units;
    float max;
    QList<QString> info;
    fsat7Initialize();
    t7 = fsat7Create(0, 1);
    qDebug() << t7;
    if(t7){
        connected();
        fsat7GetSerialNumber(t7, serial);
        m_columns = fsat7GetColumnCount(t7);
        m_rows = fsat7GetRowCount(t7);
        m_width = fsat7GetWidth(t7);
        m_height = fsat7GetHeight(t7);
        max = fsat7GetMaximum(t7);
        info.append(serial);
        info.append(QString::number(m_columns));
        info.append(QString::number(m_rows));
        info.append(QString::number(m_width));
        info.append(QString::number(m_height));
        info.append(QString::number(max));
    //    info.append(unit);

        emit updateMatInfo(info);
    }
}

void T7Interface::scan()
{
    qDebug() << "I'm scanning";
    m_running = true;

    int t=0;

    if (t7) {

        m_columns = fsat7GetColumnCount(t7);
        m_rows = fsat7GetRowCount(t7);
        m_width = fsat7GetWidth(t7);
        m_height = fsat7GetHeight(t7);
        m_sensorArea = (m_width / m_columns) * (m_height / m_columns);
        qDebug() << m_width << "-" << m_height;
        m_values = (float*) malloc(m_columns * m_rows * sizeof(float));
        if (m_values) {
            //qDebug() << m_values;

            while(m_running){
                if(fsat7Scan(t7, m_values, NULL)) {
                    calculateWeight();
                    t++;
                   // qDebug() << t;
                }
                else {
                 //   qDebug() <<"Failed to scan sensor array.";
                    m_running = false;
                }
            }


            //InfiniteCountWorker::scan(t7,values,fpcal);
            //fsat7Destroy(t7);
            //free(values);
        }//if (values)
    }else{
        //emit finished();
        //return;
    }



}

void T7Interface::disconnect()
{

    if(t7){

        m_running = false;
        //this->m_paused=true;

        qDebug() <<"STOPPED AKO";
        //emit hasReadSome("PAUSED!", "red");

        //fsaacDestroy(ac);
        //QThread::sleep(2);
       // status = false;
        //emit statusChanged(status);


    }
}

void T7Interface::connected()
{
    status = true;
    qDebug() << "Connected " << status;
    emit statusChanged(status);
}

bool T7Interface::calculateWeight()
{
    QList <int> i_val;
    QList <QString> stat;
    int r;
    int c;
    double wt;
    double total = 0.0;
    double c_weight = 0.0;
    int active = 0;
    float* value = m_values;
    for (r = 0; r < m_rows; ++r) {
        for (c = 0; c < m_columns; ++c, ++value) {
           // if(cnt) string_val += ",";
            //string_val += QString::number((int)(*value));
            i_val.append((int)(*value));
         //   cnt++;

           // qDebug() << (int)(*value);
            if(*value >= m_minimum){
                if(*value > m_maximum) m_maximum = *value;
                total += *value;
                active++;
            }
        }
    }
    //emit updateScan(string_val);
    emit updateScan(i_val);
    i_val.clear();
    if(active){
        m_sensingArea = active * m_sensorArea;
        m_averagepressure = total / active;

        //c_weight = total / (m_sensingArea / 1000);
       // qDebug() << c_weight;
            c_weight = m_averagepressure * m_sensingArea / 100000;
        m_weight_sum += c_weight;
        m_counter++;

    }
    stat.append(QString::number(m_maximum));
    stat.append(QString::number(m_averagepressure));
    stat.append(QString::number(m_sensingArea));
    stat.append(QString::number(c_weight));
    emit updateStatistics(stat);
    m_maximum=0;
    m_averagepressure=0;
    m_sensingArea=0;

    if(m_counter >= 10){
        wt = m_weight_sum / 10;
        emit updateScanner(wt);
        m_counter =0;
        m_weight_sum = 0;
    }
//    qDebug() << "Sensing Area:" <<m_sensingArea;
//    qDebug() << "Average Pressure:" <<m_averagepressure;
//    qDebug() << "Active sensors:" <<active;
//    qDebug() << "Sensor Area:" <<m_sensorArea;



}

