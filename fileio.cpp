#include "fileio.h"
#include <QFile>
#include <QTextStream>

FileIO::FileIO()
{

}

void FileIO::save(QString text){
    QFile file("bw.conf");

    if(file.open(QIODevice::ReadWrite)){
    QTextStream stream(&file);
    stream << text << endl;
    }

    file.resize(file.pos());

    return;
}

QString FileIO::read(QString f)
{
    QFile file(f);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return "";

    QTextStream in(&file);
    QString line;
    while (!in.atEnd()) {
         line = line + in.readLine() + '/';
    }
    return line;
}




FileIO::~FileIO()
{

}
