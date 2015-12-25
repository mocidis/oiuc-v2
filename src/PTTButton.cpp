#include "PTTButton.h"
PTTButton::PTTButton() {}
QPoint PTTButton::m_pos() {
	return pos;
}
QPoint PTTButton::globalPTTPos;
QPoint PTTButton::setPos(QPoint point) {
	pos = point;
	PTTButton::globalPTTPos = pos;
}
