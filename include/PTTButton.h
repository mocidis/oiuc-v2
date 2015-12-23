#ifndef __PTT_BUTTON_H__
#define __PTT_BUTTON_H__
#include <QtCore>
class PTTButton : public QObject {
	Q_OBJECT
	Q_PROPERTY(QPoint pos READ m_pos WRITE setPos NOTIFY posChanged)
public:
	PTTButton();
	QPoint m_pos();
	QPoint setPos(QPoint point);
	static QPoint globalPTTPos;
signals:
	void posChanged();
private:
	QPoint pos;
};
#endif
