#include <QObject>

#ifndef FILEIO_H
#define FILEIO_H


class FileIO : public QObject
{

    Q_OBJECT

public:
    FileIO();
    Q_INVOKABLE void save(QString text);
    Q_INVOKABLE QString read(QString f);
    ~FileIO();

};

#endif // FILEIO_H
