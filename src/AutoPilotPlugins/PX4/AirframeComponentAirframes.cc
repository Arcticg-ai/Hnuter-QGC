#include "AirframeComponentAirframes.h"
#include <QtCore/QFile>
#include <QtCore/QFileInfo>
#include <QtCore/QStringList>

QMap<QString, AirframeComponentAirframes::AirframeType_t*> AirframeComponentAirframes::rgAirframeTypes;

static QString airframeImageResource(const QString& image)
{
    QStringList candidates;
    if (QFileInfo(image).suffix().isEmpty()) {
        candidates << QStringLiteral("%1.png").arg(image)
                   << QStringLiteral("%1.jpg").arg(image)
                   << QStringLiteral("%1.jpeg").arg(image)
                   << QStringLiteral("%1.webp").arg(image)
                   << QStringLiteral("%1.svg").arg(image);
    } else {
        candidates << image;
    }

    for (const QString& candidate: candidates) {
        const QString resourcePath = QStringLiteral(":/qmlimages/Airframe/%1").arg(candidate);
        if (QFile::exists(resourcePath)) {
            return QStringLiteral("qrc%1").arg(resourcePath);
        }
    }

    return QString();
}

QMap<QString, AirframeComponentAirframes::AirframeType_t*>& AirframeComponentAirframes::get() {

#if 0
    // Set a single airframe to prevent the UI from going crazy
    if (rgAirframeTypes.count() == 0) {
        // Standard planes
        AirframeType_t *standardPlane = new AirframeType_t;
        standardPlane->name = "Standard Airplane";
        standardPlane->imageResource = "qrc:/qmlimages/Airframe/Plane.svg";
        AirframeInfo_t *easystar = new AirframeInfo_t;
        easystar->name = "Multiplex Easystar 1/2";
        easystar->autostartId = 2100;
        standardPlane->rgAirframeInfo.append(easystar);
        rgAirframeTypes.insert("StandardPlane", standardPlane);
        qDebug() << "Adding plane config";

        // Flying wings
    }
#endif

    return rgAirframeTypes;
}

void AirframeComponentAirframes::insert(QString& group, QString& image, QString& name, int id)
{
    const bool hnuterTiltrotor = id == 4051 ||
            group.contains(QStringLiteral("Hnuter"), Qt::CaseInsensitive) ||
            name.contains(QStringLiteral("Hnuter"), Qt::CaseInsensitive);
    if (hnuterTiltrotor) {
        image = QStringLiteral("HnuterTiltrotorT");
    }

    AirframeType_t *g;
    if (!rgAirframeTypes.contains(group)) {
        g = new AirframeType_t;
        g->name = group;

        if (image.length() > 0) {
            g->imageResource = airframeImageResource(image);
        }

        if (g->imageResource.isEmpty()) {
            g->imageResource = QString("qrc:/qmlimages/Airframe/AirframeUnknown.svg");
        }

        rgAirframeTypes.insert(group, g);
    } else {
        g = rgAirframeTypes.value(group);
    }

    AirframeInfo_t *i = new AirframeInfo_t;
    i->name = name;
    i->autostartId = id;

    g->rgAirframeInfo.append(i);
}

void AirframeComponentAirframes::clear() {

    // Run through all and delete them
    for (int tindex = 0; tindex < AirframeComponentAirframes::get().count(); tindex++) {

        const AirframeComponentAirframes::AirframeType_t* pType = AirframeComponentAirframes::get().values().at(tindex);

        for (int index = 0; index < pType->rgAirframeInfo.count(); index++) {
            const AirframeComponentAirframes::AirframeInfo_t* pInfo = pType->rgAirframeInfo.at(index);
            delete pInfo;
        }

        delete pType;
    }

    rgAirframeTypes.clear();
}
